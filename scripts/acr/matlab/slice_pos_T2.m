function slice_pos_T2()

global hdr2 img2 filenameT2 dir_results global_result_file

CWD = pwd;
[pathT2 nameT2 ext1]=fileparts(filenameT2);
hdr2.info.dimensions;
dim1_T2 =hdr2.info.dimensions(1);

%Interpolation
[x,y]=meshgrid(1:dim1_T2);  % %Bildgr��e quadratisch dim1=dim2
[xi,yi]=meshgrid(1:0.25:dim1_T2);
I2(:,:,1)=interp2(x,y,double(img2(:,:,1)),xi,yi,'cubic');
I12(:,:,1) = interp2(x,y,double(img2(:,:,11)),xi,yi,'cubic');

img_seg = otsu(I2(:,:,1),2);
new_size = size(img_seg);
a1 = new_size(1);
a2 = new_size(2);
for k=1:a1,
    for l=1:a2,
        if img_seg(k,l) < 2
            img_seg(k,l) = 0;
        else
            img_seg(k,l) = 1;
        end
    end
end

%Randbereiche auf Null setzen wegen m�glicher Artefakte
img_seg(1:20,:) = 0;
img_seg(a1-20:a1,:) = 0;
img_seg(:,1:20) = 0;
img_seg(:,a2-20:a2) = 0;

%Auschnitt w�hlen fuer bars
sumdim1 = sum(img_seg,1);
sumdim2 = sum(img_seg,2);
ph_edges1 = find(sumdim1 > 0);
cutre = ph_edges1(length(ph_edges1)) %rechts
ph_edges2 = find(sumdim2 > 0);
cutun = ph_edges2(length(ph_edges2)) %unten
y1 = ceil(cutun/2);
y2 = floor(y1+150);
x2 = floor(cutre+10);
x1 = ceil(x2 - 200);
roi_bar = I2(y1:y2,x1:x2,1);
roi_size = size(roi_bar);
dim1_bar = roi_size(1);
dim2_bar = roi_size(2);

%Berechne Mittelwert von roi_bar und fuehre damit Intensitaetsanpassung
%durch
mean_bar = mean(mean(roi_bar))
for i = 1:dim1_bar,
    for j = 1:dim2_bar,
        if roi_bar(i,j,1) >= round(mean_bar);
            roi_bar(i,j,1) = mean_bar;
        end
    end
end

%Segementieren, sodass bars =1, Rest =0
roi_seg = otsu(roi_bar,2);
roi_size = size(roi_seg);
b1 = roi_size(1);
b2 = roi_size(2);
for k=1:b1,
    for l=1:b2,
        if roi_seg(k,l) < 2
            roi_seg(k,l) = 1;
        else
            roi_seg(k,l) = 0;
        end
    end
    roi_seg(k,b2-40:b2) = 0;
end
%Berechne obere und untere Kante der beiden Balken und trenne die Balken
%voneinander
roicut = sum(roi_seg,2);
%roi_edge = find(roicut > 0);
roi_edge = find(roicut > 20);
bar_ob = roi_edge(1)
bar_un = roi_edge(length(roi_edge))
bar_center = round((bar_un-bar_ob)/2+bar_ob);
for l = 1:b2,
    roi_seg(bar_center-2:bar_center+2,l,1) = 0;
end

%Differenz zwischen den balken berechnen (mittlere Laenge der Balken
%berechnen)
sum1 = sum(roi_seg,2);
abl1 = diff(sum1);
mx_plot = max(abl1);
mn_plot = min(abl1);
%[maxtab mintab] = peakdet(abl1,30)
[maxtab mintab] = peakdet(abl1,20)
bar1_ce = round((mintab(1)-maxtab(1))/2+maxtab(1))
bar2_ce = round((mintab(2)-maxtab(2))/2+maxtab(2))
Lbar1 = sum(roi_seg(bar1_ce,:),2)
Lbar2 = sum(roi_seg(bar2_ce,:),2)
diffbar = abs(Lbar2-Lbar1)/4
%Kriterium: Differenz sollte 0 +/-5mm sein
if diffbar <= 5,
    action = sprintf('Test bestanden: Differenz Schicht 2 betr�gt %2.2f',diffbar)
    test_sl_pos = sprintf('Pass');
