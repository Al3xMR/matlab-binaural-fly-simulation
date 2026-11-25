function HRIRint = interphrir(az,el)

% %Limpio memoria antes de comenzar.
% clear all;
% close all; 
% clc;
% az=331;
% el=80;


%Defino los cuatro puntos medidos que van encerrar al punto dado
%   Los inicializo con valores que nunca saldrían del proceso normal
%   para poder identificar en caso que algo salga mal.
elev1=100;
elev2=100;
azim1=360;
azim2=360;
azim3=360;
azim4=360;

%Defino mi punto dado, azimut [0,360[ y elevación [-40,90]
%   [a,x] Intervalo de a hasta x (x incluido en el intervalo)
%   [a,x[ Intervalo de a hasta x (x no incluido en el intervalo)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Proceso para formatear los ángulos adecuadamente
Pd = formatangle(el,az); %elev,azim
%Pd(1) %Elevacao
%Pd(2) %Azimute

nele=14; %Numero de elevaciones
%Defino vector elevación con todas las posibles elevaciones
velev=[90,80,70,60,50,40,30,20,10, 0,-10,-20,-30,-40];
%       1, 2, 3, 4, 5, 6, 7, 8, 9,10, 11, 12, 13, 14
%Numero de azimutes por elevación
nazim=[ 1,12,24,36,45,56,60,72,72,72, 72, 72, 60, 56];

azim=0;
for a=1:nazim(6) %da valores para -40 y 40
   velevn40(a) = azim;
   velev40(a) = azim;
   azim=azim+(360/nazim(6));   
end

azim=0;
for a=1:nazim(7) %da valores para -30 y 30
   velevn30(a) = azim;
   velev30(a) = azim;
   azim=azim+(360/nazim(7));   
end

azim=0;
for a=1:nazim(8) %da valores para -20 y 20, -10 y 10 y 0
   velevn20(a) =azim;
   velev20(a) =azim;
   velevn10(a) =azim;
   velev10(a) =azim;
   velev0(a) =azim;   
   azim=azim+(360/nazim(8));   
end

azim=0;
for a=1:nazim(5) %da valores para 50
   velev50(a) =azim;
   azim=azim+(360/nazim(5));   
end

azim=0;
for a=1:nazim(4) %da valores para 60
   velev60(a) =azim;
   azim=azim+(360/nazim(4));   
end

azim=0;
for a=1:nazim(3) %da valores para 70
   velev70(a) =azim;
   azim=azim+(360/nazim(3));   
end

azim=0;
for a=1:nazim(2) %da valores para 80
   velev80(a) =azim;
   azim=azim+(360/nazim(2));   
end

azim=0;
for a=1:nazim(1) %da valores para 90
   velev90(a) = azim;
   azim=azim+(360/nazim(1));   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Proceso para encontrar Elevaciones

for a=1:13 % me sirve pare encontrar la elevación    
    if (velev(a)>=Pd(1) && velev(a+1)<=Pd(1));
        elev1=velev(a);
        elev2=velev(a+1);
    end
end
%Fin proceso para encontrar Elevaciones

%Proceso para encontrar Azimut
if(elev1==-40);% me sirve para encontrar el azimut con elevacion -40
    for a=1:nazim(14)-1
        if(velevn40(a)<=Pd(2) && velevn40(a+1)>=Pd(2));            
            azim1=velevn40(a);
            azim2=velevn40(a+1);
        end
        if (a==nazim(14)-1 && azim1==360 && azim2==360)
            azim1=velevn40(a+1);
            azim2=360;%velevn40(1);
        end
    end
end
if(elev2==-40);% me sirve para encontrar el azimut con elevacion -40
    for a=1:nazim(14)-1
        if(velevn40(a)<=Pd(2) && velevn40(a+1)>=Pd(2));            
            azim3=velevn40(a);
            azim4=velevn40(a+1);
        end
        if (a==nazim(14)-1 && azim3==360 && azim4==360)
            azim3=velevn40(a+1);
            azim4=360;%velevn40(1);
        end        
    end
end

if(elev1==-30);% me sirve para encontrar el azimut con elevacion -30
    for a=1:nazim(13)-1
        if(velevn30(a)<=Pd(2) && velevn30(a+1)>=Pd(2));            
            azim1=velevn30(a);
            azim2=velevn30(a+1);
        end
        if (a==nazim(13)-1 && azim1==360 && azim2==360)
            azim1=velevn30(a+1);
            azim2=360;%velevn30(1);
        end        
    end
end
if(elev2==-30);% me sirve para encontrar el azimut con elevacion -30    
    for a=1:nazim(13)-1
        if(velevn30(a)<=Pd(2) && velevn30(a+1)>=Pd(2));            
            azim3=velevn30(a);
            azim4=velevn30(a+1);
        end
        if (a==nazim(13)-1 && azim3==360 && azim4==360)
            azim3=velevn30(a+1);
            azim4=360;%velevn30(1);
        end 
    end
end

if(elev1==-20);% me sirve para encontrar el azimut con elevacion -20
    for a=1:nazim(12)-1
        if(velevn20(a)<=Pd(2) && velevn20(a+1)>=Pd(2));            
            azim1=velevn20(a);
            azim2=velevn20(a+1);
        end
        if (a==nazim(12)-1 && azim1==360 && azim2==360)
            azim1=velevn20(a+1);
            azim2=360;%velevn20(1);
        end
    end
end
if(elev2==-20);% me sirve para encontrar el azimut con elevacion -20
    for a=1:nazim(12)-1
        if(velevn20(a)<=Pd(2) && velevn20(a+1)>=Pd(2));            
            azim3=velevn20(a);
            azim4=velevn20(a+1);
        end        
        if (a==nazim(12)-1 && azim3==360 && azim4==360)
            azim3=velevn20(a+1);
            azim4=360;%velevn20(1);
        end 
    end
end

if(elev1==-10);% me sirve para encontrar el azimut con elevacion -10
    for a=1:nazim(11)-1
        if(velevn10(a)<=Pd(2) && velevn10(a+1)>=Pd(2));            
            azim1=velevn10(a);
            azim2=velevn10(a+1);
        end
        if (a==nazim(11)-1 && azim1==360 && azim2==360)
            azim1=velevn10(a+1);
            azim2=360;%velevn10(1);
        end        
    end
end
if(elev2==-10);% me sirve para encontrar el azimut con elevacion -10
    for a=1:nazim(11)-1
        if(velevn10(a)<=Pd(2) && velevn10(a+1)>=Pd(2));            
            azim3=velevn10(a);
            azim4=velevn10(a+1);
        end
        if (a==nazim(11)-1 && azim3==360 && azim4==360)
            azim3=velevn10(a+1);
            azim4=360;%velevn10(1);
        end        
    end
end

if(elev1==0);% me sirve para encontrar el azimut con elevacion 0
    for a=1:nazim(10)-1
        if(velev0(a)<=Pd(2) && velev0(a+1)>=Pd(2));            
            azim1=velev0(a);
            azim2=velev0(a+1);
        end
        if (a==nazim(10)-1 && azim1==360 && azim2==360)
            azim1=velev0(a+1);
            azim2=360;%velev0(1);
        end        
    end
    %display(sprintf('az1: %i° - az2: %i°', azim1, azim2));
end
if(elev2==0);% me sirve para encontrar el azimut con elevacion 0
    for a=1:nazim(10)-1
        if(velev0(a)<=Pd(2) && velev0(a+1)>=Pd(2));            
            azim3=velev0(a);
            azim4=velev0(a+1);
        end
        if (a==nazim(10)-1 && azim3==360 && azim4==360)
            azim3=velev0(a+1);
            azim4=360;%velev0(1);
        end        
    end
    %display(sprintf('az3: %i° - az4: %i°', azim3, azim4));
end


if(elev1==10);% me sirve para encontrar el azimut con elevacion 10
    for a=1:nazim(9)-1
        if(velev10(a)<=Pd(2) && velev10(a+1)>=Pd(2));            
            azim1=velev10(a);
            azim2=velev10(a+1);
        end        
        if (a==nazim(9)-1 && azim1==360 && azim2==360)
            azim1=velev10(a+1);
            azim2=360;%velev10(1);
        end
    end
end
if(elev2==10);% me sirve para encontrar el azimut con elevacion 10
    for a=1:nazim(9)-1
        if(velev10(a)<=Pd(2) && velev10(a+1)>=Pd(2));            
            azim3=velev10(a);
            azim4=velev10(a+1);
        end
        if (a==nazim(9)-1 && azim3==360 && azim4==360)
            azim3=velev10(a+1);
            azim4=360;%velev10(1);
        end         
    end
end

if(elev1==20);% me sirve para encontrar el azimut con elevacion 20
    for a=1:nazim(8)-1
        if(velev20(a)<=Pd(2) && velev20(a+1)>=Pd(2));            
            azim1=velev20(a);
            azim2=velev20(a+1);
        end
        if (a==nazim(8)-1 && azim1==360 && azim2==360)
            azim1=velev20(a+1);
            azim2=360;%velev20(1);
        end
    end
end
if(elev2==20);% me sirve para encontrar el azimut con elevacion 20
    for a=1:nazim(8)-1
        if(velev20(a)<=Pd(2) && velev20(a+1)>=Pd(2));            
            azim3=velev20(a);
            azim4=velev20(a+1);
        end
        if (a==nazim(8)-1 && azim3==360 && azim4==360)
            azim3=velev20(a+1);
            azim4=360;%velev20(1);
        end         
    end
end

if(elev1==30);% me sirve para encontrar el azimut con elevacion 30
    for a=1:nazim(7)-1
        if(velev30(a)<=Pd(2) && velev30(a+1)>=Pd(2));            
            azim1=velev30(a);
            azim2=velev30(a+1);
        end
        if (a==nazim(7)-1 && azim1==360 && azim2==360)
            azim1=velev30(a+1);
            azim2=360;%velev30(1);
        end        
    end
end
if(elev2==30);% me sirve para encontrar el azimut con elevacion 30
    for a=1:nazim(7)-1
        if(velev30(a)<=Pd(2) && velev30(a+1)>=Pd(2));            
            azim3=velev30(a);
            azim4=velev30(a+1);
        end
        if (a==nazim(7)-1 && azim3==360 && azim4==360)
            azim3=velev30(a+1);
            azim4=360;%velev30(1);
        end         
    end
end

if(elev1==40);% me sirve para encontrar el azimut con elevacion 40
    for a=1:nazim(6)-1
        if(velev40(a)<=Pd(2) && velev40(a+1)>=Pd(2));            
            azim1=velev40(a);
            azim2=velev40(a+1);
        end
        if (a==nazim(6)-1 && azim1==360 && azim2==360)
            azim1=velev40(a+1);
            azim2=360;%velev40(1);
        end
    end
end
if(elev2==40);% me sirve para encontrar el azimut con elevacion 40
    for a=1:nazim(6)-1
        if(velev40(a)<=Pd(2) && velev40(a+1)>=Pd(2));            
            azim3=velev40(a);
            azim4=velev40(a+1);
        end
        if (a==nazim(6)-1 && azim3==360 && azim4==360)
            azim3=velev40(a+1);
            azim4=360;%velev40(1);
        end        
    end
end

if(elev1==50);% me sirve para encontrar el azimut con elevacion 50
    for a=1:nazim(5)-1
        if(velev50(a)<=Pd(2) && velev50(a+1)>=Pd(2));            
            azim1=velev50(a);
            azim2=velev50(a+1);
        end
        if (a==nazim(5)-1 && azim1==360 && azim2==360)
            azim1=velev50(a+1);
            azim2=360;%velev50(1);
        end
    end
end
if(elev2==50);% me sirve para encontrar el azimut con elevacion 50
    for a=1:nazim(5)-1
        if(velev50(a)<=Pd(2) && velev50(a+1)>=Pd(2));            
            azim3=velev50(a);
            azim4=velev50(a+1);
        end
        if (a==nazim(5)-1 && azim3==360 && azim4==360)
            azim3=velev50(a+1);
            azim4=360;%velev50(1);
        end        
    end
end

if(elev1==60);% me sirve para encontrar el azimut con elevacion 60
    for a=1:nazim(4)-1
        if(velev60(a)<=Pd(2) && velev60(a+1)>=Pd(2));            
            azim1=velev60(a);
            azim2=velev60(a+1);
        end
        if (a==nazim(4)-1 && azim1==360 && azim2==360)
            azim1=velev60(a+1);
            azim2=360;%velev60(1);
        end
    end
end
if(elev2==60);% me sirve para encontrar el azimut con elevacion 60
    for a=1:nazim(4)-1
        if(velev60(a)<=Pd(2) && velev60(a+1)>=Pd(2));            
            azim3=velev60(a);
            azim4=velev60(a+1);
        end
        if (a==nazim(4)-1 && azim3==360 && azim4==360)
            azim3=velev60(a+1);
            azim4=360;%velev60(1);
        end        
    end
end

if(elev1==70);% me sirve para encontrar el azimut con elevacion 70
    for a=1:nazim(3)-1
        if(velev70(a)<=Pd(2) && velev70(a+1)>=Pd(2));            
            azim1=velev70(a);
            azim2=velev70(a+1);
        end
        if (a==nazim(3)-1 && azim1==360 && azim2==360)
            azim1=velev70(a+1);
            azim2=360;%velev70(1);
        end
    end
end
if(elev2==70);% me sirve para encontrar el azimut con elevacion 70
    for a=1:nazim(3)-1
        if(velev70(a)<=Pd(2) && velev70(a+1)>=Pd(2));            
            azim3=velev70(a);
            azim4=velev70(a+1);            
        end
        if (a==nazim(3)-1 && azim3==360 && azim4==360)
            azim3=velev70(a+1);
            azim4=360;%velev70(1);
        end        
    end
end

if(elev1==80);% me sirve para encontrar el azimut con elevacion 80
    for a=1:nazim(2)-1
        if(velev80(a)<=Pd(2) && velev80(a+1)>=Pd(2));            
            azim1=velev80(a);
            azim2=velev80(a+1);
        end
        if (a==nazim(2)-1 && azim1==360 && azim2==360)
            azim1=velev80(a+1);
            azim2=360;%velev80(1);
        end
    end
end
if(elev2==80);% me sirve para encontrar el azimut con elevacion 80    
    for a=1:nazim(2)-1
        if(velev80(a)<=Pd(2) && velev80(a+1)>=Pd(2));            
            azim3=velev80(a);
            azim4=velev80(a+1);            
        end
        if (a==nazim(2)-1 && azim3==360 && azim4==360)
            azim3=velev80(a+1);
            azim4=360;%velev80(1);
        end        
    end
end

if(elev1==90);% me sirve para encontrar el azimut con elevacion 90
    azim1=0;
    azim2=0;      
end
if(elev2==90);% me sirve para encontrar el azimut con elevacion 90
    azim3=0;
    azim4=0;
end

%Fin proceso para encontrar Azimut
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Paso para encontrar la ponderacion de distancias del rayo acustico
%Valor absoluto de Punto medido menos Punto dado

%if azim1==0 && azim2

Y1=abs(elev1-Pd(1));%distancia resultante para elevacion 1
X11=abs(azim1-Pd(2));%distancia resultante para azimut 1
X12=abs(azim2-Pd(2));%distancia resultante para azimut 2
Y2=abs(elev2-Pd(1));%distancia resultante para elevacion 2
X21=abs(azim3-Pd(2));%distancia resultante para azimut 3
X22=abs(azim4-Pd(2));%distancia resultante para azimut 4

Y=abs(elev1-elev2);%distancia resultante entre elevación 1 y 2 (siempre será 10)
X1=abs(azim1-azim2);%distancia resultante entre azimuts 1 y 2 (en elevación 1)
X2=abs(azim3-azim4);%distancia resultante entre azimuts 3 y 3 (en elevación 2)

PondV1 = 1-(Y1/Y);% Valor de ponderación vertical para HRIRs 1 y 2 (elevación 1)
PondV2 = 1-(Y2/Y);% Valor de ponderación vertical para HRIRs 3 y 4 (elevación 2)
if(X1==0)
    PondH11 = 0;% Valor de ponderación horizontal para HRIR 1
    PondH12 = 0;% Valor de ponderación horizontal para HRIR 2    
else
    PondH11 = 1-(X11/X1);% Valor de ponderación horizontal para HRIR 1
    PondH12 = 1-(X12/X1);% Valor de ponderación horizontal para HRIR 2    
end
if(X2==0)
    PondH21 = 0;% Valor de ponderación horizontal para HRIR 1
    PondH22 = 0;% Valor de ponderación horizontal para HRIR 2    
else
    PondH21 = 1-(X21/X2);% Valor de ponderación horizontal para HRIR 3
    PondH22 = 1-(X22/X2);% Valor de ponderación horizontal para HRIR 4
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Obtengo la HRIR medidas y retiro las direncias temporales interaurales

HRIR1 = readhrtf(elev1,azim1, 'R' ,[1:512])';
% % Tira o ITD
% itd = atraso(azim1);
% HRIRitd(:,1) = HRIR1(itd(1):itd(1)+127,1); %HRIR1i(:,1) = HRIR(30:157,1); %
% HRIRitd(:,2) = HRIR1(itd(2):itd(2)+127,2); %HRIR1d(:,2) = HRIR(30:157,2); %
% HRIR1=HRIRitd;
% % Fin de tira o ITD
% %atraso1 = find_delay(elev1,azim1);
% %HRIR1 = shift(HRIR1',-atraso1+1)';

HRIR2 = readhrtf(elev1,azim2, 'R' ,[1:512])';
% % Tira o ITD
% itd = atraso(azim2);
% HRIRitd(:,1) = HRIR2(itd(1):itd(1)+127,1); %HRIR1i(:,1) = HRIR(30:157,1); %
% HRIRitd(:,2) = HRIR2(itd(2):itd(2)+127,2); %HRIR1d(:,2) = HRIR(30:157,2); %
% HRIR2=HRIRitd;
% % Fin de tira o ITD
% %atraso2 = find_delay(elev1,azim2);
% %HRIR2 = shift(HRIR2',-atraso2+1)';

HRIR3 = readhrtf(elev2,azim3, 'R' ,[1:512])';
% % Tira o ITD
% itd = atraso(azim3);
% HRIRitd(:,1) = HRIR3(itd(1):itd(1)+127,1); %HRIR1i(:,1) = HRIR(30:157,1); %
% HRIRitd(:,2) = HRIR3(itd(2):itd(2)+127,2); %HRIR1d(:,2) = HRIR(30:157,2); %
% HRIR3=HRIRitd;
% % Fin de tira o ITD
% %atraso3 = find_delay(elev2,azim3);
% %HRIR3 = shift(HRIR3',-atraso3+1)';

HRIR4 = readhrtf(elev2,azim4, 'R' ,[1:512])';
% % Tira o ITD
% itd = atraso(azim4);
% HRIRitd(:,1) = HRIR4(itd(1):itd(1)+127,1); %HRIR1i(:,1) = HRIR(30:157,1); %
% HRIRitd(:,2) = HRIR4(itd(2):itd(2)+127,2); %HRIR1d(:,2) = HRIR(30:157,2); %
% HRIR4=HRIRitd;
% % Fin de tira o ITD
% %atraso4 = find_delay(elev2,azim4);
% %HRIR4 = shift(HRIR4',-atraso4+1)';

HRIR1i = HRIR1(:,1);
HRIR1d = HRIR1(:,2);
HRIR2i = HRIR2(:,1);
HRIR2d = HRIR2(:,2);
HRIR3i = HRIR3(:,1);
HRIR3d = HRIR3(:,2);
HRIR4i = HRIR4(:,1);
HRIR4d = HRIR4(:,2);

Fs = 44100;                    
T = 1/Fs;                     
L = 512;%128;%
t = (0:L-1)*T; 
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT/2+1);

HRTF1i = fft(HRIR1i,NFFT)/L;
HRTF1d = fft(HRIR1d,NFFT)/L;
HRTF2i = fft(HRIR2i,NFFT)/L;
HRTF2d = fft(HRIR2d,NFFT)/L;
HRTF3i = fft(HRIR3i,NFFT)/L;
HRTF3d = fft(HRIR3d,NFFT)/L;
HRTF4i = fft(HRIR4i,NFFT)/L;
HRTF4d = fft(HRIR4d,NFFT)/L;

for a=1:L
    if(PondH11==0&&PondH12==0)
        V1 = HRTF1i(a);    
    else
        V1 = HRTF1i(a)*PondH11 + HRTF2i(a)*PondH12;    
    end
    if(PondH21==0&&PondH22==0)
        V2 = HRTF3i(a);    
    else
        V2 = HRTF3i(a)*PondH21 + HRTF4i(a)*PondH22;
    end
    V3 = V1*PondV1 + V2*PondV2;
    HRTFi(a) = V3;
    if(PondH11==0&&PondH12==0)
        V1 = HRTF1d(a);    
    else
        V1 = HRTF1d(a)*PondH11 + HRTF2d(a)*PondH12;    
    end
    if(PondH21==0&&PondH22==0)
        V2 = HRTF3d(a);    
    else
        V2 = HRTF3d(a)*PondH21 + HRTF4d(a)*PondH22;
    end
    V3 = V1*PondV1 + V2*PondV2;
    HRTFd(a) = V3;    
end

HRIRi = ifft(HRTFi)*L;
HRIRd = ifft(HRTFd)*L;
HRIRint(:,1) = HRIRi;%(30:157);
HRIRint(:,2) = HRIRd;%(30:157);
 
%Grafica de HRIR Ponderada y las medidas

% figure(1)
% subplot(4,2,[1 2 3 4])
% plot(t(28:156),HRIRd(28:156),t(28:156),HRIRi(28:156));    
% h=legend('HRIRd','HRIRi','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRIRs Ponderadas (Azimute = %f, Elevación = %f)',Pd(2),Pd(1)));
% xlabel('time (1/44100 segundos)');
% 
% subplot(4,2,5)
% plot(t(28:156),HRIR1d(28:156),t(28:156),HRIR1i(28:156));    
% h=legend('HRIRd','HRIRi','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRIRs medidas (Azimute = %f, Elevación = %f)',azim1,elev1));
% xlabel('time (1/44100 segundos)');
% 
% subplot(4,2,6)
% plot(t(28:156),HRIR2d(28:156),t(28:156),HRIR2i(28:156));    
% h=legend('HRIRd','HRIRi','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRIRs medidas (Azimute = %f, Elevación = %f)',azim2,elev1));
% xlabel('time (1/44100 segundos)');
% 
% subplot(4,2,7)
% plot(t(28:156),HRIR3d(28:156),t(28:156),HRIR3i(28:156));    
% h=legend('HRIRd','HRIRi','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRIRs medidas (Azimute = %f, Elevación = %f)',azim3,elev2));
% xlabel('time (1/44100 segundos)');
% 
% subplot(4,2,8)
% plot(t(28:156),HRIR4d(28:156),t(28:156),HRIR4i(28:156));    
% h=legend('HRIRd','HRIRi','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRIRs medidas (Azimute = %f, Elevación = %f)',azim4,elev2));
% xlabel('time (1/44100 segundos)');
% 
% % Plot single-sided amplitude spectrum.
% figure(2)
% subplot(4,2,[1 2 3 4])
% semilogx(f,2*abs(HRTFd(1:NFFT/2+1)),f,2*abs(HRTFi(1:NFFT/2+1))) 
% h=legend('HRTFd','HRTFi','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRTFs Ponderadas - Potencia (Azimute = %f, Elevación = %f)',Pd(2),Pd(1)))
% xlabel('Frecuencia (Hz)')
% ylabel('|Y(f)|')
% 
% subplot(4,2,5)
% semilogx(f,2*abs(HRTF1d(1:NFFT/2+1)),f,2*abs(HRTF1i(1:NFFT/2+1))) 
% h=legend('HRTF1d','HRTF1i','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRTFs medidas - Potencia (Azimute = %f, Elevación = %f)',azim1,elev1))
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% 
% subplot(4,2,6)
% semilogx(f,2*abs(HRTF2d(1:NFFT/2+1)),f,2*abs(HRTF2i(1:NFFT/2+1))) 
% h=legend('HRTF2d','HRTF2i','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRTFs medidas - Potencia (Azimute = %f, Elevación = %f)',azim2,elev1))
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% 
% subplot(4,2,7)
% semilogx(f,2*abs(HRTF3d(1:NFFT/2+1)),f,2*abs(HRTF3i(1:NFFT/2+1))) 
% h=legend('HRTF3d','HRTF3i','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRTFs medidas - Potencia (Azimute = %f, Elevación = %f)',azim3,elev2))
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% 
% subplot(4,2,8)
% semilogx(f,2*abs(HRTF4d(1:NFFT/2+1)),f,2*abs(HRTF4i(1:NFFT/2+1))) 
% h=legend('HRTF4d','HRTF4i','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRTFs medidas - Potencia (Azimute = %f, Elevación = %f)',azim4,elev2))
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% 
% % Plot single-sided phase spectrum.
% figure(3)
% subplot(4,2,[1 2 3 4])
% semilogx(f,2*angle(HRTFd(1:NFFT/2+1)),f,2*angle(HRTFi(1:NFFT/2+1))) 
% h=legend('HRTFd','HRTFi','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRTFs Ponderadas - Fase (Azimute = %f, Elevación = %f)',Pd(2),Pd(1)))
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% subplot(4,2,5)
% semilogx(f,2*angle(HRTF1d(1:NFFT/2+1)),f,2*angle(HRTF1i(1:NFFT/2+1))) 
% h=legend('HRTF1d','HRTF1i','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRTFs medidas - Fase (Azimute = %f, Elevación = %f)',azim1,elev1))
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% 
% subplot(4,2,6)
% semilogx(f,2*angle(HRTF2d(1:NFFT/2+1)),f,2*angle(HRTF2i(1:NFFT/2+1))) 
% h=legend('HRTF2d','HRTF2i','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRTFs medidas - Fase (Azimute = %f, Elevación = %f)',azim2,elev1))
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% 
% subplot(4,2,7)
% semilogx(f,2*angle(HRTF3d(1:NFFT/2+1)),f,2*angle(HRTF3i(1:NFFT/2+1))) 
% h=legend('HRTF3d','HRTF3i','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRTFs medidas - Fase (Azimute = %f, Elevación = %f)',azim3,elev2))
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')
% 
% subplot(4,2,8)
% semilogx(f,2*angle(HRTF4d(1:NFFT/2+1)),f,2*angle(HRTF4i(1:NFFT/2+1))) 
% h=legend('HRTF4d','HRTF4i','Location','NorthEast');
% set(h,'Interpreter','none');
% title(sprintf('HRTFs medidas - Fase (Azimute = %f, Elevación = %f)',azim4,elev2))
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')

