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

% Patient list creation
PatientList = dir(dataFolder_all);
PatientList = PatientList([PatientList.isdir]);
PatientList = PatientList(~ismember({PatientList.name}, {'.','..'}));
PatientList = {PatientList.name};

for iPatient = 1:numel(PatientList)

    Patient = PatientList{iPatient};

    % Sport
    sportList = dir(fullfile(dataFolder_all, Patient));
    sportList = sportList(~ismember({sportList.name}, {'.','..'}));
    sportList = {sportList.name};
    for iSport = 1:numel(sportList)
        Sport = sportList{iSport};

        % Angle
        AngleList = dir(fullfile(dataFolder_all, Patient,Sport));
        AngleList = AngleList(~ismember({AngleList.name}, {'.','..'}));
        AngleList = {AngleList.name};
        for iAngle = 1:numel(AngleList)
            Angle = AngleList{iAngle};

            % Location
            LocationList = dir(fullfile(dataFolder_all, Patient,Sport, Angle));
            LocationList = LocationList(~ismember({LocationList.name}, {'.','..'}));
            LocationList = {LocationList.name};
            for iLocation = 1:numel(LocationList)
                Location = LocationList{iLocation};

                dataFolder = fullfile(dataFolder_all, Patient, Sport, Angle, Location);
                dataFiles = dir(fullfile(dataFolder, '*.csv'));

                % Crear una variable de celdas para almacenar los datos de los archivos CSV
                data_cell = cell(length(dataFiles), 1);
                DictPath = fullfile(dataFolder,strcat('DataDict_', Sport, '_', Angle, '.mat'));

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
                figure
                for iDataFile = 1:numel(dataFiles)
                    file_path = fullfile(dataFolder, dataFiles(iDataFile).name); % ruta completa del archivo
                    % Coger nombre y crear nombre del .mat
                    [~,cleanName] = fileparts(strrep(dataFiles(iDataFile).name, ' ', '_'));

                    if isKey(DataDict, cleanName)
                        % mirar si esta ya en diccionario
                        gyroData = DataDict(cleanName);
                    else
                        % Si no esta guardado, cargar el csv y añadir al diccionario y guardarlo
                        gyroData = gyroData_csv2struct(file_path);
                        % Normalizar muestras entre ... y ...
                        gyroData_norm = NormalizarFunction(gyroData, 0, 100);

                        % añadir al diccionario muestras ya normalizadas
                        DataDict(cleanName) = gyroData_norm;
                        save(DictPath, 'DataDict');
                    end

                    t = DataDict(cleanName).time;
                    eje_vert = DataDict(cleanName).x;

                    % Get name for plot ====
                    AngleTitle = ' Gyroscope ';
                    if strcmp(Angle, 'Euler')
                        AngleTitle = ' Euler';
                    end
                    nameOrd = ' x-Coordinate';
                    if strcmp(Angle, 'Euler')
                        nameOrd = ' Pitch';
                    end
                    SportTitle = ' Squats';
