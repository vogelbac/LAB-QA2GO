%%
%% This function is for calculating the Signal Summary value
%%

function [signal_to_noise_ratio,signal_sum_val,variance_summary_value] = snr_summary_value( use_mask,static_spatial_noise_image,roi,soi,signal_img,remove_time_series,dim4 )


        [row, col] = find(roi(:,:,soi,1)>0);
               
        variance_summary_value = var(reshape(static_spatial_noise_image(min(row):max(row),min(col):max(col)),[],1));
        
        signal_sum_val = mean(reshape(signal_img(min(row):max(row),min(col):max(col)),[],1));
         
        % SNR = (signal summary value)/ sqrt((variance summary value)/198 time points)
        
        signal_to_noise_ratio = (signal_sum_val)/sqrt((variance_summary_value/(dim4-remove_time_series)));
        


end

