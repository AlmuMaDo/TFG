function MyApp(promedio_all, samples, promedio_allPatients)

%     %cargar resultados necesarios para plotear en la GUI
%     load('C:\Users\almud\Desktop\GIT\TFG\gyroData\gyroDataNew\Results_TFG.mat');
% Create a figure window
app = uifigure('Name', 'My MATLAB App', 'Position', [100, 100, 800, 400]);

% Create the layout grid with three columns
layout = uigridlayout(app, [1, 3], 'ColumnWidth', {'fit', '1x', '1x'});

% First column:
column1 = uigridlayout(layout, [4, 1]);
titlelabel = uilabel(column1);
titlelabel.Text = 'DATA SELECTION';
titlelabel.FontSize = 12;
titlelabel.FontWeight = 'bold';
titlelabel.HorizontalAlignment = 'center';
column1.RowHeight={'0.2x','1x','1x','1x'};

% Dropdown menu Location
dropdown = uidropdown(column1, 'Items', {'Suprapatellar Area', 'Lateral (External) Collateral Ligament'},...
    'Position', [10, 10, 100, 30]);
dropdown.Layout.Row = 2;
dropdown.Layout.Column = 1;

% Dropdown menu Patient
dropdown1 = uidropdown(column1, 'Items', fieldnames(samples),...
    'Position', [10, 10, 100, 30]);
dropdown1.Layout.Row = 3;
dropdown1.Layout.Column = 1;

% Dropdown menu Variable
dropdown2 = uidropdown(column1, 'Items', {'Gyroscope', 'Euler'},...
    'Position', [10, 10, 100, 30]);
dropdown2.Layout.Row = 4;
dropdown2.Layout.Column = 1;


column2 = uigridlayout(layout, [4, 1]);
titlelabel = uilabel(column2);
titlelabel.Text = 'PATIENT PLOT';
titlelabel.FontSize = 12;
titlelabel.FontWeight = 'bold';
titlelabel.HorizontalAlignment = 'center';
column2.RowHeight={'0.2x','1x','1x','1x'};
axes1 = uiaxes(column2);
axes2 = uiaxes(column2);
axes3 = uiaxes(column2);


% Third column: Three vertically organized plots
column3 = uigridlayout(layout, [4, 1]);
titlelabel = uilabel(column3);
titlelabel.Text = 'COMPARATIVE ANALYSIS';
titlelabel.FontSize = 12;
titlelabel.FontWeight = 'bold';
titlelabel.HorizontalAlignment = 'center';
column3.RowHeight={'0.2x','1x','1x','1x'};
axes4 = uiaxes(column3);
axes5 = uiaxes(column3);
axes6 = uiaxes(column3);



