function spatial_res_T2()

global hdr2 img2 filenameT2 dir_results global_result_file
CWD = pwd;
%dir_results = '/home/vogelbac/Desktop/mrt_bilder/res/';
%[pathT2 nameT2 ext1 vers1]=fileparts(filenameT2);
[pathT2 nameT2 ext1]=fileparts(filenameT2);

hdr2.info.dimensions;
dim1_T2 =hdr2.info.dimensions(1);

%Interpolation
[x,y]=meshgrid(1:dim1_T2);  %Bildgr��e quadratisch dim1=dim2 (256*256)
[xi,yi]=meshgrid(1:0.1:dim1_T2);
I2(:,:,1)=interp2(x,y,double(img2(:,:,1)),xi,yi,'cubic');

bild2 = figure(3);
imagesc(img2(:,:,1));

%Segmentierung
img_seg = otsu(I2(:,:,1),2);
new_size = size(img_seg);
a1 = new_size(1);
a2 = new_size(2);
for k=1:a1;
    for l=1:a2;
        if img_seg(k,l) < 2
            img_seg(k,l) = 0;
        else
            img_seg(k,l) = 1;
        end
    end
end

 

%suche nach Ausschnitt fuer resolution insert
sumdim1 = sum(img_seg,1);
abldim1 = diff(sumdim1);
[mx1_hor loc_mx1_hor] = max(abldim1(1:round(a2/2))); %Ende roi1_hor
[mn1_hor loc_mn1_hor] = min(abldim1(1:loc_mx1_hor)); %Beginn roi1_hor
%Breite des Bereichs
RB_roi1 = loc_mx1_hor-loc_mn1_hor;
%Spalte gefunden nun die ableitung in der spalte bestimmen
ablroi1 = diff(img_seg(:,round(RB_roi1/2)+loc_mn1_hor));
%Ende Bestimmen
[mx1_vert loc_mx1_vert] = max(ablroi1(1800:a2-1));
loc_end_vert = loc_mx1_vert+1800        %Ende roi1_vert
h_roi1 = 1150;
loc_bg_vert = loc_end_vert-h_roi1 %Beginn roi_vert
loc_mn1_hor
loc_mx1_hor
roi1 = I2(loc_bg_vert:loc_end_vert,loc_mn1_hor:loc_mx1_hor,1);
roi1_size = size(roi1);
dim2_roi1 = roi1_size(2);

bild = figure(1);
imagesc(roi1);
bild1 = figure(2);
imagesc(I2);

%Definiere 3 ROIs f�r oberes, mittleres und unteres Loch-Paar
x_up = round(dim2_roi1/4)
y_up = 300;
RB_up = round(3*dim2_roi1/4)-round(dim2_roi1/4)
h_up = 240;
y_center = 540;
h_center = 230;
y_bottom = 770;
h_bottom = 200;
roi_up = roi1(y_up:y_center,x_up:round(3*dim2_roi1/4),1);
roi_center = roi1(y_center:y_bottom,x_up:round(3*dim2_roi1/4),1);
roi_bottom = roi1(y_bottom:y_bottom+h_bottom,x_up:round(3*dim2_roi1/4),1);
%Trenne oben rechts (UR) und oben links (LL)bei roi_up
roi_UR = roi_up(40:140,80:180,1);
roi_LL = roi_up(110:210,5:110,1);
%Trenne UR in 4 Spalten und betrachte den Intensitaetsverlauf der 4 Spalten von UR
roi_UR_size = size(roi_UR);
dim1_roi_UR = roi_UR_size(1);
sum1_roi_UR = sum(roi_UR,1);
[maxtab_hor_UR, mintab_hor_UR] = peakdet(sum1_roi_UR, 10);
%Detektiere alle Maxima/Minima des Intensit�tsverlaufs von den 4 Spalten
if length(maxtab_hor_UR) > 4,
    a_hor_UR = maxtab_hor_UR(2);
    b_hor_UR = maxtab_hor_UR(3);
    c_hor_UR = maxtab_hor_UR(4);
    d_hor_UR = maxtab_hor_UR(5);
elseif  length(maxtab_hor_UR) > 3,
    a_hor_UR = maxtab_hor_UR(1);
    b_hor_UR = maxtab_hor_UR(2);
    c_hor_UR = maxtab_hor_UR(3);
    d_hor_UR = maxtab_hor_UR(4);
