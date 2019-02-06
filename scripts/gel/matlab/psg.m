%%
%% This function calculates the PSG value.
%% first the ROIs were placed for every slice in all timepoints left,right,top and bottom of the phantom (centerd)
%% then the ghosting level is calculated for every slice and timepoint
%%

function [mean_psg,PSG2] = psg( bin_mask_phantom,dim1,dim2,dim3,dim4,image,phantom_name,roi_length,remove_time_series,soi,signal_img,ghost_roi_length )
    
  
    %Roi für Phantom wird die Friedman ROI verwendet
    
    for t= remove_time_series+1:dim4
        for z = 1:dim3
            %phantomgrenzen detektieren
            
            % Werte finden die > 0 sind
            [row, col] = find(bin_mask_phantom(:,:,z,t)>0);
            phantom_oben = min(row);
            phantom_unten = max(row);
            phantom_links = min(col);
            phantom_rechts = max(col);
            
            %ROI start und Ende detektieren im Bereich Bild oben und
            %Phantom oben
            [ roi_start_oben, roi_ende_oben ] = get_start_end_of_roi( 0, phantom_oben, ghost_roi_length);
            %ROI start und Ende detektieren im Bereich Phantom unten und
            %Bild unten
            [ roi_start_unten, roi_ende_unten ] = get_start_end_of_roi( phantom_unten, dim1, ghost_roi_length);
            %ROI Start und Ende von der Ganzen dim2, um die Roi in die
            %Mitte zu platzieren
            [ roi_start_dim2, roi_ende_dim2 ] = get_start_end_of_roi( 0, dim2, ghost_roi_length);
            
            %ROI start und Ende detektieren im Bereich Bild links und
            %Phantom links
            [ roi_start_links, roi_ende_links ]= get_start_end_of_roi( 0, phantom_links, ghost_roi_length);
            %ROI start und Ende detektieren im Bereich Phantom rechts und
            %Bild rechts
            [ roi_start_rechts, roi_ende_rechts ]= get_start_end_of_roi( phantom_rechts, dim2, ghost_roi_length);
            %ROI Start und Ende von der Ganzen dim2, um die Roi in die
            %Mitte zu platzieren
            [ roi_start_dim1, roi_ende_dim1 ] = get_start_end_of_roi( 0, dim1, ghost_roi_length);
            
            %ROI in der Mitte des Phantoms detektieren
            [ roi_start_phantom_dim1, roi_ende_phantom_dim1 ] = get_start_end_of_roi( phantom_oben, phantom_unten, roi_length);
            [ roi_start_phantom_dim2, roi_ende_phantom_dim2 ] = get_start_end_of_roi( phantom_links, phantom_rechts, roi_length);
            
            % Mittelwerte der ROIs berechnen
            mean_oben = mean(reshape(image(roi_start_oben:roi_ende_oben,roi_start_dim2:roi_ende_dim2,z,t),[],1));
            mean_unten = mean(reshape(image(roi_start_unten:roi_ende_unten,roi_start_dim2:roi_ende_dim2,z,t),[],1));
            mean_links = mean(reshape(image(roi_start_dim1:roi_ende_dim1,roi_start_links:roi_ende_links,z,t),[],1));
            mean_rechts = mean(reshape(image(roi_start_dim1:roi_ende_dim1,roi_start_rechts:roi_ende_rechts,z,t),[],1));
            mean_phantom = mean(reshape(image(roi_start_phantom_dim1:roi_ende_phantom_dim1,roi_start_phantom_dim2:roi_ende_phantom_dim2,z,t),[],1));
            
            PSG(z,t) = abs(((mean_oben + mean_unten) - (mean_links + mean_rechts)) / (2 * mean_phantom));

            %rechteck_roi(rechteck_roi_x_start:rechteck_roi_x_ende,rechteck_roi_y_start:rechteck_roi_y_ende,z,t) = 1;
        end
        psg_msl(t) = mean(reshape(PSG(:,t),[],1));
    end
    
    psg_sl_vol = PSG(1:dim3,remove_time_series+1:dim4);
    psg_vol = psg_msl(remove_time_series+1:dim4);
    min_psg = min(psg_msl);
    max_psg = max(psg_msl);
    mean_psg = mean(psg_vol);
    std_psg = std(psg_vol);
    ymax = max(psg_vol)+ 0.3;
    ymin = min(psg_vol)-0.3;
    
    f = figure();
    set(f, 'Position', [300,300, 740, 600])
    set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
    set(gcf,'Color','w');
    name = strcat('PSG_', phantom_name);
    set(f,'Name',name);
    imagesc(image(:,:,soi,1));
    hold on;
    %Rechteck oben
    rectangle('Position',[roi_start_oben-0.5 roi_start_dim2-0.5 ghost_roi_length ghost_roi_length],'EdgeColor','w')
    %Rechteck unten
    rectangle('Position',[roi_start_unten-0.5 roi_start_dim2-0.5 ghost_roi_length ghost_roi_length],'EdgeColor','w')
    %Rechteck links
    rectangle('Position',[roi_start_dim1-0.5 roi_start_links-0.5 ghost_roi_length ghost_roi_length],'EdgeColor','w')
    %Rechteck rechts
    rectangle('Position',[roi_start_dim1-0.5 roi_start_rechts-0.5 ghost_roi_length ghost_roi_length],'EdgeColor','w')
    %Rechteck Phantom
    rectangle('Position',[roi_start_phantom_dim1-0.5 roi_start_phantom_dim2-0.5 roi_length roi_length],'EdgeColor','w')
    hold off;
    print(f,name,'-dpng');

    f = figure();
    set(gcf,'Color','w');
    h= subplot(2,3,1:3);
    %p=get(h,'position');
    imagesc(psg_sl_vol);
    colormap(jet);
    colorbar ();
    ylabel('slice number','FontName','Arial','FontSize',10,'FontWeight','Bold');
    xlabel('volumes','FontName','Arial','FontSize',10,'FontWeight','Bold');
    set(gca,'XTickLabel',[]);
    %title('PSG  per slice','FontName','Arial','FontSize',10,'FontWeight','Bold');
    %title('%','FontName','Arial','FontSize',10,'FontWeight','Bold');

    %set(h,'position',p)
    subplot(2,3,4:6);
    plot(remove_time_series+1:dim4,psg_vol,'k-');
    set(gca,'YLim',[ymin ymax]);
    set(gca,'XLim',[remove_time_series+1 dim4]);
    xlabel('volumes','FontName','Arial','FontSize',10,'FontWeight','Bold');
    ylabel('PSG','FontName','Arial','FontSize',10,'FontWeight','Bold');
    title(sprintf('PSG (mean = %i %%)',mean_psg),'FontName','Arial','FontSize', 10, 'FontWeight', 'bold');

    name = strcat('PSG_per_slice_', phantom_name);
    set(f,'Name',name);
    print(f,name,'-dpng');
    
    
    
    temp_binary_mask(:,:) = zeros(dim1,dim2);
    temp_binary_mask(:,:) = otsu(signal_img(:,:),2);
    binary_mask(:,:) = zeros(dim1,dim2);
    binary_mask(temp_binary_mask(:,:) >= 2) = 1;

    bin_mask_phantom = binary_mask;

    % Für jeden X Wert die Kanten des Phantoms detektieren und
    % die Werte dazwischen auffüllen
    for x= 1:dim1
        [row, col] = find(binary_mask(x,:)>0);
        start = min(col);
        ende = max(col);
        bin_mask_phantom(x,start:ende) = 1;
    end

    
    [row, col] = find(bin_mask_phantom(:,:)>0);
    phantom_oben = min(row);
    phantom_unten = max(row);
    phantom_links = min(col);
    phantom_rechts = max(col);

    %ROI start und Ende detektieren im Bereich Bild oben und
    %Phantom oben
    [ roi_start_oben, roi_ende_oben ] = get_start_end_of_roi( 0, phantom_oben, ghost_roi_length);
    %ROI start und Ende detektieren im Bereich Phantom unten und
    %Bild unten
    [ roi_start_unten, roi_ende_unten ] = get_start_end_of_roi( phantom_unten, dim1, ghost_roi_length);
    %ROI Start und Ende von der Ganzen dim2, um die Roi in die
    %Mitte zu platzieren
    [ roi_start_dim2, roi_ende_dim2 ] = get_start_end_of_roi( 0, dim2, ghost_roi_length);

    %ROI start und Ende detektieren im Bereich Bild links und
    %Phantom links
    [ roi_start_links, roi_ende_links ]= get_start_end_of_roi( 0, phantom_links, ghost_roi_length);
    %ROI start und Ende detektieren im Bereich Phantom rechts und
    %Bild rechts
    [ roi_start_rechts, roi_ende_rechts ]= get_start_end_of_roi( phantom_rechts, dim2, ghost_roi_length);
    %ROI Start und Ende von der Ganzen dim2, um die Roi in die
    %Mitte zu platzieren
    [ roi_start_dim1, roi_ende_dim1 ] = get_start_end_of_roi( 0, dim1, ghost_roi_length);

    %ROI in der Mitte des Phantoms detektieren
    [ roi_start_phantom_dim1, roi_ende_phantom_dim1 ] = get_start_end_of_roi( phantom_oben, phantom_unten, roi_length);
    [ roi_start_phantom_dim2, roi_ende_phantom_dim2 ] = get_start_end_of_roi( phantom_links, phantom_rechts, roi_length);

    % Mittelwerte der ROIs berechnen
    mean_oben = mean(reshape(signal_img(roi_start_oben:roi_ende_oben,roi_start_dim2:roi_ende_dim2),[],1));
    mean_unten = mean(reshape(signal_img(roi_start_unten:roi_ende_unten,roi_start_dim2:roi_ende_dim2),[],1));
    mean_links = mean(reshape(signal_img(roi_start_dim1:roi_ende_dim1,roi_start_links:roi_ende_links),[],1));
    mean_rechts = mean(reshape(signal_img(roi_start_dim1:roi_ende_dim1,roi_start_rechts:roi_ende_rechts),[],1));
    mean_phantom = mean(reshape(signal_img(roi_start_phantom_dim1:roi_ende_phantom_dim1,roi_start_phantom_dim2:roi_ende_phantom_dim2),[],1));

    
    PSG2 = abs(((mean_oben + mean_unten) - (mean_links + mean_rechts)) / (2 * mean_phantom));
    f = figure();
    set(f, 'Position', [300,300, 740, 600])
    set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
    set(gcf,'Color','w');
    name = strcat('PSG_bin_signal2_', phantom_name);
    set(f,'Name',name);
    imagesc(signal_img(:,:));
    hold on;
    title(sprintf('PSG = %i ',PSG2),'FontName','Arial','FontSize', 10, 'FontWeight', 'bold');
    %Rechteck links
    rectangle('Position',[roi_start_oben+0.5 roi_start_dim2-0.5 ghost_roi_length ghost_roi_length],'EdgeColor','w')
    %Rechteck rechts
    rectangle('Position',[roi_start_unten+0.5 roi_start_dim2-0.5 ghost_roi_length ghost_roi_length],'EdgeColor','w')
    %Rechteck oben
    rectangle('Position',[roi_start_dim1-0.5 roi_start_links-1.5 ghost_roi_length ghost_roi_length],'EdgeColor','w')
    %Rechteck unten
    rectangle('Position',[roi_start_dim1-0.5 roi_start_rechts-1.5 ghost_roi_length ghost_roi_length],'EdgeColor','w')
    %Rechteck Phantom
    rectangle('Position',[roi_start_phantom_dim1+1.5 roi_start_phantom_dim2-2.5 roi_length roi_length],'EdgeColor','w')
    hold off;
    print(f,name,'-dpng');
    
    temp_img = zeros(dim1,dim2);
    temp_img(roi_start_oben:roi_ende_oben,roi_start_dim2:roi_ende_dim2) = 1;
    temp_img(roi_start_unten:roi_ende_unten,roi_start_dim2:roi_ende_dim2) = 1;
    temp_img(roi_start_dim1:roi_ende_dim1,roi_start_links:roi_ende_links) = 1;
    temp_img(roi_start_dim1:roi_ende_dim1,roi_start_rechts:roi_ende_rechts) = 1;
    temp_img(roi_start_phantom_dim1:roi_ende_phantom_dim1,roi_start_phantom_dim2:roi_ende_phantom_dim2) = 1;
    
    f = figure();
    set(f, 'Position', [300,300, 740, 600])
    set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
    set(gcf,'Color','w');
    name = strcat('PSG_bin_signal_', phantom_name);
    set(f,'Name',name);
    imagesc(temp_img(:,:));
    print(f,name,'-dpng');
    
    
    
end

