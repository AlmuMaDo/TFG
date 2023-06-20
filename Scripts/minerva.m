% gyro delante minerva
% registro 1
fs=100;
T=1/fs;
close all

% Leer el archivo CSV
datosR1 = readmatrix('minervaregistro1_Sensor Viejo2_2023-05-31T12.29.37.734_CCA00625B61F_Gyroscope_100.000Hz_1.3.6.csv');

% Extraer las columnas de interés
x_r1 = datosR1(:, 3); 
y_r1_x = datosR1(:, 4);
y_r1_y =datosR1(:,5);
y_r1_z =datosR1(:,6);

% Graficar los datos
subplot(3,1,1)
plot(x_r1, y_r1_x)
grid on
title ('Minerva gyro suprapatellar area R1 coord x')

subplot(3,1,2)
plot(x_r1, y_r1_y)
grid on
title ('Minerva gyro suprapatellar area R1 coord y')

subplot(3,1,3)
plot(x_r1, y_r1_z)
grid on
title ('Minerva gyro suprapatellar area R1 coord z')

% definir el rango deseado en el eje x
rango_x_inicio = 21.93;
rango_x_fin = 24.93;


% fragmentar el trozo deseado basado en el rango en el eje x
indices = (x_r1>= rango_x_inicio) & (x_r1<= rango_x_fin);
x_trozo = x_r1(indices);
y_trozo_x = y_r1_x(indices);
y_trozo_y = y_r1_y(indices);
y_trozo_z= y_r1_z(indices);


% graficar el trozo fragmentado
figure
subplot(3,1,1)
plot(x_trozo, y_trozo_x)
grid on
title ('Minerva gyro suprapatellar area R1 coord x frag')
xlim([21.93,24.93]);


subplot(3,1,2)
plot(x_trozo, y_trozo_y)
grid on
title ('Minerva gyro suprapatellar area R1 coord y frag')
xlim([21.93,24.93]);


subplot(3,1,3)
plot(x_trozo, y_trozo_z)
grid on
title ('Minerva gyro suprapatellar area R1 coord z frag')
xlim([21.93,24.93]);






%tendria que normalizar? porque promediar no porque la gracia es que es una
%sentadilla de un paciente random, ya no forma parte de la curva ideal,
%porque hay que compararla con esa curva.