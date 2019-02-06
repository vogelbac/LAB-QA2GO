function geom_test()

global hdr img hdr1 img1 filenameT1 dir_results global_result_file

CWD = pwd;
[pathT1 nameT1 ext1]=fileparts(filenameT1);

%Localizer Informations
hdr.info.dimensions;
dim1 =hdr.info.dimensions(1)
dim2 =hdr.info.dimensions(2)

%T1 Informations
hdr1.info.dimensions;
dim1_ax =hdr1.info.dimensions(1)
dim2_ax =hdr1.info.dimensions(2)

cd(CWD);
%Segmentierung
%Localizer
%Binärbild aus dem Original machen
loc1_seg = otsu(img(:,:,1),2);
%T1
%Binärbild aus Slice 1 und 5 machen
slice1_seg = otsu(img1(:,:,1),2); 
slice5_seg = otsu(img1(:,:,5),2);

%Randbereiche auf Null setzen wegen möglicher Artefakte
slice1_seg(1:10,:) = 0;
slice1_seg(dim1_ax-10:dim1_ax,:) = 0;
slice1_seg(:,1:10) = 0;
slice1_seg(:,dim2_ax-10:dim2_ax) = 0;
slice5_seg(1:10,:) = 0;
slice5_seg(dim1_ax-10:dim1_ax,:) = 0;
slice5_seg(:,1:10) = 0;
slice5_seg(:,dim2_ax-10:dim2_ax) = 0;

for i=1:dim1,
    for j=1:dim2,
        if loc1_seg(i,j) < 2
            loc1_seg(i,j) = 0;
        else
            loc1_seg(i,j) = 1;
        end
    end
end

for k=1:dim1_ax,
    for l=1:dim2_ax,
        if slice1_seg(k,l) < 2
            slice1_seg(k,l) = 0;
        else
            slice1_seg(k,l) = 1;
        end
        if slice5_seg(k,l) < 2
            slice5_seg(k,l) = 0;
        else
            slice5_seg(k,l) = 1;
        end
    end
end

%Localizer
sumdim1 = sum(loc1_seg,1); %summieren x-Dimension
sumdim2 = sum(loc1_seg,2); %summieren y-Dimension
ph_edges1 = find(sumdim1 > 150); % 150 ist der schwellenwert ab wann im binaerbild die Ecken als Phantom erkannt werden.
cut_l = ph_edges1(1);
cut_r = ph_edges1(length(ph_edges1));

%diffx = (250/256)*(cut_r-cut_l)/2; %durch 2 wg Acqu-Matrix(512/256) siehe logfile
diffx = (cut_r-cut_l)/2; %durch 2 wg Acqu-Matrix(512/256) siehe logfile
ph_edges2 = find(sumdim2 > 0);
cut_ob = ph_edges2(1);
cut_un = ph_edges2(length(ph_edges2));
locy = (cut_un-cut_ob)/2+cut_ob;

%Criteria geometry hor:148 mm --> Diskrepanz berechnen
disc_loc_hor = abs(148-abs(diffx));
if disc_loc_hor <= 2
    action1 = sprintf('Localizer passed the test')
    test_loc_hor = sprintf('Pass');
else
    action1 = sprintf('Localizer failed the test')
    test_loc_hor = sprintf('Fail');
end


%Schicht1
sumdim1_sl2 = sum(slice1_seg,1); %summieren x-Dimension
sumdim2_sl2 = sum(slice1_seg,2); %summieren y-Dimension
ph_edges1_sl2 = find(sumdim1_sl2 > 0); %index von den Zeilen, die mehr als 1 Wert beinhalten
cutl_sl2 = ph_edges1_sl2(1); %erste Zeile, in der ein Wert auftritt (Anfang)
cutr_sl2 = ph_edges1_sl2(length(ph_edges1_sl2)); % letzte Zeile in der ein Wert auftritt (Ende)
diffx_sl2 = (250/256)*(cutr_sl2-cutl_sl2)
%diffx_sl2 = (cutr_sl2-cutl_sl2); % Ende - Anfang = Länge des Phantoms 

ph_edges2_sl2 = find(sumdim2_sl2 > 0);
cut_ob_sl2 = ph_edges2_sl2(1);
cut_un_sl2 = ph_edges2_sl2(length(ph_edges2_sl2));
diffy_sl2 = (250/256)*(cut_ob_sl2-cut_un_sl2) ;

%Criteria Geometry slice 2: 190 mm --> Diskrepanz berechnen
disc_sl2_hor = abs(190-abs(diffx_sl2));
if disc_sl2_hor <= 2,
    action2 = sprintf('T1 measurement slice 2 passed the test (horizontal line)')
    test_sl2_hor = sprintf('Pass');
else
    action2 = sprintf('T1 measurement slice 2 failed the test (horizontal line)')
    test_sl2_hor = sprintf('Fail');
end

disc_sl2_vert = abs(190-abs(diffy_sl2))
if disc_sl2_vert <= 2,
    action3 = sprintf('T1 measurement slice 2 passed the test (vertical line)')
    test_sl2_vert = sprintf('Pass');
