%% PROMEDIO QUE FUNCA
% clc
% clear all
% close all
% 
% fs=100;
% T=1/fs;
% %muestra 1 datos generales (comienza en 0)
% datos1 = readmatrix ('Accelerometer_andando_pisarMarcas_20230305-104412579.csv');
% trial1= datos1(:,1); % lo entiendo pero no se como llamarlo para cambiarle el nombre
% t1 = 0:T:((length(trial1)/fs)-T);
% 
% %muestra 2 datos generales (no comienza en 0)
% datos2 = readmatrix ('Accelerometer_andando_pisarMarcas_20230305-104544074.csv');
% trial2 = datos2 (:,1);
% t2 = 0:T:((length(trial2)/fs)-T);
% 
% %muestra 3 datos generales (comienza en 0)
% datos3 = readmatrix ('Accelerometer_andando_pisarMarcas_20230305-113501210.csv');
% trial3 = datos3 (:,1);
% t3 = 0:T:((length(trial3)/fs)-T);
% 
% %muestra  datos generales (comienza en 0)
% datos4 = readmatrix ('Accelerometer_andando_pisarMarcas_20230305-113639016.csv');
% trial4 = datos4 (:,1);
% t4 = 0:T:((length(trial4)/fs)-T);



% acel_x1 = datos1 (:,2);
% acel_x2 = datos2 (:,2);
% acel_x3 = datos3 (:,2);
% acel_x4 = datos4 (:,2);

% a1 = smoothdata(acel_x1, 'gaussian' , fs);
% a2 = smoothdata(acel_x2, 'gaussian' , fs);
% a3 = smoothdata(acel_x3, 'gaussian' , fs);
% a4 = smoothdata(acel_x4, 'gaussian' , fs);

% %el 4 este habria que ponerlo como algo general claro
% acel_x = nan(4,615);
% acel_x(1,:) = interp1(acel_x1,linspace(0,length(acel_x1),615));%no se si en el linspace tendria que poner tb el numero de puntos
% acel_x(2,:) = interp1(acel_x2,linspace(0,length(acel_x2),615));
% acel_x(3,:) = interp1(acel_x3,linspace(0,length(acel_x3),615));
% acel_x(4,:) = interp1(acel_x4,linspace(0,length(acel_x4),615));
% 
% promedio = mean (acel_x);
% 
% 
% %modificar este codigo
% %en el 615 si eso funciona habria que poner length del mas largo ?
% sample_1 = plot(linspace(0,100,615), acel_x(1,:),'g','DisplayName','Muestra 1')
% hold on
% sample_2 = plot(linspace(0,100,615), acel_x(2,:),'m','DisplayName','Muestra 2')
% hold on
% sample_3 = plot(linspace(0,100,615), acel_x(3,:),'b','DisplayName','Muestra 3')
% hold on
% sample_4 = plot(linspace(0,100,615), acel_x(4,:),'r','DisplayName','Muestra 4')
% hold on
% promedio = plot(linspace(0,100,615), mean(acel_x),'k-','DisplayName','Promedio','LineWidth',3)
% grid on
% xlabel ('time')
% ylabel ('acel_x')
% legend
% hold off
% %figure
% 
