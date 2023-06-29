clc
clear all
close all

fs=100;
T=1/fs;


%%
%-----ADQUISICION DE DATOS-----
%GIROSCOPIO

% coger path de esta funcion
TFG_git_path = fileparts(fileparts(mfilename('fullpath')));%mismo para minerva

% addpath de todo el git
addpath(genpath(TFG_git_path));

% set datafiles folder path
dataFolder_all = fullfile(TFG_git_path, 'gyroData', 'gyroDataNew');
% mismo paso para minerva
% dataFolder_all_M = fullfile(TFG_git_path, 'gyroData', 'MINERVA/gyroDelanteMinerva/minervaregistro1_SensorViejo 2_2023-05-31T12.29.37.734_CCA00625B61F_Gyroscope_100.000Hz_1.3.6.csv');
% mismo paso para victor
%dataFolder_all_V = fullfile(TFG_git_path, 'gyroData', 'SUBJECT13/gyroDelanteVictor/');





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
                        % mirar si esta ya en diccionario del paciente (uno
                        % por paciente)
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
                       ylabel('Angle (�)')

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
                        % Si no esta guardado, cargar el csv y a�adir al diccionario y
                        % guardarlo
                        gyroData = gyroData_csv2struct(file_path);

                        % Normalizar muestras entre ... y ...
                        gyroData_norm = NormalizarFunction(gyroData, 0, 100);

                        % a�adir al diccionario muestras ya normalizadas
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
                       ylabel('Angle (�)')

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
                        % Si no esta guardado, cargar el csv y a�adir al diccionario y
                        % guardarlo
                        gyroData = gyroData_csv2struct(file_path);

                        % Normalizar muestras entre ... y ...
                        gyroData_norm = NormalizarFunction(gyroData, 0, 100);

                        % a�adir al diccionario muestras ya normalizadas
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
                       ylabel('Angle (�)')

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
                    ylabel('Angle (�)')

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
                    ylabel('Angle (�)')

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
                    ylabel('Angle (�)')

                end
                

                % PARA EL PROMEDIO DE PROMEDIOS %ESTO EN TEORIA PODRIA IR
                % ARRIBA , JUSTO DESPUES DE CUANDO SE TERMINA DE DEFINIR EL
                % BUCLE DE LAS PERSONAS, ANTES DE LOS PLOTS
                prom_total.(PatientName) = promedio_all.(PatientName).(SportType).(AngleType).(LocationType);
            end


%             promedio_allPatients = promedioAllFunction(prom_total); % llamo a la funci�n que hace el promedio de promedios
%             subplot(3,1,1)
%             plot(promedio_allPatients.time ,promedio_allPatients.x,'k-','LineWidth',1.75, 'DisplayName', 'Total Average')
%             legend('show','AutoUpdate','off');
%             subplot(3,1,2)
%             plot(promedio_allPatients.time ,promedio_allPatients.y,'k-','LineWidth',1.75, 'DisplayName', 'Total Average')
%             legend('show','AutoUpdate','off');
%             subplot(3,1,3)
%             plot(promedio_allPatients.time ,promedio_allPatients.z,'k-','LineWidth',1.75, 'DisplayName', 'Total Average')
%             legend('show','AutoUpdate','off');

            promedio_allPatients = promedioAllFunction(prom_total); % llamo a la funci�n que hace el promedio de promedios
            subplot(3,1,1)
            plot(promedio_allPatients.time ,promedio_allPatients.x,'k-','LineWidth',1.75, 'DisplayName', 'Total Average')
            legend('show','AutoUpdate','off');
            subplot(3,1,2)
            plot(promedio_allPatients.time ,promedio_allPatients.y,'k-','LineWidth',1.75, 'DisplayName', 'Total Average')
            legend('show','AutoUpdate','off');
            subplot(3,1,3)
            plot(promedio_allPatients.time ,promedio_allPatients.z,'k-','LineWidth',1.75, 'DisplayName', 'Total Average')
            legend('show','AutoUpdate','off');

            promedio_allPatients_gui.(Sport).(AngleType).(LocationType) = promedio_allPatients;

        end
    end
