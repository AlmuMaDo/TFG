function all_promTotal = promedioAllFunction(prom_total)

patientList = fieldnames(prom_total);

% seleccionar cual de los promedios tiene el maximo numero de valores 
max_samples_proms = cellfun(@(s) numel(prom_total.(s).time), patientList);

[n_samples_prom_all, indexSimu] = max(max_samples_proms);
minvalue_time = min(prom_total.(patientList{indexSimu}).time);
maxvalue_time = max(prom_total.(patientList{indexSimu}).time);

frec_prom = (maxvalue_time-minvalue_time)/n_samples_prom_all;
 
% interpolar todo para tener mismo numero de valores
for iDataPromTotal = 1:numel(patientList) 
    num_samples_promPatient.time = prom_total.(patientList{indexSimu}).time;
    num_samples_promPatient.x = interp1(prom_total.(patientList{iDataPromTotal}).time, prom_total.(patientList{iDataPromTotal}).x, num_samples_promPatient.time);
    num_samples_promPatient.y = interp1(prom_total.(patientList{iDataPromTotal}).time, prom_total.(patientList{iDataPromTotal}).y, num_samples_promPatient.time);
    num_samples_promPatient.z = interp1(prom_total.(patientList{iDataPromTotal}).time, prom_total.(patientList{iDataPromTotal}).z, num_samples_promPatient.time);   
    
% guardar la estructura con los datos interpolados (%estructura de
% antes.campo de antes = nueva estructura que es en la que tengo los datos interpolados y que arriba desglosaba en x,y,z)
    %num_samples_promPatient es la de la ultima persona y esa se guarda en
    %la prom_total.(patientList{iDataPromTotal}) que es en la que se acumulan todos 
    prom_total.(patientList{iDataPromTotal})= num_samples_promPatient;
end


%% Hacer el promedio
all_promTotal.time = num_samples_promPatient.time;
% Eje x
% coger todos los valores de x y unirlos en una sola matriz para luego
% hacer el mean
all_x = cellfun(@(s) prom_total.(s).x, patientList, 'UniformOutput', false);
all_prom.x = horzcat(all_x{:});
% MIRAR FALLO EN LOS VALORES PORQUE NO PARECE COHERENTE, HAY DOS COLUMNAS
% DE NUMEROS NEGATIVOS
% Eje y
% coger todos los valores de y y unirlos en una sola matriz para luego
% hacer el mean
all_y = cellfun(@(s) prom_total.(s).y, patientList, 'UniformOutput', false);
all_prom.y = horzcat(all_y{:});

% Eje z
% coger todos los valores de y y unirlos en una sola matriz para luego
% hacer el mean
all_z = cellfun(@(s) prom_total.(s).z, patientList, 'UniformOutput', false);
all_prom.z = horzcat(all_z{:});

% MEDIA
all_promTotal.x = mean(all_prom.x, 2);
all_promTotal.y = mean (all_prom.y, 2);
all_promTotal.z = mean(all_prom.z, 2);


end