%                     if strcmp(Sport, 'Walking')
%                         exercise = ' Walking';
%                     end
                    LocationTitle = ' Suprapatellar Area';
                    if strcmp(Location, 'Lateral')
                        LocationTitle = ' Lateral (External) Collateral Ligament'; 
                    end
                    
                    % ======================

                    label = ['Sample ', num2str(iDataFile)]; % crea una variable para indicar el numero de muestra
                    subplot(3,1,1) 
                    plot(t, eje_vert, 'DisplayName', label)
                    hold on
                    title(strcat(AngleTitle, ' ', nameOrd, ' ', SportTitle, ' ', LocationTitle, ' Right Knee'))
                    xlabel('Time (s)')
                    % Get name for ylabel ====
                    ylabel('Angular velocity in x (deg/s)')
                    if strcmp(Angle, 'Euler')
                       ylabel('Angle (°)')

                    end
                    %===========================================

                    %guardo en un struct las muestras de cada uno (que seran 6
                %de cada cosa) para poder representarlos en la GUI
                samples.(Patient).(Sport).(Angle).(Location).(['Sample_',num2str(iDataFile)]) = DataDict(cleanName);
                
                end
                grid on

                
                % Calcular promedios con muestras normalizadas
                % COORDENADA X
                % PROMEDIO COORDENADA X
                hold on
                label_average = ['Average ','Patient ', num2str(iPatient)];
                gyroData_all = load(DictPath);
                gyroData_all = gyroData_all.DataDict;
                [promedio, gyroData_all_interp] = promedioFunction(gyroData_all);
                plot(promedio.time,promedio.x,'k-','LineWidth',1.75, 'DisplayName', label_average)
                legend('show','AutoUpdate','off');

                %% COORDENADA Y

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
                        % Si no esta guardado, cargar el csv y añadir al diccionario y
                        % guardarlo
                        gyroData = gyroData_csv2struct(file_path);

                        % Normalizar muestras entre ... y ...
                        gyroData_norm = NormalizarFunction(gyroData, 0, 100);

                        % añadir al diccionario muestras ya normalizadas
                        DataDict(cleanName) = gyroData_norm;
                        save(DictPath, 'DataDict');
                    end
                    % Get name for plot ====
                    AngleTitle = ' Gyroscope ';
                    if strcmp(Angle, 'Euler')
                        AngleTitle = ' Euler';
                    end
                    nameOrd = ' y-Coordinate';
                    if strcmp(Angle, 'Euler')
                        nameOrd = ' Roll';
                    end
                    SportTitle = ' Squats';
%                     if strcmp(Sport, 'Walking')
%                         exercise = ' Walking';
%                     end
                    LocationTitle = ' Suprapatellar Area';
                    if strcmp(Location, 'Lateral')
                        LocationTitle = ' Lateral (External) Collateral Ligament';
                    end
                    
                    % ======================
                    t = DataDict(cleanName).time;
                    eje_vert = DataDict(cleanName).y;
                    label = ['Sample ', num2str(iDataFile)]; % crea una variable para indicar el numero de muestra
                    subplot(3,1,2)
                    plot(t, eje_vert, 'DisplayName', label)
                    hold on
                    title(strcat(AngleTitle, ' ', nameOrd, ' ', SportTitle, ' ', LocationTitle, ' Right Knee'))
                    xlabel('Time (s)')
                   % Get name for ylabel ====
                    ylabel('Angular velocity in y (deg/s)')
                    if strcmp(Angle, 'Euler')
                       ylabel('Angle (°)')

                    end
                    %===========================================
                end

                % PROMEDIO COORDENADA Y
                grid on
                hold on
                label_average = ['Average ', 'Patient ', num2str(iPatient)];
                gyroData_all = load(DictPath);
                gyroData_all = gyroData_all.DataDict;
                [promedio, gyroData_all_interp] = promedioFunction(gyroData_all);
                plot(promedio.time,promedio.y,'k-','LineWidth',1.75, 'DisplayName', label_average)

                legend('show','AutoUpdate','off');
                %% COORDENADA Z

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
                        % Si no esta guardado, cargar el csv y añadir al diccionario y
                        % guardarlo
                        gyroData = gyroData_csv2struct(file_path);

                        % Normalizar muestras entre ... y ...
                        gyroData_norm = NormalizarFunction(gyroData, 0, 100);

                        % añadir al diccionario muestras ya normalizadas
                        DataDict(cleanName) = gyroData_norm;
                        save(DictPath, 'DataDict');
                    end
                     % Get name for plot ====
                    AngleTitle = ' Gyroscope ';
                    if strcmp(Angle, 'Euler')
                        AngleTitle = ' Euler';
                    end
                    nameOrd = ' z-Coordinate';
                    if strcmp(Angle, 'Euler')
                        nameOrd = ' Yaw';
                    end
                    SportTitle = ' Squats';
