%%
%% This function calculates a centerd squared ROI in the phantom based on the detected phantom edges
%% and the defined roi_length parameter for every image in the volumen
%%

function [ rechteck_roi , bin_mask_phantom ] = calculate_roi(image,dim1,dim2,dim3,dim4,roi_length )

    % Binärbild für jede Schicht für jeden Zeitpunkt erzeugen
    temp_binary_mask(:,:,:,:) = zeros(dim1,dim2,dim3,dim4);
    for t = 1:dim4
        for z = 1:dim3
         temp_binary_mask(:,:,z,t) = otsu(image(:,:,z,t),2);
        end
    end

    binary_mask(:,:,:,:) = zeros(dim1,dim2,dim3,dim4);
    binary_mask(temp_binary_mask(:,:,:,:) >= 2) = 1;

    bin_mask_phantom = binary_mask;

    %Löcher stopfen in der Maske
    for t=1:dim4
        for z = 1:dim3
            % Für jeden X Wert die Kanten des Phantoms detektieren und
            % die Werte dazwischen auffüllen
            for x= 1:dim1
                [row, col] = find(binary_mask(x,:,z,t)>0);
                start = min(col);
                ende = max(col);
                bin_mask_phantom(x,start:ende,z,t) = 1;
            end
        end
    end

   rechteck_roi = zeros(dim1,dim2,dim3,dim4);

    for t = 1:dim4
       for z = 1:dim3
            % Werte finden die > 0 sind
            [row, col] = find(bin_mask_phantom(:,:,z,t)>0);
            %Bounding Box definieren
            phantom_oben = min(row);
            phantom_unten = max(row);
            phantom_links = min(col);
            phantom_rechts = max(col);


            % Vorsicht index!
            %BSP: min = 17 , max = 49 
            % breite wäre 49-17 = 32
            % wir betrachten aber voxel, daher ist 17 der erste index
            % und 49 der letzte index, in dem eine 1 steht, also
            % phantom ist. Daher ist eine gerade Zahl eine Ungerade
            % phantombreite

            %in Y Richtung (oben / unten)
            if mod(((phantom_unten - phantom_oben)/2),1) == 0
                if mod((roi_length/2),1) == 0
                    %Fall 3: ROI Länge gerade und Phantombreite ungerade
                    rechteck_roi_y_start = (phantom_oben + ((phantom_unten - phantom_oben)/2)) - floor(roi_length/2) ;
                    rechteck_roi_y_ende = (phantom_oben + ((phantom_unten - phantom_oben)/2)) + floor(roi_length/2) - 1;
                else
                    %Fall 4: ROI Länge ungerade und Phantombreite ungerade
                    rechteck_roi_y_start = (phantom_oben + ((phantom_unten - phantom_oben)/2)) - floor(roi_length/2);
                    rechteck_roi_y_ende = (phantom_oben + ((phantom_unten - phantom_oben)/2)) + floor(roi_length/2);
                end
            else
                if mod((roi_length/2),1) == 0
                    %Fall 1: ROI Länge gerade und Phantombreite gerade
                    rechteck_roi_y_start = (phantom_oben + (((phantom_unten - phantom_oben)+1)/2)) - (roi_length/2);
                    rechteck_roi_y_ende = (phantom_oben + (((phantom_unten - phantom_oben)+1)/2)) + (roi_length/2) - 1;
                else
                    %Fall 2: ROI Länge ungerade und Phantombreite gerade
                    rechteck_roi_y_start = (phantom_oben + (((phantom_unten - phantom_oben)+1)/2)) - floor(roi_length/2) - 1;
                    rechteck_roi_y_ende = (phantom_oben + (((phantom_unten - phantom_oben)+1)/2)) + floor(roi_length/2) - 1;
                end
            end

            %in X Richtung (rechts/ links)
            if mod(((phantom_rechts - phantom_links)/2),1) == 0
                if mod((roi_length/2),1) == 0
                    %Fall 3: ROI Länge gerade und Phantombreite ungerade
                    rechteck_roi_x_start = (phantom_links + ((phantom_rechts - phantom_links)/2)) - floor(roi_length/2); 
                    rechteck_roi_x_ende = (phantom_links + ((phantom_rechts - phantom_links)/2)) + floor(roi_length/2) - 1;
                else
                    %Fall 4: ROI Länge ungerade und Phantombreite ungerade
                    rechteck_roi_x_start = (phantom_links + ((phantom_rechts - phantom_links)/2)) - floor(roi_length/2);
                    rechteck_roi_x_ende = (phantom_links + ((phantom_rechts - phantom_links)/2)) + floor(roi_length/2);
                end
            else
                if mod((roi_length/2),1) == 0
                    %Fall 1: ROI Länge gerade und Phantombreite gerade
                    rechteck_roi_x_start = (phantom_links + (((phantom_rechts - phantom_links)+1)/2)) - (roi_length/2);
                    rechteck_roi_x_ende = (phantom_links + (((phantom_rechts - phantom_links)+1)/2)) + (roi_length/2) - 1;
                else
                    %Fall 2: ROI Länge ungerade und Phantombreite gerade
                    rechteck_roi_x_start = (phantom_links + (((phantom_rechts - phantom_links)+1)/2)) - floor(roi_length/2) - 1;
                    rechteck_roi_x_ende = (phantom_links + (((phantom_rechts - phantom_links)+1)/2)) + floor(roi_length/2) - 1;
                end
            end

            rechteck_roi(rechteck_roi_x_start:rechteck_roi_x_ende,rechteck_roi_y_start:rechteck_roi_y_ende,z,t) = 1;
       end
    end

       

   

end

