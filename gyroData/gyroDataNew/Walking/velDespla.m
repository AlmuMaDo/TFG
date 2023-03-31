
%% Coordenada x
% ACELERACIONES
%represento las coordenadas x de las muestras.
%acel_x1 = datos1 (:,2);
% %plot (t1,acel_x1, 'DisplayName', 'Muestra 1')
% % plot (t1, acel_x1)
% %xlim ([0,7])
% %ylim ([0.6]) %habia puesto de limite inferior -2.1 pero no se si es util, o tp se si no pones limite inferior el unico numero que pones como lo toma
% % title ('Aceleración en x (Pisando Marcas) Muestra 1')
% % xlabel('Tiempo')
% % ylabel('Aceleración en x')
% grid on
% %hold on
% figure
%acel_x2 = datos2 (:,2);
%plot (t2,acel_x2, 'DisplayName', 'Muestra 2')
% plot (t2, acel_x2)
% grid on
% title ('Aceleración en x (Pisando Marcas) Muestra 2')
% xlabel('Tiempo')
% ylabel('Aceleración en x')
% %xlim
%ylim
%hold on
%acel_x3 = datos3 (:,2);
% % %plot (t3,acel_x3, 'DisplayName', 'Muestra 3')
% plot (t3,acel_x3)
% grid on
% title ('Aceleración en x (Pisando Marcas) Muestra 3')
% xlabel('Tiempo')
% ylabel('Aceleración en x')
% %hold on
%acel_x4 = datos4 (:,2);
% %plot (t4,acel_x4, 'DisplayName', 'Muestra 4')
% plot (t4,acel_x4)
% grid on
% title ('Aceleración en x (Pisando Marcas) Muestra 4')
% xlabel('Tiempo')
% ylabel('Aceleración en x')
% legend