%                     if strcmp(Sport, 'Walking')
%                         exercise = ' Walking';
%                     end
                    LocationTitle = ' Suprapatellar Area';
                    if strcmp(Location, 'Lateral')
                        LocationTitle = ' Lateral (External) Collateral Ligament';
                    end
                    
                    % ======================
                    t = DataDict(cleanName).time;
                    eje_vert = DataDict(cleanName).z;
                    label = ['Sample ', num2str(iDataFile)]; % crea una variable para indicar el numero de muestra
                    subplot(3,1,3)
                    plot(t, eje_vert, 'DisplayName', label)
                    hold on
                    title(strcat(AngleTitle, '  ', nameOrd, '  ', SportTitle, '  ', LocationTitle, ' Right Knee'))
                    xlabel('Time (s)')
                    % Get name for ylabel ====
                    ylabel('Angular velocity in z (deg/s)')
                    if strcmp(Angle, 'Euler')
                       ylabel('Angle (°)')

                    end
                    %===========================================
                end

                % PROMEDIO COORDENADA Z
                grid on
                hold on
                label_average = ['Average ', 'Patient ', num2str(iPatient)];
                gyroData_all = load(DictPath);
                gyroData_all = gyroData_all.DataDict;
                [promedio, gyroData_all_interp] = promedioFunction(gyroData_all);
                plot(promedio.time,promedio.z,'k-','LineWidth',1.75, 'DisplayName', label_average)

                legend('show','AutoUpdate','off');

                % Guardar promedio en una estructura
                promedio_all.(Patient).(Sport).(Angle).(Location) = promedio;
                
            end
        end
    end
end
%% GUARDAR TODOS LOS PROMEDIOS CON TODOS LOS CAMPOS EN UN .MAT Y REPRESENTAR LA CURVA IDEAL
% lo voy a guardar al mismo nivel que los pacientes, dentro de la carpeta
% gyroDataNew
%prueba de juntar los dos bucles en uno y luego probar a hacer uno por
%coordenada
%lo unico que se me ocurre es meter todo dentro de un bucle que recorra un
%vector con las 3 coordenadas (x,y,z) e igual asi se puede arreglar

%poner lo de label_average en todos los sitios que le corresponda

promedioPath = fullfile(dataFolder_all,'Promedio_all_results.mat');
save(promedioPath, 'promedio_all')

