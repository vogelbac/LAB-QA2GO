%%
%% This function calculates the PSC value. 
%% in each slice 4 ROIs were placed in the corners and one in the center of the phantom
%% then the ratio between the singal and the noise is calculated.
%% 


function [ mean_psc, std_psc,max_psc,min_psc] = psc( use_mask,image,dim4,dim3,remove_time_series,dim1,dim2,soi,phantom_name,roi)
    

        % limits für Anzeige festlegen
        ymin_psc = 0.4;
        ymax_psc = 1.6;

        psclim_min = 0; 
        psclim_max = 1200;

        
       
        %Rechteckbreite
        RB_w = round(dim1/8);

        %4 ROIs fuer Noise
        xn_lob = 1;
        yn_lob = 1;           
        xn_rob = dim2-RB_w;
        yn_rob = 1;
        xn_lun = 1;
        yn_lun = dim1-RB_w;           
        xn_run = dim2-RB_w;
        yn_run = dim1-RB_w;


        %Maske für jede Schicht und jeden Zeitpunkt berechnen

        for t= remove_time_series+1:dim4
         for z = 1:dim3
            %ROI ins zentrum legen
            [row, col] = find(roi(:,:,z,t)>0);
            %speichert den Mittelwert in der ROI zu jeder Schicht zu jedem
            %Zeitpunkt ab.
            MW_mask(z,t) = mean(reshape(image(min(row):max(row),min(col):max(col),z,t),[],1));
            %speichert die Summe der Intensitätswerte in der ROI ab
            phantom_mask_intensity(z,t) = sum(reshape(image(min(row):max(row),min(col):max(col),z,t),[],1));
             %speichert die Anzahl der Intensitätswerte in der ROI ab
            phantom_mask_counter(z,t) = numel(reshape(image(min(row):max(row),min(col):max(col),z,t),[],1));          
            %/0.655; = Rayleigh correction
            % Mittelwert der Rayleigh korrigierten Standardabweichungen Berechnen
            sigma_bg(z,t) = (((std(reshape(image(yn_lob:(yn_lob+RB_w),xn_lob:(xn_lob+RB_w),z,t),[],1)))/0.655)+((std(reshape(image(yn_lun:(yn_lun+RB_w),xn_lun:(xn_lun+RB_w),z,t),[],1)))/0.655)+((std(reshape(image(yn_rob:(yn_rob+RB_w),xn_rob:(xn_rob+RB_w),z,t),[],1)))/0.655)+((std(reshape(image(yn_run:(yn_run+RB_w),xn_run:(xn_run+RB_w),z,t),[],1)))/0.655))/4;

            %PSC Berechnen für eine Schicht zu einem Zeitpunkt
            PSC(z,t)=100*sigma_bg(z,t)/MW_mask(z,t);
                 

         end 
         %Vorher mittelwert über alles
         %psc_msl(t) = mean(PSC(1:dim3,t)); 
         %Berechnung psc über gesammtes Volumen
         % summe aller sigmas in einer schicht / Anzahl der schichten  
         % = mittelwert von Sigama zu einem Zeitpunkt
         % summe aller Phantomintensitäten / Anzahl der einzelnen
         % Intensitätspunkte
         psc_msl(t) = 100 * (mean(sigma_bg(:,t))/(mean(phantom_mask_intensity(:,t)./phantom_mask_counter(:,t))));
        end






        psc_sl_vol = PSC(1:dim3,remove_time_series+1:dim4);
        psc_vol = psc_msl(remove_time_series+1:dim4);
        min_psc = min(psc_msl);
        max_psc = max(psc_msl);
        mean_psc = mean(psc_vol);
        std_psc = std(psc_vol);
        ymax = max(psc_vol)+ 0.3;
        ymin = min(psc_vol)-0.3;


        f=figure();
        set(gcf,'Color','w');
        imagesc(image(:,:,soi,floor(dim4/2)));
        axis off;
        hold on;
        title('PSC','FontName','Arial','FontSize',10,'FontWeight','Bold');
        caxis([psclim_min psclim_max]);
        colormap(jet);
        hold off;
        rectangle('position',[xn_lob-0.5 yn_lob-0.5 RB_w RB_w],...
                  'facecolor',[0.7 0.7 0.7],'Edgecolor','none');
        rectangle('position',[xn_lun-0.5 yn_lun+0.5 RB_w RB_w],...
                  'facecolor',[0.7 0.7 0.7],'Edgecolor','none');
        rectangle('position',[xn_run+0.5 yn_run+0.5 RB_w RB_w],...
                  'facecolor',[0.7 0.7 0.7],'Edgecolor','none');         
        rectangle('position',[xn_rob+0.5 yn_rob-0.5 RB_w RB_w],...
                  'facecolor',[0.7 0.7 0.7],'Edgecolor','none');

        set(f, 'Position', [300,300, 740, 600])
        set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 10 10])      
        name = strcat('PSC_BOLD_', phantom_name);
        set(f,'Name',name);
        print(f,name,'-dpng');

        f = figure();
        set(gcf,'Color','w');
        h= subplot(2,3,1:3);
        %p=get(h,'position');
        imagesc(psc_sl_vol);
        caxis([ymin_psc ymax_psc]);
        colormap(jet);
	colorbar ();
        ylabel('slice number','FontName','Arial','FontSize',10,'FontWeight','Bold');
	xlabel('volumes','FontName','Arial','FontSize',10,'FontWeight','Bold');
        set(gca,'XTickLabel',[]);
        %title('PSC  per slice','FontName','Arial','FontSize',10,'FontWeight','Bold');
        %title('%','FontName','Arial','FontSize',10,'FontWeight','Bold');

        %set(h,'position',p)
        subplot(2,3,4:6);
        plot(remove_time_series+1:dim4,psc_vol,'k-');
        set(gca,'YLim',[ymin ymax]);
        set(gca,'XLim',[remove_time_series+1 dim4]);
        xlabel('volumes','FontName','Arial','FontSize',10,'FontWeight','Bold');
        ylabel('PSC (%)','FontName','Arial','FontSize',10,'FontWeight','Bold');
        title(sprintf('PSC (mean = %i %%)',mean_psc),'FontName','Arial','FontSize', 10, 'FontWeight', 'bold');

        name = strcat('PSC_per_slice_', phantom_name);
        set(f,'Name',name);
        print(f,name,'-dpng');



end

