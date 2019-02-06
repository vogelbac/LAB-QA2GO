%% 
%% This function calculates the fluctuation and the drift of the mean signal of the centerd ROI 
%% First the signal is detrended by a sencond order polynomial and the fitted values were used to calculate the
%% fluctuaion and the drift.
%%

function [ percent_fluctuation,drift,residuals,drift_intensity ] = percent_fluctuation_drift( use_mask,roi,image,soi,phantom_name,dim4,remove_time_series )

       
        roi_intensity = [];
        for t=remove_time_series+1:dim4
            [row, col] = find(roi(:,:,soi,t)>0);
            roi_intensity(end+1) = mean(reshape(image(min(row):max(row),min(col):max(col),soi,t),[],1));
        end
        
        % polyfit der 2ten Ordnung machen
        timeseries = [(remove_time_series+1):dim4];
        p = polyfit(timeseries,roi_intensity,2);
        fitted_values = polyval(p,timeseries);
        
        f = figure();
        set(f, 'Position', [300,150 , 600, 600])
        set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 10 10])   
        set(gcf,'Color','w');
        name = strcat('Fit_ROI_Intensity_', phantom_name);
        set(f,'Name',name);
        plot(timeseries,roi_intensity,'-k',timeseries,fitted_values,'-r');  
        ylim([700 1000]);
        xlim([(remove_time_series+1) dim4-remove_time_series])
	xlabel('Volumes','FontName','Arial','FontSize',10,'FontWeight','Bold');
        ylabel('Intensity','FontName','Arial','FontSize',10,'FontWeight','Bold');
        print(f,name,'-dpng');
        residuals = roi_intensity - fitted_values;

    	pause(5);
    
        f = figure();
        set(f, 'Position', [300,150 , 600, 600])
        set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 10 10])   
        set(gcf,'Color','w');
        name = strcat('Fitted_values_', phantom_name);
        set(f,'Name',name);
        plot(timeseries,residuals,'-k',[remove_time_series+1,dim4-remove_time_series],[0,0],'-r')
        ylim([-10 10])
        xlim([(remove_time_series+1) dim4-remove_time_series])
	xlabel('Volumes','FontName','Arial','FontSize',10,'FontWeight','Bold');
        ylabel('Intensity','FontName','Arial','FontSize',10,'FontWeight','Bold');
        print(f,name,'-dpng');
        
        
        % percent_fluctuation = 100 * (SD residuen / mean signal intensity)
        percent_fluctuation = 100 * (std(residuals)/mean(roi_intensity));

        % drift = ((maxfit - minfit) / mean signal intensity) * 100
        drift = ((fitted_values(end)-fitted_values(1))/mean(roi_intensity))*100;
        drift_intensity = ((max(fitted_values)-min(fitted_values))/mean(roi_intensity))*100;
        
        %individuelle Darstellung der Percent Flutcuation
        ymin = min(roi_intensity) - 3;
        ymax = max(roi_intensity) + 3;
        xmax = dim4-remove_time_series;
        f = figure();
        set(f, 'Position', [300,150 , 600, 600])
        set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 10 10])   
        set(gcf,'Color','w');
        name = strcat('Fit_ROI_Intensity_Zoom_', phantom_name);
        set(f,'Name',name);
        plot(timeseries,roi_intensity,'-k',timeseries,fitted_values,'-r');  
        ylim([ymin ymax])
        xlim([0 xmax])
	xlabel('Volumes','FontName','Arial','FontSize',10,'FontWeight','Bold');
        ylabel('Intensity','FontName','Arial','FontSize',10,'FontWeight','Bold');
        print(f,name,'-dpng');


end