end


%% PARA LA GUI

% COLUMNA 2 Y 3
% COORDENADA X
% Guardo en un .mat la coordenada x de cada muestra y el promedio de todas
% ellas
save (fullfile(dataFolder_all,'Results_TFG.mat'), 'samples', 'promedio_all', 'promedio_allPatients', "promedio_allPatients_gui")

%% Comparativa curva ideal con curvas minerva y victor
%aislar primero la curva ideal y luego el fragmento lo represento en lo
%otro
%minerva
% Leer el archivo CSV
datosR1 = readmatrix('minervaregistro1_Sensor Viejo2_2023-05-31T12.29.37.734_CCA00625B61F_Gyroscope_100.000Hz_1.3.6.csv');

% Extraer las columnas de inter�s
dataMinerva.time = datosR1(:, 3);
dataMinerva.x = datosR1(:, 4);
dataMinerva.y = datosR1(:,5);
dataMinerva.z = datosR1(:,6);

% definir el rango deseado en el eje x para minerva
rango_time_inicio = 21.93;
rango_time_fin = 24.93;

% fragmentar el trozo deseado basado en el rango en el eje x
indices = (dataMinerva.time>= rango_time_inicio) & (dataMinerva.time<= rango_time_fin);
dataMinerva.time = dataMinerva.time(indices);
dataMinerva.x = dataMinerva.x(indices);
dataMinerva.y = dataMinerva.y(indices);
dataMinerva.z= dataMinerva.z(indices);
dataMinerva_norm = NormalizarFunctionCompareMinerva(dataMinerva,0,100);

% Victor
% Leer el archivo CSV
datosR2 = readmatrix('victorregistro1_Sensor Viejo 2_2023-05-31T10.31.37.670_CCA00625B61F_Gyroscope_100.000Hz_1.3.6.csv');

% Extraer las columnas de inter�s
dataVictor.time = datosR2(:, 3);
dataVictor.x = datosR2(:, 4);
dataVictor.y = datosR2(:,5);
dataVictor.z = datosR2(:,6);

% definir el rango deseado en el eje x para victor
rango_time_inicioV = 28.31;
rango_time_finV = 31.31;


% fragmentar el trozo deseado basado en el rango en el eje x
indicesVictor = (dataVictor.time>= rango_time_inicioV) & (dataVictor.time<= rango_time_finV);
dataVictor.time = dataVictor.time(indicesVictor);
dataVictor.x = dataVictor.x(indicesVictor);
dataVictor.y = dataVictor.y(indicesVictor);
dataVictor.z= dataVictor.z(indicesVictor);
dataVictor_norm = NormalizarFunctionCompareVictor(dataVictor,0,100);

%aislo la curva ideal
% definir el rango deseado en el eje x
rango_time_inicio_ideal = 15.54;
rango_time_fin_ideal = 25.5241;

% fragmentar el trozo deseado basado en el rango en el eje x
indices_ideal = (promedio_allPatients.time>= rango_time_inicio_ideal) & (promedio_allPatients.time<= rango_time_fin_ideal);
promedio_allPatients.time = promedio_allPatients.time(indices_ideal);
promedio_allPatients.x = promedio_allPatients.x(indices_ideal);
promedio_allPatients.y = promedio_allPatients.y(indices_ideal);
promedio_allPatients.z = promedio_allPatients.z(indices_ideal);
%porque promedio_allPatients es un struct 
promedio_allPatients_norm = NormalizarFunctionCompareICurve(promedio_allPatients, 0, 100);

grid on
% graficar el trozo fragmentado de minerva
figure
subplot(3,1,1)
curva_promx = plot(dataMinerva_norm.time, dataMinerva_norm.x,'k-', 'DisplayName','Subject 12 x-coordinate');
threshold_max= 0.6;