elseif length(maxtab_hor_UR) > 2,
    a_hor_UR = maxtab_hor_UR(1);
    b_hor_UR = maxtab_hor_UR(2);
    c_hor_UR = maxtab_hor_UR(3);
    d_hor_UR = c_hor_UR+22;
elseif length(maxtab_hor_UR) > 1,
    a_hor_UR = maxtab_hor_UR(1);
    b_hor_UR = maxtab_hor_UR(2);
    c_hor_UR = b_hor_UR+22;
    d_hor_UR = c_hor_UR+22;
end
%Threshold definieren:
mean_UR = mean(mean(nonzeros(roi_UR)))
t_UR = round(0.3*mean_UR)
%Zaehle die Maxima der 4 Reihen auf UR image (zw. Maximum und Minimum muss ein Wert, der 30% der mittleren Intenstit�t entspricht) 
%und ueberpruefe,ob alle 4 L�cher detektiert werden k�nnen
[tmaxtab1_UR, tmintab1_UR] = peakdet(roi_UR(:,a_hor_UR,1), t_UR);
[tmaxtab2_UR, tmintab2_UR] = peakdet(roi_UR(:,b_hor_UR,1), t_UR);
[tmaxtab3_UR, tmintab3_UR] = peakdet(roi_UR(:,c_hor_UR,1), t_UR);
[tmaxtab4_UR, tmintab4_UR] = peakdet(roi_UR(:,d_hor_UR,1), t_UR);
nb_holes_c1_UR = length(tmaxtab1_UR)
nb_holes_c2_UR = length(tmaxtab2_UR)
nb_holes_c3_UR = length(tmaxtab3_UR)
nb_holes_c4_UR = length(tmaxtab4_UR)


%Trenne LL in 4 Reihen und betrachte den Intensitaetsverlauf der 4 Reihen
roi_LL_size = size(roi_LL);
dim1_roi_LL = roi_LL_size(1);
dim2_roi_LL = roi_LL_size(2);
sum2_roi_LL = sum(roi_LL,2);
[maxtab_ver_LL, mintab_ver_LL] = peakdet(sum2_roi_LL, 10);
%Detektiere alle Maxima/Minima des Intensit�tsverlaufs von den 4 Reihen
if length(maxtab_ver_LL) > 4,
   a_ver_LL = maxtab_ver_LL(2);
   b_ver_LL = maxtab_ver_LL(3);
   c_ver_LL = maxtab_ver_LL(4);
   d_ver_LL = maxtab_ver_LL(5);
elseif length(maxtab_ver_LL) > 3,
   a_ver_LL = maxtab_ver_LL(1);
   b_ver_LL = maxtab_ver_LL(2);
   c_ver_LL = maxtab_ver_LL(3);
   d_ver_LL = maxtab_ver_LL(4); 
elseif length(maxtab_ver_LL) > 2,
   a_ver_LL = maxtab_ver_LL(1);
   b_ver_LL = maxtab_ver_LL(2);
   c_ver_LL = maxtab_ver_LL(3);
   d_ver_LL = c_ver_LL+22;
elseif length(maxtab_ver_LL) > 1,
    a_ver_LL = maxtab_ver_LL(1);
    b_ver_LL = maxtab_ver_LL(2);
    c_ver_LL = b_ver_LL+22;
    d_ver_LL = c_ver_LL+22;
end
%Threshold definieren:
mean_LL = mean(mean(nonzeros(roi_LL)))
t_LL = round(0.3*mean_LL)
%Zaehle die Maxima der 4 Reihen auf LL image 
%und ueberpruefe,ob alle 4 L�cher detektiert werden k�nnen
[tmaxtab1_LL, tmintab1_LL] = peakdet(roi_LL(a_ver_LL,:,1), t_LL);
[tmaxtab2_LL, tmintab2_LL] = peakdet(roi_LL(b_ver_LL,:,1), t_LL);
[tmaxtab3_LL, tmintab3_LL] = peakdet(roi_LL(c_ver_LL,:,1), t_LL);
[tmaxtab4_LL, tmintab4_LL] = peakdet(roi_LL(d_ver_LL,:,1), t_LL);
nb_holes_r1_UL = length(tmaxtab1_LL)
nb_holes_r2_UL = length(tmaxtab2_LL)
nb_holes_r3_UL = length(tmaxtab3_LL)
nb_holes_r4_UL = length(tmaxtab4_LL)

