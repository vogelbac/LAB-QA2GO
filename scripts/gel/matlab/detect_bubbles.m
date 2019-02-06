%% 
%% This function detect and mask the air bubbles / non homogenous
%% parts of the phantom.
%% Threrefore the image is binarized to detect the hole phantom.
%% A double erosion step is performed to minimize the effects at the edges of the phantom
%% based on a differentiation step the non hemogenous pixels were detected by masking (otsu with 3 classes)
%% this step is done in 2 directions and in the end combined.
%%

function bubble_mask_final = detect_bubbles(image,dim1,dim2,dim3,dim4,soi)

    % Binärbild für jede SOI für jeden Zeitpunkt erzeugen
    temp_binary_mask(:,:,:,:) = zeros(dim1,dim2,dim3,dim4);
    for t = 1:dim4
        for z = 1:dim3
         temp_binary_mask(:,:,z,t) = otsu(image(:,:,z,t),2);
        end
    end

    binary_mask(:,:,:,:) = zeros(dim1,dim2,dim3,dim4);
    binary_mask(temp_binary_mask(:,:,:,:) >= 2) = 1;

    bin_mask_2 = binary_mask;

    %Löcher stopfen in der Maske
    for t=1:dim4
        for z = 1:dim3
            %Kanten detektieren
            for x= 1:dim1
                [row, col] = find(binary_mask(x,:,z,t)>0);
                start = min(col);
                ende = max(col);
                bin_mask_2(x,start:ende,z,t) = 1;
            end
        end
    end
    
    % %Erosion mit der folgenden Struktur
    %     % 0 1 0
    %     % 1 1 1
    %     % 0 1 0
    %     
    %einfacher Erosion
    temp_erosion_image = zeros(dim1,dim2,dim3,dim4);
    for t=1:dim4
        for z = 1: dim3
            for x = 2:dim1-1
                for y = 2:dim2-1
                    if bin_mask_2(x,y-1,z,t) == 1 && bin_mask_2(x-1,y,z,t) == 1 && bin_mask_2(x,y,z,t) == 1 && bin_mask_2(x+1,y,z,t) == 1 && bin_mask_2(x,y+1,z,t) == 1
                        temp_erosion_image(x,y,z,t) = 1;
                    end
                end
            end
        end
    end

    %zweifache Erosion
    erosion_image2 = zeros(dim1,dim2,dim3,dim4);
    for t=1:dim4
        for z = 1:dim3
            for x = 2:dim1-1
                for y = 2:dim2-1
                    if temp_erosion_image(x,y-1,z,t) == 1 && temp_erosion_image(x-1,y,z,t) == 1 && temp_erosion_image(x,y,z,t) == 1 && temp_erosion_image(x+1,y,z,t) == 1 && temp_erosion_image(x,y+1,z,t) == 1
                        erosion_image2(x,y,z,t) = 1;
                    end
                end
            end
        end
    end
    

    calc_mask = erosion_image2;
    
    %Blasendetektion via Differenzierung


    for t = 1:dim4
        for z = 1:dim3
            rechts = image(:,2:dim2,z,t);
            links = image(:,1:(dim2-1),z,t);
            kante = rechts -links;
            
            oben = image(2:dim1,:,z,t);
            unten = image(1:(dim1-1),:,z,t);
            kante2 = oben-unten;
           
            %reduzierte Ebene wieder einfügen
            kante_neu = zeros(dim1,dim2);
            kante2_neu = zeros (dim1,dim2);
            for i = 1:dim1-1
                kante2_neu(i,:) = kante2(i,:);
            end
            for i = 1:dim2-1
               kante_neu(:,i) = kante(:,i); 
            end
            
            
            
            %klassifizierung in 3 klassen
            k_1 = kante_neu(:,:);%.*calc_mask(:,:,z,t);
            k_2 = kante2_neu(:,:);%.*calc_mask(:,:,z,t);
            diff_otsu_temp = otsu(k_1,3);
            diff_otsu2_temp = otsu(k_2,3);
            diff_otsu_both = ones(dim1,dim2);
            
            diff_otsu = diff_otsu_temp.*calc_mask(:,:,z,t);
            diff_otsu2 = diff_otsu2_temp.*calc_mask(:,:,z,t);
            
    
            %detektierte luftblasen markieren
            for x= 1:dim1
                if any(diff_otsu(x,:)==1 | diff_otsu(x,:)==3) == 1
                    [row, col] = find(diff_otsu(x,:)==1|diff_otsu(x,:)==3);
                    for i = 1:length(col)
                        index1 = col(i);
                        if(diff_otsu(x,index1)==1)
                            if i < length(col)
                                index2 = col(i+1);
                                if(diff_otsu(x,index2) == 3)
                                   diff_otsu_both(x,index1:index2) = 0;
                                end
                            end
                            diff_otsu_both(x,index1)=0;
                        elseif(diff_otsu(x,index1)==3)
                            diff_otsu_both(x,index1)=0;
                        end
                    end
                end
            end
            for y= 1:dim2
                if any(diff_otsu2(:,y)==1 | diff_otsu2(:,y)==3) == 1
                    [row, col] = find(diff_otsu2(:,y)==1|diff_otsu2(:,y)==3);
                    for i = 1:length(row)
                        index1 = row(i);
                        if(diff_otsu2(index1,y)==1)
                            if i < length(row)
                                index2 = row(i+1);
                                if(diff_otsu2(index2,y) == 3)
                                    diff_otsu_both(index1:index2,y) = 0;
                                end
                            end
                            diff_otsu_both(index1,y)=0;
                        elseif(diff_otsu2(index1,y)==3)
                            diff_otsu_both(index1,y)=0;
                        end
                    end
                end
            end
            
            bubble_mask(:,:,z,t)=diff_otsu_both(:,:);
            
 
            
        end
    end
    
    for z = 1:dim3
        temp_img (:,:) = otsu(sum(bubble_mask(:,:,z,:),4),3);
        temp_img(temp_img==1) = 0;
        temp_img(temp_img==2) = 1;
        temp_img(temp_img==3) = 1;

        
        if ( isnan(sum(sum(temp_img(:,:)))) || sum(sum(temp_img(:,:)))==0)
            temp_img(:,:) = 1;
        end
        
       for t = 1:dim4
           
           %hier rein programmieren wenn ein Bild komplett auf Null ist
            bubble_mask_final(:,:,z,t) = temp_img(:,:);

       end   
    end
    
   
end