%% VELOCIDADES (INTUYO QUE PARA NO TENER QUE HACER TANTO CODIGO PUES HABRIA
% % QUE CREAR BUCLES Y COSAS)
% %igual habria que ajustar los ejes pero de momento asi
% vel_x1 = cumtrapz(t1,acel_x1);
% plot (t1,vel_x1, 'DisplayName','M1');
% grid on
% title ('VELOCIDADES EN X DE LAS DISTINTAS MUESTRAS')
% xlabel('Tiempo')
% ylabel('Velocidad en x')
% hold on
% vel_x2 = cumtrapz(t2,acel_x2);
% plot (t2,vel_x2, 'DisplayName','M2');
% grid on
% xlabel('Tiempo')
% ylabel('Velocidad en x')
% hold on
% vel_x3 = cumtrapz(t3,acel_x3);
% plot (t3,vel_x3, 'DisplayName','M3');
% grid on
% xlabel('Tiempo')
% ylabel('Velocidad en x')
% hold on
% vel_x4 = cumtrapz(t4,acel_x4);
% plot (t4,vel_x4, 'DisplayName','M4');
% grid on
% xlabel('Tiempo')
% ylabel('Velocidad en x')
% legend
% 
% % Ahora voy a representar las velocidades en x, y ,z de la muestra 1 en la
% % misma grafica
% 
% figure
% acel_y1 = datos1(:,3);
% acel_z1 = datos1 (:,4);
% vel_y1 = cumtrapz(t1,acel_y1);
% vel_z1 = cumtrapz(t1,acel_z1);
% plot(t1,vel_x1, 'Color', 'blue')
% hold on
% plot(t1,vel_y1,'Color', 'red')
% hold on 
% plot (t1,vel_z1,'Color', 'green')
% title ('Velocidades en los 3 ejes M1')
% xlabel('Tiempo')
% ylabel('Velocidad en x')
% grid on
% legend ('x','y','z')
% 
% % DESPLAZAMIENTOS (INTUYO QUE PARA NO TENER QUE HACER TANTO CODIGO PUES HABRIA
% % QUE CREAR BUCLES Y COSAS)
% %igual habria que ajustar los ejes pero de momento asi
% figure
% desp_x1 = cumtrapz(t1,vel_x1);
% plot (t1,desp_x1, 'DisplayName','M1');
% grid on
% title ('DESPLAZAMIENTOS EN X DE LAS DISTINTAS MUESTRAS')
% xlabel('Tiempo')
% ylabel('Desplazamiento en x')
% hold on
% desp_x2 = cumtrapz(t2,vel_x2);
% plot (t2,desp_x2, 'DisplayName','M2');
% grid on
% xlabel('Tiempo')
% ylabel('Desplazamiento en x')
% hold on
% desp_x3 = cumtrapz(t3,vel_x3);
% plot (t3,desp_x3, 'DisplayName','M3');
% grid on
% xlabel('Tiempo')
% ylabel('Desplazamiento en x')
% hold on
% desp_x4 = cumtrapz(t4,vel_x4);
% plot (t4,desp_x4, 'DisplayName','M4');
% grid on
% xlabel('Tiempo')
% ylabel('Desplazamiento en x')
% legend
% 
% % Ahora voy a representar los desplazamientos en x, y ,z de la muestra 1 en la
% % misma grafica
% 
% figure
% desp_y1 = cumtrapz(t1,vel_y1);
% desp_z1 = cumtrapz(t1,vel_z1);
% plot(t1,desp_x1, 'Color', 'blue')
% hold on
% plot(t1,desp_y1,'Color', 'red')
% hold on 
% plot (t1,desp_z1,'Color', 'green')
% title ('Desplazamientos en los 3 ejes M1')
% xlabel('Tiempo')
% ylabel('Desplazamiento en x')
% grid on
% legend ('x','y','z')
% 
% 
% %% Coordenada y
% %represento las coordenadas y de las muestras.
% % figure
% %acel_y1 = datos1(:,3);
% % plot (t1, acel_y1, 'DisplayName', 'Muestra 1')
% % title ('Aceleración en y (Pisando Marcas)')
% % %faltan xlim e ylim tb
% % xlabel('Tiempo')
% % ylabel('Aceleración en y')%el titulo de la grafica y de los ejes quiza mejor al final de cada grafica
% % grid on
% % hold on
% % acel_y2 = datos2 (:,3);
% % plot (t2,acel_y2, 'DisplayName', 'Muestra 2')
% % hold on
% % acel_y3 = datos3 (:,3);
% % plot (t3,acel_y3, 'DisplayName', 'Muestra 3')
% % hold on
% % acel_y4 = datos4 (:,3);
% % plot (t4,acel_y4, 'DisplayName', 'Muestra 4')
% % legend
% %  
% 
% 
% %% Coordenada z
% % % represento las coordenadas z de las muestras.
% % figure
% %acel_z1 = datos1 (:,4);
% % plot (t1,acel_z1, 'DisplayName', 'Muestra 1')
% % title ('Aceleración en z (Pisando Marcas)')
% % %xlim ylim
% % xlabel('Tiempo')
% % ylabel('Aceleración en z')
% % grid on
% % hold on
% % acel_z2 = datos2 (:,4);
% % plot (t2,acel_z2, 'DisplayName', 'Muestra 2')
% % hold on
% % acel_z3 = datos3 (:,4);
% % plot (t3,acel_z3, 'DisplayName', 'Muestra 3')
% % hold on
% % acel_z4 = datos4 (:,4);
% % plot (t4,acel_z4, 'DisplayName', 'Muestra 4')
% % legend
% %  
% 
% %% Represento aceleracion en x, y y z en la misma grafica para la m1 por ejemplo
% 
% % plot(t1,acel_x1,acel_y1,acel_z1);
% 
% 
% %% Gráfica representando Vx vs Vy (no se si esto es interesante)
% % Muestra 1
% figure
% plot(vel_x1,vel_y1);
% xlabel('Vx')
% ylabel('Vy')
% title('Vx vs Vy')
% grid on
% 