%Trenne mitte rechts (CR) und mitte links (CL)bei roi_center
roi_CR = roi_center(30:130,80:175,1);
roi_CL = roi_center(100:200,15:110,1);
%Trenne CR in 4 Spalten und betrachte den Intensitaetsverlauf der 4 Spalten von CR
roi_CR_size = size(roi_CR);
dim1_roi_CR = roi_CR_size(1);
sum1_roi_CR = sum(roi_CR,1);
[maxtab_hor_CR, mintab_hor_CR] = peakdet(sum1_roi_CR, 10);
%Detektiere alle Maxima/Minima des Intensit�tsverlaufs von den 4 Spalten
if length(maxtab_hor_CR) > 4,
    a_hor_CR = maxtab_hor_CR(2);
    b_hor_CR = maxtab_hor_CR(3);
    c_hor_CR = maxtab_hor_CR(4);
    d_hor_CR = maxtab_hor_CR(5);
elseif length(maxtab_hor_CR) > 3,
    a_hor_CR = maxtab_hor_CR(1);
    b_hor_CR = maxtab_hor_CR(2);
    c_hor_CR = maxtab_hor_CR(3);
    d_hor_CR = maxtab_hor_CR(4);
elseif length(maxtab_hor_CR) > 2,
    a_hor_CR = maxtab_hor_CR(1);
    b_hor_CR = maxtab_hor_CR(2);
    c_hor_CR = maxtab_hor_CR(3);
    d_hor_CR = c_hor_CR+20;
elseif length(maxtab_hor_CR) > 1,
    a_hor_CR = maxtab_hor_CR(1);
    b_hor_CR = maxtab_hor_CR(2);
    c_hor_CR = b_hor_CR+20;
    d_hor_CR = c_hor_CR+20;
end
%Threshold definieren:
mean_CR = mean(mean(nonzeros(roi_CR)))
t_CR = round(0.3*mean_CR)
%Zaehle die Maxima der 4 Reihen auf CR image (zw. Maximum und Minimum muss ein Wert von 150 liegen) 
%und ueberpruefe,ob alle 4 L�cher detektiert werden k�nnen
[tmaxtab1_CR, tmintab1_CR] = peakdet(roi_CR(:, a_hor_CR,1), t_CR);
[tmaxtab2_CR, tmintab2_CR] = peakdet(roi_CR(:, b_hor_CR,1), t_CR);
[tmaxtab3_CR, tmintab3_CR] = peakdet(roi_CR(:, c_hor_CR,1), t_CR);
[tmaxtab4_CR, tmintab4_CR] = peakdet(roi_CR(:, d_hor_CR,1), t_CR);
nb_holes_c1_CR = length(tmaxtab1_CR)
nb_holes_c2_CR = length(tmaxtab2_CR)
nb_holes_c3_CR = length(tmaxtab3_CR)
nb_holes_c4_CR = length(tmaxtab4_CR)

%Trenne CL in 4 Reihen und betrachte den Intensitaetsverlauf der 4 Reihen
roi_CL_size = size(roi_CL);
dim2_roi_CL = roi_CL_size(2);
sum2_roi_CL = sum(roi_CL,2);
[maxtab_ver_CL, mintab_ver_CL] = peakdet(sum2_roi_CL, 10);
%Detektiere alle Maxima/Minima des Intensit�tsverlaufs von den 4 Reihen
if length(maxtab_ver_CL) > 4,
    a_ver_CL = maxtab_ver_CL(2);
    b_ver_CL = maxtab_ver_CL(3);
    c_ver_CL = maxtab_ver_CL(4);
    d_ver_CL = maxtab_ver_CL(5);
elseif length(maxtab_ver_CL) > 3,
    a_ver_CL = maxtab_ver_CL(1);
    b_ver_CL = maxtab_ver_CL(2);
    c_ver_CL = maxtab_ver_CL(3);
    d_ver_CL = maxtab_ver_CL(4);
elseif length(maxtab_ver_CL) > 2,
    a_ver_CL = maxtab_ver_CL(1);
    b_ver_CL = maxtab_ver_CL(2);
    c_ver_CL = maxtab_ver_CL(3);
    d_ver_CL = c_ver_CL+20;
elseif length(maxtab_ver_CL) > 1,
    a_ver_CL = maxtab_ver_CL(1);
    b_ver_CL = maxtab_ver_CL(2);
    c_ver_CL = b_ver_CL+20;
    d_ver_CL = c_ver_CL+20;
