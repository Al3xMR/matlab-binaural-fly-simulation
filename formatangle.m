function R = formatangle(elev,azim)

% R = formatangle(elev,azim)
% Retorna os angulos formatados dentro do esquema utilizado nas medicoes do
% MIT

Pd(1)=elev;
Pd(2)=azim;

%Para garantizar que no me den un valor de azimut menor que 0 o un valor
%mayor o igual a 360
while(abs(Pd(2))>=360)
    if (Pd(2)<0)
        Pd(2)=Pd(2)+360;       
    end
    if (Pd(2)>0)
        Pd(2)=Pd(2)-360;
    end
end
if (Pd(2)<0)
    Pd(2)=Pd(2)+360;       
end 

%Para garantizar que no me den un valor de azimut mayor 90 y menor que -40
while(abs(Pd(1))>=360) %Garantizo que no sea mayor que 360 ni menor que -360
   if (Pd(1)<0)
       Pd(1)=Pd(1)+360;       
   end   
   if (Pd(1)>0)
       Pd(1)=Pd(1)-360;       
   end    
end
if (Pd(1)<-180) % Todo valor menor que -180 se expresa como angulo entre 0 y 180 
    Pd(1)=Pd(1)+360;
end
if (Pd(1)>90 && Pd(1)<=180) %Todo valor mayor que 90 y menor que 180 se expresa como angulo entre 0 y 90
       Pd(1)=180-Pd(1);
end
if (Pd(1)>180) % Todo valor mayor que 180 se expresa como angulo entre -180 y 0
    Pd(1)=Pd(1)-360;
end
if (Pd(1)<-40 && Pd(1)>-140) %Todo valor entre -40 y -140 es considerado como -40
       Pd(1)=-40;        
end

R = [Pd(1) Pd(2)];