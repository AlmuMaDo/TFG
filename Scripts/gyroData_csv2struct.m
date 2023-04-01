
function gyroData = gyroData_csv2struct(inputcsv_path)
% inputcsv path
try
    % he tenido que añadir el try por si no esta la funcion en otra version
    % de matlab
    gyroData_raw = readmatrix(inputcsv_path);
    gyroData.time = gyroData_raw(:,3);
    gyroData.x = gyroData_raw(:,4);
    gyroData.y = gyroData_raw(:,5);
    gyroData.z = gyroData_raw(:,6);
catch
    gyroData_raw = dlmread(inputcsv_path, ',', 1,2);
    gyroData.time = gyroData_raw(:,1);
    gyroData.x = gyroData_raw(:,2);
    gyroData.y = gyroData_raw(:,3);
    gyroData.z = gyroData_raw(:,4);
end

end