end
%Threshold definieren:
mean_CL = mean(mean(nonzeros(roi_CL)))
t_CL = round(0.3*mean_CL)
%Zaehle die Maxima der 4 Reihen auf CL image (zw. Maximum und Minimum muss ein Wert von 150 liegen) 
%und ueberpruefe,ob alle 4 L�cher detektiert werden k�nnen
[tmaxtab1_CL, tmintab1_CL] = peakdet(roi_CL(a_ver_CL,:,1), t_CL);
[tmaxtab2_CL, tmintab2_CL] = peakdet(roi_CL(b_ver_CL,:,1), t_CL);
[tmaxtab3_CL, tmintab3_CL] = peakdet(roi_CL(c_ver_CL,:,1), t_CL);
[tmaxtab4_CL, tmintab4_CL] = peakdet(roi_CL(d_ver_CL,:,1), t_CL);
nb_holes_r1_CL = length(tmaxtab1_CL)
nb_holes_r2_CL = length(tmaxtab2_CL)
nb_holes_r3_CL = length(tmaxtab3_CL)
nb_holes_r4_CL = length(tmaxtab4_CL)

%Trenne unten rechts (BR) und unten links (BL)bei roi_bottom
roi_BR = roi_bottom(37:137,80:175,1);
roi_BL = roi_bottom(95:195,13:112,1);
%Trenne BR in 4 Spalten und betrachte den Intensitaetsverlauf der 4 Spalten von BR
roi_BR_size = size(roi_BR);
dim1_roi_BR = roi_BR_size(1);
dim2_roi_BR = roi_BR_size(2);
sum1_roi_BR = sum(roi_BR,1);
[maxtab_hor_BR, mintab_hor_BR] = peakdet(sum1_roi_BR, 1);
%Detektiere alle Maxima/Minima des Intensit�tsverlaufs von den 4 Spalten
if length(maxtab_hor_BR) > 4,
    a_hor_BR = maxtab_hor_BR(2);
    b_hor_BR = maxtab_hor_BR(3);
    c_hor_BR = maxtab_hor_BR(4);
    d_hor_BR = maxtab_hor_BR(5);
elseif  length(maxtab_hor_BR) > 3,
    a_hor_BR = maxtab_hor_BR(1);
    b_hor_BR = maxtab_hor_BR(2);
    c_hor_BR = maxtab_hor_BR(3);
    d_hor_BR = maxtab_hor_BR(4);
elseif length(maxtab_hor_BR) > 2,
    a_hor_BR = maxtab_hor_BR(1);
    b_hor_BR = maxtab_hor_BR(2);
    c_hor_BR = maxtab_hor_BR(3);
    d_hor_BR = c_hor_BR+18;
elseif length(maxtab_hor_BR) > 1,
    a_hor_BR = maxtab_hor_BR(1);
    b_hor_BR = maxtab_hor_BR(2);
    c_hor_BR = b_hor_BR+18;
    d_hor_BR = c_hor_BR+18;
end
%Threshold definieren:
mean_BR = mean(mean(roi_BR))
t_BR = round(0.3*mean_BR)
%Zaehle die Maxima der 4 Reihen auf CR image (zw. Maximum und Minimum muss ein Wert von 150 liegen) 
%und ueberpruefe,ob alle 4 L�cher detektiert werden k�nnen
[tmaxtab1_BR, tmintab1_BR] = peakdet(roi_BR(:, a_hor_BR,1), t_BR);
[tmaxtab2_BR, tmintab2_BR] = peakdet(roi_BR(:, b_hor_BR,1), t_BR);
[tmaxtab3_BR, tmintab3_BR] = peakdet(roi_BR(:, c_hor_BR,1), t_BR);
[tmaxtab4_BR, tmintab4_BR] = peakdet(roi_BR(:, d_hor_BR,1), t_BR);
nb_holes_c1_BR = length(tmaxtab1_BR)
nb_holes_c2_BR = length(tmaxtab2_BR)
nb_holes_c3_BR = length(tmaxtab3_BR)
nb_holes_c4_BR = length(tmaxtab4_BR)

