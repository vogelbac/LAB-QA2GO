%%
%% This function calculates the static spatial noise image
%%

function [ diff_img,intrinsic_noise  ] = static_spatial_noise_image(use_mask, image,soi,remove_time_series,dim4)


        odd_img = sum(image(:,:,soi,(remove_time_series+1):2:dim4),4);
        even_img = sum(image(:,:,soi,(remove_time_series+2):2:dim4),4);
        
            
        diff_img = odd_img - even_img;
        intrinsic_noise = var(reshape(diff_img,[],1));

end

