%%
%% This function calculates tht themporal fluctuation noise image
%%

function std_image = temporal_fluctuation_noise_image(image,use_mask,dim1,dim2,dim4,soi,remove_time_series)

        std_image = zeros(dim1,dim2);
        % Zeitserie
        t = [remove_time_series+1:dim4];
        % polyfit 2 ordnung
        for x = 1:dim1
            for y = 1:dim2
                    Values = [];
                    %polyfit voxel-by-voxel
                    % Intensitätswerte ab remove_time_series bestimmen
                    %for i = remove_time_series+1:dim4
                    %    Values(end+1) = image(x,y,soi,i);
                    %end
                    %Values
                    %alternativ:
                    Values = reshape(image(x,y,soi,remove_time_series+1:dim4),1,[]);
                    % Polyfit der 2ten Ordnung
                    p = polyfit(t,Values,2);
                    % Polval sind die gefitteten Werte 
                    fitted_values = polyval(p,t);
                    % differenz zwischen fitted_values und Intensitätswert
                    % bekommen
                    residuals = Values-fitted_values;
                    
                    % Standardabweichung
                    std_image(x,y) = std(residuals);
            end
        end


end

