%%
% Input:
% file: Dateiname Nifti Format 4D Datensatz
% phantom name: Name der Messung /Name des Phantoms
% phantom year: Jahr in dem das Phantom gemessen wurde
% phantom month: Monat in dem das Phantom gemessen wurde
% phantom day: Tag an dem das Phantom gemessen wurde
% phantom hour / phantom minute: zu welcher Uhrzeit wurde das Phantom gemessen
% helium: Heliumstand zur Zeitpunkt der Messung
% temperature: Temperatur zur Zeitpunkt der Messung
% This function is the main routine to start every single function by the given input.
%%
function start_auswertung(file,phantom_name_in,in_phantom_year,in_phantom_month,in_phantom_day,in_phantom_hour, in_phantom_minute,in_helium,in_temperature)

    addpath(genpath("/home/brain/qa/niak/"));
    savepath();
    rehash ();


    %Automatic    
    phantom_name = phantom_name_in;
    phantom_year = in_phantom_year;
    phantom_month = in_phantom_month;
    phantom_day = in_phantom_day;
    phantom_hour = in_phantom_hour;
    phantom_minute = in_phantom_minute;
    helium = in_helium;
    temperature = in_temperature;
    filename = file ;
    

    [path name ext]=fileparts(filename);
    [hdr,vol]=niak_read_vol(filename);
    
    %vol vorher:
    % (0,0),(0,1),(0,2)
    % (1,0),(1,1),(1,2)
    
    %vol nachher (image)
    % (0,0),(1,0),(2,0)
    % (0,1),(1,1),(2,1)
    image=permute(vol,[2 1 3 4]);
    
    % X Achse
    dim1 = hdr.info.dimensions(1);
    % Y Achse
    dim2 = hdr.info.dimensions(2);
    % Z Achse
    dim3 = hdr.info.dimensions(3);
    % Zeitachse
    dim4 = hdr.info.dimensions(4);
    
    % TR aus dem Header lesen
    tr = hdr.info.tr;
    
    % Grenze für Wahrscheinlichkeitslimit, für spike detection bei FFT
    fft_probability_limit = 1.0;
      
    % Definieren der ROI GrÃ¶ÃŸe (KantenlÃ¤nge)
    roi_length = 15;

    % ROI Größe für Ghosting definieren
    roi_ghost_length = 10;
    % ROI für PSG
    ghost_roi_length = 8; 
    
    % Größen für Colormaps
    % definiert die Range von 0-1500
    % color_min = 0; 
    % color_max = 1500;
    % color_max_temp = 6;
    % color_max_signal_fluct = 300;
    % color_min_static_signal = -250;
    % color_max_static_signal = 250;
    
    
    % Definiert, wie viele Zeitserien zur Auswertung weggeworfen werden.
    if mod(dim4,2) == 0
        remove_time_series = 2;
    else
        remove_time_series = 3;
    end
    
     % SOI bestimmen
    soi = 0;
    % hat das Phantom eine gerade oder ungerade Anzahl an Schichten
    % wenn die Anzahl der Schichten gerade ist
    if mod(dim3,2) == 0
        soi = (dim3/2);
    % wenn die Anzahl der Schichten ungerade ist nach oben aufrunden
    else
        soi = round(dim3/2);
    end
    

    
    % zur Berechnung die Maske verwenden ja (1) oder nein (0)?
    use_mask = 1; % If use_mask==0 then line 101 won't be evaluated and bubble_mask will be the entire image
    bubble_mask = ones(dim1,dim2,dim3,dim4);
    
    if use_mask == 1
    %luftblasenmaske berechnen detektieren
        bubble_mask = detect_bubbles(image,dim1,dim2,dim3,dim4,soi);
    end
    %ROI berechnen
    [ rechteck_roi , bin_mask_phantom ] = calculate_roi(image,dim1,dim2,dim3,dim4,roi_length);
    
   
    f = figure();
    set(f, 'Position', [300,300, 740, 600])
    set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
    set(gcf,'Color','w');
    name = strcat('Bin_mask_pahntom_time_', phantom_name);
    set(f,'Name',name);
    imagesc(sum(bin_mask_phantom(:,:,soi,:),4));
    set(gca, 'CLim', [0, dim4]);
    colorbar
    print(f,name,'-dpng');
    
    f = figure();
    set(f, 'Position', [300,300, 740, 600])
    set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
    set(gcf,'Color','w');
    name = strcat('ROI_mask_pahntom_time_', phantom_name);
    set(f,'Name',name);
    imagesc(sum(rechteck_roi(:,:,soi,:),4));
    set(gca, 'CLim', [0, dim4]);
    colorbar
    print(f,name,'-dpng');
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%
    use_mask = 0;
    %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%
    
    %Signal Image berechnen
    [signal_img] = signal_image(image,use_mask,soi,dim4,remove_time_series,bubble_mask);
    
    %Signal Image ausgeben
    f = figure();
    set(f, 'Position', [300,300, 740, 600])
    set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
    set(gcf,'Color','w');
    name = strcat('Signal_Image_', phantom_name);
    set(f,'Name',name);
    imagesc(signal_img);
    set(gca, 'CLim', [min(signal_img(:)), max(signal_img(:))]); % letting image decide the minimum and maximum 
    colorbar
    print(f,name,'-dpng');
    
    %TemporalFluctuation Noise Image berechnen
    temporal_fluctuation_noise_img = temporal_fluctuation_noise_image(image,use_mask,dim1,dim2,dim4,soi,remove_time_series);
    
    %TemporalFluctuation Noise Image ausgeben
    f = figure();
    set(f, 'Position', [300,300, 740, 600])
    set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
    set(gcf,'Color','w');
    name = strcat('Temporal_Fluctuation_Noise_Image_', phantom_name);
    set(f,'Name',name);
    imagesc(temporal_fluctuation_noise_img);
    set(gca, 'CLim', [0, max(temporal_fluctuation_noise_img(:))]); % letting image decide the maximum 
    colorbar
    print(f,name,'-dpng');
    
    
    f = figure();
    set(f, 'Position', [300,150 , 740, 600])
    set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])   
    set(gcf,'Color','w');
    name = strcat('ROI_', phantom_name);
    set(f,'Name',name);
    imagesc(rechteck_roi(:,:,soi,1)); 
    print(f,name,'-dpng');
    
    %Signal to Fluctuation Noise 
    [sfnr_value,sfnr_img] = signal_to_fluictuation_noise(use_mask, signal_img,temporal_fluctuation_noise_img,rechteck_roi,soi );
     
    f = figure();
    set(f, 'Position', [300,300, 740, 600])
    set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
    set(gcf,'Color','w');
    name = strcat('Signal_To_Fluictuation_Noise_Image_ROI_', phantom_name);
    set(f,'Name',name);
    imagesc(sfnr_img);
    set(gca, 'CLim', [0, max(sfnr_img(:))]); % letting image decide the maximum 
    colorbar

    print(f,name,'-dpng');
    
    
    %Static Spatial Noise
    [ diff_img, intrinsic_noise  ] = static_spatial_noise_image(use_mask, image,soi,remove_time_series,dim4);
    
    f = figure();
    set(f, 'Position', [300,300, 740, 600])
    set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
    set(gcf,'Color','w');
    name = strcat('Static_Spatial_Noise_Image_', phantom_name);
    set(f,'Name',name);
    imagesc(diff_img);
    set(gca, 'CLim', [min(diff_img(:)), max(diff_img(:))]);
    colorbar

    print(f,name,'-dpng');
    
    %Signal to Noise Ratio
    [signal_to_noise_ratio,signal_sum_val,variance_summary_value] = snr_summary_value(use_mask,diff_img,rechteck_roi,soi,signal_img,remove_time_series,dim4);
    
    %percent fluctuation and drift
    [ percent_fluctuation,drift,residuals,drift_intensity ] = percent_fluctuation_drift( use_mask,rechteck_roi,image,soi,phantom_name,dim4,remove_time_series );
    