else
    action3 = sprintf('T1 measurement slice 2 failed the test (vertical line)')
    test_sl2_vert = sprintf('Fail');   
end
%Phantommittelpunkt
ym_sl2 = (cut_un_sl2-cut_ob_sl2)/2+cut_ob_sl2; %dim1
xm_sl2 = (cutr_sl2-cutl_sl2)/2+cutl_sl2; %dim2


%Schicht5
%von oben nach unten und von links nach rechts
sumdim1_sl5 = sum(slice5_seg,1);
sumdim2_sl5 = sum(slice5_seg,2);
ph_edges1_sl5 = find(sumdim1_sl5 > 0);
cutl_sl5 = ph_edges1_sl5(1);
cutr_sl5 = ph_edges1_sl5(length(ph_edges1_sl5));
diffx_sl5 = (250/256)*(cutr_sl5-cutl_sl5)
ph_edges2_sl5 = find(sumdim2_sl5 > 0);
cut_ob_sl5 = ph_edges2_sl5(1);
cut_un_sl5 = ph_edges2_sl5(length(ph_edges2_sl5));
diffy_sl5 = (250/256)*(cut_ob_sl5-cut_un_sl5)

%Criteria Geometry slice 6: 190 mm --> Diskrepanz berechnen
disc_sl5_hor = abs(190-abs(diffx_sl5));
if disc_sl5_hor <= 2,
    action4 = sprintf('T1 measurement slice 6 passed the test (horizontal line)')
    test_sl5_hor = sprintf('Pass');
else
    action4 = sprintf('T1 measurement slice 6 failed the test (horizontal line)')
    test_sl5_hor = sprintf('Fail');
end
disc_sl5_vert = abs(190-abs(diffy_sl5));
if disc_sl5_vert <= 2,
    action5 = sprintf('T1 measurement slice 6 passed the test (vertical line)')
    test_sl5_vert = sprintf('Pass');
else
    action5 = sprintf('T1 measurement slice 6 failed the test (vertical line)')
    test_sl5_vert = sprintf('Fail');
end

%Phantommittelpunkt und Abstaende im 45�Winkel
ym_sl5 = (cut_un_sl5-cut_ob_sl5)/2+cut_ob_sl5; %dim1
xm_sl5 = (cutr_sl5-cutl_sl5)/2+cutl_sl5; %dim2
r_sl5 = round((cut_un_sl5-cut_ob_sl5)/2);
phi1_sl5=225;
phi1_sl5=phi1_sl5./180.*pi;
[xc1_sl5,yc1_sl6] = pol2cart(phi1_sl5,r_sl5);
x1_sl5 = round(xc1_sl5+xm_sl5);
y1_sl5 = round(yc1_sl6+ym_sl5);
vec1_sl5 = [x1_sl5 y1_sl5];
phi2_sl5=315;
phi2_sl5=phi2_sl5./180.*pi;
[xc2_sl5,yc2_sl5] = pol2cart(phi2_sl5,r_sl5);
x2_sl5 = round(xc2_sl5+xm_sl5);
y2_sl5 = round(yc2_sl5+ym_sl5);
vec2_sl5 = [x2_sl5 y2_sl5];
phi3_sl5=45;
phi3_sl5=phi3_sl5./180.*pi;
[xc3_sl5,yc3_sl5] = pol2cart(phi3_sl5,r_sl5);
x3_sl5 = round(xc3_sl5+xm_sl5);
y3_sl5 = round(yc3_sl5+ym_sl5);
vec3_sl5 = [x3_sl5 y3_sl5];
phi4_sl5=135;
phi4_sl5=phi4_sl5./180.*pi;
[xc4_sl5,yc4_sl5] = pol2cart(phi4_sl5,r_sl5);
x4_sl5 = round(xc4_sl5+xm_sl5);
y4_sl5 = round(yc4_sl5+ym_sl5);
vec4_sl5 = [x4_sl5 y4_sl5];

abst1_sl5 = (250/256)*norm(vec3_sl5-vec1_sl5)
abst2_sl5 = (250/256)*norm(vec2_sl5-vec4_sl5)

%Criteria Geometry slice 6: 190 mm --> Diskrepanz f�r 45Grad berechnen
disc_sl5_45r = abs(190-abs(abst1_sl5));
if disc_sl5_45r <= 2,
    action6 = sprintf('T1 measurement slice 6 passed the test (45� right)')
    test_sl5_45r = sprintf('Pass');
else
    action6 = sprintf('T1 measurement slice 6 failed the test (45� right)')
    test_sl5_45r = sprintf('Fail');
end

%Criteria Geometry slice 6: 190 mm --> Diskrepanz f�r 45Grad berechnen
disc_sl5_45l = abs(190-abs(abst2_sl5));
if disc_sl5_45l <= 2,
    action7 = sprintf('T1 measurement slice 6 passed the test (45� left)')
    test_sl5_45l = sprintf('Pass');
else
    action7 = sprintf('T1 measurement slice 6 failed the test (45� left)')
    test_sl5_45l = sprintf('Fail');
end

