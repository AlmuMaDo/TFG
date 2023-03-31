clc
clear all
close all

fs=100;
T=1/fs;

%%
%-----ADQUISICION DE DATOS-----
%GIROSCOPIO

%creo que tendria que hacer 2 bucles, uno que lea el csv y saque la matriz
%y luego otro que recorra esa matriz y que la separe en lo que he dicho

% Bucle para leer los csv y sacar una matriz (STAND BY)

% % Directorio donde se encuentran los archivos csv
folder_path = 'C:\Users\almud\Desktop\GIT\TFG\gyroData\gyroDataNew\Walking\Giroscopio';
% %SOLO LO ESTOY HACIENDO AQUI QUE EN LA CARPETA HAY SOLO ANDAR, PARA LUEGO
% %DIVIDIR PUEDE VENIR BIEN EL MKDIR con parentfolder y lo otro
% % Obtener lista de archivos csv en el directorio
files = dir(fullfile(folder_path, '*.csv'));    
% 
% Crear una variable de celdas para almacenar los datos de los archivos CSV
data_cell = cell(length(files), 1); %CREO QUE ESTO AHORA NO TIENE SENTIDO
% 
% % Bucle para leer los archivos uno por uno


%% CARGAR .MAT
if exist('gyroData.mat')
    simuStruct = load('gyroData.mat');
else
    simuStruct = struct();
end
figure();
hold on;
grid on
% COORDENADA X
for i = 1:length(data_cell)
     file_path = fullfile(folder_path, files(i).name); % ruta completa del archivo
%      data = readtable(file_path); % leer archivo csv
     % Almacenar los datos en la celda correspondiente
     % Hacer lo que necesites con los datos...
     gyroData = gyroData_csv2struct(file_path); % no se si esta linea es necesaria
     if ~isfield (simuStruct,'gyroData')
         simuStruct.(files(i).name) = gyroData;
     end
%           if ~isfield (gyroData,'data_cell{i}')
%          data_cell{i} = data;
%      end
     %gyroData.(data_cell{i}) = gyroData_csv2struct(data_cell{i});
     trial = gyroData.time(:,1);
     t = 0:T:((length(trial)/fs)-T);
     x = gyroData.x(:,1);
     %n = 1:length(data_cell);
     label = strcat('Muestra', num2str(i)); % crea una etiqueta para el archivo actual% crea una variable para indicar el número de muestra
     plot(t, x, 'DisplayName', label)
     title('Datos Giroscopio Coordenada x Andando')
     xlabel('Tiempo (s)')
     ylabel('Velocidad angular en x (deg/s)')
end
legend('show','AutoUpdate','off');
figure
hold on
grid on
% COORDENADA Y
for i = 1:length(data_cell)
     file_path = fullfile(folder_path, files(i).name); % ruta completa del archivo
%      data = readtable(file_path); % leer archivo csv
     % Almacenar los datos en la celda correspondiente
     % Hacer lo que necesites con los datos...
     gyroData = gyroData_csv2struct(file_path); % no se si esta linea es necesaria
     if ~isfield (simuStruct,'gyroData')
         simuStruct.(files(i).name) = gyroData;
     end
%           if ~isfield (gyroData,'data_cell{i}')
%          data_cell{i} = data;
%      end
     %gyroData.(data_cell{i}) = gyroData_csv2struct(data_cell{i});
     trial = gyroData.time(:,1);
     t = 0:T:((length(trial)/fs)-T);
     y = gyroData.y(:,1);
     %n = 1:length(data_cell);
     label = strcat('Muestra', num2str(i)); % crea una etiqueta para el archivo actual% crea una variable para indicar el número de muestra
     plot(t, y, 'DisplayName', label)
     title('Datos Giroscopio Coordenada y Andando')
     xlabel('Tiempo (s)')
     ylabel('Velocidad angular en y (deg/s)')
end
legend('show','AutoUpdate','off');
figure
hold on
grid on
% COORDENADA Z
for i = 1:length(data_cell)
     file_path = fullfile(folder_path, files(i).name); % ruta completa del archivo
%      data = readtable(file_path); % leer archivo csv
     % Almacenar los datos en la celda correspondiente
     % Hacer lo que necesites con los datos...
     gyroData = gyroData_csv2struct(file_path); % no se si esta linea es necesaria
     if ~isfield (simuStruct,'gyroData')
         simuStruct.(files(i).name) = gyroData;
     end
%           if ~isfield (gyroData,'data_cell{i}')
%          data_cell{i} = data;
%      end
     %gyroData.(data_cell{i}) = gyroData_csv2struct(data_cell{i});
     trial = gyroData.time(:,1);
     t = 0:T:((length(trial)/fs)-T);
     z = gyroData.z(:,1);
     %n = 1:length(data_cell);
     label = strcat('Muestra', num2str(i)); % crea una etiqueta para el archivo actual% crea una variable para indicar el número de muestra
     plot(t, z, 'DisplayName', label)
     title('Datos Giroscopio Coordenada z Andando')
     xlabel('Tiempo (s)')
     ylabel('Velocidad angular en z (deg/s)')
   end
     save ('gyroData.mat', 'gyroData')
%      xlabel('Tiempo (s)')
%      ylabel('Velocidad angular en x (deg/s)')
     legend('show','AutoUpdate','off'); % agrega una leyenda con el nombre del archivo actual 

%% PROMEDIO

%     load('gyroData.mat');
%     promedioFunction (gyroData,data_cell);
% Guardo en una "variable" .mat por separado los datos de tiempo, x, y, z








%aqui cargar con load la estructura que a lo mejor previamente tenemos que guardar
%en un .mat y ya plotear VER IDEAS DEL FINAL y ver tb lo del archivo de
%carlos y pasarme todo lo de este script a sucio para ir pegando de ahi
%trozos y tener esto ordenado

%GyroData_csv2struct(RM1MW_MetaWearNuevo_2023-03-22T20.06.42.945_DFE264DC19EA_Gyroscope_100.000Hz_1.7.3.csv);
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










% %muestra 1 datos generales (comienza en 0)
% datos1 = readmatrix ('Accelerometer_andando_pisarMarcas_20230305-104412579.csv');
% trial1= datos1(:,1); % lo entiendo pero no se como llamarlo para cambiarle el nombre
% t1 = 0:T:((length(trial1)/fs)-T);
% 
% %muestra 2 datos generales (no comienza en 0)
% datos2 = readmatrix ('Accelerometer_andando_pisarMarcas_20230305-104544074.csv');
% trial2 = datos2 (:,1);
% t2 = 0:T:((length(trial2)/fs)-T);
% 
% %muestra 3 datos generales (comienza en 0)
% datos3 = readmatrix ('Accelerometer_andando_pisarMarcas_20230305-113501210.csv');
% trial3 = datos3 (:,1);
% t3 = 0:T:((length(trial3)/fs)-T);
% 
% %muestra  datos generales (comienza en 0)
% datos4 = readmatrix ('Accelerometer_andando_pisarMarcas_20230305-113639016.csv');
% trial4 = datos4 (:,1);
% t4 = 0:T:((length(trial4)/fs)-T);