% m�ximos curva promedio de minerva x
[peaksMinerva, peakIndicesMinerva] = findpeaks(dataMinerva_norm.x);
filteredPeaksMinerva = peaksMinerva(peaksMinerva > threshold_max*max(peaksMinerva));
filteredPeakIndicesMinerva = peakIndicesMinerva(peaksMinerva > threshold_max*max(peaksMinerva));
hold on
plot(dataMinerva_norm.time(filteredPeakIndicesMinerva), filteredPeaksMinerva, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva promedio de minerva x
threshold_x_min= 0.60;
[minPeaksMinerva, minPeakIndicesMinerva] = findpeaks(-dataMinerva_norm.x);
minPeaksMinerva = -minPeaksMinerva;
filteredPeaks_minMinerva = minPeaksMinerva(minPeaksMinerva < threshold_x_min*min(minPeaksMinerva));
filteredPeakIndices_minMinerva = minPeakIndicesMinerva(minPeaksMinerva < threshold_x_min*min(minPeaksMinerva));
hold on
plot(dataMinerva_norm.time(filteredPeakIndices_minMinerva), filteredPeaks_minMinerva, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)

grid on
hold on
curva_estandarx = plot (promedio_allPatients_norm.time,promedio_allPatients_norm.x, 'r-', 'DisplayName','Standard Curve for x');
title ('Comparative analysis x-coordinate patient with osteopenia')
xlabel('Time (s)')
ylabel('Angular velocity in x (deg/s)')
 % m�ximos curva ideal aislada x
[peaksIdeal, peakIndicesIdeal] = findpeaks(promedio_allPatients_norm.x);
filteredPeaksIdeal = peaksIdeal(peaksIdeal > threshold_max*max(peaksIdeal));
filteredPeakIndicesIdeal = peakIndicesIdeal(peaksIdeal > threshold_max*max(peaksIdeal));
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndicesIdeal), filteredPeaksIdeal, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva ideal aislada x
% threshold_x_min= 0.8;
[minPeaksIdeal, minPeakIndicesIdeal] = findpeaks(-promedio_allPatients_norm.x);
minPeaksIdeal = -minPeaksIdeal;
filteredPeaks_minIdeal = minPeaksIdeal(minPeaksIdeal < threshold_x_min*min(minPeaksIdeal));
filteredPeakIndices_minIdeal = minPeakIndicesIdeal(minPeaksIdeal < threshold_x_min*min(minPeaksIdeal));
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndices_minIdeal), filteredPeaks_minIdeal, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)
% legend('off');
legend([curva_promx,curva_estandarx],'Location','best');