else
    action = sprintf('Test nicht bestanden: Differenz Schicht 2 betr�gt %2.2f',diffbar)
    test_sl_pos = sprintf('Fail');
end

%Positionen bestimmen zum Einzeichnen der Laengen
posbar1 = find(roi_seg(bar1_ce,:) > 0);
posli = posbar1(1);
posre = posbar1(length(posbar1))+1;
posbar2 = find(roi_seg(bar2_ce,:) > 0);
posli2 = posbar2(1);
posre2 = posbar2(length(posbar2))+1;

%%%%%%Differenz zwischen den bars bestimmen fuer Slice12
%Segmentierung
img_seg12 = otsu(I12(:,:,1),2);
new_size12 = size(img_seg12);
a1_12 = new_size12(1);
a2_12 = new_size12(2);
for k=1:a1_12,
    for l=1:a2_12,
        if img_seg12(k,l) < 2
            img_seg12(k,l) = 0;
        else
            img_seg12(k,l) = 1;
        end
    end
end
%Auschnitt w�hlen fuer die Balken
sumdim1_12 = sum(img_seg12,1);
sumdim2_12 = sum(img_seg12,2);
ph_edges1_12 = find(sumdim1_12 > 0);
cutre12 = ph_edges1_12(length(ph_edges1_12)); %rechts
ph_edges2_12 = find(sumdim2_12 > 0);
cutun12 = ph_edges2_12(length(ph_edges2_12)); %unten
y1_12 = ceil(cutun12/2);
y2_12 = floor(y1_12+150);
x2_12 = floor(cutre12+10);
x1_12 = ceil(x2_12 - 200);
roi_bar12 = I12(y1_12:y2_12,x1_12:x2_12,1);
roi_size = size(roi_bar12);
dim1_bar12 = roi_size(1);
dim2_bar12 = roi_size(2);
%Berechne Mittelwert von roi_th und fuehre damit Intensitaetsanpassung
%durch
mean_bar12 = mean(mean(roi_bar12))
for i = 1:dim1_bar12,
    for j = 1:dim2_bar12,
        if roi_bar12(i,j,1) >= round(mean_bar12);
            roi_bar12(i,j,1) = mean_bar12;
        end
    end
end

%Segementieren, sodass bars =1, Rest =0
roi_seg12 = otsu(roi_bar12,2);
roi_size12 = size(roi_seg12);
b1_12 = roi_size12(1);
b2_12 = roi_size12(2);
for k=1:b1_12,
    for l=1:b2_12,
        if roi_seg12(k,l) < 2
            roi_seg12(k,l) = 1;
        else
            roi_seg12(k,l) = 0;
        end
    end
    roi_seg12(k,b2-40:b2) = 0;
end
%Berechne obere und untere Kante der beiden Balken und trenne die Balken
%voneinander
roicut12 = sum(roi_seg12,2);
%roi_edge12 = find(roicut12 > 0);
roi_edge12 = find(roicut12 > 20);
bar_ob12 = roi_edge12(1)
bar_un12 = roi_edge12(length(roi_edge12))
bar_center12 = round((bar_un12-bar_ob12)/2+bar_ob12);
for l = 1:b2_12,
    roi_seg12(bar_center12-2:bar_center12+2,l,1) = 0;
end

%Differenz zwischen den bars berechnen 
sum1_12 = sum(roi_seg12,2);
abl1_12 = diff(sum1_12);
%[maxtab12 mintab12] = peakdet(abl1_12,30);
[maxtab12 mintab12] = peakdet(abl1_12,20);
bar1_ce12 = round((mintab12(1)-maxtab12(1))/2+maxtab12(1));
bar2_ce12 = round((mintab12(2)-maxtab12(2))/2+maxtab12(2));
Lbar1_12 = sum(roi_seg12(bar1_ce12,:),2)
Lbar2_12 = sum(roi_seg12(bar2_ce12,:),2)
diffbar12 = abs(Lbar2_12-Lbar1_12)/4;
%Kriterium: Differenz sollte 0 +/-5mm sein
if diffbar12 <= 5,
    action12 = sprintf('Test bestanden: Differenz Schicht 12 betr�gt %2.2f',diffbar12)
    test_sl12_pos = sprintf('Pass');