%Visualisierung der Ergebnisse
bild = figure(1);
set(gcf,'numbertitle','off','Name','Test Geometrie');
set(gcf,'Color','w');
%plot oben links
subplot(3,2,1)
imagesc(img(:,:,1)); 
%Greyfield
colormap(gray);
%plot oben rechts
subplot(3,2,2)
imagesc(loc1_seg);
colormap(gray);
line([cut_l cut_r],[locy locy],'Color','b','LineWidth',2);
%plot mitte links
subplot(3,2,3)
imagesc(img1(:,:,1)); 
colormap(gray);
%plot mitte rechts
subplot(3,2,4)
imagesc(slice1_seg);
colormap(gray);
set(gca,'XLim',[1 256]);
set(gca,'YLim',[1 256]);
line([xm_sl2 xm_sl2],[cut_ob_sl2 cut_un_sl2],'Color','b','LineWidth',2);
line([cutl_sl2 cutr_sl2],[ym_sl2 ym_sl2],'Color','b','LineWidth',2);
%plot unten links
subplot(3,2,5)
imagesc(img1(:,:,5)); 
colormap(gray);
%plot unten rechts
subplot(3,2,6);
imagesc(slice5_seg);
colormap(gray);
set(gca,'XLim',[1 256]);
set(gca,'YLim',[1 256]);
line([xm_sl5 xm_sl5],[cut_ob_sl5 cut_un_sl5],'Color','b','LineWidth',2);
line([cutl_sl5 cutr_sl5],[ym_sl5 ym_sl5],'Color','b','LineWidth',2);
line([x1_sl5 x3_sl5],[y1_sl5 y3_sl5],'Color','b','LineWidth',2);
line([x2_sl5 x4_sl5],[y2_sl5 y4_sl5],'Color','b','LineWidth',2);

%runtime = datestr(now,'dd-mmm-yyyy');
datefinder=findstr('201',nameT1);
datum=nameT1(datefinder:datefinder+7);

%Speichern der Ergebnisse in  Textfile und png Format
cd(dir_results);
%Bild speichern
set(bild, 'PaperUnits', 'centimeter', ...
   'PaperPosition', [0, 0, 18, 14], ...
   'PaperSize', [18, 14]);
geombild = sprintf('geometry_%s',nameT1); 
print( gcf, '-dpng', geombild );

fname_result = sprintf('Geometry_Results_%s.txt',nameT1);
%Parameter speichern
FID        = fopen(fname_result,'w');
fprintf(FID,'Messung:%s\n',nameT1);
fprintf(FID,'Ergebnisse:\n');
fprintf(FID,'Parameter\tL�nge(mm)\tNormwert\tFehler(mm)\tDatum\t\tTest\n');     
fprintf(FID,'localizer:\t%2.2f\t\t148\t\t%2.2f\t%s\t%s\n',abs(diffx),disc_loc_hor,datum,test_loc_hor);
fprintf(FID,'T1_sl1_hor:%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(diffx_sl2),disc_sl2_hor,datum,test_sl2_hor);
fprintf(FID,'T1_sl1_ver:%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(diffy_sl2),disc_sl2_vert,datum,test_sl2_vert);
fprintf(FID,'T1_sl5_hor:%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(diffx_sl5),disc_sl5_hor,datum,test_sl5_hor);
fprintf(FID,'T1_sl5_ver:%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(diffy_sl5),disc_sl5_vert,datum,test_sl5_vert);
fprintf(FID,'T1_sl5_+45d:%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(abst1_sl5),disc_sl5_45r,datum,test_sl5_45r);
fprintf(FID,'T1_sl5_-45d:%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(abst2_sl5),disc_sl5_45l,datum,test_sl5_45l);
fclose(FID);


fprintf(global_result_file,'Messung:%s\n',nameT1);
fprintf(global_result_file,'#1\nErgebnisse Geometrie Test:\n');
fprintf(global_result_file,'Parameter\tL�nge(mm)\tNormwert\tFehler(mm)\tDatum\t\tTest\n');     
fprintf(global_result_file,'localizer\t%2.2f\t\t148\t\t%2.2f\t%s\t%s\n',abs(diffx),disc_loc_hor,datum,test_loc_hor);
fprintf(global_result_file,'T1_sl1_hor\t%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(diffx_sl2),disc_sl2_hor,datum,test_sl2_hor);
fprintf(global_result_file,'T1_sl1_ver\t%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(diffy_sl2),disc_sl2_vert,datum,test_sl2_vert);
fprintf(global_result_file,'T1_sl5_hor\t%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(diffx_sl5),disc_sl5_hor,datum,test_sl5_hor);
fprintf(global_result_file,'T1_sl5_ver\t%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(diffy_sl5),disc_sl5_vert,datum,test_sl5_vert);
fprintf(global_result_file,'T1_sl5_+45d\t%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(abst1_sl5),disc_sl5_45r,datum,test_sl5_45r);
fprintf(global_result_file,'T1_sl5_-45d\t%2.2f\t\t190\t\t%2.2f\t%s\t%s\n',abs(abst2_sl5),disc_sl5_45l,datum,test_sl5_45l);

cd(CWD);