subplot(3,1,2)
curva_promy = plot(dataMinerva_norm.time, dataMinerva_norm.y, 'k-', 'DisplayName','Subject 12 y-coordinate');
% m�ximos curva promedio de minerva y
threshold_max1= 0.9;
[peaksMinerva1, peakIndicesMinerva1] = findpeaks(dataMinerva_norm.y);
filteredPeaksMinerva1 = peaksMinerva1(peaksMinerva1 > threshold_max1*max(peaksMinerva1));
filteredPeakIndicesMinerva1 = peakIndicesMinerva1(peaksMinerva1 > threshold_max1*max(peaksMinerva1));
hold on
plot(dataMinerva_norm.time(filteredPeakIndicesMinerva1), filteredPeaksMinerva1, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva promedio de minerva y
threshold_x_min1= 0.9;
[minPeaksMinerva1, minPeakIndicesMinerva1] = findpeaks(-dataMinerva_norm.y);
minPeaksMinerva1 = -minPeaksMinerva1;
filteredPeaks_minMinerva1 = minPeaksMinerva1(minPeaksMinerva1 < threshold_x_min1*min(minPeaksMinerva1));
filteredPeakIndices_minMinerva1 = minPeakIndicesMinerva1(minPeaksMinerva1 < threshold_x_min1*min(minPeaksMinerva1));
hold on
plot(dataMinerva_norm.time(filteredPeakIndices_minMinerva1), filteredPeaks_minMinerva1, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)

grid on
hold on
curva_estandary = plot(promedio_allPatients_norm.time, promedio_allPatients_norm.y, 'r-', 'DisplayName', 'Standard curve for y');
title ('Comparative analysis y-coordinate patient with osteopenia')
xlabel('Time (s)')
ylabel('Angular velocity in y (deg/s)')
% m�ximos curva ideal aislada y
[peaksIdeal1, peakIndicesIdeal1] = findpeaks(promedio_allPatients_norm.y);
filteredPeaksIdeal1 = peaksIdeal1(peaksIdeal1 > threshold_max*max(peaksIdeal1));
filteredPeakIndicesIdeal1 = peakIndicesIdeal1(peaksIdeal1 > threshold_max*max(peaksIdeal1));
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndicesIdeal1), filteredPeaksIdeal1, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva ideal aislada y
% threshold_x_min= 0.8;
[minPeaksIdeal1, minPeakIndicesIdeal1] = findpeaks(-promedio_allPatients_norm.y);
minPeaksIdeal1 = -minPeaksIdeal1;
filteredPeaks_minIdeal1 = minPeaksIdeal1(minPeaksIdeal1 < threshold_x_min*min(minPeaksIdeal1));
filteredPeakIndices_minIdeal1 = minPeakIndicesIdeal1(minPeaksIdeal1 < threshold_x_min*min(minPeaksIdeal1));
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndices_minIdeal1), filteredPeaks_minIdeal1, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)
legend([curva_promy,curva_estandary],'Location','best');


subplot(3,1,3)
curva_promz = plot(dataMinerva_norm.time, dataMinerva_norm.z, 'k-', 'DisplayName','Subject 12 z-coordinate');
% m�ximos curva promedio de minerva z
threshold_max2= 0.9;
[peaksMinerva2, peakIndicesMinerva2] = findpeaks(dataMinerva_norm.z);
filteredPeaksMinerva2 = peaksMinerva2(peaksMinerva2 > threshold_max2*max(peaksMinerva2));
filteredPeakIndicesMinerva2 = peakIndicesMinerva2(peaksMinerva2 > threshold_max2*max(peaksMinerva2));
hold on
plot(dataMinerva_norm.time(filteredPeakIndicesMinerva2), filteredPeaksMinerva2, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva promedio de minerva z
threshold_x_min2= 0.9;
[minPeaksMinerva2, minPeakIndicesMinerva2] = findpeaks(-dataMinerva_norm.z);
minPeaksMinerva2 = -minPeaksMinerva2;
filteredPeaks_minMinerva2 = minPeaksMinerva2(minPeaksMinerva2 < threshold_x_min2*min(minPeaksMinerva2));
filteredPeakIndices_minMinerva2 = minPeakIndicesMinerva2(minPeaksMinerva2 < threshold_x_min2*min(minPeaksMinerva2));
plot(dataMinerva_norm.time(filteredPeakIndices_minMinerva2), filteredPeaks_minMinerva2, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)
hold on

grid on
hold on
curva_estandarz = plot(promedio_allPatients_norm.time,promedio_allPatients_norm.z, 'r-', 'DisplayName','Standard curve for z');
% m�ximos curva ideal aislada z
[peaksIdeal2, peakIndicesIdeal2] = findpeaks(promedio_allPatients_norm.z);
filteredPeaksIdeal2 = peaksIdeal2(peaksIdeal2 > threshold_max*max(peaksIdeal2));
filteredPeakIndicesIdeal2 = peakIndicesIdeal2(peaksIdeal2 > threshold_max*max(peaksIdeal2));
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndicesIdeal2), filteredPeaksIdeal2, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva ideal aislada z
% threshold_x_min= 0.8;
[minPeaksIdeal2, minPeakIndicesIdeal2] = findpeaks(-promedio_allPatients_norm.z);
minPeaksIdeal2 = -minPeaksIdeal2;
filteredPeaks_minIdeal2 = minPeaksIdeal2(minPeaksIdeal2 < threshold_x_min*min(minPeaksIdeal2));
filteredPeakIndices_minIdeal2 = minPeakIndicesIdeal2(minPeaksIdeal2 < threshold_x_min*min(minPeaksIdeal2));
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndices_minIdeal2), filteredPeaks_minIdeal2, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)

