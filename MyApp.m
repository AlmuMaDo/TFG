function MyApp(promedio_all, samples)

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

    % Set up the app callbacks
%     dropdown.ValueChangedFcn = @(src, event) updatePlots(src.Value, axes1, axes2, axes3, axes4, axes5, axes6);
%     dropdown.ValueChangedFcn = @(src, event) updatePlotsUsers(src.Value, axes1,axes2,axes3);
%     dropdown1.ValueChangedFcn = @(src, event) updatePlotsUsers(src.Value, axes1,axes2,axes3);
%     dropdown2.ValueChangedFcn = @(src, event) updatePlotsUsers(src.Value, axes1,axes2,axes3);

    dropdown.ValueChangedFcn = @(src, event) updatePlotsUsers(src.Value,axes1,axes2,axes3);
    dropdown1.ValueChangedFcn = @(src, event) updatePlotsUsers(src.Value,axes1,axes2,axes3);
    dropdown2.ValueChangedFcn = @(src, event) updatePlotsUsers(src.Value, axes1,axes2,axes3);

    function updatePlotsUsers(INPUTINUTIL, axes1,axes2,axes3 )
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
        
        % AÑADIR EL RESTO DE IFS PARA SACAR LOS NOMBRES DE LOS CAMPOS
        % Agregar cuadrícula a los plots
        grid(axes1, 'on');
        grid(axes2, 'on');
        grid(axes3, 'on');
        % % Update the x-axis data for axes1
        for iSample = 1:numel(fieldnames(samples.(Patient_value).(Sport).(Angle).(Location)))
            newXData = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).time;  % Replace with your new x-axis data
            newYData1 = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).x;  % Replace with your new y-axis data
            
            % Update the plot in axes1
%             cla(axes1);  % Clear the existing plot
            plot(axes1, newXData, newYData1);  % Plot the updated data
            hold(axes1, "on")
            
        
        % % Update the x-axis data for axes2
        newXData = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).time;  % Replace with your new x-axis data
        newYData2 = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).y;  % Replace with your new y-axis data

        % Update the plot in axes1
%         cla(axes2);  % Clear the existing plot
        plot(axes2, newXData, newYData2);  % Plot the updated data
        hold(axes2, "on")

        % Plot the data in axes2

        % % Update the x-axis data for axes3
        newXData = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).time;  % Replace with your new x-axis data
        newYData3 = samples.(Patient_value).(Sport).(Angle).(Location).(['Sample_',num2str(iSample)]).z;  % Replace with your new y-axis data

        % Update the plot in axes3
%         cla(axes3);  % Clear the existing plot
        plot(axes3, newXData, newYData3);  % Plot the updated data
        hold(axes3, "on")

        end 
        hold (axes1, 'off');
        hold (axes2, 'off');
        hold (axes3, 'off');
    end
   
end

