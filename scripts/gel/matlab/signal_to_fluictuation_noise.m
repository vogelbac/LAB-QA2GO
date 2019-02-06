%%
%% This function ist to calculate the SFNR value
%%

function [sfnr_value,sfnr_image] = signal_to_fluictuation_noise(use_mask, signal_img,temporal_fluctuation_noise_img,roi,soi )


        sfnr_image = signal_img./temporal_fluctuation_noise_img;
        
        [row, col] = find(roi(:,:,soi,1)>0);
        
        sfnr_value = mean(reshape(sfnr_image(min(row):max(row),min(col):max(col)),[],1));


end