title ('Comparative analysis z-coordinate patient with osteopenia')
xlabel('Time (s)')
ylabel('Angular velocity in z (deg/s)')
legend([curva_promz,curva_estandarz],'Location','best');


% graficar el trozo fragmentado de victor
figure
grid on
subplot(3,1,1)
curva_promxV = plot(dataVictor_norm.time, dataVictor_norm.x, 'k-', 'DisplayName','Subject 13 x-coordinate');
threshold_max= 0.6;

% m�ximos curva promedio de victor x
[peaksVictor, peakIndicesVictor] = findpeaks(dataVictor_norm.x);
filteredPeaksVictor = peaksVictor(peaksVictor > threshold_max*max(peaksVictor));
filteredPeakIndicesVictor = peakIndicesVictor(peaksVictor > threshold_max*max(peaksVictor));
hold on
plot(dataVictor_norm.time(filteredPeakIndicesVictor), filteredPeaksVictor, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva promedio de Victor x
% threshold_x_min= 0.60;
[minPeaksVictor, minPeakIndicesVictor] = findpeaks(-dataVictor_norm.x);
minPeaksVictor = -minPeaksVictor;
filteredPeaks_minVictor = minPeaksVictor(minPeaksVictor < threshold_x_min*min(minPeaksVictor));
filteredPeakIndices_minVictor = minPeakIndicesVictor(minPeaksVictor < threshold_x_min*min(minPeaksVictor));
hold on
plot(dataVictor_norm.time(filteredPeakIndices_minVictor), filteredPeaks_minVictor, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)

grid on
hold on
curva_estandarx = plot (promedio_allPatients_norm.time,promedio_allPatients_norm.x, 'r-','DisplayName','Standard curve for x');
 % m�ximos curva ideal aislada x
% [peaksIdeal, peakIndicesIdeal] = findpeaks(promedio_allPatients_norm.x);
% filteredPeaksIdeal = peaksIdeal(peaksIdeal > threshold_max*max(peaksIdeal));
% filteredPeakIndicesIdeal = peakIndicesIdeal(peaksIdeal > threshold_max*max(peaksIdeal));
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndicesIdeal), filteredPeaksIdeal, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva ideal aislada x
% threshold_x_min= 0.8;
% [minPeaksIdeal, minPeakIndicesIdeal] = findpeaks(-promedio_allPatients_norm.x);
% minPeaksIdeal = -minPeaksIdeal;
% filteredPeaks_minIdeal = minPeaksIdeal(minPeaksIdeal < threshold_x_min*min(minPeaksIdeal));
% filteredPeakIndices_minIdeal = minPeakIndicesIdeal(minPeaksIdeal < threshold_x_min*min(minPeaksIdeal));
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndices_minIdeal), filteredPeaks_minIdeal, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)
xlabel('Time (s)')
ylabel('Angular velocity in x (deg/s)')
title ('Comparative analysis x-coordinate patient with athlete')
legend([curva_promxV,curva_estandarx],'Location','best');

 
subplot(3,1,2)
curva_promyV = plot(dataVictor_norm.time, dataVictor_norm.y,'k-', 'DisplayName','Subject 13 y-coordinate');
% m�ximos curva promedio de victor y
[peaksVictor1, peakIndicesVictor1] = findpeaks(dataVictor_norm.y);
filteredPeaksVictor1 = peaksVictor1(peaksVictor1 > threshold_max*max(peaksVictor1));
filteredPeakIndicesVictor1 = peakIndicesVictor1(peaksVictor1 > threshold_max*max(peaksVictor1));
hold on
plot(dataVictor_norm.time(filteredPeakIndicesVictor1), filteredPeaksVictor1, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva promedio de Victor y
% threshold_x_min= 0.60;
[minPeaksVictor1, minPeakIndicesVictor1] = findpeaks(-dataVictor_norm.y);
minPeaksVictor1 = -minPeaksVictor1;
filteredPeaks_minVictor1 = minPeaksVictor1(minPeaksVictor1 < threshold_x_min*min(minPeaksVictor1));
filteredPeakIndices_minVictor1 = minPeakIndicesVictor1(minPeaksVictor1 < threshold_x_min*min(minPeaksVictor1));
hold on
plot(dataVictor_norm.time(filteredPeakIndices_minVictor1), filteredPeaks_minVictor1, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)

grid on
hold on
curva_estandary = plot(promedio_allPatients_norm.time, promedio_allPatients_norm.y,'r-', 'DisplayName','Standard curve for y');
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndicesIdeal1), filteredPeaksIdeal1, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndices_minIdeal1), filteredPeaks_minIdeal1, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)
title ('Comparative analysis y-coordinate patient with athlete')
xlabel('Time (s)')
ylabel('Angular velocity in y (deg/s)')
legend([curva_promyV,curva_estandary],'Location','best');

