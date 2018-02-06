% procesado_datos.m - Análisis de datos de la placa. Integración con la captura de video

clear;

addpath ('C:\Users\BPWilcox\Documents\Motion_Capture\Brian_arm_motion')

% Cambio Directorio
%cd('C:\Users\Administrator\Documents\Ferrol\LIM\Proyectos\Biomecanica\Datos');

% Procesado Datos Cámara

itf=c3dserver;
fichero=input('Nombre del fichero de datos c3d:','s');

openc3d(itf,0,fichero);

% Procesado del fichero

n_frames_orig=nframes(itf);

% Extracción de las etiquetas

n_param=itf.GetNumberParameters;

% Búsqueda del parámetro LABELS'

i=0;
while(i<n_param)
     nombre=itf.GetParameterName(i);
     if( strcmp(nombre,'LABELS'))
         n_label=i;
         i=n_param;
     end
     i=i+1;
 end
 
% Captura de las etiquetas

n_puntos=itf.GetNumber3DPoints();
etiquetas=[];
for i=0:(n_puntos-1)
    nombre=itf.GetParameterValue(n_label,i);
    etiquetas=strvcat(etiquetas, nombre);
end

aux=sprintf('Capturadas %d curvas de %d puntos cada una.',n_puntos,n_frames_orig);
disp(aux);
disp('Etiquetas:');
disp(etiquetas);

% Extracción de los datos

captura_orig=[];
for i=4:(n_puntos)
    captura_orig=[captura_orig get3dtarget(itf,etiquetas(i,:))];
end

closec3d(itf);

%%

% Eliminación de las frame_inic-1 primeras muestras

frame_inic=1;

n_frames=n_frames_orig-(frame_inic-1);
captura=captura_orig(frame_inic:n_frames_orig,:);

%%

% Eliminación dels últims frames si cal
frame_fi=n_frames_orig-50;
n_frames=frame_fi;
captura=captura_orig(frame_inic:frame_fi,:);
%%
% Base de Tiempos

Ts=1/100;  % 100 fps
T=[0:Ts:((n_frames-1)*Ts)];

% Reconstrucción Trayectorias

datos=[];
secuencia_datos=[];
datos_parciales=[];
secuencia_datos_parciales=[];

max_salto=80; % 6,0 m/s 
max_saltoest=3.5*max_salto; 
max_tam_hueco=0; % 0 muestras -> No prioridad a la curva
max_tam_gap=100; % Horizonte Temporal 100 frames (1,0 s) 

