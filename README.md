# Simulación Binaural 3D de una Mosca en MATLAB (HRTF / KEMAR)

Este proyecto simula el sonido tridimensional de una mosca volando alrededor de la cabeza de un oyente durante 60 segundos. A partir de una grabación simple de audio y ecuaciones de movimiento en 3D, el programa calcula en cada instante la posición relativa entre la fuente sonora (*source*) y el oyente (*receptor*), y procesa el sonido para que al escucharlo con **audífonos** se perciba dirección (izquierda, derecha, adelante, atrás), altura (arriba, abajo) y distancia (cerca, lejos).

> **Nota importante:** El efecto espacial 3D solo se percibe correctamente usando **audífonos**, ya que depende de enviar señales acústicas distintas e independientes a cada oído.

---

## Conceptos clave (para entender el proyecto desde cero)

Antes de revisar el código, estos son los cinco conceptos de física y procesamiento de señales que hacen posible el audio 3D:

### 1. HRTF y HRIR (Cómo sabe tu cerebro de dónde viene un sonido)
Cuando un sonido llega a tu cabeza desde un ángulo específico, tu cerebro determina su ubicación usando tres pistas físicas:
* **ITD (Diferencia de Tiempo Interaural):** Si la mosca está a tu derecha, el sonido llega una fracción de milisegundo antes al oído derecho que al izquierdo.
* **ILD (Diferencia de Nivel Interaural):** Tu cabeza actúa como un escudo acústico; el sonido llega más fuerte al oído cercano y más débil al lejano.
* **Forma del pabellón auditivo (oreja):** Los pliegues de la oreja filtran ciertas frecuencias dependiendo de si el sonido viene de arriba, abajo o atrás.

Una **HRIR** (*Head-Related Impulse Response*) es una grabación corta (512 muestras) que captura exactamente cómo la cabeza y las orejas modifican un sonido desde un ángulo específico. Su equivalente en el dominio de la frecuencia se llama **HRTF** (*Head-Related Transfer Function*). Este proyecto utiliza el dataset acústico **KEMAR** del MIT Media Lab.

### 2. RMS (*Root Mean Square*)
El valor RMS mide la energía o volumen efectivo de una señal de audio en una ventana de tiempo:

$$\text{RMS} = \sqrt{\frac{1}{M} \sum_{k=1}^{M} x[k]^2}$$

En lugar de mirar muestra por muestra (que sube y baja miles de veces por segundo), el RMS nos da una curva suave del volumen real del audio. Lo usamos para detectar y recortar automáticamente los silencios del inicio y final de `mosca.wav`.

### 3. *Crossfade* de potencia constante
Si repites un audio pegándolo uno detrás de otro, se escucha un corte brusco. Si haces una transición lineal (bajar uno de 1 a 0 y subir el otro de 0 a 1), el volumen cae ligeramente en la mitad de la unión. Para mantener la energía sonora constante durante el empalme, multiplicamos el final por $\cos(\theta)$ y el inicio por $\sin(\theta)$ con $\theta \in [0, \pi/2]$, aprovechando la identidad trigonométrica:

$$\cos^2(\theta) + \sin^2(\theta) = 1$$

### 4. Convolución y *Overlap-Add* (OLA)
Aplicar una HRIR a un audio se hace mediante la operación matemática de **convolución** (`conv` en MATLAB). Como la mosca está en movimiento constante, no podemos aplicar un solo ángulo a todo el audio:
1. Dividimos el audio de 60 segundos en bloques pequeños (`hop = 2048` muestras, unos 46 ms).
2. A cada bloque le aplicamos la HRIR correspondiente a la posición de la mosca en ese instante.
3. Al convolucionar un bloque de $2048$ muestras con una HRIR de $512$ muestras, el resultado mide $2048 + 512 - 1 = 2559$ muestras. Esas $511$ muestras extra ("cola" del filtro) se **suman solapadas** al inicio del siguiente bloque (*Overlap-Add*) para que no existan chasquidos ni cortes.

### 5. Atenuación por distancia
En el mundo real, la amplitud de una onda sonora disminuye inversamente proporcional a la distancia $r$ entre la fuente y el receptor:

$$G = \frac{1}{\max(r,\ r_{\min})}$$

Se usa un límite mínimo $r_{\min} = 0.25\text{ m}$ para evitar que la ganancia tienda a infinito si la mosca pasa demasiado cerca del centro de la cabeza.

---

## Estructura del directorio

