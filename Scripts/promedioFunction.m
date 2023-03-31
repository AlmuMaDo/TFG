function [promedio_x, promedio_y, promedio_z] = promedioFunction(gyroData)
gyroData_x = gyroData.x;% yo creo que esta linea no hace falta
promGyroData_x = nan(length(gyroData), length(gyroData_x));
for j = 1:length(promGyroData_x)
    promGyroData_x(j,:) = interp1(gyroData_x(:,1), linspace(0,length(gyroData_x(:,1)), length(gyroData_x)));
    % no se si en la linea de abajo en el linspace es mejor poner 100 o que
    %hago lo de la longitud mas larga porque asi lo hice en la prueba que
    %hice pero no se si tiene que ser obligatoriamente eso
    % para representar mejor puedo hacer lo de colores aleatorios
end 
promedio_x = mean (promGyroData_x);

gyroData_y = gyroData.y;% yo creo que esta linea no hace falta
promGyroData_y = nan(length(gyroData), length(gyroData_y));
for j = 1:length(promGyroData_y)
    promGyroData_y(j,:) = interp1(gyroData_y(:,1), linspace(0,length(gyroData_y(:,1)), length(gyroData_y)));
end 
promedio_y = mean (promGyroData_y);


gyroData_z = gyroData.z;% yo creo que esta linea no hace falta
promGyroData_z = nan(length(gyroData), length(gyroData_z));
for j = 1:length(promGyroData_z)
    promGyroData_z(j,:) = interp1(gyroData_z(:,1), linspace(0,length(gyroData_z(:,1)), length(gyroData_z)));
end
promedio_z = mean (promGyroData_z);
%no se si el plot es mejor dentro de la funcion o en el script principal
end