clear az;
clear el;
clear HRIRi;
clear HRIRd;
clear Fs;
clear HRIR1;
clear HRIR1d;
clear HRIR1i;
clear HRIR2;
clear HRIR2d;
clear HRIR2i;
clear HRIR3;
clear HRIR3d;
clear HRIR3i;
clear HRIR4;
clear HRIR4d;
clear HRIR4i;
clear HRTF1d;
clear HRTF1i;
clear HRTF2d;
clear HRTF2i;
clear HRTF3d;
clear HRTF3i;
clear HRTF4d;
clear HRTF4i;
clear HRTFd;
clear HRTFi;
clear L;
clear NFFT;
clear Pd;
clear PondH11;
clear PondH12;
clear PondH21;
clear PondH22;
clear PondV1;
clear PondV2;
clear T;
clear V1;
clear V2;
clear V3;
clear X1;
clear X11;
clear X12;
clear X2;
clear X21;
clear X22;
clear Y;
clear Y1;
clear Y2;
clear a;
clear azim;
clear azim1;
clear azim2;
clear azim3;
clear azim4;
clear elev1;
clear elev2;
clear f;
clear h;
clear nazim;
clear nele;
clear t;
clear velev;
clear velev0;
clear velev10;
clear velev20;
clear velev30;
clear velev40;
clear velev50;
clear velev60;
clear velev70;
clear velev80;
clear velev90;
clear velevn10;
clear velevn20;
clear velevn30;
clear velevn40;