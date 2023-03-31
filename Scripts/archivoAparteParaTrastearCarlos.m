%%%COMPARACION DATOS MOCAP E IMU

clc
clear all
close all

fs=100;
T=1/fs;

%%
%-----ADQUISICION DE DATOS-----

%Datos de giroscopio
csvGyroInput = 'Accelerometer_andando_pisarMarcas_20230305-104412579.csv';
gyroData1 = GyroData_csv2struct(csvGyroInput);

figure()
plot(gyroData1.time, gyroData1.x)
grid on
xlabel('time')
ylabel('señal giroscopio - x')


% %% Ideas
% output.csvfilename.t = t1;
% 
% %save mat
% if ~isfolder("output")
%     mkdir("output") %La función mkdir en MATLAB se utiliza para crear un directorio o carpeta en el sistema de archivos.
% end
% save("output/outtput_loadedfiles.mat")
% 