```text
Proyecto1-MoscaVolando/
├── main_mosca.m        # Script principal de simulación, audio 3D y gráfica
├── mosca.wav           # Audio base de la mosca
├── interphrir.m        # Interpolación bilineal de HRIR en frecuencia
├── formatangle.m       # Normalización de ángulos al rango del dataset KEMAR
├── readhrtf.m          # Lectura simétrica y normalización de filtros HRIR
├── hrtfpath.m          # Construcción de rutas hacia los archivos .dat
├── readraw.m           # Lectura binaria (big-endian) de archivos .dat
└── full/               # Dataset KEMAR (carpetas elev-40 hasta elev90)

```

---

## Explicación detallada de `main_mosca.m`

### Paso 1: Conversión a mono y recorte automático por RMS

```matlab
[audio, Fs] = audioread('mosca.wav');
src_raw = mean(audio, 2);

```

Una fuente puntual (la mosca) debe ser una señal **monoaural** (un solo canal) antes de espacializarla. `mean(audio, 2)` promedia los canales si el archivo original venía en estéreo.

Luego se calcula la envolvente RMS en ventanas de 50 ms (`0.05 * Fs`) y se conservan únicamente las muestras donde el volumen supera el 30% del máximo (`thresh = 0.3 * max(env)`), aplicando un margen interior de seguridad (`0.15 * Fs`) para descartar el *fade-out* natural del archivo original.

### Paso 2: Extensión continua a 60 segundos

```matlab
t_fade = linspace(0, pi/2, fade_len)';
w_out = cos(t_fade);
w_in = sin(t_fade);

```

El bucle `while` concatena repeticiones del segmento limpio `src_base` usando el *crossfade* de potencia constante de 200 ms hasta alcanzar `target_N = 60 * Fs` muestras exactas.

### Paso 3: Modelo físico y trayectoria 3D (*Source* vs. *Receptor*)

El receptor (cabeza) se fija en el origen $\vec{p}_r = [0, 0, 0]$. Para cada bloque de audio, se evalúa el tiempo central `t` y se calcula la posición 3D de la mosca $\vec{p}_s(t) = [x_s, y_s, z_s]$:

* **Ángulo orbital:** $\theta(t) = 2\pi (0.4)\, t$ (da 0.4 vueltas por segundo).
* **Radio variable:** $R(t) = 0.8 + 0.4 \sin(2\pi (0.25)\, t)$ (se acerca hasta 0.4 m y se aleja hasta 1.2 m).
* **Coordenadas cartesianas:**

$$x_s = R(t)\cos(\theta), \quad y_s = R(t)\sin(\theta), \quad z_s = 0.35\sin(2\pi (0.5)\, t)$$



Con ambas posiciones se obtiene el vector relativo y la distancia euclidiana:


$$\Delta\vec{p} = \vec{p}_s - \vec{p}_r, \qquad d = \|\Delta\vec{p}\|$$

### Paso 4: Conversión a coordenadas esféricas

```matlab
[az_rad, el_rad, ~] = cart2sph(rel_pos(1), rel_pos(2), rel_pos(3));
az_deg = mod(-rad2deg(az_rad), 360);
el_deg = max(-40, min(90, rad2deg(el_rad)));

```

`cart2sph` convierte $(x, y, z)$ a ángulos en radianes. Luego se adaptan a la convención del dataset KEMAR:

* **Acimut (`az_deg`):** En $[0^\circ, 360^\circ)$, donde $0^\circ$ es al frente, $90^\circ$ a la derecha, $180^\circ$ atrás y $270^\circ$ a la izquierda. Se invierte el signo de `az_rad` porque `cart2sph` mide ángulos positivos en sentido antihorario.
* **Elevación (`el_deg`):** Se limita al rango físico medido en KEMAR: $[-40^\circ, 90^\circ]$.

### Paso 5: Optimización con caché en memoria

Cada llamada a `interphrir` lee varios archivos `.dat` del disco. Para evitar miles de lecturas repetidas en un audio de 60 segundos, los ángulos se cuantizan en pasos de $2^\circ$ (`angle_step = 2`) y se almacenan en un `containers.Map` (`hrir_cache`). Si un ángulo ya fue calculado en una vuelta anterior, se recupera instantáneamente de la memoria RAM.

### Paso 6: Convolución estéreo, normalización y gráfica 3D