else
    action12 = sprintf('Test nicht bestanden: Differenz Schicht 12 betr�gt %2.2f',diffbar12)
    test_sl12_pos = sprintf('Fail');
end

%Positionen bestimmen zum Einzeichnen der Laengen
posbar1_12 = find(roi_seg12(bar1_ce12,:) > 0);
posli_12 = posbar1_12(1);
posre_12 = posbar1_12(length(posbar1_12));
posbar2_12 = find(roi_seg12(bar2_ce12,:) > 0);
posli2_12 = posbar2_12(1);
posre2_12 = posbar2_12(length(posbar2_12));

figure(5);
set(gcf,'Color','w');
plot(abl1,'LineWidth',2);
line([bar1_ce bar1_ce],[mn_plot-50 mx_plot+50],'Color','r','LineWidth',2);
line([bar2_ce bar2_ce],[mn_plot-50 mx_plot+50],'Color','g','LineWidth',2);

bild = figure(1);
set(gcf,'numbertitle','off','Name','Slice position test');
set(gcf,'Color','w');
subplot(2,3,1)
imagesc(I2(:,:,1));
colormap(gray);
colorbar();
rectangle('position',[x1 y1 200 150],'Edgecolor','b');
subplot(2,3,2)
imagesc(roi_bar);
colormap(gray);
colorbar();
subplot(2,3,3)
imagesc(roi_seg);
colormap(gray);
line([posli posre],[bar1_ce bar1_ce],'Color','r','LineWidth',2);
line([posli2 posre2],[bar2_ce bar2_ce],'Color','g','LineWidth',2);
subplot(2,3,4)
imagesc(I12(:,:,1));
colormap(gray);
colorbar();
rectangle('position',[x1_12 y1_12 200 150],'Edgecolor','b');
subplot(2,3,5)
imagesc(roi_bar12);
colormap(gray);
colorbar();
subplot(2,3,6)
imagesc(roi_seg12);
colormap(gray);
line([posli_12 posre_12],[bar1_ce12 bar1_ce12],'Color','r','LineWidth',2);
line([posli2_12 posre2_12],[bar2_ce12 bar2_ce12],'Color','g','LineWidth',2);

datefinder=findstr('201',nameT2);
datum=nameT2(datefinder:datefinder+7);

%Speichern der Ergebnisse in  Textfile und png Format
cd(dir_results);
%Bild speichern
set(bild, 'PaperUnits', 'centimeter', ...
   'PaperPosition', [0, 0, 18, 10], ...
   'PaperSize', [18, 10]);
sl_pos_bild = sprintf('Schichtposition_%s',nameT2); 
print( gcf, '-dpng', sl_pos_bild );

fname_result = sprintf('Schichtposition_T2_Results.txt');
%Parameter speichern
FID        = fopen(fname_result,'a+');
fprintf(FID,'Messung:%s\n',nameT2);
fprintf(FID,'Ergebnisse:\n');
fprintf(FID,'Schicht 2\tTest\tSchicht 12\tTest\tDatum\n');     
fprintf(FID,'%2.2f\t\t%s\t%2.2f\t\t%s\t%s\n',diffbar,test_sl_pos,diffbar12,test_sl12_pos,datum);
fclose(FID);


fprintf(global_result_file,'\n#7\nErgebnisse Slice Position T2:\n');
fprintf(global_result_file,'Schicht 2\tTest\tSchicht 12\tTest\tDatum\n');     
fprintf(global_result_file,'%2.2f\t\t%s\t%2.2f\t\t%s\t%s\n',diffbar,test_sl_pos,diffbar12,test_sl12_pos,datum);
cd(CWD);

close all;