dropdown.ValueChangedFcn = @(src, event) updatePlotsUsersColumn2(src.Value,axes1,axes2,axes3,axes4,axes5,axes6);
dropdown1.ValueChangedFcn = @(src, event) updatePlotsUsersColumn2(src.Value,axes1,axes2,axes3,axes4,axes5,axes6);
dropdown2.ValueChangedFcn = @(src, event) updatePlotsUsersColumn2(src.Value, axes1,axes2,axes3,axes4,axes5,axes6);

    function updatePlotsUsersColumn2(INPUTINUTIL, axes1,axes2,axes3,axes4,axes5,axes6)
        % coger valores de todos los dropdown
        Location_value = dropdown.Value;
        Patient_value = dropdown1.Value;
        Variable_value = dropdown2.Value;

        % detectar nombres de los campos
        Sport = 'Squats';
        if strcmp(Variable_value, 'Gyroscope')
            Angle = 'Gyroscope';
        else
            Angle = 'Euler';
        end
        if strcmp(Location_value, 'Lateral (External) Collateral Ligament')
            Location = 'Lateral';
        else
            Location = 'Delante';
        end

        % Agregar cuadrícula a los plots
        grid(axes1, 'on');
        grid(axes2, 'on');
        grid(axes3, 'on');

        % Update the x-axis data for axes1
        for iSample = 1:numel(fieldnames(samples.(Patient_value).(Sport).(Angle).(Location)))
            newXData = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).time;  % Replace with your new x-axis data
            newYData1 = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).x;  % Replace with your new y-axis data

            % Update the plot in axes1
            %             cla(axes1);  % Clear the existing plot
            plot(axes1, newXData, newYData1);  % Plot the updated data
            xlabel (axes1, 'Time (s)')

            % ylabel según variable
            if strcmp(Variable_value, 'Gyroscope')
                ylabel(axes1,'Angular velocity in x (deg/s)')
            else
                ylabel(axes1,'Angle (°)')
            end

            % title según variable
            if strcmp (Variable_value, 'Gyroscope')
                title_variable = 'Gyroscope';
            else
                title_variable = 'Euler';
            end

            % title según coordenada
            if strcmp(Variable_value, 'Gyroscope')
                titleCoordinate = 'x-coordinate';
            else
                titleCoordinate = 'Pitch';
            end

            % title según localización
            if strcmp(Location_value, 'Lateral (External) Collateral Ligament')
                titleLocation = 'Lateral (External) Collateral Ligament';
            else
                titleLocation = 'Suprapatellar Area';
            end
            title (axes1, strcat([title_variable, ' ', titleCoordinate, ' Squats ' ,  titleLocation, ' Right Knee']))

            newXData_prom = promedio_all.(Patient_value).(Sport).(Angle).(Location).time;
            newYData1_prom = promedio_all.(Patient_value).(Sport).(Angle).(Location).x;
            plot(axes1,newXData_prom, newYData1_prom, 'k-','LineWidth',1.75);
            hold(axes1, "on")


            % % Update the x-axis data for axes2
            newXData = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).time;  % Replace with your new x-axis data
            newYData2 = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).y;  % Replace with your new y-axis data

            % Update the plot in axes1
            %         cla(axes2);  % Clear the existing plot
            plot(axes2, newXData, newYData2);  % Plot the updated data
            xlabel (axes2, 'Time (s)')

            % ylabel según variable
            if strcmp(Variable_value, 'Gyroscope')
                ylabel(axes2,'Angular velocity in y (deg/s)')
            else
                ylabel(axes2,'Angle (°)')
            end
            % title según variable
            if strcmp (Variable_value, 'Gyroscope')
                title_variable = 'Gyroscope';
            else
                title_variable = 'Euler';
            end

            % title según coordenada
            if strcmp(Variable_value, 'Gyroscope')
                titleCoordinate = 'y-coordinate';
            else
                titleCoordinate = 'Roll';
            end

            % title según localización
            if strcmp(Location_value, 'Lateral (External) Collateral Ligament')
                titleLocation = 'Lateral (External) Collateral Ligament';
            else
                titleLocation = 'Suprapatellar Area';
            end
            title (axes2, strcat([title_variable, ' ', titleCoordinate, ' Squats ' ,  titleLocation, ' Right Knee']))

            newXData_prom = promedio_all.(Patient_value).(Sport).(Angle).(Location).time;
            newYData2_prom = promedio_all.(Patient_value).(Sport).(Angle).(Location).y;
            plot(axes2,newXData_prom, newYData2_prom, 'k-','LineWidth',1.75);
            hold(axes2, "on")

            % Plot the data in axes2

            % % Update the x-axis data for axes3
            newXData = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).time;  % Replace with your new x-axis data
            newYData3 = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).z;  % Replace with your new y-axis data

            % Update the plot in axes3
            %         cla(axes3);  % Clear the existing plot
            plot(axes3, newXData, newYData3);  % Plot the updated data
            xlabel (axes3, 'Time (s)')

            % ylabel según variable
            if strcmp(Variable_value, 'Gyroscope')
                ylabel(axes3,'Angular velocity in z (deg/s)')
            else
                ylabel(axes3,'Angle (°)')
            end
            % title según variable
            if strcmp (Variable_value, 'Gyroscope')
                title_variable = 'Gyroscope';
            else
                title_variable = 'Euler';
            end

            % title según coordenada
            if strcmp(Variable_value, 'Gyroscope')
                titleCoordinate = 'z-coordinate';
            else
                titleCoordinate = 'Yaw';
            end

            % title según localización
            if strcmp(Location_value, 'Lateral (External) Collateral Ligament')
                titleLocation = 'Lateral (External) Collateral Ligament';
            else
                titleLocation = 'Suprapatellar Area';
            end
            title (axes3, strcat([title_variable, ' ', titleCoordinate, ' Squats ' ,  titleLocation, ' Right Knee']))

            newXData_prom = promedio_all.(Patient_value).(Sport).(Angle).(Location).time;
            newYData3_prom = promedio_all.(Patient_value).(Sport).(Angle).(Location).x;
            plot(axes3,newXData_prom, newYData3_prom, 'k-','LineWidth',1.75);
            hold(axes3, "on")

        end
        hold (axes1, 'off');
        hold (axes2, 'off');
        hold (axes3, 'off');

        % Para la columna 3

        % Agregar cuadrícula a los plots
        grid(axes4, 'on');
        grid(axes5, 'on');
        grid(axes6, 'on');

            
            % axes4
            newXData_prom = promedio_all.(Patient_value).(Sport).(Angle).(Location).time;
            newYData4_prom = promedio_all.(Patient_value).(Sport).(Angle).(Location).x;

            % para representar la curva ideal encima del promedio. LA CURVA
            % IDEAL NO DEPENDE DE LOS DROPDOWN, ES IGUAL PARA TODOS

            newXData_prom_all = promedio_allPatients.time;
            newYData4_prom_all = promedio_allPatients.x;
            plot(axes4,newXData_prom, newYData4_prom, 'k-','LineWidth',1.75);
            ylim (axes4, [-50 50]);


            threshold_max= 0.8;
            
            % máximos curva promedio de cada persona para x
            [peaks, peakIndices] = findpeaks(newYData4_prom);
            filteredPeaks = peaks(peaks > threshold_max*max(peaks));
            filteredPeakIndices = peakIndices(peaks > threshold_max*max(peaks));
            hold(axes4, "on")
            plot(axes4, newXData_prom(filteredPeakIndices), filteredPeaks, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);

            % mínimos curva promedio de cada persona para x
            threshold_x_min= 0.8;
            [minPeaks, minPeakIndices] = findpeaks(-newYData4_prom);
            minPeaks = -minPeaks;
            filteredPeaks_min = minPeaks(minPeaks < threshold_x_min*min(minPeaks));
            filteredPeakIndices_min = minPeakIndices(minPeaks < threshold_x_min*min(minPeaks));
            hold(axes4, "on")
            plot(axes4, newXData_prom(filteredPeakIndices_min), filteredPeaks_min, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)

            hold(axes4, "on")


            % representación curva ideal
            plot(axes4,newXData_prom_all,newYData4_prom_all,'r-','LineWidth',1.75);
            hold(axes4, "on")

    
            % máximos curva ideal para x
            [peaks1, peakIndices1] = findpeaks(newYData4_prom_all);
            filteredPeaks1 = peaks1(peaks1 > threshold_max*max(peaks1));
            filteredPeakIndices1 = peakIndices1(peaks1 > threshold_max*max(peaks1));
          
            plot(axes4, newXData_prom_all(filteredPeakIndices1), filteredPeaks1, 'gx', 'MarkerSize', 10 ,'LineWidth',1.75);

            % minimos curva ideal para x
            [minPeaks1, minPeakIndices1] = findpeaks(-newYData4_prom_all);
            minPeaks1 = -minPeaks1;
            filteredPeaks_min1 = minPeaks1(minPeaks1 < threshold_x_min*min(minPeaks1));
            filteredPeakIndices_min1 = minPeakIndices1(minPeaks1 < threshold_x_min*min(minPeaks1));
            hold(axes4, "on")
            plot(axes4, newXData_prom_all(filteredPeakIndices_min1), filteredPeaks_min1, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)


            % para ejes y titulos
            xlabel (axes4, 'Time (s)')
            % ylabel según variable
            if strcmp(Variable_value, 'Gyroscope')
                ylabel(axes4,'Angular velocity in x (deg/s)')
            else
                ylabel(axes4,'Angle (°)')
            end

            % title según variable
            if strcmp (Variable_value, 'Gyroscope')
                title_variable = 'Gyroscope';
            else
                title_variable = 'Euler';
            end

            % title según coordenada
            if strcmp(Variable_value, 'Gyroscope')
                titleCoordinate = 'x-coordinate';
            else
                titleCoordinate = 'Pitch';
            end

            % title según localización
            if strcmp(Location_value, 'Lateral (External) Collateral Ligament')
                titleLocation = 'Lateral (External) Collateral Ligament';
            else
                titleLocation = 'Suprapatellar Area';
            end
            title (axes4, strcat([title_variable, ' ', titleCoordinate, ' Squats ' ,  titleLocation, ' Right Knee']))

            % axes5
            newYData5_prom = promedio_all.(Patient_value).(Sport).(Angle).(Location).y;

            plot(axes5,newXData_prom, newYData5_prom, 'k-','LineWidth',1.75);
            
            % máximos curva promedio de cada persona para y
            [peaks2, peakIndices2] = findpeaks(newYData5_prom);
            filteredPeaks2 = peaks2(peaks2 > threshold_max*max(peaks2));
            filteredPeakIndices2 = peakIndices2(peaks2 > threshold_max*max(peaks2));
            hold(axes5, "on")
            plot(axes5, newXData_prom(filteredPeakIndices2), filteredPeaks2, 'bo', 'MarkerSize', 10,'LineWidth',1.75 );


            % mínimos curva promedio de cada persona para y
            threshold_y_min= 0.8;
            [minPeaks2, minPeakIndices2] = findpeaks(-newYData5_prom);
            minPeaks2 = -minPeaks2;
            filteredPeaks_min2 = minPeaks2(minPeaks2 < threshold_y_min*min(minPeaks2));
            filteredPeakIndices_min2 = minPeakIndices2(minPeaks2< threshold_y_min*min(minPeaks2));
            hold(axes5, "on")
            plot(axes5, newXData_prom(filteredPeakIndices_min2), filteredPeaks_min2, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)


            newXData_prom_all = promedio_allPatients.time;
            newYData5_prom_all = promedio_allPatients.y;

            % representacion curva ideal
            plot(axes5,newXData_prom_all,newYData5_prom_all,'r-','LineWidth',1.75);
            hold(axes5, "on")
            ylim (axes5, [-100 100]);

    
            % máximos curva ideal para y
            [peaks3, peakIndices3] = findpeaks(newYData5_prom_all);
            filteredPeaks3 = peaks3(peaks3 > threshold_max*max(peaks3));
            filteredPeakIndices3 = peakIndices3(peaks3 > threshold_max*max(peaks3));
          
            plot(axes5, newXData_prom_all(filteredPeakIndices3), filteredPeaks3, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);

            % minimos curva ideal para y
            [minPeaks3, minPeakIndices3] = findpeaks(-newYData5_prom_all);
            minPeaks3 = -minPeaks3;
            filteredPeaks_min3 = minPeaks3(minPeaks3 < threshold_y_min*min(minPeaks3));
            filteredPeakIndices_min3 = minPeakIndices3(minPeaks3 < threshold_y_min*min(minPeaks3));
            hold(axes5, "on")
            plot(axes5, newXData_prom_all(filteredPeakIndices_min3), filteredPeaks_min3, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)


            % para ejes y titulo
            xlabel (axes5, 'Time (s)')

            % ylabel según variable
            if strcmp(Variable_value, 'Gyroscope')
                ylabel(axes5,'Angular velocity in y (deg/s)')
            else
                ylabel(axes5,'Angle (°)')
            end

            % title según variable
            if strcmp (Variable_value, 'Gyroscope')
                title_variable = 'Gyroscope';
            else
                title_variable = 'Euler';
            end

            % title según coordenada
            if strcmp(Variable_value, 'Gyroscope')
                titleCoordinate = 'y-coordinate';
            else
                titleCoordinate = 'Roll';
            end

            % title según localización
            if strcmp(Location_value, 'Lateral (External) Collateral Ligament')
                titleLocation = 'Lateral (External) Collateral Ligament';
                ylim(axes5, [-30 30])
            else
                titleLocation = 'Suprapatellar Area';
            end
            title (axes5, strcat([title_variable, ' ', titleCoordinate, ' Squats ' ,  titleLocation, ' Right Knee']))


            % axes6
            newYData6_prom = promedio_all.(Patient_value).(Sport).(Angle).(Location).x;
            plot(axes6,newXData_prom, newYData6_prom, 'k-','LineWidth',1.75);
            

            threshold_z = 0.6;

            % máximos curva promedio de cada persona para z
            [peaks4, peakIndices4] = findpeaks(newYData6_prom);
            filteredPeaks4 = peaks4(peaks4 > threshold_z*max(peaks4));
            filteredPeakIndices4 = peakIndices4(peaks4 > threshold_z*max(peaks4));
            hold(axes6, "on")
            plot(axes6, newXData_prom(filteredPeakIndices4), filteredPeaks4, 'bo', 'MarkerSize', 10, 'LineWidth',1.75);
            hold(axes6, "on")


            % mínimos curva promedio de cada persona para z
            threshold_z_min= 0.8;
            [minPeaks4, minPeakIndices4] = findpeaks(-newYData6_prom);
            minPeaks4 = -minPeaks4;
            filteredPeaks_min4 = minPeaks4(minPeaks4 < threshold_z_min*min(minPeaks4));
            filteredPeakIndices_min4 = minPeakIndices4(minPeaks4< threshold_z_min*min(minPeaks4));
            hold(axes6, "on")
            plot(axes6, newXData_prom(filteredPeakIndices_min4), filteredPeaks_min4, 'bo', 'MarkerSize', 10, 'LineWidth',1.75)

            newXData_prom_all = promedio_allPatients.time;
            newYData6_prom_all = promedio_allPatients.z;

            % representacion curva ideal
            plot(axes6,newXData_prom_all,newYData6_prom_all,'r-','LineWidth',1.75);

             % máximos curva ideal para z
            [peaks5, peakIndices5] = findpeaks(newYData6_prom_all);
            filteredPeaks5 = peaks5(peaks5 > threshold_z*max(peaks5));
            filteredPeakIndices5 = peakIndices5(peaks5 > threshold_z*max(peaks5));

            plot(axes6, newXData_prom_all(filteredPeakIndices5), filteredPeaks5, 'gx', 'MarkerSize', 10, 'LineWidth',1.75);
            
            
            % minimos curva ideal para z
            [minPeaks5, minPeakIndices5] = findpeaks(-newYData6_prom_all);
            minPeaks5 = -minPeaks5;
            filteredPeaks_min5 = minPeaks5(minPeaks5 < threshold_z_min*min(minPeaks5));
            filteredPeakIndices_min5 = minPeakIndices5(minPeaks5 < threshold_z_min*min(minPeaks5));
            hold(axes6, "on")
            plot(axes6, newXData_prom_all(filteredPeakIndices_min5), filteredPeaks_min5, 'gx', 'MarkerSize', 10, 'LineWidth',1.75)


            % para ejes y titulo
            ylim (axes6, [-50 50]);
            xlabel (axes6, 'Time (s)')
            % ylabel según variable
            if strcmp(Variable_value, 'Gyroscope')
                ylabel(axes6,'Angular velocity in z (deg/s)')
            else
                ylabel(axes6,'Angle (°)')
            end

            % title según variable
            if strcmp (Variable_value, 'Gyroscope')
                title_variable = 'Gyroscope';
            else
                title_variable = 'Euler';
            end

            % title según coordenada
            if strcmp(Variable_value, 'Gyroscope')
                titleCoordinate = 'z-coordinate';
            else
                titleCoordinate = 'Yaw';
            end

            % title según localización
            if strcmp(Location_value, 'Lateral (External) Collateral Ligament')
                titleLocation = 'Lateral (External) Collateral Ligament';
            else
                titleLocation = 'Suprapatellar Area';
            end
            title (axes6, strcat([title_variable, ' ', titleCoordinate, ' Squats ' ,  titleLocation, ' Right Knee']))

        hold (axes4, 'off');
        hold (axes5, 'off');
        hold (axes6, 'off');

       
    end
end


