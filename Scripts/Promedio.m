

%% PROMEDIO
% 
% acel_x1 = datos1 (:,2);
% acel_x2 = datos2 (:,2);
% acel_x3 = datos3 (:,2);
% acel_x4 = datos4 (:,2);
% 
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
%figure
