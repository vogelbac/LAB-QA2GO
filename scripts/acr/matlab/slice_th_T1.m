function slice_th_T1()

global hdr1 img1 filenameT1 dir_results global_result_file
CWD = pwd;
[pathT1 nameT1 ext1]=fileparts(filenameT1);

hdr1.info.dimensions;
dim1_T1 =hdr1.info.dimensions(1);
T1_fl = findstr('fl',nameT1);

%Interpolation
[x,y]=meshgrid(1:dim1_T1);  %Bildgr��e quadratisch dim1=dim2 
[xi,yi]=meshgrid(1:0.2:dim1_T1);
I2(:,:,1)=interp2(x,y,double(img1(:,:,1)),xi,yi,'cubic');
%Segementierung
img_seg = otsu(I2(:,:,1),2);
new_size = size(img_seg);
a1 = new_size(1);
a2 = new_size(2);

%Randbereiche auf Null setzen wegen m�glicher Artefakte
img_seg(1:10,:) = 0;
img_seg(a1-10:a1,:) = 0;
img_seg(:,1:10) = 0;
img_seg(:,a2-10:a2) = 0;

for k=1:a1,
    for l=1:a2,
        if img_seg(k,l) < 2
            img_seg(k,l) = 0;
        else
            img_seg(k,l) = 1;
        end
    end
end

%suche Phantomrand oben und unten
sumdim2 = sum(img_seg,2);
ph_edges2 = find(sumdim2 > 0);
cut_ob = ph_edges2(1);
cut_un = ph_edges2(length(ph_edges2));

%suche nach Ausschnitt fuer resolution insert
sumdim1 = sum(img_seg,1);
abldim1 = diff(sumdim1);
[mx_roi1_hor loc_mx_roi1_hor] = max(abldim1(1:round(a2/2))); %Ende roi1_hor

%suche nach Ausschnitt fuer thickness insert
[mx_roi2_hor loc_mx_roi2_hor] = max(abldim1(loc_mx_roi1_hor+10:a2-1)); 
loc_end_roi2_hor = loc_mx_roi2_hor+loc_mx_roi1_hor+10;     %Ende roi2_hor
[mn_roi2_hor loc_mn_roi2_hor] = min(abldim1(loc_mx_roi1_hor+10:a2-1));
loc_bg_roi2_hor = loc_mn_roi2_hor+ loc_mx_roi1_hor+10;     %Beginn roi2_hor
RB_roi2 = loc_end_roi2_hor-loc_bg_roi2_hor;
ablroi2 = diff(img_seg(:,round(RB_roi2/2+loc_bg_roi2_hor)));
[mn_roi2_vert loc_mn_roi2_vert] = min(ablroi2(cut_ob+10:round(a1/2)));
loc_bg_roi2_vert = loc_mn_roi2_vert+cut_ob+10;  %Beginn roi2_vert
[mx_roi2_vert loc_mx_roi2_vert] = max(ablroi2(750:cut_un-10));
loc_end_roi2_vert = loc_mx_roi2_vert+750;      %Ende roi2_vert
h_roi2 = loc_end_roi2_vert-loc_bg_roi2_vert;
%ROI_Thickness_insert
roi_th = I2(loc_bg_roi2_vert:loc_end_roi2_vert,loc_bg_roi2_hor:loc_end_roi2_hor,1);
roi_size = size(roi_th);
dim1_ROI = roi_size(1);
dim2_ROI = roi_size(2);

%setze die Randbereiche auf Null, um Randartefakte zu eleminieren
roi_th(1:150,:,1) = 0;
roi_th(dim1_ROI-150:dim1_ROI,:) = 0;
%roi_th(:,1:4,1) = 0;
%roi_th(:,dim2_ROI-4:dim2_ROI,1) = 0;

%Berechne Mittelwert von roi_th und fuehre damit Intensitaetsanpassung
%durch
if T1_fl > 0,
    mean_roi_th = mean(mean(roi_th))+80;
else
    mean_roi_th = mean(mean(roi_th))
end

for i = 1:dim1_ROI,
    for j = 1:dim2_ROI,
        if roi_th(i,j,1) <= round(mean_roi_th);
            roi_th(i,j,1) = 0;
        end
        if roi_th(i,j,1) < 0;
            roi_th(i,j,1) = 0;
        end
    end
end

%Segmentierung -schneide rechts und links die auf Null gesetzten Raender ab
%roi_seg = otsu(roi_th(:,10:dim2_ROI-10,1),2);
roi_seg = otsu(roi_th(:,5:dim2_ROI-5,1),3);
roi_size = size(roi_seg);
roia1 = roi_size(1);
roia2 = roi_size(2);
for k=1:roia1,
    for l=1:roia2,
        if roi_seg(k,l) < 2
            roi_seg(k,l) = 0;
        else
            roi_seg(k,l) = 1;
        end
    end