Cada bloque se multiplica por la ganancia por distancia (`1 / max(dist, 0.25)`), se convoluciona por separado con `h(:, 1)` (oído izquierdo) y `h(:, 2)` (oído derecho), y se acumula en `output` mediante *Overlap-Add*.

Al finalizar el bucle:

1. Se normaliza la señal al 95% del rango máximo (`* 0.95`) para evitar distorsión (*clipping*).
2. Se guarda el resultado en `mosca_3D.wav`.
3. Se grafica la trayectoria 3D guardada en `traj` junto con la posición del receptor usando `plot3`.

---

## Documentación de los archivos librería

Estos archivos actúan como el motor de lectura e interpolación del dataset KEMAR y trabajan en cadena:

`main_mosca.m` $\rightarrow$ `interphrir.m` $\rightarrow$ `formatangle.m` / `readhrtf.m` $\rightarrow$ `hrtfpath.m` / `readraw.m`

### `interphrir.m`

* **Propósito:** Calcular una HRIR suave para cualquier ángulo arbitrario `(az, el)`, incluso si no existe un archivo `.dat` medido exactamente en ese punto.
* **Cómo funciona:**
1. Llama a `formatangle` para asegurar que los ángulos estén dentro del dominio válido.
2. Busca los **4 puntos medidos más cercanos** en la malla esférica de KEMAR (dos elevaciones adyacentes `elev1`, `elev2` y dos acimutes por cada elevación).
3. Calcula pesos de ponderación lineal horizontales (`PondH`) y verticales (`PondV`) según la cercanía del punto deseado a cada esquina.
4. Carga las 4 HRIR con `readhrtf`, las pasa al dominio de la frecuencia mediante la Transformada Rápida de Fourier (`fft`), realiza la **interpolación bilineal** en frecuencia para cada oído, y vuelve al dominio del tiempo con `ifft`.
5. Devuelve una matriz de $512 \times 2$ (columna 1 = izquierdo, columna 2 = derecho).



### `formatangle.m`

* **Propósito:** Normalizar cualquier ángulo de entrada al formato esperado por las mediciones del MIT.
* **Cómo funciona:** Envuelve el acimut al intervalo $[0^\circ, 360^\circ)$ sumando o restando $360^\circ$, y restringe la elevación al rango $[-40^\circ, 90^\circ]$ (cualquier elevación por debajo de $-40^\circ$ se fija en $-40^\circ$).

### `readhrtf.m`

* **Propósito:** Cargar el par estéreo de respuestas al impulso para un punto medido exacto `(elev, azim)`.
* **Cómo funciona:**
1. Utiliza `dir_ch = filesep` para compatibilidad automática entre Windows (`\`) y Linux/MATLAB Online (`/`).
2. Aprovecha la **simetría de la cabeza**: para un oído lee el ángulo `azim` y para el otro oído lee el ángulo espejo `flip_azim = 360 - azim`.
3. **Normalización acústica:** Divide toda la señal por la norma de la medición en `(40°, 45°)` para evitar que la ganancia del filtro supere 1 y cause distorsión en el archivo `.wav`.
4. Recorta los coeficientes solicitados (`1:512`).



### `hrtfpath.m`

* **Propósito:** Construir la ruta relativa hacia el archivo `.dat` correspondiente.
* **Formato de salida:** `full/elev<E>/<S><E>e<AAA>a.dat` (por ejemplo, `full/elev0/R0e090a.dat` para elevación $0^\circ$, acimut $90^\circ$, oído derecho).

### `readraw.m`

* **Propósito:** Leer los datos binarios crudos de un archivo `.dat`.
* **Cómo funciona:** Abre el archivo en formato *big-endian* (`'ieee-be'`), lee enteros de 16 bits con signo (`'short'`) y los divide para $32768$ ($2^{15}$) para escalar las muestras al rango estándar de audio $[-1, 1]$.

---

## Requisitos y ejecución

1. **Software:** MATLAB (escritorio o MATLAB Online). No requiere toolboxes adicionales.
2. **Dataset:** La carpeta `full/` del dataset KEMAR (MIT Media Lab) debe ubicarse en la raíz del proyecto junto a `main_mosca.m`.
3. **Ejecución:**
* Abre la carpeta del proyecto como directorio actual (*Current Folder*) en MATLAB.
* Ejecuta `main_mosca` en el *Command Window*.
* Al finalizar, se abrirá la gráfica 3D de la trayectoria, se reproducirá el audio y se guardará `mosca_3D.wav` en la misma carpeta.