%     %Fast Fourier analyse
%     %residuals werden vorher bei percent fluctuation berechnet und werden
%     %von dort übernommen
    [spike_array,spike_array_counter] = fast_fourier_analysis( use_mask,residuals,tr,dim4,remove_time_series,phantom_name,fft_probability_limit );
%     
%     %ghosting 

    ghosting = ghosting_detection( use_mask,image,dim1,dim2,soi,dim4,remove_time_series,roi_ghost_length,phantom_name,bin_mask_phantom );

    [mean_psg,psg_signal_image] = psg( bin_mask_phantom,dim1,dim2,dim3,dim4,image,phantom_name,roi_length,remove_time_series,soi,signal_img,ghost_roi_length );
    

%     %percent signal change 
    [ mean_psc, std_psc,max_psc,min_psc] = psc( use_mask,image,dim4,dim3,remove_time_series,dim1,dim2,soi,phantom_name,rechteck_roi);

    
    %%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%
    use_mask = 0;
    %%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%
    
%     
%     %piu
     [ mean_piu_value,min_piu_value,max_piu_value,std_piu_value] = piu(use_mask,image,dim1,dim2,dim4,soi,remove_time_series,phantom_name,bubble_mask );
%     

    use_mask = 1;
    [ mean_piu_value2,min_piu_value2,max_piu_value2,std_piu_value2] = piu(use_mask,image,dim1,dim2,dim4,soi,remove_time_series,phantom_name,bubble_mask );


    %save values & report
    save_values_temp(sfnr_value,intrinsic_noise,signal_to_noise_ratio,signal_sum_val,variance_summary_value,percent_fluctuation,drift,drift_intensity,ghosting,mean_psc, std_psc ,max_psc,min_psc,phantom_year, phantom_month, phantom_day, phantom_hour , phantom_minute,phantom_name,mean_psg,psg_signal_image,mean_piu_value,min_piu_value,max_piu_value,std_piu_value,mean_piu_value2,min_piu_value2,max_piu_value2,std_piu_value2)
    save_report(phantom_year,phantom_month,phantom_day,phantom_hour,phantom_minute,phantom_name,helium,temperature,dim1,dim2,dim3,dim4,tr,soi,remove_time_series,roi_length,roi_ghost_length,filename,spike_array,spike_array_counter)

end
