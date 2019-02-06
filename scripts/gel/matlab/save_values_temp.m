%%
%% This function saves all calculated values into a file.
%% 



function save_values_temp(sfnr_value,intrinsic_noise,signal_to_noise_ratio,signal_sum_val,variance_summary_value,percent_fluctuation,drift,drift_intensity,ghosting,mean_psc, std_psc ,max_psc,min_psc,phantom_year, phantom_month, phantom_day, phantom_hour , phantom_minute,phantom_name,mean_psg,psg_signal_image,mean_piu_value,min_piu_value,max_piu_value,std_piu_value,mean_piu_value2,min_piu_value2,max_piu_value2,std_piu_value2)

    
    phantom = strcat(phantom_year,'_',phantom_month,'_',phantom_day,'_',phantom_hour,'_',phantom_minute,'_',phantom_name);
    
    name = strcat('values_',phantom_name);
    fullname = strcat(name,'.txt');
    fid = fopen(fullname, 'w');
    % Name des Phantoms
    fprintf(fid, '%s\t', phantom);
    % SNR Value
    fprintf(fid, '%.4f\t', signal_to_noise_ratio);
    fprintf(fid, '%.4f\t', signal_sum_val);
    fprintf(fid, '%.4f\t', variance_summary_value);
    %intrinsic noise. Variance in diff image
    fprintf(fid, '%.4f\t',  intrinsic_noise);   
    % SFNR Value
    fprintf(fid, '%.4f\t', sfnr_value);
    % Standard deviation of residuals

    % percent flucutation (trend removed)
    fprintf(fid, '%.4f\t', percent_fluctuation);
    % drift
    fprintf(fid, '%.4f\t', drift);
    fprintf(fid, '%.4f\t', drift_intensity);
    %Ghosting
    fprintf(fid, '%.4f\t', ghosting(1));
    fprintf(fid, '%.4f\t', ghosting(2));
    fprintf(fid, '%.4f\t', ghosting(3));
    fprintf(fid, '%.4f\t', ghosting(4));
    
    fprintf(fid, '%.4f\t', ghosting(5));
    fprintf(fid, '%.4f\t', ghosting(6));
    fprintf(fid, '%.4f\t', ghosting(7));
    fprintf(fid, '%.4f\t', ghosting(8));
    
    fprintf(fid, '%.4f\t', ghosting(9));
    fprintf(fid, '%.4f\t', ghosting(10));
    fprintf(fid, '%.4f\t', ghosting(11));
    fprintf(fid, '%.4f\t', ghosting(12));
    
    fprintf(fid, '%.4f\t', ghosting(13));
    fprintf(fid, '%.4f\t', ghosting(14));
    fprintf(fid, '%.4f\t', ghosting(15));
    fprintf(fid, '%.4f\t', ghosting(16));
    
    % psc
    fprintf(fid, '%.4f\t',  mean_psc);      
    fprintf(fid, '%.4f\t',  std_psc);  
    fprintf(fid, '%.4f\t',  max_psc); 
    fprintf(fid, '%.4f\t',  min_psc); 
    
    %PSG
    %1. volume
    %2.signal image
    fprintf(fid, '%.4f\t',  mean_psg);
    fprintf(fid, '%.4f\t',  psg_signal_image);
    
        %PIU
    fprintf(fid, '%.4f\t', mean_piu_value);
    fprintf(fid, '%.4f\t', min_piu_value);
    fprintf(fid, '%.4f\t', max_piu_value);
    fprintf(fid, '%.4f\t', std_piu_value);
    
    %mit maske
    fprintf(fid, '%.4f\t', mean_piu_value2);
    fprintf(fid, '%.4f\t', min_piu_value2);
    fprintf(fid, '%.4f\t', max_piu_value2);
    fprintf(fid, '%.4f\t', std_piu_value2);
    
    % Datei schliessen
    fclose(fid);

end

