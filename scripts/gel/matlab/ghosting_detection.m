%%
%% This function detects the mean and max signal to ghosting in frequency and phase encodind direction
%% Therefore the phantom mask is twice dilated to remove the artifacts caused by the edges.
%% A moving ROI in phase and frequence direction is used to detect the intensity and calculate the ghosting level.
%% A ROI is placed in the center of the phantom to calculate then the different signal to ghosting values.
%%

function return_value  = ghosting_detection( use_mask,image,dim1,dim2,soi,dim4,remove_time_series,roi_ghost_length,phantom_name,bin_mask_phantom )


        % Binärbild für jede SOI für jeden Zeitpunkt erzeugen


        for t = remove_time_series+1:dim4
            index_ghost = roi_ghost_length-1;

            %Dilatation mit der folgenden Struktur
            % 0 1 0
            % 1 1 1
            % 0 1 0

            %zweifacher Dilationsschritt
            %zunächst auf dem thershold Bild dann auf dem Durchgelaufenen Bild.
            dilatation_image = zeros(dim1,dim2,1,dim4);
            for x = 2:dim1-1
                for y = 2:dim2-1
                    if bin_mask_phantom(x,y-1,soi,t) == 1 || bin_mask_phantom(x-1,y,soi,t) == 1 || bin_mask_phantom(x,y,soi,t) == 1 || bin_mask_phantom(x+1,y,soi,t) == 1 || bin_mask_phantom(x,y+1,soi,t) == 1
                        dilatation_image(x,y,1,t) = 1;
                    end
                end
            end

            dilatation_image2 = zeros(dim1,dim2,1,dim4);
            for x = 2:dim1-1
                for y = 2:dim2-1
                    if dilatation_image(x,y-1,1,t) == 1 || dilatation_image(x-1,y,1,t) == 1 || dilatation_image(x,y,1,t) == 1 || dilatation_image(x+1,y,1,t) == 1 || dilatation_image(x,y+1,1,t) == 1
                        dilatation_image2(x,y,1,t) = 1;
                    end
                end
            end
            
            % Bild in 2 Bereiche einteilen: Oben und unten vom Phantom
            % rechts und links vom Phantom

            %Kanten vom Phantom detektiern
            [row, col] = find(dilatation_image2(:,:,1,t)>0);

            phantom_oben = min(row);
            phantom_unten = max(row);
            phantom_links = min(col);
            phantom_rechts = max(col);

            non_ghost_mean = 0;
            non_ghost_x_start = 0;
            non_ghost_x_end = 0;
            non_ghost_y_start = 0;
            non_ghost_y_end = 0;
           

            
            temp_mean_ghost_freq = 0;
            temp_mean_ghost_freq_counter = 0;
            

            %in Frequenzkodierrichtung (rechts und links ist das Ghosting)
            for x = 1:dim1-roi_ghost_length
                for y = 1:dim2-roi_ghost_length
                    x_max = x+index_ghost;
                    y_max = y+index_ghost;
                    temp_mean = 0;
                    %liegt man links oder rechts vom Phantom
                    if (y_max < phantom_links-1 || y >phantom_rechts+1)
                        %liegen wirklich alle Punkte außerhalb des Phantoms
                        if( length(find(dilatation_image2(x:x_max,y:y_max,1,t) == 0)) == 100  )
                           temp_mean = mean(reshape(image(x:x_max,y:y_max,soi,t),[],1));
                        end
                        % speichere den neuen Wert ab
                        % maximaler ghost bestimmen
                        if temp_mean > non_ghost_mean
                            non_ghost_mean = temp_mean;
                            non_ghost_x_start = x;
                            non_ghost_x_end = x_max;
                            non_ghost_y_start = y;
                            non_ghost_y_end = y_max;
                        end
                        % alle means des Phantoms aufsummieren
                        temp_mean_ghost_freq = temp_mean_ghost_freq + temp_mean;
                        temp_mean_ghost_freq_counter = temp_mean_ghost_freq_counter +1;
                    end
                end
            end

            %mean ghost für zeitpunkt berechnen
            mean_ghost_freq = temp_mean_ghost_freq / temp_mean_ghost_freq_counter;


            ghost_mean = 0;
            ghost_x_start = 0;
            ghost_x_end = 0;
            ghost_y_start = 0;
            ghost_y_end = 0;
            temp_mean_ghost_phase = 0;
            temp_mean_ghost_phase_counter = 0;
            %in Phasenkodierrichtung (oben und unten ist das Ghosting)
            for x = 1:dim1-roi_ghost_length
                for y = 1:dim2-roi_ghost_length
                    x_max = x+index_ghost;
                    y_max = y+index_ghost;
                    temp_mean = 0;
                    %liegt man oberhalb oder unterhalb vom Phantom
                    if (x_max < phantom_oben-1 || x >phantom_unten+1)
                        %liegen wirklich alle Punkte außerhalb des Phantoms
                        if( length(find(dilatation_image2(x:x_max,y:y_max,1,t) == 0)) == 100  )
                            temp_mean = mean(reshape(image(x:x_max,y:y_max,soi,t),[],1));
                        end
                        % speichere den neuen Wert ab
                        % max ghost bestimmen
                        if temp_mean > ghost_mean
                            ghost_mean = temp_mean;
                            ghost_x_start = x;
                            ghost_x_end = x_max;
                            ghost_y_start = y;
                            ghost_y_end = y_max;
                        end
                        %werte für mean aufsummieren
                        temp_mean_ghost_phase = temp_mean_ghost_phase + temp_mean;
                        temp_mean_ghost_phase_counter = temp_mean_ghost_phase_counter +1;
                    end

                end
            end

            % mean ghost berechnen
            mean_ghost_phase = temp_mean_ghost_phase / temp_mean_ghost_phase_counter;

            % 10x10 roi im Phantom berechnen % Werte finden die > 0 sind
            %in Y Richtung (oben / unten)
            if mod(((phantom_unten - phantom_oben)/2),1) == 0
                if mod((roi_ghost_length/2),1) == 0
                    %Fall 3: ROI Länge gerade und Phantombreite ungerade
                    ghost_phantom_roi_y_start = (phantom_oben + ((phantom_unten - phantom_oben)/2)) - floor(roi_ghost_length/2) ;
                    ghost_phantom_roi_y_ende = (phantom_oben + ((phantom_unten - phantom_oben)/2)) + floor(roi_ghost_length/2) - 1;
                else
                    %Fall 4: ROI Länge ungerade und Phantombreite ungerade
                    ghost_phantom_roi_y_start = (phantom_oben + ((phantom_unten - phantom_oben)/2)) - floor(roi_ghost_length/2);
                    ghost_phantom_roi_y_ende = (phantom_oben + ((phantom_unten - phantom_oben)/2)) + floor(roi_ghost_length/2);
                end
            else
                if mod((roi_ghost_length/2),1) == 0
                    %Fall 1: ROI Länge gerade und Phantombreite gerade
                    ghost_phantom_roi_y_start = (phantom_oben + (((phantom_unten - phantom_oben)+1)/2)) - (roi_ghost_length/2);
                    ghost_phantom_roi_y_ende = (phantom_oben + (((phantom_unten - phantom_oben)+1)/2)) + (roi_ghost_length/2) - 1;
                else
                    %Fall 2: ROI Länge ungerade und Phantombreite gerade
                    ghost_phantom_roi_y_start = (phantom_oben + (((phantom_unten - phantom_oben)+1)/2)) - floor(roi_ghost_length/2) - 1;
                    ghost_phantom_roi_y_ende = (phantom_oben + (((phantom_unten - phantom_oben)+1)/2)) + floor(roi_ghost_length/2) - 1;
                end
            end

            %in X Richtung (rechts/ links)
            if mod(((phantom_rechts - phantom_links)/2),1) == 0
                if mod((roi_ghost_length/2),1) == 0
                    %Fall 3: ROI Länge gerade und Phantombreite ungerade
                    ghost_phantom_roi_x_start = (phantom_links + ((phantom_rechts - phantom_links)/2)) - floor(roi_ghost_length/2); 
                    ghost_phantom_roi_x_ende = (phantom_links + ((phantom_rechts - phantom_links)/2)) + floor(roi_ghost_length/2) - 1;
                else
                    %Fall 4: ROI Länge ungerade und Phantombreite ungerade
                    ghost_phantom_roi_x_start = (phantom_links + ((phantom_rechts - phantom_links)/2)) - floor(roi_ghost_length/2);
                    ghost_phantom_roi_x_ende = (phantom_links + ((phantom_rechts - phantom_links)/2)) + floor(roi_ghost_length/2);
                end
            else
                if mod((roi_ghost_length/2),1) == 0
                    %Fall 1: ROI Länge gerade und Phantombreite gerade
                    ghost_phantom_roi_x_start = (phantom_links + (((phantom_rechts - phantom_links)+1)/2)) - (roi_ghost_length/2);
                    ghost_phantom_roi_x_ende = (phantom_links + (((phantom_rechts - phantom_links)+1)/2)) + (roi_ghost_length/2) - 1;
                else
                    %Fall 2: ROI Länge ungerade und Phantombreite gerade
                    ghost_phantom_roi_x_start = (phantom_links + (((phantom_rechts - phantom_links)+1)/2)) - floor(roi_ghost_length/2) - 1;
                    ghost_phantom_roi_x_ende = (phantom_links + (((phantom_rechts - phantom_links)+1)/2)) + floor(roi_ghost_length/2) - 1;
                end
            end


            ghost_phantom_mean = mean(reshape(image(ghost_phantom_roi_x_start:ghost_phantom_roi_x_ende,ghost_phantom_roi_y_start:ghost_phantom_roi_y_start,soi,t),[],1));

            
            % Signal zu maximum ghost ratio in Frequenz richtung
            signal_to_max_ghost_ratio_freq = ghost_phantom_mean / non_ghost_mean ;
            signal_to_max_ghost_ratio_freq_array(t-remove_time_series) = signal_to_max_ghost_ratio_freq;

            % Signal zu maximum ghost ratio in Phasen richtung
            signal_to_max_ghost_ratio_phase = ghost_phantom_mean / ghost_mean ;
            signal_to_max_ghost_ratio_phase_array(t-remove_time_series) = signal_to_max_ghost_ratio_phase;

            % Signal zu mean ghost ratio in Frequenz richtung
            signal_to_mean_ghost_ratio_freq = ghost_phantom_mean / mean_ghost_freq ;
            signal_to_mean_ghost_ratio_freq_array(t-remove_time_series) = signal_to_mean_ghost_ratio_freq;

             % Signal zu mean ghost ratio in Frequenz richtung
            signal_to_mean_ghost_ratio_phase = ghost_phantom_mean / mean_ghost_phase ;
            signal_to_mean_ghost_ratio_phase_array(t-remove_time_series) = signal_to_mean_ghost_ratio_phase;

        end

        %plot timeline
        timeseries = [(remove_time_series+1):dim4];

      
        f = figure();
        set(f, 'Position', [300,600, 740, 600])
        set(gcf,'PaperUnits','centimeters','PaperPosition',[3 6 12.8 10])
        set(gcf,'Color','w');
        name = strcat('Ghosting_', phantom_name);
        set(f,'Name',name);
        plot(timeseries,signal_to_max_ghost_ratio_freq_array,'-r',timeseries,signal_to_max_ghost_ratio_phase_array,'-g',timeseries,signal_to_mean_ghost_ratio_freq_array,'-y',timeseries,signal_to_mean_ghost_ratio_phase_array,'-b');
        legend('sig-max-freq','sig-max-phase','sig-mean-freq','sig-mean-phase','Location','northoutside')
        legend('boxoff')
	xlabel('Volumes','FontName','Arial','FontSize',10,'FontWeight','Bold');
        ylabel('Ghosting','FontName','Arial','FontSize',10,'FontWeight','Bold');
        xlim([0 (dim4-remove_time_series)])
        print(f,name,'-dpng');

        % mean, min , max, sd für alle Arrays
        mean_sig_max_freq = mean(signal_to_max_ghost_ratio_freq_array);
        min_sig_max_freq = min(signal_to_max_ghost_ratio_freq_array);
        max_sig_max_freq = max(signal_to_max_ghost_ratio_freq_array);
        std_sig_max_freq = std(signal_to_max_ghost_ratio_freq_array);

        % mean, min , max, sd für alle Arrays
        mean_sig_max_phase = mean(signal_to_max_ghost_ratio_phase_array);
        min_sig_max_phase = min(signal_to_max_ghost_ratio_phase_array);
        max_sig_max_phase = max(signal_to_max_ghost_ratio_phase_array);
        std_sig_max_phase = std(signal_to_max_ghost_ratio_phase_array);

        % mean, min , max, sd für alle Arrays
        mean_sig_mean_freq = mean(signal_to_mean_ghost_ratio_freq_array);
        min_sig_mean_freq = min(signal_to_mean_ghost_ratio_freq_array);
        max_sig_mean_freq = max(signal_to_mean_ghost_ratio_freq_array);
        std_sig_mean_freq = std(signal_to_mean_ghost_ratio_freq_array);

        % mean, min , max, sd für alle Arrays
        mean_sig_mean_phase = mean(signal_to_mean_ghost_ratio_phase_array);
        min_sig_mean_phase = min(signal_to_mean_ghost_ratio_phase_array);
        max_sig_mean_phase = max(signal_to_mean_ghost_ratio_phase_array);
        std_sig_mean_phase = std(signal_to_mean_ghost_ratio_phase_array);

        return_value = [mean_sig_max_freq,min_sig_max_freq,max_sig_max_freq,std_sig_max_freq,mean_sig_max_phase,min_sig_max_phase,max_sig_max_phase,std_sig_max_phase,mean_sig_mean_freq,min_sig_mean_freq,max_sig_mean_freq,std_sig_mean_freq,mean_sig_mean_phase,min_sig_mean_phase,max_sig_mean_phase,std_sig_mean_phase];

        

end