end

%Separiere rechte und linke Rampe voneinander
posleft = round(roia2/2)-1;
posright = round(roia2/2)+1;
roi_seg(:,posleft:posright) = 0;
%Bestimme L�nge der Rampen
pos_x1 = round(roia2/4);
pos_x2 = pos_x1*3;
sum_ramp_left = sum(roi_seg(:,pos_x1,1),2);
edges_ramp_left = find(sum_ramp_left > 0);
if size(edges_ramp_left)(1) == 0
	pos_x1 = round(pos_x2/2);
	sum_ramp_left = sum(roi_seg(:,pos_x1,1),2);
	edges_ramp_left = find(sum_ramp_left > 0);
end
cut_ob_left = edges_ramp_left(1);
cut_un_left = edges_ramp_left(length(edges_ramp_left));
leftramp = (cut_un_left-cut_ob_left)/5   %durch 5 wegen fuenfacher Vergr��erung des Bildes
sum_ramp_right = sum(roi_seg(:,pos_x2,1),2);
edges_ramp_right = find(sum_ramp_right > 0);
cut_ob_right = edges_ramp_right(1);
cut_un_right = edges_ramp_right(length(edges_ramp_right));
rightramp = (cut_un_right-cut_ob_right)/5
%Berechne Schichtdicke (Formel ACR Test Guidance)
sl_thickness = 0.2*(leftramp*rightramp)/(leftramp+rightramp)
%Kriterium: Schichtdicke sollte (5+/-0.7)mm sein
%Diskrepanz berechnen
disc_sl_th = abs(5-sl_thickness);
if disc_sl_th <= 0.7,
    action = sprintf('Test bestanden: Schichtdicke betr�gt %2.2f',sl_thickness)
    test_sl_th = sprintf('Pass');
else
    action = sprintf('Test nicht bestanden: Schichtdicke betr�gt %2.2f', sl_thickness)
    test_sl_th = sprintf('Fail');
end

bild = figure(1);
subplot(2,2,1)
set(gcf,'numbertitle','off','Name','Slice thickness test');
set(gcf,'Color','w');
imagesc(I2(:,:,1));
colormap(gray);
colorbar();
rectangle('position',[loc_bg_roi2_hor loc_bg_roi2_vert RB_roi2 h_roi2],'EdgeColor','b','LineWidth',2);  
subplot(2,2,2)
imagesc(img_seg(:,:,1));
colormap(gray);
rectangle('position',[loc_bg_roi2_hor loc_bg_roi2_vert RB_roi2 h_roi2],'EdgeColor','b','LineWidth',2);    
subplot(2,2,3)
imagesc(roi_th);
colormap(gray);
colorbar();
subplot(2,2,4)
imagesc(roi_seg);
colormap(gray);
line([pos_x1 pos_x1],[1 roia1],'Color','b','LineWidth',2);
line([pos_x2 pos_x2],[1 roia1],'Color','b','LineWidth',2);

datefinder=findstr('201',nameT1);
datum=nameT1(datefinder:datefinder+7);

%Speichern der Ergebnisse in  Textfile und png Format
cd(dir_results);
%Bild speichern
set(bild, 'PaperUnits', 'centimeter', ...
   'PaperPosition', [0, 0, 12, 10], ...
   'PaperSize', [12, 10]);
sl_th_bild = sprintf('Schichtdicke_%s',nameT1); 
print( gcf, '-dpng', sl_th_bild );

fname_result = sprintf('Schichtdicke_Results.txt');
%Parameter speichern
FID        = fopen(fname_result,'a+');
fprintf(FID,'Messung:%s\n',nameT1);
fprintf(FID,'Ergebnisse:\n');
fprintf(FID,'Schichtdicke\tNormwert\tFehler\tDatum\t\tTest\n');     
fprintf(FID,'%2.2f\t\t\t5\t\t%2.2f\t\t%s\t%s\n',sl_thickness,disc_sl_th,datum,test_sl_th);
fclose(FID);
cd(CWD);



fprintf(global_result_file,'\n#4\nErgebnisse Slice Thickness T1:\n');
fprintf(global_result_file,'Schichtdicke\tNormwert\tFehler\tDatum\t\tTest\n');     
fprintf(global_result_file,'%2.2f\t\t\t5\t\t%2.2f\t\t%s\t%s\n',sl_thickness,disc_sl_th,datum,test_sl_th);
close all;