%Trenne CL in 4 Reihen und betrachte den Intensitaetsverlauf der 4 Reihen
roi_BL_size = size(roi_BL);
dim1_roi_BL = roi_BL_size(1);
dim2_roi_BL = roi_BL_size(2);
sum2_roi_BL = sum(roi_BL,2);
[maxtab_ver_BL, mintab_ver_BL] = peakdet(sum2_roi_BL, 10);
%Detektiere alle Maxima/Minima des Intensit�tsverlaufs von den 4 Reihen
if length(maxtab_ver_BL) > 4,
    a_ver_BL = maxtab_ver_BL(2);
    b_ver_BL = maxtab_ver_BL(3);
    c_ver_BL = maxtab_ver_BL(4);
    d_ver_BL = maxtab_ver_BL(5);
elseif length(maxtab_ver_BL) > 3,
    a_ver_BL = maxtab_ver_BL(1);
    b_ver_BL = maxtab_ver_BL(2);
    c_ver_BL = maxtab_ver_BL(3);
    d_ver_BL = maxtab_ver_BL(4);
elseif length(maxtab_ver_BL) > 2,
    a_ver_BL = maxtab_ver_BL(1);
    b_ver_BL = maxtab_ver_BL(2);
    c_ver_BL = maxtab_ver_BL(3);
    d_ver_BL = c_ver_BL+18;
elseif length(maxtab_ver_BL) > 1,

    a_ver_BL = maxtab_ver_BL(1);
    if(maxtab_ver_BL(1) < maxtab_ver_BL(2) -25)
    	b_ver_BL = a_ver_BL+18;
    else
    	b_ver_BL = maxtab_ver_BL(2);
    end
    c_ver_BL = b_ver_BL+18;
    d_ver_BL = c_ver_BL+18;
end

temp_size = size(roi_BL);

if d_ver_BL > temp_size(2)
    d_ver_BL = temp_size(2);
end

%Threshold definieren:
mean_BL = mean(mean(nonzeros(roi_BL)))
t_BL = round(0.3*mean_BL)
%Zaehle die Maxima der 4 Reihen auf CL image (zw. Maximum und Minimum muss ein Wert von 150 liegen) 
%und ueberpruefe,ob alle 4 L�cher detektiert werden k�nnen
[tmaxtab1_BL, tmintab1_BL] = peakdet(roi_BL(a_ver_BL,:,1), t_BL);
[tmaxtab2_BL, tmintab2_BL] = peakdet(roi_BL(b_ver_BL,:,1), t_BL);
[tmaxtab3_BL, tmintab3_BL] = peakdet(roi_BL(c_ver_BL,:,1), t_BL);
[tmaxtab4_BL, tmintab4_BL] = peakdet(roi_BL(d_ver_BL,:,1), t_BL);
nb_holes_r1_BL = length(tmaxtab1_BL)
nb_holes_r2_BL = length(tmaxtab2_BL)
nb_holes_r3_BL = length(tmaxtab3_BL)
nb_holes_r4_BL = length(tmaxtab4_BL)

if nb_holes_c1_UR >= 4 || nb_holes_c2_UR >=4 || nb_holes_c3_UR >= 4 || nb_holes_c4_UR >= 4,
    res_UR = sprintf('Aufl�sung Quadrat oben rechts ist 1.1mm')
else
    res_UR = sprintf('Aufl�sung Quadrat oben rechts schlechter als 1.1mm')
end

if nb_holes_r1_UL >= 4 || nb_holes_r2_UL >=4 || nb_holes_r3_UL >= 4 || nb_holes_r4_UL >= 4,
    res_UL = sprintf('Aufl�sung Quadrat oben links ist 1.1mm')
else
    res_UL = sprintf('Aufl�sung Quadrat oben links schlechter als 1.1mm')
end

if nb_holes_c1_CR >= 4 || nb_holes_c2_CR >=4 || nb_holes_c3_CR >= 4 || nb_holes_c4_CR >= 4,
    res_CR = sprintf('Aufl�sung Quadrat Mitte rechts ist 1mm')
else
    res_CR = sprintf('Aufl�sung Quadrat Mitte rechts schlechter als 1mm')
end

if nb_holes_r1_CL >= 4 || nb_holes_r2_CL >=4 || nb_holes_r3_CL >= 4 || nb_holes_r4_CL >= 4,
    res_CL = sprintf('Aufl�sung Quadrat Mitte links ist 1mm')
else
    res_CL = sprintf('Aufl�sung Quadrat Mitte links schlechter als 1mm')
end

