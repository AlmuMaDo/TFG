% %minerva
% % Leer el archivo CSV
% datosR1 = readmatrix('minervaregistro1_Sensor Viejo2_2023-05-31T12.29.37.734_CCA00625B61F_Gyroscope_100.000Hz_1.3.6.csv');
% 
% % Extraer las columnas de interés
% dataMinerva.time = datosR1(:, 3);
% dataMinerva.x = datosR1(:, 4);
% dataMinerva.y = datosR1(:,5);
% dataMinerva.z = datosR1(:,6);
% 
% 
% % definir el rango deseado en el eje x
% rango_time_inicio = 21.93;
% rango_time_fin = 24.93;
% 
% 
% % fragmentar el trozo deseado basado en el rango en el eje x
% indices = (dataMinerva.time>= rango_time_inicio) & (dataMinerva.time<= rango_time_fin);
% dataMinerva.time = dataMinerva.time(indices);
% dataMinerva.x = dataMinerva.x(indices);
% dataMinerva.y = dataMinerva.y(indices);
% dataMinerva.z= dataMinerva.z(indices);
% dataMinerva_norm = NormalizarFunctionCompareMinerva(dataMinerva,0,100);
% 
% 
% 
% %aislo la curva ideal
% % definir el rango deseado en el eje x
% rango_time_inicio_ideal = 15.54;
% rango_time_fin_ideal = 25.5241;
% 
% 
% % fragmentar el trozo deseado basado en el rango en el eje x
% indices_ideal = (promedio_allPatients.time>= rango_time_inicio_ideal) & (promedio_allPatients.time<= rango_time_fin_ideal);
% promedio_allPatients.time = promedio_allPatients.time(indices_ideal);
% promedio_allPatients.x = promedio_allPatients.x(indices_ideal);
% promedio_allPatients.y = promedio_allPatients.y(indices_ideal);
% promedio_allPatients.z = promedio_allPatients.z(indices_ideal);
% %porque promedio_allPatients es un struct 
% promedio_allPatients_norm = NormalizarFunctionCompareICurve(promedio_allPatients, 0, 100);
% 
% 
% grid on
% % graficar el trozo fragmentado de minerva
% figure
% subplot(3,1,1)
% plot(dataMinerva_norm.time, dataMinerva_norm.x)
% threshold_max= 0.8;
% 
% % máximos curva promedio de minerva
% [peaksMinerva, peakIndicesMinerva] = findpeaks(dataMinerva_norm.x);
% filteredPeaksMinerva = peaksMinerva(peaksMinerva > threshold_max*max(peaksMinerva));
% filteredPeakIndicesMinerva = peakIndicesMinerva(peaksMinerva > threshold_max*max(peaksMinerva));
% hold on
% plot(dataMinerva_norm.x(filteredPeakIndicesMinerva), filteredPeaksMinerva, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
% 
% grid on
% hold on
% plot (promedio_allPatients_norm.time,promedio_allPatients_norm.x)
% title ('comparativa en x minerva')
% 
%  
% subplot(3,1,2)
% plot(dataMinerva_norm.time, dataMinerva_norm.y)
% grid on
% hold on
% plot(promedio_allPatients_norm.time, promedio_allPatients_norm.y)
% title ('comparativa en y minerva')
% 
% subplot(3,1,3)
% plot(dataMinerva_norm.time, dataMinerva_norm.z)
% grid on
% hold on
% plot(promedio_allPatients_norm.time,promedio_allPatients_norm.z)
% title ('comparativa en z minerva')