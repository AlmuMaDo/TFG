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
% Mirar si existe diccionario
if exist(DictPath)
    load(DictPath)
else
    % Si no existe hay que crearlo
    DataDict = containers.Map();
    save(DictPath, 'DataDict')
end

%% Bucle para leer los archivos uno por uno
%% COORDENADA X

for iDataFile = 1:numel(dataFiles)
    file_path = fullfile(dataFolder, dataFiles(iDataFile).name); % ruta completa del archivo 
    % Coger nombre y crear nombre del .mat
    [~,cleanName] = fileparts(strrep(dataFiles(iDataFile).name, ' ', '_'));

    if isKey(DataDict, cleanName)
        % mirar si esta ya en diccionario
        gyroData = DataDict(cleanName);
    else
% Si no esta guardado, cargar el csv y a�adir al diccionario y guardarlo
    gyroData = gyroData_csv2struct(file_path); 
        % Normalizar muestras entre ... y ...
    gyroData_norm = NormalizarFunction(gyroData, 0, 100);
        
        % a�adir al diccionario muestras ya normalizadas
    DataDict(cleanName) = gyroData_norm;
    save(DictPath, 'DataDict'); 
    end

    t = DataDict(cleanName).time;
    eje_vert = DataDict(cleanName).x;
    label = strcat('Muestra', num2str(iDataFile)); % crea una variable para indicar el numero de muestra
    plot(t, eje_vert, 'DisplayName', label)
    hold on
    title('Datos Giroscopio Coordenada x Andando')
    xlabel('Tiempo (s)')
    ylabel('Velocidad angular en x (deg/s)')
end


% Calcular promedios con muestras normalizadas
% COORDENADA X
% PROMEDIO COORDENADA X
hold on
gyroData_all = load(DictPath);
gyroData_all = gyroData_all.DataDict;
[promedio, gyroData_all_interp] = promedioFunction(gyroData_all);
plot(promedio.time,promedio.x,'k-','LineWidth',1.75, 'DisplayName', 'Promedio')

legend('show','AutoUpdate','off'); 

%% COORDENADA Y
figure
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
        % Si no esta guardado, cargar el csv y a�adir al diccionario y
        % guardarlo
        gyroData = gyroData_csv2struct(file_path); 
        
        % Normalizar muestras entre ... y ...
        gyroData_norm = NormalizarFunction(gyroData, 0, 100);
        
        % a�adir al diccionario muestras ya normalizadas
        DataDict(cleanName) = gyroData_norm;
        save(DictPath, 'DataDict');
    end
    t = DataDict(cleanName).time;
    eje_vert = DataDict(cleanName).y;
    label = strcat('Muestra', num2str(iDataFile)); % crea una variable para indicar el numero de muestra
    plot(t, eje_vert, 'DisplayName', label)
    hold on
    title('Datos Giroscopio Coordenada y Andando')
    xlabel('Tiempo (s)')
    ylabel('Velocidad angular en y (deg/s)')
end

% PROMEDIO COORDENADA Y
hold on
gyroData_all = load(DictPath);
gyroData_all = gyroData_all.DataDict;
[promedio, gyroData_all_interp] = promedioFunction(gyroData_all);
plot(promedio.time,promedio.y,'k-','LineWidth',1.75, 'DisplayName', 'Promedio')

legend('show','AutoUpdate','off'); 
%% COORDENADA Z
figure
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
        % Si no esta guardado, cargar el csv y a�adir al diccionario y
        % guardarlo
        gyroData = gyroData_csv2struct(file_path); 
        
        % Normalizar muestras entre ... y ...
        gyroData_norm = NormalizarFunction(gyroData, 0, 100);
        
        % a�adir al diccionario muestras ya normalizadas
%         DataDict(cleanName) = gyroData;

        DataDict(cleanName) = gyroData_norm;
        save(DictPath, 'DataDict');
    end
    t = DataDict(cleanName).time;
    eje_vert = DataDict(cleanName).z;
    label = strcat('Muestra', num2str(iDataFile)); % crea una variable para indicar el numero de muestra
    plot(t, eje_vert, 'DisplayName', label)
    hold on
    title('Datos Giroscopio Coordenada z Andando')
    xlabel('Tiempo (s)')
    ylabel('Velocidad angular en z (deg/s)')
end

% PROMEDIO COORDENADA Z
hold on
gyroData_all = load(DictPath);
gyroData_all = gyroData_all.DataDict;
[promedio, gyroData_all_interp] = promedioFunction(gyroData_all);
plot(promedio.time,promedio.z,'k-','LineWidth',1.75, 'DisplayName', 'Promedio')

legend('show','AutoUpdate','off'); 