subplot(3,1,3)
curva_promzV = plot(dataVictor_norm.time, dataVictor_norm.z, 'k-', 'DisplayName','Subject 13 z-coordinate');
% m�ximos curva promedio de victor z
[peaksVictor2, peakIndicesVictor2] = findpeaks(dataVictor_norm.z);
filteredPeaksVictor2 = peaksVictor2(peaksVictor2 > threshold_max*max(peaksVictor2));
filteredPeakIndicesVictor2 = peakIndicesVictor2(peaksVictor2 > threshold_max*max(peaksVictor2));
hold on
plot(dataVictor_norm.time(filteredPeakIndicesVictor2), filteredPeaksVictor2, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva promedio de Victor z
% threshold_x_min= 0.60;
[minPeaksVictor2, minPeakIndicesVictor2] = findpeaks(-dataVictor_norm.z);
minPeaksVictor2 = -minPeaksVictor2;
filteredPeaks_minVictor2 = minPeaksVictor2(minPeaksVictor2 < threshold_x_min*min(minPeaksVictor2));
filteredPeakIndices_minVictor2 = minPeakIndicesVictor2(minPeaksVictor2 < threshold_x_min*min(minPeaksVictor2));
hold on
plot(dataVictor_norm.time(filteredPeakIndices_minVictor2), filteredPeaks_minVictor2, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)

grid on
hold on
curva_estandarz = plot(promedio_allPatients_norm.time,promedio_allPatients_norm.z, 'r-','DisplayName', 'Standard curve for z');
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndicesIdeal2), filteredPeaksIdeal2, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndices_minIdeal2), filteredPeaks_minIdeal2, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)

title ('Comparative analysis z-coordinate patient with athlete')
xlabel('Time (s)')
ylabel('Angular velocity in z (deg/s)')
legend([curva_promzV,curva_estandarz],'Location','best');


%% Curvas S11

% S11
% Leer el archivo CSV
datosS11 = readmatrix('SGDM2S11_PM _MetaWear nuevo_2023-05-26T21.12.18.356_DFE264DC19EA_Gyroscope_100.000Hz_1.7.3.csv');

figure
% Extraer las columnas de inter�s
dataS11.time = datosS11(:, 3);
dataS11.x = datosS11(:, 4);
dataS11.y = datosS11(:,5);
dataS11.z = datosS11(:,6);