if nb_holes_c1_BR >= 4 || nb_holes_c2_BR >=4 || nb_holes_c3_BR >= 4 || nb_holes_c4_BR >= 4,
    res_BR = sprintf('Aufl�sung Quadrat unten rechts ist 0.9mm')
else
    res_BR = sprintf('Aufl�sung Quadrat unten rechts schlechter als 0.9mm')
end

if nb_holes_r1_BL >= 4 || nb_holes_r2_BL >=4 || nb_holes_r3_BL >= 4 || nb_holes_r4_BL >= 4,
    res_BL = sprintf('Aufl�sung Quadrat unten links ist 0.9mm')
else
    res_BL = sprintf('Aufl�sung Quadrat unten links schlechter als 0.9mm')
end

%Visualisierung der Ergebnisse
figure(1);
set(gcf,'Color','w');
set(gcf,'numbertitle','off','Name','Spatial resolution Test');
subplot(2,2,1)
imagesc(I2(:,:,1));
colormap(gray);
colorbar();
set(gcf,'Color','w');
set(gca,'box','off');
rectangle('position',[loc_mn1_hor loc_bg_vert RB_roi1 h_roi1],'EdgeColor','b','LineWidth',2);
subplot(2,2,2)
imagesc(img_seg);
colormap(gray);
colorbar();
set(gcf,'Color','w');
set(gca,'box','off');
rectangle('position',[loc_mn1_hor loc_bg_vert RB_roi1 h_roi1],'EdgeColor','b','LineWidth',2);
subplot(2,2,3)
imagesc(roi1);
colormap(gray);
colorbar();
rectangle('position',[x_up y_up RB_up h_up],'EdgeColor','g','LineWidth',1);
rectangle('position',[x_up y_center RB_up h_center],'EdgeColor','g','LineWidth',1);
rectangle('position',[x_up y_bottom RB_up h_bottom],'EdgeColor','g','LineWidth',1);
set(gca,'box','off');
subplot(2,2,4)
imagesc(roi_up);
colormap(gray);
colorbar();

figure(2);
set(gcf,'numbertitle','off','Name','Spatial resolution: profile of CL columns');
subplot(2,2,1)
plot(roi_CL(:,a_ver_CL,1));
xlim([0 100]);
title('intensity profile first column');
subplot(2,2,2)
plot(roi_CL(:,b_ver_CL,1));
xlim([0 100]);
title('second column');
subplot(2,2,3)
plot(roi_CL(:,c_ver_CL,1));
xlim([0 100]);
title('third column');
subplot(2,2,4)
plot(roi_CL(:,d_ver_CL,1));
xlim([0 100]);
title('fourth column');

bild = figure(3);
subplot(3,2,1)
imagesc(roi_UR);
colormap(gray);
colorbar();
title('upper hole pair upper right');
set(gcf,'Color','w');
set(gca,'box','off');
line([a_hor_UR a_hor_UR],[1 dim1_roi_UR],'Color','b');
line([b_hor_UR b_hor_UR],[1 dim1_roi_UR],'Color','b');
line([c_hor_UR c_hor_UR],[1 dim1_roi_UR],'Color','b');
line([d_hor_UR d_hor_UR],[1 dim1_roi_UR],'Color','b');
subplot(3,2,2)
imagesc(roi_LL);
colormap(gray);
colorbar();
title('upper hole pair lower left');
set(gcf,'Color','w');
set(gca,'box','off');
line([1 dim2_roi_LL],[a_ver_LL a_ver_LL],'Color','b');
line([1 dim2_roi_LL],[b_ver_LL b_ver_LL],'Color','b');
line([1 dim2_roi_LL],[c_ver_LL c_ver_LL],'Color','b');
line([1 dim2_roi_LL],[d_ver_LL d_ver_LL],'Color','b');
subplot(3,2,3)
imagesc(roi_CR);
colormap(gray);
colorbar();
title('center hole pair upper right');
set(gcf,'Color','w');
set(gca,'box','off');
line([a_hor_CR a_hor_CR],[1 dim1_roi_CR],'Color','b');
line([b_hor_CR b_hor_CR],[1 dim1_roi_CR],'Color','b');
line([c_hor_CR c_hor_CR],[1 dim1_roi_CR],'Color','b');
line([d_hor_CR d_hor_CR],[1 dim1_roi_CR],'Color','b');
subplot(3,2,4)
imagesc(roi_CL);
colormap(gray);
colorbar();
title('center hole pair lower left');
set(gcf,'Color','w');
set(gca,'box','off');
line([1 dim2_roi_CL],[a_ver_CL a_ver_CL],'Color','b');
line([1 dim2_roi_CL],[b_ver_CL b_ver_CL],'Color','b');
line([1 dim2_roi_CL],[c_ver_CL c_ver_CL],'Color','b');
line([1 dim2_roi_CL],[d_ver_CL d_ver_CL],'Color','b');
subplot(3,2,5)
imagesc(roi_BR);
colormap(gray);
colorbar();
title('bottom hole pair upper right');
set(gcf,'Color','w');
set(gca,'box','off');
line([a_hor_BR a_hor_BR],[1 dim1_roi_BR],'Color','b');
line([b_hor_BR b_hor_BR],[1 dim1_roi_BR],'Color','b');
line([c_hor_BR c_hor_BR],[1 dim1_roi_BR],'Color','b');
line([c_hor_BR+18 c_hor_BR+18],[1 dim1_roi_BR],'Color','b');
subplot(3,2,6)
imagesc(roi_BL);
colormap(gray);
colorbar();
title('bottom hole pair lower left');
set(gcf,'Color','w');
set(gca,'box','off');
line([1 dim2_roi_BL],[a_ver_BL a_ver_BL],'Color','b');
line([1 dim2_roi_BL],[b_ver_BL b_ver_BL],'Color','b');
line([1 dim2_roi_BL],[c_ver_BL c_ver_BL],'Color','b');
line([1 dim2_roi_BL],[d_ver_BL d_ver_BL],'Color','b');

