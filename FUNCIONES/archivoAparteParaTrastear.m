%%%COMPARACION DATOS MOCAP E IMU

clc
clear all
close all

fs=100;
T=1/fs;

%%
%-----ADQUISICION DE DATOS-----

%GIROSCOPIO
%datos = csvread('Accelerometer_andando_pisarMarcas_20230305-104412579.csv',1,0);

%creo que tendria que hacer 2 bucles, uno que lea el csv y saque la matriz
%y luego otro que recorra esa matriz y que la separe en lo que he dicho

% Bucle para leer los csv y sacar una matriz (STAND BY)

% % Directorio donde se encuentran los archivos csv
% dir_path = 'ruta/a/la/carpeta';
% 
% % Obtener lista de archivos csv en el directorio
% files = dir(fullfile(dir_path, '*.csv'));
% 
% % Bucle para leer los archivos uno por uno
% for i = 1:length(files)
%     file_path = fullfile(dir_path, files(i).name); % ruta completa del archivo
%     data = readtable(file_path); % leer archivo csv
%     % Hacer lo que necesites con los datos...
% end

%GyroData_csv2struct(Accelerometer_andando_pisarMarcas_20230305-104412579.csv);
% filenames{1} = 'Accelerometer_andando_pisarMarcas_20230305-104412579.csv';
% filenames{2} = 'Accelerometer_andando_pisarMarcas_20230305-104544074.csv';
% filenames = {'Accelerometer_andando_pisarMarcas_20230305-104412579.csv';'Accelerometer_andando_pisarMarcas_20230305-104544074.csv'}
% 
% %cargar el .mat con los datos ya guardados de antes
% load("output")
% 
% for iFileName = 1:numel(filenames)
% if ~isfield(output, filenames{iFileName})
%     %ejecuto la funcion que carga el csv y lo meto en la estructura output
%     %aue sera del tipo output.csvfilename.t
%     %me puedo crear una funcion que sea solo para cargar/importar los
%     %archivos csv (en un script de funcion y luego la llamo)
% end



%muestra 1 datos generales (comienza en 0)
datos1 = readmatrix ('M1MW_MetaWearNuevo_2023-03-22T20.06.42.945_DFE264DC19EA_Gyroscope_100.000Hz_1.7.3.csv');
trial1= datos1(:,3); % lo entiendo pero no se como llamarlo para cambiarle el nombre
t1 = 0:T:((length(trial1)/fs)-T);

%muestra 2 datos generales (no comienza en 0)
datos2 = readmatrix ('M2SMW_MetaWearNuevo_2023-03-22T20.07.34.696_DFE264DC19EA_Gyroscope_100.000Hz_1.7.3.csv');
trial2 = datos2 (:,3);
t2 = 0:T:((length(trial2)/fs)-T);


%% Coordenada x
% ACELERACIONES
%represento las coordenadas x de las muestras.
gyro_x1 = datos1 (:,4);

gyro_x2 = datos2 (:,4);


%% FILTRADO

% primero calculo la transformada de fourier de la señal y la represento
% para poder averiguar la frecuencia de corte ideal para aplicar el filtro
% butterworth
nfft_1 = 2^nextpow2(length(gyro_x1));
nfft_2 = 2^nextpow2(length(gyro_x2));


% Calcula la Transformada de Fourier
N = length(gyro_x1); % Tamaño de la señal
Y1 = fft(gyro_x1,nfft_1); % Calcula la FFT
Y1_mag = abs(gyro_x1); % Magnitud de la FFT
Y2 = fft(gyro_x2,nfft_2); % Calcula la FFT
Y2_mag = abs(gyro_x2); % Magnitud de la FFT
f = fs/2*linspace(0, 1, nfft_1/2+1); % Eje de frecuencia. Al definirlo de esta manera,se asegura que cada punto en el espectro de frecuencia (X) se asocie con su frecuencia correspondiente.

% Visualiza el espectro de frecuencia
figure
plot(f, 2/nfft_1*abs(Y1_mag(1:nfft_1/2+1)))
figure
plot(f, 2/nfft_2*abs(Y2_mag(1:nfft_2/2+1)))

xlabel('Frecuencia (Hz)');
ylabel('Magnitud');

% aplico filtro butterworth
% fc = 5;
% order = 4;
% frecNorm = fc/(fs/2);
% [b,a] = butter (order,frecNorm,'high');
% filtro = filtfilt (b,a,gyro_x1);
% 
% % Graficar la señal original y la señal filtrada
% figure;
% plot(t1, gyro_x1, 'b', 'LineWidth', 1.5);
% hold on;
% plot(t1, filtro, 'r', 'LineWidth', 1.5);
% legend('Original', 'Filtrada');
% xlabel('Tiempo (s)');
% ylabel('Amplitud');
% title('Filtro Butterworth pasa altas');

