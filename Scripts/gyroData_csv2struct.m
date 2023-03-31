
function gyroData = gyroData_csv2struct(inputcsv_path)
% inputcsv path
gyroData_raw = readmatrix(inputcsv_path);
gyroData.time = gyroData_raw(:,3);
gyroData.x = gyroData_raw(:,4);
gyroData.y = gyroData_raw(:,5);
gyroData.z = gyroData_raw(:,6);
end