for i=1:n_puntos-3
    a=1; 
    i1=i;
    
    aux1=zeros(n_frames,3);
    aux1(1,:)=captura(1,(i1-1)*3+1:(i1*3));
    
    sec=sprintf('%d: %s',i1,etiquetas(i1,:));
    disp(sec);
    
    if(isnan(mean(captura(1:12,(i1-1)*3+1:(i1*3)))))
        disp(sprintf('-> %s','Datos no válidos'));
        salto=inf;
    else
        while (a<n_frames)
            salto=max(abs(captura(a+1,(i1-1)*3+1:(i1*3))-captura(a,(i1-1)*3+1:(i1*3))));
            if(isnan(salto))
                salto=inf;
            end
            
            % Comprobación de Hueco Finito - Prioridad a la función actual
            
            if(salto>max_salto && a>12)
                
                % Polinomio de Estimación Orden 3, espaciado pseudologaritmico
                
                if(a<=20) 
                    Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);];                    
                    X=[a, a-3, a-6, a-11]';    
                elseif(a<=35) 
                    Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);];                    
                    X=[a, a-3, a-6, a-11, a-15]';    
                elseif(a<=65) 
                    Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);];                    
                    X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33]';    
                elseif(a<=75)
                    Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);aux1(a-45,:);aux1(a-61,:);];                    
                    X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33, a-45, a-61]';    
                elseif(a<=95)
                    Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);aux1(a-45,:);aux1(a-61,:);aux1(a-75,:);];
                    X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33, a-45, a-61, a-75]';  
                else
                    Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);aux1(a-45,:);aux1(a-61,:);aux1(a-75,:);aux1(a-91,:);];
                    X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33, a-45, a-61, a-75, a-91]';   
                end
                Te=[ones(size(X)), X, X.^2, X.^3 ];
                Ae=Te\Y; 
                
                % Comprobación de continuidad
                
                b=1;
                tam_hueco=min(max_tam_hueco,(n_frames-a)); 
                
                while(b<tam_hueco)
                    aest=a+b;                     
                    estimacion=[1 (aest) (aest)^2 (aest)^3 ]*Ae;
                    salto=max(abs(captura(aest,(i1-1)*3+1:(i1*3))-estimacion));
                    if(isnan(salto))
                        salto=inf;
                    end
                    
                    if(salto<max_salto) % Hueco Finito
                        
                        % Rellenado
                        for c=1:b                            
                            aux1(a+c,:)=[1 (a+c) (a+c)^2 (a+c)^3 ]*Ae;    
                        end
                        aux=sprintf('--%d Hueco -->Salto Estimado %d',a,b);
                        sec=[sec aux]; 
                        aux=sprintf('--%d--> %s',aest,etiquetas(i1,:));                        
                        sec=[sec aux];  
                        disp(sec);  
                        a=aest;
                        b=max_tam_hueco;    
                    else
                        b=b+1;
                    end
                end
            end
            
            % Búsqueda de la curva más próxima
            
            if(salto>max_salto && a>12)
                salto_ant=salto;
                i_ant=1;
            
                % Busca el más próximo
                
                for i2=1:n_puntos-3
                    salto=max(abs(captura(a+1,(i2-1)*3+1:(i2*3))-captura(a,(i1-1)*3+1:(i1*3))));
                    if(isnan(salto))
                        salto=inf;
                    end

                    if(salto<salto_ant)
                        salto_ant=salto;
                        i_ant=i2;
                    end
                end
            
                % Salto encontrado
                
                 if(salto_ant<max_salto)
                    i1=i_ant;
                    aux=sprintf('--%d--> %s',a,etiquetas(i1,:));
                    sec=[sec aux];
                    disp(sec);
                 else   % Hueco - Salto infinito
                     disp(sprintf('--%d--> %s',a,'Hueco Detectado'));
                    
                     % Proyección horizonte temporal 
                                          
                     % Polinomio de Estimación Orden 3, 17 puntos espaciado pseudologaritmico
                     
                     if(a<=20) 
                         Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);];  
                         X=[a, a-3, a-6, a-11]';                         
                     elseif(a<=35) 
                         Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);];                                             
                         X=[a, a-3, a-6, a-11, a-15]';    
                     elseif(a<=65) 
                         Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);];                                        X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33]';    
                     elseif(a<=75)
                         Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);aux1(a-45,:);aux1(a-61,:);];                    
                         X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33, a-45, a-61]';    
                     elseif(a<=105)
                         Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);aux1(a-45,:);aux1(a-61,:);aux1(a-75,:);];
                         X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33, a-45, a-61, a-75]';  
                     elseif(a<=125) 
                         Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);aux1(a-45,:);aux1(a-61,:);aux1(a-75,:);aux1(a-91,:);aux1(a-100,:);];                    
                         X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33, a-45, a-61, a-75, a-91, a-100]';    
                     elseif(a<=150)
                         Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);aux1(a-45,:);aux1(a-61,:);aux1(a-75,:);aux1(a-91,:);aux1(a-111,:);aux1(a-125,:);];                    
                         X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33, a-45, a-61, a-75, a-91, a-111, a-125]';    
                     elseif(a<=175)
                         Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);aux1(a-45,:);aux1(a-61,:);aux1(a-75,:);aux1(a-91,:);aux1(a-111,:);aux1(a-135,:);aux1(a-150,:);];                    
                         X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33, a-45, a-61, a-75, a-91, a-111, a-135, a-150]';    
                     elseif(a<=200)
                         Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);aux1(a-45,:);aux1(a-61,:);aux1(a-75,:);aux1(a-91,:);aux1(a-111,:);aux1(a-135,:);aux1(a-154,:);aux1(a-175,:);];                    
                         X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33, a-45, a-61, a-75, a-91, a-111, a-135, a-154, a-175]';
                     else
                         Y=[aux1(a,:);aux1(a-3,:); aux1(a-6,:);aux1(a-11,:);aux1(a-15,:);aux1(a-18,:);aux1(a-25,:);aux1(a-33,:);aux1(a-45,:);aux1(a-61,:);aux1(a-75,:);aux1(a-91,:);aux1(a-111,:);aux1(a-135,:);aux1(a-154,:);aux1(a-179,:);aux1(a-200,:);];
                         X=[a, a-3, a-6, a-11, a-15, a-18, a-25, a-33, a-45, a-61, a-75, a-91, a-111, a-135, a-154, a-179, a-200]';
                     end
                     
                     Te=[ones(size(X)), X, X.^2, X.^3 ];
                     Ae=Te\Y;                   
                     
                     b=1;
                     min_gap=[1 inf inf];
                     max_gap=min(max_tam_gap,(n_frames-a));
                     
                     while(b<max_gap)
                         
                         % Busca el más próximo a la estimación 
                         aest=a+b;                    
                         estimacion=[1 (aest) (aest)^2 (aest)^3 ]*Ae;
                         
                         salto_ant=inf;
                         i_ant=1;
                         
                         for i2=1:n_puntos-3
                             salto=max(abs(captura(aest,(i2-1)*3+1:(i2*3))-estimacion));
                             if(isnan(salto))
                                 salto=inf;
                             end
                             if(salto<salto_ant)
                                 salto_ant=salto;
                                 i_ant=i2;
                             end
                         end
                         
                         if(salto_ant<max_saltoest)
                             i1=i_ant;                   
                             aux=sprintf('--%d Hueco -->Salto Estimado %d',a,b);       
                             sec=[sec aux];                        
                             aux=sprintf('--%d--> %s',aest,etiquetas(i1,:));                        
                             sec=[sec aux];                        
                             disp(sec);  
                             b=max_gap;
                             aux1(aest,:)=[1 (aest) (aest)^2 (aest)^3 ]*Ae; 
                         else
                             aux1(aest,:)=[1 (aest) (aest)^2 (aest)^3 ]*Ae;
                         end
                         
                         b=b+1;
                         
                         if(salto_ant<min_gap(1,2))
                             min_gap(1,1)=b;
                             min_gap(1,2)=salto_ant;
                             min_gap(1,3)=i2;
                         end
                     end
                     
                     if(salto_ant>max_saltoest) % No encontrado
                         aux=sprintf('--%d Hueco -->Fin de Secuencia.',a);  
                         sec=[sec aux];                        
                         disp(sec);
                         disp(sprintf('Almacenada Secuencia Parcial'));
                         % Eliminar Estimación de la Secuencia
                         for b=1:max_gap
                             aux1(a+b,:)=[0,0,0];
                         end
                         % Almacenamiento Trayectoria Parcial
                         datos_parciales=[datos_parciales aux1];               
                         secuencia_datos_parciales=strvcat(secuencia_datos_parciales, sec);
                         a=n_frames;
                         min_gap
                     else
                         a=aest;
                     end                 
                 end                 
            end
            
            a=a+1;
            if(a<=n_frames)
                aux1(a,:)=captura(a,(i1-1)*3+1:(i1*3));
            end
        end
    end

    % Almacena Trayectoria Válida
    if(salto<max_salto)
        datos=[datos aux1];               
        secuencia_datos=strvcat(secuencia_datos, sec);
    end
