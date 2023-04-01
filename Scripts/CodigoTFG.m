clc
clear all
close all

fs=100;
T=1/fs;

%%
%-----ADQUISICION DE DATOS-----
%GIROSCOPIO

% coger path de esta funcion
TFG_git_path = fileparts(fileparts(mfilename('fullpath')));

% addpath de todo el git
addpath(genpath(TFG_git_path));

% set datafiles folder path
dataFolder_all = fullfile(TFG_git_path, 'gyroData', 'gyroDataNew');

% Elige que data se quiere importar (squats, walking...)
sportType = 'Walking';
angleType = 'Giroscopio';
dataFolder = fullfile(dataFolder_all, sportType, angleType);

dataFiles = dir(fullfile(dataFolder, '*.csv'));    

% Crear una variable de celdas para almacenar los datos de los archivos CSV
data_cell = cell(length(dataFiles), 1); 
DictPath = fullfile(dataFolder,strcat('DataDict_', sportType, '_', angleType, '.mat'));

%% CARGAR .MAT
% matFileName = strcat('gyroData','_', sportType,'_', angleType, '.mat');
% if exist(matFileName)
%     simuStruct = load(matFileName);
% else
%     simuStruct = struct();
% end

% Mirar si existe diccionario
if exist(DictPath)
    load(DictPath)
else
    % Si no existe hay que crearlo
    DataDict = containers.Map();
    save(DictPath, 'DataDict')
end

%% Bucle para leer los archivos uno por uno
for iDataFile = 1:numel(dataFiles)
    file_path = fullfile(dataFolder, dataFiles(iDataFile).name); % ruta completa del archivo
    % Almacenar los datos en la celda correspondiente
    % Hacer lo que necesites con los datos...
    
    % Coger nombre y crear nombre del .mat
    [~,cleanName] = fileparts(strrep(dataFiles(iDataFile).name, ' ', '_'));
%     filePathMat = fullfile(dataFolder, strcat(cleanName, '.mat'));
    
    if isKey(DataDict, cleanName)
        % mirar si esta ya en diccionario
        gyroData = DataDict(cleanName);
    else
        % Si no esta guardado, cargar de csv y anadir al diccionario y
        % guardarlo
        gyroData = gyroData_csv2struct(file_path); % no se si esta linea es necesaria
        
        % Normalizar muestras entre ... y ...
        
        % a�adir al diccionario muestras ya normalizadas
        DataDict(cleanName) = gyroData;
        save(DictPath, 'DataDict');
    end
        
%         save(filePathMat, 'gyroData');
%     if exist(filePathMat)
%         % mirar si existe el .mat (en teoria mas eficiente que cargar csv)
%         gyroData = load(filePathMat);
%     else
%         % si no existe: cargar de csv y guardar en .mat
%         gyroData = gyroData_csv2struct(file_path); % no se si esta linea es necesaria
%         save(filePathMat, 'gyroData');
%     end
    

    
    
    trial = gyroData.time(:,1);
    t = 0:T:((length(trial)/fs)-T);
    x = gyroData.x(:,1);
    %n = 1:length(data_cell);
    label = strcat('Muestra', num2str(iDataFile)); % crea una etiqueta para el archivo actual% crea una variable para indicar el número de muestra
    plot(t, x, 'DisplayName', label)
    hold on
    title('Datos Giroscopio Coordenada x Andando')
    xlabel('Tiempo (s)')
    ylabel('Velocidad angular en x (deg/s)')
end
legend('show','AutoUpdate','off'); % agrega una leyenda con el nombre del archivo actual




%% Calcular promedios con muestras normalizadas
%% COORDENADA X
% PROMEDIO COORDENADA X
% figure();

hold on
% load('gyroData.mat');
promedio_x = promedioFunction(gyroData);
plot(t,promedio_x,'k-', 'DisplayName','Promedio', 'LineWidth',2);
% Guardo en una "variable" .mat por separado los datos de tiempo, x, y, z

%% COORDENADA Y
figure
grid on

for iDataFile = 1:length(data_cell)
     file_path = fullfile(folder_path, files(iDataFile).name); % ruta completa del archivo
     % Almacenar los datos en la celda correspondiente
     % Hacer lo que necesites con los datos...
     gyroData = gyroData_csv2struct(file_path);
     if ~isfield (simuStruct,'gyroData')
         simuStruct.(files(iDataFile).name) = gyroData;
     end
     trial = gyroData.time(:,1);
     t = 0:T:((length(trial)/fs)-T);
     y = gyroData.y(:,1);
     %n = 1:length(data_cell);
     label = strcat('Muestra', num2str(iDataFile)); % crea una etiqueta para el archivo actual% crea una variable para indicar el número de muestra
     plot(t, y, 'DisplayName', label)
     title('Datos Giroscopio Coordenada y Andando')
     xlabel('Tiempo (s)')
     ylabel('Velocidad angular en y (deg/s)')
end
legend('show','AutoUpdate','off');

% PROMEDIO COORDENADA Y
     hold on
     load('gyroData.mat');
     promedio_y = promedioFunction(gyroData_y);
     plot (t,promedio_y,'k-','DisplayName','Promedio','LineWidth',2);

     %%PROBLEMA que tenemos es que coge el mismo promedio que en x

%% COORDENADA Z
figure
hold on
grid on

for iDataFile = 1:length(data_cell)
     file_path = fullfile(folder_path, files(iDataFile).name); % ruta completa del archivo
     % Almacenar los datos en la celda correspondiente
     % Hacer lo que necesites con los datos...
     gyroData = gyroData_csv2struct(file_path); 
     if ~isfield (simuStruct,'gyroData')
         simuStruct.(files(iDataFile).name) = gyroData;
     end
     trial = gyroData.time(:,1);
     t = 0:T:((length(trial)/fs)-T);
     z = gyroData.z(:,1);
     %n = 1:length(data_cell);
     label = strcat('Muestra', num2str(iDataFile)); % crea una etiqueta para el archivo actual% crea una variable para indicar el número de muestra
     plot(t, z, 'DisplayName', label)
     title('Datos Giroscopio Coordenada z Andando')
     xlabel('Tiempo (s)')
     ylabel('Velocidad angular en z (deg/s)')
   end
     save ('gyroData.mat', 'gyroData')
     legend('show','AutoUpdate','off'); % agrega una leyenda con el nombre del archivo actual 


     %a lo mejor tengo que crear un t nuevo , el de interpolacion, dentro
     %del bucle dentro de la funcion o no se donde exactamente, porque con
     %ese mismo, con el de la interpolacion es con el que tengo que plotear

 %comprobar si me lo esta haciendo todo con los ejes de tiempo que toca y
 %aqui si t lo he definido antes dentro del bucle me lo va a pillar bien?

% idea feliz: Guardo en una "variable" .mat por separado los datos de tiempo, x, y, z








%aqui cargar con load la estructura que a lo mejor previamente tenemos que guardar
%en un .mat y ya plotear VER IDEAS DEL FINAL y ver tb lo del archivo de
%carlos y pasarme todo lo de este script a sucio para ir pegando de ahi
%trozos y tener esto ordenado