%pruebo ahora con un filtro paso bajo, a priori no le veo sentido por la
%representacion que hemos hecho de las frecuencias y su magnitud de la
%señal pero voy a probar porque lo he visto ya en el tfg de ines
%mismo codigo que arriba pero poniendo low en vez de high
fc = 15;
order = 4;
frecNorm = fc/(fs/2);
[b,a] = butter (order,frecNorm,'low');
filtro = filtfilt (b,a,gyro_x1);

% Graficar la señal original y la señal filtrada
figure;
subplot(2,1,1);
plot(t1, gyro_x1, 'b', 'LineWidth', 1.5);
% hold on;
subplot(2,1,2);
plot(t1, filtro, 'r', 'LineWidth', 1.5);
legend('Original', 'Filtrada');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Filtro Paso bajo en teoria');

%con el filtro paso bajo no parece que pierda tantos datos pero es que tp
%elimino mucho





% %% PROMEDIO
% 
% gyro_x1 = datos1 (:,2);
% gyro_x2 = datos2 (:,2);
% gyro_x3 = datos3 (:,2);
% gyro_x4 = datos4 (:,2);
% 
% %el 4 este habria que ponerlo como algo general claro
% acel_x = nan(4,615);
% acel_x(1,:) = interp1(gyro_x1,linspace(0,length(gyro_x1),615));%no se si en el linspace tendria que poner tb el numero de puntos
% acel_x(2,:) = interp1(gyro_x2,linspace(0,length(gyro_x2),615));
% acel_x(3,:) = interp1(gyro_x3,linspace(0,length(gyro_x3),615));
% acel_x(4,:) = interp1(gyro_x4,linspace(0,length(gyro_x4),615));
% 
% promedio = mean (acel_x);
% 
% 
% %modificar este codigo
% %en el 615 si eso funciona habria que poner length del mas largo ?
% sample_1 = plot(linspace(0,100,615), acel_x(1,:),'g','DisplayName','Muestra 1')
% hold on
% sample_2 = plot(linspace(0,100,615), acel_x(2,:),'m','DisplayName','Muestra 2')
% hold on
% sample_3 = plot(linspace(0,100,615), acel_x(3,:),'b','DisplayName','Muestra 3')
% hold on
% sample_4 = plot(linspace(0,100,615), acel_x(4,:),'r','DisplayName','Muestra 4')
% hold on
% promedio = plot(linspace(0,100,615), mean(acel_x),'k-','DisplayName','Promedio','LineWidth',3)
% grid on
% xlabel ('time')
% ylabel ('acel_x')
% legend
% hold off
% %figure


