function ghosting_T1()
global hdr1 img1 filenameT1 dir_results global_result_file
CWD = pwd;
[pathT1 nameT1 ext1]=fileparts(filenameT1);

hdr1.info.dimensions;
dim1_T1 =hdr1.info.dimensions(1);
dim2_T1 =hdr1.info.dimensions(2);

%Segmentierung
IDX = otsu(img1(:,:,7),2);
for i=1:dim1_T1,
    for j=1:dim2_T1,
        if IDX(i,j) < 2
           IDX(i,j) = 0;
        else
            IDX(i,j) = 1;
        end
    end
end
%Phantomgrenzen bestimmen
sumdim1 = sum(IDX,1);
sumdim2 = sum(IDX,2);
ph_edges1 = find(sumdim1 > 0);
cut3 = ph_edges1(1); %links
cut4 = ph_edges1(length(ph_edges1)); %rechts
ph_edges2 = find(sumdim2 > 0);
cut1 = ph_edges2(1); %oben
cut2 = ph_edges2(length(ph_edges2)); %unten
%75%-Bereich berechnen
%Radius fuer 75%-Bereich berechnen
%zwischen 82 und 85 % der Fläche verwenden
cut_percob = (cut2-cut1)*0.115+cut1;
cut_percun = cut2-(cut2-cut1)*0.115;
r_vert = round((cut_percun-cut_percob)/2)
cut_percli = (cut4-cut3)*0.115+cut3;
cut_percre = cut4-(cut4-cut3)*0.115;
%Phantommittelpunkt
ym = (cut2-cut1)/2+cut1; %dim1
xm = (cut4-cut3)/2+cut3; %dim2
center = [xm ym]
%als large ROI Kreis festlegen, der 75% des Phantomvolumens abdeckt
phi=1:1:360;
phi=phi./180.*pi;
[xtmp,ytmp] = pol2cart(phi,r_vert);
x_circle=xtmp+xm;
y_circle=ytmp+ym;
xcl = ceil(xm-r_vert);
xcr = floor(xm+r_vert);
yco = ceil(ym-r_vert);
ycu = floor(ym+r_vert);

%Abstand von allen Bildpunkten zum Kreismittelpunkt berechen,um nur die
%Pixel,die innerhalb des Kreises liegen zu finden
for column = yco:ycu,
    for row = xcl:xcr,
        vec_xy = [row column];
        abst(row) = norm(center-vec_xy);
    end
    pos_row = find(0< abst(:) & round(abst(:)) <= r_vert);
    pos_row_dim = length(pos_row);
    dim2_circle = pos_row(1):pos_row(pos_row_dim);
    im_circle = img1(column,dim2_circle,8);
end
mean_large = mean(im_circle)

%Definition Rechteck-ROIs auï¿½erhalb des Phantoms
w_rec = 60;
h_rec = 17;
x1_top = round(xm-w_rec/2);
x2_top = x1_top+w_rec;
y1_top = round(cut1/2-h_rec/2);
y2_top = y1_top+h_rec;

x1_bottom = round(xm-w_rec/2);
x2_bottom = x1_bottom+w_rec;
y1_bottom = round(cut2+(dim1_T1-cut2)/2-h_rec/2);
y2_bottom = y1_bottom+h_rec;

x1_left = round(cut3/2-h_rec/2);
x2_left = x1_left+h_rec;
y1_left = round(ym-w_rec/2);
y2_left = y1_left+w_rec;

x1_right = round(cut4+(dim2_T1-cut4)/2-h_rec/2);
x2_right = x1_right+h_rec;
y1_right = round(ym-w_rec/2);
y2_right = y1_right+w_rec;

roi_top = img1(y1_top:y2_top,x1_top:x2_top,7);
mean_top = mean(mean(roi_top))
roi_bottom = img1(y1_bottom:y2_bottom,x1_bottom:x2_bottom,7);
mean_bottom = mean(mean(roi_bottom))
roi_left = img1(y1_left:y2_left,x1_left:x2_left,7);
mean_left = mean(mean(roi_left))
roi_right = img1(y1_right:y2_right,x1_right:x2_right,7);
mean_right = mean(mean(roi_right))
%Ghosting ratio sollte <=0.025 sein
gh_ratio = abs(((mean_top+mean_bottom)-(mean_left+mean_right))/(2*mean_large))
%Diskrepanz berechnen
disc_psg = 0.025-gh_ratio;
if gh_ratio <= 0.025,
    action = sprintf('Test bestanden: PSG %2.5f',gh_ratio)
    test_psg = sprintf('Pass');
else
    action = sprintf('Test nicht bestanden: PSG betrï¿½gt %2.5f', gh_ratio)
    test_psg = sprintf('Fail');
end

bild = figure(1);
set(gcf,'numbertitle','off','Name','Percent Signal Ghosting');
set(gcf,'Color','w');
imagesc(img1(:,:,7)); 
colormap(gray);
colorbar();
hold on;
h = area(x_circle,y_circle);
set(h,'FaceColor',[0 0 1],'EdgeColor','none')
hold off; 
rectangle('position',[round(xm-w_rec/2) round(cut1/2-h_rec/2) w_rec h_rec],'FaceColor',[0 0 1],'EdgeColor','none');
rectangle('position',[round(xm-w_rec/2) round(cut2+(dim1_T1-cut2)/2-h_rec/2) w_rec h_rec],'FaceColor',[0 0 1],'EdgeColor','none');
rectangle('position',[round(cut3/2-h_rec/2) round(ym-w_rec/2) h_rec w_rec],'FaceColor',[0 0 1],'EdgeColor','none');
rectangle('position',[round(cut4+(dim2_T1-cut4)/2-h_rec/2) round(ym-w_rec/2) h_rec w_rec],'FaceColor',[0 0 1],'EdgeColor','none');
title(sprintf('ghosting ratio = %i',gh_ratio),'FontSize',14,'FontWeight', 'bold');

datefinder=findstr('201',nameT1);
datum=nameT1(datefinder:datefinder+7);

%Speichern der Ergebnisse in  Textfile und png Format
cd(dir_results);
%Bild speichern
set(bild, 'PaperUnits', 'centimeter', ...
   'PaperPosition', [0, 0, 12, 9], ...
   'PaperSize', [12, 9]);
sl_pos_bild = sprintf('Ghosting_%s',nameT1); 
print( gcf, '-dpng', sl_pos_bild );

fname_result = sprintf('Ghosting_T1_Results.txt');
%Parameter speichern
FID        = fopen(fname_result,'a+');
fprintf(FID,'Messung:%s\n',nameT1);
fprintf(FID,'Ergebnisse:\n');
fprintf(FID,'PSG\t\tNormwert\tDiskrepanz\tTest\tDatum\n');     
fprintf(FID,'%2.5f\t< 0.025\t%2.2f\t\t%s\t%s\n',gh_ratio,disc_psg,test_psg,datum);
fclose(FID);


fprintf(global_result_file,'\n#10\nErgebnisse PSG T1:\n');
fprintf(global_result_file,'PSG\t\tNormwert\tDiskrepanz\tTest\tDatum\n');     
fprintf(global_result_file,'%2.5f\t< 0.025\t%2.2f\t\t%s\t%s\n',gh_ratio,disc_psg,test_psg,datum);
cd(CWD);