end 
          
disp(sprintf('Generadas %d trayectorias válidas',size(secuencia_datos,1)));
disp(sprintf('Generadas %d trayectorias parciales',size(secuencia_datos_parciales,1)));

% Registro de datos

save(fichero,'T','Ts','n_frames_orig','n_frames','n_puntos','captura_orig','etiquetas','datos','secuencia_datos','max_salto','datos_parciales','secuencia_datos_parciales');

%%

% Animación 3D 

a=figure();
h=newplot();
set(h,'NextPlot','replacechildren ');
axis([-2000 2000 -3500 3500 0 2000])
title('Animación 3D');
view([-20  45])
grid on;

for i1=1:2:n_frames
    
    h=newplot();
    set(h,'NextPlot','replacechildren ');

    h=newplot();
    set(h,'NextPlot','add');
    
    % Datos completos

    for i2=1:size(secuencia_datos,1)
        x=datos(i1,(i2-1)*3+1);    
        y=datos(i1,(i2-1)*3+2);    
        z=datos(i1,(i2-1)*3+3);    
        plot3(x,y,z,'.','MarkerEdgeColor','blue','MarkerSize',12);       
    end

    % Datos Parciales

    for i2=1:size(secuencia_datos_parciales,1)
        x=datos_parciales(i1,(i2-1)*3+1);
        y=datos_parciales(i1,(i2-1)*3+2);
        z=datos_parciales(i1,(i2-1)*3+3);
        plot3(x,y,z,'.','MarkerEdgeColor','red','MarkerSize',12);
    end

    drawnow;
end

figure(a);

% Identificación - Posición Marcadores

a=figure();

% Posición Inicial

i1=1;
subplot(1,2,1);
h=newplot();
set(h,'NextPlot','replacechildren ');
axis([-2000 2000 -3500 3500 0 2000])
title('Posición Inicial Marcadores');
view([-16  21])
grid off;
h=newplot();
set(h,'NextPlot','add');

% Datos completos

for i2=1:size(secuencia_datos,1)
    x=datos(i1,(i2-1)*3+1);    
    y=datos(i1,(i2-1)*3+2);    
    z=datos(i1,(i2-1)*3+3);    
    plot3(x,y,z,'.','MarkerEdgeColor','blue','MarkerSize',5);    
    text(x,y,z,sprintf('%d%',i2));
end

% Datos Parciales

for i2=1:size(secuencia_datos_parciales,1)
    x=datos_parciales(i1,(i2-1)*3+1);
    y=datos_parciales(i1,(i2-1)*3+2);
    z=datos_parciales(i1,(i2-1)*3+3);
    plot3(x,y,z,'.','MarkerEdgeColor','red','MarkerSize',5);
    text(x,y,z,sprintf('%d%',i2));
end
drawnow;

% Posición Final

i1=n_frames;
subplot(1,2,2);
h=newplot();
set(h,'NextPlot','replacechildren ');
drawnow;
axis([-2000 2000 -3500 3500 0 2000])
title('Posición Final Marcadores');
view([-16  21])
grid off;
h=newplot();
set(h,'NextPlot','add');

% Datos completos

for i2=1:size(secuencia_datos,1)
    x=datos(i1,(i2-1)*3+1);    
    y=datos(i1,(i2-1)*3+2);    
    z=datos(i1,(i2-1)*3+3);    
    plot3(x,y,z,'.','MarkerEdgeColor','blue','MarkerSize',5);    
    text(x,y,z,sprintf('%d%',i2));
end

drawnow;
figure(a);