%definir el rango deseado en el eje x para S11
rango_time_inicioS11 = 4.49 ;
rango_time_finS11 = 7.49;


% fragmentar el trozo deseado basado en el rango en el eje x
indicesS11 = (dataS11.time>= rango_time_inicioS11) & (dataS11.time<= rango_time_finS11);
dataS11.time = dataS11.time(indicesS11);
dataS11.x = dataS11.x(indicesS11);
dataS11.y = dataS11.y(indicesS11);
dataS11.z= dataS11.z(indicesS11);
dataS11_norm = NormalizarFunctionCompareS11(dataS11,0,100);
 
%aislo la curva ideal
% definir el rango deseado en el eje x
rango_time_inicio_ideal = 15.54;
rango_time_fin_ideal = 25.5241;

% fragmentar el trozo deseado basado en el rango en el eje x
indices_ideal = (promedio_allPatients.time>= rango_time_inicio_ideal) & (promedio_allPatients.time<= rango_time_fin_ideal);
promedio_allPatients.time = promedio_allPatients.time(indices_ideal);
promedio_allPatients.x = promedio_allPatients.x(indices_ideal);
promedio_allPatients.y = promedio_allPatients.y(indices_ideal);
promedio_allPatients.z = promedio_allPatients.z(indices_ideal);
%porque promedio_allPatients es un struct 
promedio_allPatients_norm = NormalizarFunctionCompareICurve(promedio_allPatients, 0, 100);

%graficar el trozo fragmentado de S11
figure
grid on
subplot(3,1,1)
curva_promxS11 = plot(dataS11_norm.time, dataS11_norm.x, 'k-', 'DisplayName','Subject 11 x-coordinate');
threshold_max= 0.6;

% m�ximos curva promedio de S11 x
[peaksS11, peakIndicesS11] = findpeaks(dataS11_norm.x);
filteredPeaksS11 = peaksS11(peaksS11 > threshold_max*max(peaksS11));
filteredPeakIndicesS11 = peakIndicesS11(peaksS11 > threshold_max*max(peaksS11));
hold on
plot(dataS11_norm.time(filteredPeakIndicesS11), filteredPeaksS11, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva promedio de S11 x
% threshold_x_min= 0.6;
[minPeaksS11, minPeakIndicesS11] = findpeaks(-dataS11_norm.x);
minPeaksS11 = -minPeaksS11;
filteredPeaks_minS11 = minPeaksS11(minPeaksS11 < threshold_x_min*min(minPeaksS11));
filteredPeakIndices_minS11 = minPeakIndicesS11(minPeaksS11 < threshold_x_min*min(minPeaksS11));
hold on
plot(dataS11_norm.time(filteredPeakIndices_minS11), filteredPeaks_minS11, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)

grid on
hold on
curva_estandarx = plot (promedio_allPatients_norm.time,promedio_allPatients_norm.x, 'r-','DisplayName','Standard curve for x');
 % m�ximos curva ideal aislada x
% [peaksIdeal, peakIndicesIdeal] = findpeaks(promedio_allPatients_norm.x);
% filteredPeaksIdeal = peaksIdeal(peaksIdeal > threshold_max*max(peaksIdeal));
% filteredPeakIndicesIdeal = peakIndicesIdeal(peaksIdeal > threshold_max*max(peaksIdeal));
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndicesIdeal), filteredPeaksIdeal, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva ideal aislada x
% threshold_x_min= 0.8;
% [minPeaksIdeal, minPeakIndicesIdeal] = findpeaks(-promedio_allPatients_norm.x);
% minPeaksIdeal = -minPeaksIdeal;
% filteredPeaks_minIdeal = minPeaksIdeal(minPeaksIdeal < threshold_x_min*min(minPeaksIdeal));
% filteredPeakIndices_minIdeal = minPeakIndicesIdeal(minPeaksIdeal < threshold_x_min*min(minPeaksIdeal));
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndices_minIdeal), filteredPeaks_minIdeal, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)
xlabel('Time (s)')
ylabel('Angular velocity in x (deg/s)')
title ('Comparative analysis x-coordinate patient with non-athlete')
legend([curva_promxS11,curva_estandarx],'Location','best');

 
subplot(3,1,2)
curva_promyS11 = plot(dataS11_norm.time, dataS11_norm.y,'k-', 'DisplayName','Subject 11 y-coordinate');
% m�ximos curva promedio de S11 y
[peaksS111, peakIndicesS111] = findpeaks(dataS11_norm.y);
filteredPeaksS111 = peaksS111(peaksS111 > threshold_max*max(peaksS111));
filteredPeakIndicesS111 = peakIndicesS111(peaksS111 > threshold_max*max(peaksS111));
hold on
plot(dataS11_norm.time(filteredPeakIndicesS111), filteredPeaksS111, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva promedio de S11 y
% threshold_x_min= 0.60;
[minPeaksS111, minPeakIndicesS111] = findpeaks(-dataS11_norm.y);
minPeaksS111 = -minPeaksS111;
filteredPeaks_minS111 = minPeaksS111(minPeaksS111 < threshold_x_min*min(minPeaksS111));
filteredPeakIndices_minS111 = minPeakIndicesS111(minPeaksS111 < threshold_x_min*min(minPeaksS111));
hold on
plot(dataS11_norm.time(filteredPeakIndices_minS111), filteredPeaks_minS111, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)

grid on
hold on
curva_estandary = plot(promedio_allPatients_norm.time, promedio_allPatients_norm.y,'r-', 'DisplayName','Standard curve for y');
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndicesIdeal1), filteredPeaksIdeal1, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndices_minIdeal1), filteredPeaks_minIdeal1, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)
title ('Comparative analysis y-coordinate patient with non-athlete')
xlabel('Time (s)')
ylabel('Angular velocity in y (deg/s)')
legend([curva_promyS11,curva_estandary],'Location','best');

