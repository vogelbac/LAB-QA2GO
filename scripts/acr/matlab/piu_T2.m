function piu_T2()

global hdr2 img2 filenameT2 dir_results global_result_file

CWD = pwd;
[pathT2 nameT2 ext1]=fileparts(filenameT2);
hdr2.info.dimensions;
dim1_T2 =hdr2.info.dimensions(1);
dim2_T2 =hdr2.info.dimensions(2);

%Bestimmung der Phantomgrenzen/-kanten (Segmentierung mit Otsuï¿½s Methode)
IDX = otsu(img2(:,:,7),2);
for i=1:dim1_T2,
    for j=1:dim2_T2,
        if IDX(i,j) < 2
           IDX(i,j) = 0;
        else
            IDX(i,j) = 1;
        end
    end
end
sumdim1 = sum(IDX,1);
sumdim2 = sum(IDX,2);
ph_edges1 = find(sumdim1 > 0);
cut3 = ph_edges1(1); %links
cut4 = ph_edges1(length(ph_edges1)); %rechts
ph_edges2 = find(sumdim2 > 0);
cut1 = ph_edges2(1); %oben
cut2 = ph_edges2(length(ph_edges2)); %unten
%zwischen 82 und 85 % der Fläche verwenden
cut_percob = (cut2-cut1)*0.115+cut1;
cut_percun = cut2-(cut2-cut1)*0.115;
r_vert = round((cut_percun-cut_percob)/2)
%r_vert =79 fuer eine Flaeche von 195 cmï¿½;

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
xcl = ceil(xm-r_vert)
xcr = floor(xm+r_vert)
yco = ceil(ym-r_vert)
ycu = floor(ym+r_vert)

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
    im_circle = img2(column,dim2_circle,7);
    max_circle(column) = max(im_circle);
    min_circle(column) = min(im_circle);
    pos_min_circle = find(min_circle(:) > 0);
    length_minv = length(pos_min_circle);
    dim_min_circle = yco:pos_min_circle(length_minv);
    mn_circle = min_circle(dim_min_circle);
end
%nach highest und lowest value innerhalb des Kreises suchen
[immaxdim1 locmx_dim1]= max(max_circle(:));
[immindim1 locmn1] = min(mn_circle(:));
locmn_dim1 = (locmn1+yco)-1;

for row = xcl:xcr,
    vec_xy1 = [row locmx_dim1];
    vec_xy2 = [row locmn_dim1];
    abst1(row) = norm(center-vec_xy1); 
    abst2(row) = norm(center-vec_xy2);
end
pos1_row = find(0< abst1(:) & abst1(:) < r_vert);
pos2_row = find(0< abst2(:) & abst2(:) <= r_vert);
im1_circle = img2(locmx_dim1,pos1_row,7);
im2_circle = img2(locmn_dim1,pos2_row,7);
[immaxdim2 locmx2] = max(im1_circle);
locmx_dim2 = (locmx2+pos1_row(1))-1;
[immindim2 locmn2] = min(im2_circle);
locmn_dim2 = (locmn2+pos2_row(1))-1;
max_wert = img2(locmx_dim1,locmx_dim2,7)
min_wert = img2(locmn_dim1,locmn_dim2,7)

%small ROI definieren, Rechteckbreite 10mm
RB=10;
% high rectangle
xh1 = locmx_dim2-RB/2;
xh2 = xh1+RB;
yh1 = locmx_dim1-RB/2;
yh2 = yh1+RB;
% low rectangle
xl1 = locmn_dim2-RB/2;
xl2 = xl1+RB;
yl1 = locmn_dim1-RB/2;
yl2 = yl1+RB;

signal_high = img2(yh1:yh2,xh1:xh2,7);
mean_high = mean(mean(signal_high)) 
signal_low = img2(yl1:yl2,xl1:xl2,7);
mean_low = mean(mean(signal_low))
%percent intensity uniformity PIU (PIU bei 3Tesla sollte >=82%
%sein,ACRPhantom Test Guidance)
PIU = 100*(1-(mean_high-mean_low)/(mean_high+mean_low))
%nicht gemittelt, nur maximaler und minimaler Wert eingesetzt

%Kriterium: PIU sollte groesser gleich 82% sein
%Diskrepanz berechnen
disc_piu = PIU-82;
if PIU >= 82,
    action = sprintf('Test bestanden: PIU %2.2f',PIU)
    test_piu = sprintf('Pass');
else
    action = sprintf('Test nicht bestanden: PIU betrï¿½gt %2.2f', PIU)
    test_piu = sprintf('Fail');
end

bild = figure(1);
set(gcf,'numbertitle','off','Name','Image Intensity Uniformity');
set(gcf,'Color','w');
subplot(1,2,1)
imagesc(img2(:,:,7)); 
colormap(gray);
colorbar();
hold on;
h = area(x_circle,y_circle);
set(h,'FaceColor',[0 0 1],'EdgeColor','none')
hold off; 
subplot(1,2,2)
set(gcf,'Color','w');
imagesc(img2(:,:,7)); 
colormap(gray);
colorbar();
rectangle('position',[xh1 yh1 RB RB],'FaceColor',[0 0 1],'EdgeColor','none');
rectangle('position',[xl1 yl1 RB RB],'FaceColor',[0 0 1],'EdgeColor','none');
hold on;
plot(x_circle,y_circle,'LineWidth',2);
title(sprintf('PIU = %i %%',PIU),'FontSize', 12, 'FontWeight', 'bold');
text(xh2+3,yh1-3,'high','Color','b','FontSize', 12);
text(xl1-5,yl2+5,'low','Color','b','FontSize', 12);

datefinder=findstr('201',nameT2);
datum=nameT2(datefinder:datefinder+7);

%Speichern der Ergebnisse in  Textfile und png Format
cd(dir_results);
%Bild speichern
set(bild, 'PaperUnits', 'centimeter', ...
   'PaperPosition', [0, 0, 16, 6], ...
   'PaperSize', [16, 6]);
piu_bild = sprintf('piu_%s',nameT2); 
print( gcf, '-dpng', piu_bild );

fname_result = sprintf('PIU_T2_Results.txt');
%Parameter speichern
FID        = fopen(fname_result,'a+');
fprintf(FID,'Messung:%s\n',nameT2);
fprintf(FID,'Ergebnisse:\n');
fprintf(FID,'PIU\t\tNormwert\tDiskrepanz\tTest\tDatum\n');     
fprintf(FID,'%2.2f\t\t82\t\t%2.2f\t\t%s\t%s\n',PIU,disc_piu,test_piu,datum);
fclose(FID);


fprintf(global_result_file,'\n#9\nErgebnisse PIU T2:\n');
fprintf(global_result_file,'PIU\t\tNormwert\tDiskrepanz\tTest\tDatum\n');     
fprintf(global_result_file,'%2.2f\t\t82\t\t%2.2f\t\t%s\t%s\n',PIU,disc_piu,test_piu,datum);
cd(CWD);

close all;