% % VELOCIDADES (INTUYO QUE PARA NO TENER QUE HACER TANTO CODIGO PUES HABRIA
% % QUE CREAR BUCLES Y COSAS)
% %igual habria que ajustar los ejes pero de momento asi
% vel_x1 = cumtrapz(t1,acel_x1);
% plot (t1,vel_x1, 'DisplayName','M1');
% grid on
% title ('VELOCIDADES EN X DE LAS DISTINTAS MUESTRAS')
% xlabel('Tiempo')
% ylabel('Velocidad en x')
% hold on
% vel_x2 = cumtrapz(t2,acel_x2);
% plot (t2,vel_x2, 'DisplayName','M2');
% grid on
% xlabel('Tiempo')
% ylabel('Velocidad en x')
% hold on
% vel_x3 = cumtrapz(t3,acel_x3);
% plot (t3,vel_x3, 'DisplayName','M3');
% grid on
% xlabel('Tiempo')
% ylabel('Velocidad en x')
% hold on
% vel_x4 = cumtrapz(t4,acel_x4);
% plot (t4,vel_x4, 'DisplayName','M4');
% grid on
% xlabel('Tiempo')
% ylabel('Velocidad en x')
% legend
% 
% % Ahora voy a representar las velocidades en x, y ,z de la muestra 1 en la
% % misma grafica
% 
% figure
% acel_y1 = datos1(:,3);
% acel_z1 = datos1 (:,4);
% vel_y1 = cumtrapz(t1,acel_y1);
% vel_z1 = cumtrapz(t1,acel_z1);
% plot(t1,vel_x1, 'Color', 'blue')
% hold on
% plot(t1,vel_y1,'Color', 'red')
% hold on 
% plot (t1,vel_z1,'Color', 'green')
% title ('Velocidades en los 3 ejes M1')
% xlabel('Tiempo')
% ylabel('Velocidad en x')
% grid on
% legend ('x','y','z')
% 
% % DESPLAZAMIENTOS (INTUYO QUE PARA NO TENER QUE HACER TANTO CODIGO PUES HABRIA
% % QUE CREAR BUCLES Y COSAS)
% %igual habria que ajustar los ejes pero de momento asi
% figure
% desp_x1 = cumtrapz(t1,vel_x1);
% plot (t1,desp_x1, 'DisplayName','M1');
% grid on
% title ('DESPLAZAMIENTOS EN X DE LAS DISTINTAS MUESTRAS')
% xlabel('Tiempo')
% ylabel('Desplazamiento en x')
% hold on
% desp_x2 = cumtrapz(t2,vel_x2);
% plot (t2,desp_x2, 'DisplayName','M2');
% grid on
% xlabel('Tiempo')
% ylabel('Desplazamiento en x')
% hold on
% desp_x3 = cumtrapz(t3,vel_x3);
% plot (t3,desp_x3, 'DisplayName','M3');
% grid on
% xlabel('Tiempo')
% ylabel('Desplazamiento en x')
% hold on
% desp_x4 = cumtrapz(t4,vel_x4);
% plot (t4,desp_x4, 'DisplayName','M4');
% grid on
% xlabel('Tiempo')
% ylabel('Desplazamiento en x')
% legend
% 
% % Ahora voy a representar los desplazamientos en x, y ,z de la muestra 1 en la
% % misma grafica
% 
% figure
% desp_y1 = cumtrapz(t1,vel_y1);
% desp_z1 = cumtrapz(t1,vel_z1);
% plot(t1,desp_x1, 'Color', 'blue')
% hold on
% plot(t1,desp_y1,'Color', 'red')
% hold on 
% plot (t1,desp_z1,'Color', 'green')
% title ('Desplazamientos en los 3 ejes M1')
% xlabel('Tiempo')
% ylabel('Desplazamiento en x')
% grid on
% legend ('x','y','z')
% 
% 
% %% Coordenada y
% %represento las coordenadas y de las muestras.
% % figure
% %acel_y1 = datos1(:,3);
% % plot (t1, acel_y1, 'DisplayName', 'Muestra 1')
% % title ('Aceleración en y (Pisando Marcas)')
% % %faltan xlim e ylim tb
% % xlabel('Tiempo')
% % ylabel('Aceleración en y')%el titulo de la grafica y de los ejes quiza mejor al final de cada grafica
% % grid on
% % hold on
% % acel_y2 = datos2 (:,3);
% % plot (t2,acel_y2, 'DisplayName', 'Muestra 2')
% % hold on
% % acel_y3 = datos3 (:,3);
% % plot (t3,acel_y3, 'DisplayName', 'Muestra 3')
% % hold on
% % acel_y4 = datos4 (:,3);
% % plot (t4,acel_y4, 'DisplayName', 'Muestra 4')
% % legend
% %  
% 
% 
% %% Coordenada z
% % % represento las coordenadas z de las muestras.
% % figure
% %acel_z1 = datos1 (:,4);
% % plot (t1,acel_z1, 'DisplayName', 'Muestra 1')
% % title ('Aceleración en z (Pisando Marcas)')
% % %xlim ylim
% % xlabel('Tiempo')
% % ylabel('Aceleración en z')
% % grid on
% % hold on
% % acel_z2 = datos2 (:,4);
% % plot (t2,acel_z2, 'DisplayName', 'Muestra 2')
% % hold on
% % acel_z3 = datos3 (:,4);
% % plot (t3,acel_z3, 'DisplayName', 'Muestra 3')
% % hold on
% % acel_z4 = datos4 (:,4);
% % plot (t4,acel_z4, 'DisplayName', 'Muestra 4')
% % legend
% %  
% 
% %% Represento aceleracion en x, y y z en la misma grafica para la m1 por ejemplo
% 
% % plot(t1,acel_x1,acel_y1,acel_z1);
% 
% 
% %% Gráfica representando Vx vs Vy (no se si esto es interesante)
% % Muestra 1
% figure
% plot(vel_x1,vel_y1);
% xlabel('Vx')
% ylabel('Vy')
% title('Vx vs Vy')
% grid on
% 
% 
% 
% 
% %% ÁNGULOS DE EULER (SOLO SE PUEDE CON EL NUEVO)
% 
% 
% 
% %% Ideas
% output.csvfilename.t = t1;
% 
% %save mat
% if ~isfolder("output")
%     mkdir("output")
% end
% save("output/outtput_loadedfiles.mat")
% 
