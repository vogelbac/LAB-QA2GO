%%
%% This is a helping function to position the ROI (based on a length) inside a
%% given range (start/end) e.g. position the ROI in the center of the phantom
%%

function [ rechteck_roi_start, rechteck_roi_ende ] = get_start_end_of_roi( startpoint, endpoint, roi_length)


    %in X Richtung (rechts/ links)
    if mod(((endpoint - startpoint)/2),1) == 0
        if mod((roi_length/2),1) == 0
            %Fall 3: ROI Länge gerade und Phantombreite ungerade
            rechteck_roi_start = (startpoint + ((endpoint - startpoint)/2)) - floor(roi_length/2); 
            rechteck_roi_ende = (startpoint + ((endpoint - startpoint)/2)) + floor(roi_length/2) - 1;
        else
            %Fall 4: ROI Länge ungerade und Phantombreite ungerade
            rechteck_roi_start = (startpoint + ((endpoint - startpoint)/2)) - floor(roi_length/2);
            rechteck_roi_ende = (startpoint + ((endpoint - startpoint)/2)) + floor(roi_length/2);
        end
    else
        if mod((roi_length/2),1) == 0
            %Fall 1: ROI Länge gerade und Phantombreite gerade
            rechteck_roi_start = (startpoint + (((endpoint - startpoint)+1)/2)) - (roi_length/2);
            rechteck_roi_ende = (startpoint + (((endpoint - startpoint)+1)/2)) + (roi_length/2) - 1;
        else
            %Fall 2: ROI Länge ungerade und Phantombreite gerade
            rechteck_roi_start = (startpoint + (((endpoint - startpoint)+1)/2)) - floor(roi_length/2) - 1;
            rechteck_roi_ende = (startpoint + (((endpoint - startpoint)+1)/2)) + floor(roi_length/2) - 1;
        end
    end


end

