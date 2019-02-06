%%
%% This function calculates the PIU. First an erosion is performed twice.
%% Then in the image the minimum and maximum is searched for a 9th neiborhood.
%% By using the air-bubble-mask the non homogenous values are excluded for the search.
%% 

function  [ mean_piu_value,min_piu_value,max_piu_value,std_piu_value] = piu(use_mask,image,dim1,dim2,dim4,soi,remove_time_series,phantom_name,bubble_mask )


        % Binärbild für jede SOI für jeden Zeitpunkt erzeugen
        temp_binary_mask(:,:,:) = zeros(dim1,dim2,dim4);
        for t = 1:dim4
            temp_binary_mask(:,:,t) = otsu(image(:,:,soi,t),2);
        end

        binary_mask(:,:,:) = zeros(dim1,dim2,dim4);
        binary_mask(temp_binary_mask(:,:,:) >= 2) = 1;

        bin_mask_2 = binary_mask;

        %Löcher stopfen in der Maske
        for t=1:dim4
            %Kanten detektieren
            for x= 1:dim1
                [row, col] = find(binary_mask(x,:,t)>0);
                start = min(col);
                ende = max(col);
                bin_mask_2(x,start:ende,t) = 1;
            end
        end

         %Erosion mit der folgenden Struktur
            % 0 1 0
            % 1 1 1
            % 0 1 0

        %einfacher Erosion
        temp_erosion_image = zeros(dim1,dim2,dim4);
        for t=1:dim4
            for x = 2:dim1-1
                for y = 2:dim2-1
                    if bin_mask_2(x,y-1,t) == 1 && bin_mask_2(x-1,y,t) == 1 && bin_mask_2(x,y,t) == 1 && bin_mask_2(x+1,y,t) == 1 && bin_mask_2(x,y+1,t) == 1
                        temp_erosion_image(x,y,t) = 1;
                    end
                end
            end
        end

        %zweifache Erosion
        erosion_image = zeros(dim1,dim2,dim4);
        for t=1:dim4
            for x = 2:dim1-1
                for y = 2:dim2-1
                    if temp_erosion_image(x,y-1,t) == 1 && temp_erosion_image(x-1,y,t) == 1 && temp_erosion_image(x,y,t) == 1 && temp_erosion_image(x+1,y,t) == 1 && temp_erosion_image(x,y+1,t) == 1
                        erosion_image(x,y,t) = 1;
                    end
                end
            end
        end

        % Intensitätsbild definieren
        intensity_img = zeros(dim1,dim2,dim4);
        
        
        %Maske verwenden
        if use_mask == 1
        %nur phantom innere
        %phantommaske + %bubble mask miteinander multiplizieren
            for t=1:dim4
                intensity_img(:,:,t) = erosion_image(:,:,t).*image(:,:,soi,t).*bubble_mask(:,:,soi,t);
                if t ==1
                        f = figure();
                        set(f, 'Position', [300,150 , 640, 600])
                        set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 10.4 10])
                        set(gcf,'Color','w');
                        temp_name = 'erosion_';
                        name = strcat(temp_name, phantom_name);
                        set(f,'Name',name);
                        imagesc(erosion_image(:,:,soi,t));
                        colorbar   
                        print(f,name,'-dpng')
    
                        f = figure();
                        set(f, 'Position', [300,150 , 640, 600])
                        set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 10.4 10])
                        set(gcf,'Color','w');
                        temp_name = 'image_';
                        name = strcat(temp_name, phantom_name);
                        set(f,'Name',name);
                        imagesc(image(:,:,soi,t));
                        colorbar    
                        print(f,name,'-dpng')

                        f = figure();
                        set(f, 'Position', [300,150 , 640, 600])
                        set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 10.4 10])
                        set(gcf,'Color','w');
                        temp_name = 'bubblemask_';
                        name = strcat(temp_name, phantom_name);
                        set(f,'Name',name);
                        imagesc(bubble_mask(:,:,soi,t));
                        colorbar   
                        print(f,name,'-dpng')
                end
            end
        
        elseif use_mask == 0
            for t=1:dim4
                intensity_img(:,:,t) = erosion_image(:,:,t).*image(:,:,soi,t);
            end
        end
                f = figure();
                set(f, 'Position', [300,300, 740, 600])
                set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
                set(gcf,'Color','w');
                if use_mask == 1
                    name = strcat('PIU_intensity_mask_', phantom_name);
                else
                    name = strcat('PIU_intensity_', phantom_name);
                end
                set(f,'Name',name);
                imagesc(intensity_img(:,:,1));
                set(gca, 'CLim', [0, 1000]);
                colorbar
                print(f,name,'-dpng');


        % Moving ROI Form Definieren
            % 1 1 1
            % 1 1 1
            % 1 1 1

        % minimum und maxiumum suchen


        for t=remove_time_series+1:dim4
            min_x = 0;
            min_y = 0;
            min_mean = 5000;

            max_x = 0;
            max_y = 0;
            max_mean = 0;
            for x = 2:dim1-1
                for y = 2:dim2-1
                    % 9er nachbarschaft
                    %1,-1 | 1,0 | 1,1
                    %0,-1 | 0,0 | 0,1
                    %-1,-1| -1,0| -1,2
                    if intensity_img(x+1,y-1,t-remove_time_series) >0 && intensity_img(x+1,y,t-remove_time_series) > 0 && intensity_img(x+1,y+1,t-remove_time_series) > 0 && intensity_img(x,y-1,t-remove_time_series) > 0 && intensity_img(x,y,t-remove_time_series) > 0 && intensity_img(x,y+1,t-remove_time_series) > 0 && intensity_img(x-1,y-1,t-remove_time_series) > 0 && intensity_img(x-1,y,t-remove_time_series) > 0 && intensity_img(x-1,y+1,t-remove_time_series) > 0
                        temp_values = [intensity_img(x+1,y-1,t-remove_time_series), intensity_img(x+1,y,t-remove_time_series), intensity_img(x+1,y+1,t-remove_time_series), intensity_img(x,y-1,t-remove_time_series), intensity_img(x,y,t-remove_time_series), intensity_img(x,y+1,t-remove_time_series),intensity_img(x-1,y-1,t-remove_time_series),intensity_img(x-1,y,t-remove_time_series),intensity_img(x-1,y+1,t-remove_time_series)];
                        temp_mean = mean(temp_values);

                        if temp_mean < min_mean
                            min_mean = temp_mean;
                            min_x = x;
                            min_y = y;
                        end

                        if temp_mean > max_mean
                            max_mean = temp_mean;
                            max_x = x;
                            max_y = y;
                        end
                    end
                end
            end
            min_x_time(t-remove_time_series) = min_x;
            min_y_time(t-remove_time_series) = min_y;
            min_mean_time(t-remove_time_series) = min_mean;

            max_x_time(t-remove_time_series) = max_x;
            max_y_time(t-remove_time_series) = max_y;
            max_mean_time(t-remove_time_series) = max_mean;

            piu_value(t-remove_time_series) = 100 * (1 - ( (max_mean - min_mean)/(max_mean + min_mean) ) );
        end        

                timeseries = [1:(dim4-remove_time_series)];
                f = figure();
                set(f, 'Position', [300,600, 740, 600])
                set(gcf,'PaperUnits','centimeters','PaperPosition',[3 6 12.8 10])
                set(gcf,'Color','w');
                 if use_mask == 1
                    name = strcat('PIU_mask_', phantom_name);
                else
                    name = strcat('PIU_', phantom_name);
                end
                
                set(f,'Name',name);
                plot(timeseries, piu_value,'-r');
                xlim([0 (dim4-remove_time_series)])
                ylim([50 150])
		xlabel('Volumes','FontName','Arial','FontSize',10,'FontWeight','Bold');
		ylabel('PIU value','FontName','Arial','FontSize',10,'FontWeight','Bold');
                print(f,name,'-dpng');


                f = figure();
                set(f, 'Position', [300,300, 740, 600])
                set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
                set(gcf,'Color','w');
                if use_mask == 1
                    name = strcat('PIU_intensity_Roi_mask_', phantom_name);
                else
                    name = strcat('PIU_intensity_Roi_', phantom_name);
                end
                
                set(f,'Name',name);
                imagesc(intensity_img(:,:,1+remove_time_series));
                colorbar
                hold on
                %originalpunkt minimum
                p=patch([min_y_time(1)-1.5 min_y_time(1)-1.5 min_y_time(1)+1.5 min_y_time(1)+1.5],[min_x_time(1)-1.5 min_x_time(1)+1.5 min_x_time(1)+1.5 min_x_time(1)-1.5],'w');
                set(p,'FaceAlpha',0.5); 

                %originalpunkt max
                pm=patch([max_y_time(1)-1.5 max_y_time(1)-1.5 max_y_time(1)+1.5 max_y_time(1)+1.5],[max_x_time(1)-1.5 max_x_time(1)+1.5 max_x_time(1)+1.5 max_x_time(1)-1.5],'w');
                set(pm,'FaceAlpha',0.5); 


                hold off
                set(gca, 'CLim', [0, 1000]);
                print(f,name,'-dpng');

                mean_piu_value = mean(piu_value);
                min_piu_value = min(piu_value);
                max_piu_value = max(piu_value);
                std_piu_value = std(piu_value);
                
end