datefinder=findstr('201',nameT2);
datum=nameT2(datefinder:datefinder+7);
fname_result = sprintf('Resolution_Results_%s.txt',nameT2);

cd(dir_results);
%Speichern der Ergebnisse in  Textfile und png Format
resT1bild = sprintf('resolution_%s',nameT2); 
print(bild,resT1bild,'-dpng');

%Parameter speichern
FID        = fopen(fname_result,'w');
fprintf(FID,'Datum der Messung:%s\n',datum);
fprintf(FID,'Anzahl oben rechts\t\tAnzahl oben links\n');     
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c1_UR,nb_holes_r1_UL);
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c2_UR,nb_holes_r2_UL);
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c3_UR,nb_holes_r3_UL);
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c4_UR,nb_holes_r4_UL);
fprintf(FID,'%s\n',res_UR);
fprintf(FID,'%s\n',res_UL);
fprintf(FID,'Anzahl Mitte rechts\tAnzahl Mitte links\n'); 
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c1_CR,nb_holes_r1_CL);
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c2_CR,nb_holes_r2_CL);
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c3_CR,nb_holes_r3_CL);
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c4_CR,nb_holes_r4_CL);
fprintf(FID,'%s\n',res_CR);
fprintf(FID,'%s\n',res_CL);
fprintf(FID,'Anzahl unten rechts\tAnzahl unten links\n'); 
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c1_BR,nb_holes_r1_BL);
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c2_BR,nb_holes_r2_BL);
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c3_BR,nb_holes_r3_BL);
fprintf(FID,'%d\t\t\t\t\t%d\n',nb_holes_c4_BR,nb_holes_r4_BL);
fprintf(FID,'%s\n',res_BR);
fprintf(FID,'%s\n',res_BL);
fclose(FID);
cd(CWD);

fprintf(global_result_file,'\n#3\nErgebnisse Spatial Resolution T2:\n');
fprintf(global_result_file,'Anzahl oben rechts\t\tAnzahl oben links\n');     
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c1_UR,nb_holes_r1_UL);
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c2_UR,nb_holes_r2_UL);
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c3_UR,nb_holes_r3_UL);
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c4_UR,nb_holes_r4_UL);
fprintf(global_result_file,'Anzahl Mitte rechts\tAnzahl Mitte links\n'); 
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c1_CR,nb_holes_r1_CL);
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c2_CR,nb_holes_r2_CL);
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c3_CR,nb_holes_r3_CL);
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c4_CR,nb_holes_r4_CL);
fprintf(global_result_file,'Anzahl unten rechts\tAnzahl unten links\n'); 
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c1_BR,nb_holes_r1_BL);
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c2_BR,nb_holes_r2_BL);
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c3_BR,nb_holes_r3_BL);
fprintf(global_result_file,'%d\t\t\t\t\t%d\n',nb_holes_c4_BR,nb_holes_r4_BL);

close all;
