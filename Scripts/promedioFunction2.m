function [promedio, gyroData_all_interp] = promedioFunction2(gyroData_all)

testNames = keys(gyroData_all);

% seleccionar cual de los tests tiene el maximo numero de valores 
n_samples_all = cellfun(@(s) numel(gyroData_all(s).time), testNames);

[n_samples_prom, indexSimu] = max(n_samples_all);
minvalue_time = min(gyroData_all(testNames{indexSimu}).time);
maxvalue_time = max(gyroData_all(testNames{indexSimu}).time);

frec_prom = maxvalue_time/n_samples_prom;

% interpolar todo para tener mismo numero de valores
for iData = 1:numel(testNames) 
    DataStruct = gyroData_all(testNames{iData});
    DataStruct.time = gyroData_all(testNames{indexSimu}).time;
    DataStruct.x = interp1(gyroData_all(testNames{iData}).time, gyroData_all(testNames{iData}).x, DataStruct.time);
    DataStruct.y = interp1(gyroData_all(testNames{iData}).time, gyroData_all(testNames{iData}).y, DataStruct.time);
    DataStruct.z = interp1(gyroData_all(testNames{iData}).time, gyroData_all(testNames{iData}).z, DataStruct.time);   
    
    %sobreescribir la estructura 
    gyroData_all(testNames{iData}) = DataStruct;
end

gyroData_all_interp = gyroData_all;

%% Hacer el promedio 
% Eje x

% coger todos los valores de x y unirlos en una sola matriz para luego
% hacer el mean
all_x = cellfun(@(s) gyroData_all(s).x, testNames, 'UniformOutput', false);
all_x_juntos = horzcat(all_x{:});

% media 
promedio.x = mean(all_x_juntos, 2);



end