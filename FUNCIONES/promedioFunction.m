function [promedio_x, promedio_y, promedio_z] = promedioFunction(gyroData,data_cell)
gyroData_x = gyroData.x;
%aqui NO es longitud de data_cell, eso seria 2 y queremos lo de 615
promGyroData_x = nan(length(data_cell), length(gyroData_x));
for j = 1:length(promGyroData_x)
    promGyroData_x(j,:) = interp1(gyroData_x(:,j), linspace(0,length(gyroData_x(:,j)), length(gyroData_x)));
    promedio_x = mean (promGyroData_x);
    % no se si en la linea de abajo en el linspace es mejor poner 100 o que
    %hago lo de la longitud mas larga porque asi lo hice en la prueba que
    %hice pero no se si tiene que ser obligatoriamente eso
    % para representar mejor puedo hacer lo de colores aleatorios
 end 
gyroData_y = gyroData.y;
promGyroData_y = nan(size(data_cell), length(data_cell));
for j = 1:length(promGyroData_y)
    promGyroData_y(j,:) = interp1(gyroData_y{j}, linspace(0,length(gyroData_y{j}), length(data_cell)));
    promedio_y = mean (promGyroData_y);
end 
gyroData_z = gyroData.z;
promGyroData_z = nan(size(data_cell), length(data_cell));
for j = 1:length(promGyroData_z)
    promGyroData_z(j,:) = interp1(gyroData_z{j}, linspace(0,length(gyroData_z{j}), length(data_cell)));
    promedio_z = mean (promGyroData_z);
end 
%no se si el plot es mejor dentro de la funcion o en el script principal
end