subplot(3,1,3)
curva_promzS11 = plot(dataS11_norm.time, dataS11_norm.z, 'k-', 'DisplayName','Subject 11 z-coordinate');
% m�ximos curva promedio de S11 z
[peaksS112, peakIndicesS112] = findpeaks(dataS11_norm.z);
filteredPeaksS112 = peaksS112(peaksS112 > threshold_max*max(peaksS112));
filteredPeakIndicesS112 = peakIndicesS112(peaksS112 > threshold_max*max(peaksS112));
hold on
plot(dataS11_norm.time(filteredPeakIndicesS112), filteredPeaksS112, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
% m�nimos curva promedio de S11 z
% threshold_x_min= 0.60;
[minPeaksS112, minPeakIndicesS112] = findpeaks(-dataS11_norm.z);
minPeaksS112 = -minPeaksS112;
filteredPeaks_minS112 = minPeaksS112(minPeaksS112 < threshold_x_min*min(minPeaksS112));
filteredPeakIndices_minS112 = minPeakIndicesS112(minPeaksS112 < threshold_x_min*min(minPeaksS112));
hold on
plot(dataS11_norm.time(filteredPeakIndices_minS112), filteredPeaks_minS112, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)

grid on
hold on
curva_estandarz = plot(promedio_allPatients_norm.time,promedio_allPatients_norm.z, 'r-','DisplayName', 'Standard curve for z');
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndicesIdeal2), filteredPeaksIdeal2, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);
hold on
plot(promedio_allPatients_norm.time(filteredPeakIndices_minIdeal2), filteredPeaks_minIdeal2, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)

title ('Comparative analysis z-coordinate patient with non-athlete')
xlabel('Time (s)')
ylabel('Angular velocity in z (deg/s)')
legend([curva_promzS11,curva_estandarz],'Location','best');


% PONGO LEYENDA ENTONCES EN LA GUI??