% COORDENADA X
for iSportType = 1:numel(sportList)
    SportType = sportList{iSportType};
    for iAngleType = 1:numel(AngleList)
        AngleType = AngleList{iAngleType};
        for iLocationType = 1:numel(LocationList)
            figure
            grid on
            LocationType = LocationList{iLocationType};

            for iPatientName = 1:numel(PatientList)
            label = ['Average ', num2str(iPatientName)];

                PatientName = PatientList{iPatientName};
                %VER SI PUEDO PONER ESTO Y GENERALIZARLO PARA TODAS LAS
                %COORDENADAS, DE MOMENTO LO COPIO 3 VECES

                % COORDENADA X
                % Get name for plot ====
                AngleTitle = ' Gyroscope ';
                if strcmp(AngleType, 'Euler')
                    AngleTitle = ' Euler';
                end
                nameOrd_x = ' x-Coordinate';
                if strcmp(AngleType, 'Euler')
                    nameOrd_x = ' Pitch';
                end
                SportTitle = ' Squats';
                %if strcmp(Sport, 'Walking')
                %   exercise = ' Walking';
                %end
                LocationTitle = ' Suprapatellar Area';
                if strcmp(LocationType, 'Lateral')
                    LocationTitle = ' Lateral (External) Collateral Ligament';
                end

                % ======================
                tPlotProm = promedio_all.(PatientName).(SportType).(AngleType).(LocationType).time;
                ord_x = promedio_all.(PatientName).(SportType).(AngleType).(LocationType).x;
                subplot(3,1,1)
                plot(tPlotProm,ord_x, 'DisplayName', label)
                hold on
                grid on
                title(strcat('Average', AngleTitle, ' in ', nameOrd_x, '  ', SportTitle, '  ', LocationTitle, ' Right Knee'))
                xlabel('Time (s)')
                % Get name for ylabel ====
                ylabel('Angular velocity in x (deg/s)')
                if strcmp(AngleType, 'Euler')
                    ylabel('Angle (°)')

                end
                %===========================================
                nameOrd_x = ' x-Coordinate';
                if strcmp(AngleType, 'Euler')
                    nameOrd_x = ' Pitch';
                end

                % COORDENADA Y
                % Get name for plot ====
                AngleTitle = ' Gyroscope ';
                if strcmp(AngleType, 'Euler')
                    AngleTitle = ' Euler';
                end
                nameOrd_y = ' y-Coordinate';
                if strcmp(AngleType, 'Euler')
                    nameOrd_y = ' Roll';
                end
                SportTitle = ' Squats';
                %if strcmp(Sport, 'Walking')
                %   exercise = ' Walking';
                %end
                LocationTitle = ' Suprapatellar Area';
                if strcmp(LocationType, 'Lateral')
                    LocationTitle = ' Lateral (External) Collateral Ligament';
                end

                % ======================
                

                tPlotProm = promedio_all.(PatientName).(SportType).(AngleType).(LocationType).time;
                ord_y = promedio_all.(PatientName).(SportType).(AngleType).(LocationType).y;
                subplot(3,1,2)
                plot(tPlotProm,ord_y, 'DisplayName', label)
                hold on
                grid on
                title(strcat('Average', AngleTitle, ' in ', nameOrd_y, '  ', SportTitle, '  ', LocationTitle, ' Right Knee'))
                % Get name for ylabel ====
                ylabel('Angular velocity in y (deg/s)')
                if strcmp(AngleType, 'Euler')
                    ylabel('Angle (°)')

                end


                % COORDENADA Z
                % Get name for plot ====
                AngleTitle = ' Gyroscope ';
                if strcmp(AngleType, 'Euler')
                    AngleTitle = ' Euler';
                end
                nameOrd_z = ' z-Coordinate';
                if strcmp(AngleType, 'Euler')
                    nameOrd_z = ' Yaw';
                end
                SportTitle = ' Squats';
                %if strcmp(Sport, 'Walking')
                %   exercise = ' Walking';
                %end
                LocationTitle = ' Suprapatellar Area';
                if strcmp(LocationType, 'Lateral')
                    LocationTitle = ' Lateral (External) Collateral Ligament';
                end

                % ======================
               

                tPlotProm = promedio_all.(PatientName).(SportType).(AngleType).(LocationType).time;
                ord_z = promedio_all.(PatientName).(SportType).(AngleType).(LocationType).z;
                subplot(3,1,3)
                plot(tPlotProm,ord_z, 'DisplayName', label)
                hold on
                grid on
                title(strcat('Average', AngleTitle, ' in ', nameOrd_z, '  ', SportTitle, '  ', LocationTitle, ' Right Knee'))

                % Get name for ylabel ====
                ylabel('Angular velocity in z (deg/s)')
                if strcmp(AngleType, 'Euler')
                    ylabel('Angle (°)')

                end
                

                % PARA EL PROMEDIO DE PROMEDIOS %ESTO EN TEORIA PODRIA IR
                % ARRIBA , JUSTO DESPUES DE CUANDO SE TERMINA DE DEFINIR EL
                % BUCLE DE LAS PERSONAS, ANTES DE LOS PLOTS
                prom_total.(PatientName) = promedio_all.(PatientName).(SportType).(AngleType).(LocationType);
            end


            promedio_allPatients = promedioAllFunction(prom_total); % llamo a la función que hace el promedio de promedios
            subplot(3,1,1)
            plot(promedio_allPatients.time ,promedio_allPatients.x,'k-','LineWidth',1.75, 'DisplayName', 'Total Average')
            legend('show','AutoUpdate','off');
            subplot(3,1,2)
            plot(promedio_allPatients.time ,promedio_allPatients.y,'k-','LineWidth',1.75, 'DisplayName', 'Total Average')
            legend('show','AutoUpdate','off');
            subplot(3,1,3)
            plot(promedio_allPatients.time ,promedio_allPatients.z,'k-','LineWidth',1.75, 'DisplayName', 'Total Average')
            legend('show','AutoUpdate','off');



        end
    end
end


%% PARA LA GUI

% COLUMNA 2 Y 3
% COORDENADA X
% Guardo en un .mat la coordenada x de cada muestra y el promedio de todas
% ellas
save (fullfile(dataFolder_all,'Results_TFG.mat'), 'samples', 'promedio_all', 'promedio_allPatients')



