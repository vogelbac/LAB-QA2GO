%%
%% This function calculates the singal image by calculating the mean of all time series of the SOI
%%

function [signal_image] = signal_image(image,use_mask,soi,dim4,remove_time_series,bubble_mask)

    % Die Maske wird für die Berechnung verwendet
    if (use_mask ==1)
        temp_image = image.*bubble_mask;
        signal_image = mean(temp_image(:,:,soi,(remove_time_series+1):dim4),4);
       
        %die Maske wird nicht verwendet für die Berechnung
    elseif (use_mask == 0)
        signal_image = mean(image(:,:,soi,(remove_time_series+1):dim4),4);
    end
end

