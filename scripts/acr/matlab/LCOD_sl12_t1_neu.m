function LCOD_sl12_t1_neu()
global img1 dim1_T1 dim2_T1 score_sl12_t1 dir_results

%Bestimmung der Phantomgrenzen/-kanten (Segmentierung mit Otsu s Methode)
IDX = otsu(img1(:,:,11),2);
for i=1:dim1_T1,
    for j=1:dim2_T1,
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
cutli = ph_edges1(1) %links
cutre = ph_edges1(length(ph_edges1)) %rechts
ph_edges2 = find(sumdim2 > 0);
cutob = ph_edges2(1) %oben
cutun = ph_edges2(length(ph_edges2)) %unten
%Phantommittelpunkt
ym = (cutun-cutob)/2+cutob; %dim1_ax
xm = (cutre-cutli)/2+cutli; %dim2_ax
center = [xm ym]

ug1 = 55;
og1 = 100;
ug2 = 130;
og2 = 180;
%Region fuer Low Contrast Objekt sheet finden
abldim1 = diff(sumdim1);
[mx1_1_li loc_mx1_1_li] = max(abldim1(ug1:og1)); 
[mx1_2_li loc_mx1_2_li] = max(abldim1(ug1:og1)(abldim1(ug1:og1)~=max(abldim1(ug1:og1))));

[mn1_1_li loc_mn1_1_li] = min(abldim1(ug1:og1)); 
[mn1_2_li loc_mn1_2_li] = min(abldim1(ug1:og1)(abldim1(ug1:og1)~=min(abldim1(ug1:og1))));

[mx1_1_re loc_mx1_1_re] = max(abldim1(ug2:og2)); 
[mx1_2_re loc_mx1_2_re] = max(abldim1(ug2:og2)(abldim1(ug2:og2)~=max(abldim1(ug2:og2))));

[mn1_1_re loc_mn1_1_re] = min(abldim1(ug2:og2)); 
[mn1_2_re loc_mn1_2_re] = min(abldim1(ug2:og2)(abldim1(ug2:og2)~=min(abldim1(ug2:og2))));

mx1_li  = abldim1(ug1+max(loc_mx1_1_li,loc_mx1_2_li));
loc_mx1_li =ug1+max(loc_mx1_1_li,loc_mx1_2_li);

mn1_li = abldim1(ug1+min(loc_mn1_1_li,loc_mn1_2_li));
loc_mn1_li = ug1+min(loc_mn1_1_li,loc_mn1_2_li);

mx1_re = abldim1(ug2+max(loc_mx1_1_re,loc_mx1_2_re));
loc_mx1_re = ug2+max(loc_mx1_1_re,loc_mx1_2_re);

mn1_re = abldim1(ug2+min(loc_mn1_1_re,loc_mn1_2_re));
loc_mn1_re = ug2+min(loc_mn1_1_re,loc_mn1_2_re);

pos1li = loc_mn1_li;
pos2li = loc_mx1_li;
pos1re = loc_mn1_re;
pos2re = loc_mx1_re;

ug3 = 40;
og3 = 110;
ug4 = 140;
og4 = 200;
abldim2 = diff(sumdim2);
[mx2_1_ob loc_mx2_1_ob] = max(abldim2(ug3:og3)); 
[mx2_2_ob loc_mx2_2_ob] = max(abldim2(ug3:og3)(abldim2(ug3:og3)~=max(abldim2(ug3:og3))));

[mn2_1_ob loc_mn2_1_ob] = min(abldim2(ug3:og3)); 
[mn2_2_ob loc_mn2_2_ob] = min(abldim2(ug3:og3)(abldim2(ug3:og3)~=min(abldim2(ug3:og3))));

[mx2_1_un loc_mx2_1_un] = max(abldim2(ug4:og4)); 
[mx2_2_un loc_mx2_2_un] = max(abldim2(ug4:og4)(abldim2(ug4:og4)~=max(abldim2(ug4:og4))));

[mn2_1_un loc_mn2_1_un] = min(abldim2(ug4:og4)); 
[mn2_2_un loc_mn2_2_un] = min(abldim2(ug4:og4)(abldim2(ug4:og4)~=min(abldim2(ug4:og4))));

mx2_ob = abldim2(ug3+max(loc_mx2_1_ob,loc_mx2_2_ob));
loc_mx2_ob = ug3+max(loc_mx2_1_ob,loc_mx2_2_ob);

mn2_ob = abldim2(ug3+min(loc_mn2_1_ob,loc_mn2_2_ob));
loc_mn2_ob = ug3+min(loc_mn2_1_ob,loc_mn2_2_ob);

mx2_un = abldim2(ug4+max(loc_mx2_1_un,loc_mx2_2_un));
loc_mx2_un = ug4+max(loc_mx2_1_un,loc_mx2_2_un);

mn2_un = abldim2(ug4+min(loc_mn2_1_un,loc_mn2_2_un));
loc_mn2_un = ug4+min(loc_mn2_1_un,loc_mn2_2_un);

pos1ob = loc_mn2_ob;
pos2ob = loc_mx2_ob;
pos1un = loc_mn2_un;
pos2un = loc_mx2_un;

cc_list= [pos1re-pos2li,pos1un-pos2ob];
[val_cc ,loc_cc] = max(cc_list);
if loc_cc == 1
	pos1un = pos2ob+val_cc;
else
	pos1re = pos2li+val_cc;
end

%Objekt sheet Mittelpunkt und Kreisflaeche bestimmen
ym1 = (pos1un-pos2ob)/2+pos2ob %dim1
xm1 = (pos1re-pos2li)/2+pos2li %dim2
r_vert = (pos1un-pos2ob)/2
r_horiz = (pos1re -pos2li)/2
r_best = min(r_vert,r_horiz)
RB = (pos1re-pos2li);
cc = [xm1 ym1];
phi=1:1:360;
phi=phi./180.*pi;
[xtmp1,ytmp1] = pol2cart(phi,r_best);
x_circle1=xtmp1+xm1;
y_circle1=ytmp1+ym1;
x_circle2=xtmp1+xm;
y_circle2=ytmp1+ym;


%Abstand von allen Bildpunkten zum Kreismittelpunkt berechen,um nur die
%Pixel,die innerhalb des Kreises liegen zu finden
%for k =1:dim2_T1
%    mask(:,k) = 1000;
%%end
%for l =1:dim1_T1
%    mask(l,:) = 1000;
%end
mask(1:dim1_T1,1:dim2_T1)=1000;

for column = pos2ob:pos1un,
    for row = pos2li:pos1re,
        vec_xy = [row column];
        abst(row) = norm(cc-vec_xy);
    end
    pos_row = find(0< abst(:) & round(abst(:)) <= round(r_best));
    pos_row_dim = length(pos_row);
    if pos_row_dim > 0    
	dim2_circle = pos_row(1):pos_row(pos_row_dim);
	im_circle = img1(column,dim2_circle,11);
	mask(column,dim2_circle)=1; 
    end 
end
%Werte ausserhalb des Kreises auf Null setzen
for j=1:dim1_T1,
        for k=1:dim2_T1,
            if mask(j,k)~=1
                mask(j,k)=0;
            end
        end
end
Objs(:,:,1) = img1(:,:,11).*mask(:,:);
imsheet_nothresh(:,:,1) = Objs(pos2ob:pos1un,pos2li:pos1re,1);

%Schwellenwert fuer Intensitaetsanpassung festlegen
mw_imsheet = mean(mean(nonzeros(imsheet_nothresh)))
mn_imsheet = min(min(nonzeros(imsheet_nothresh)))
mx_imsheet = max(max(nonzeros(imsheet_nothresh)))
if mn_imsheet > 110
 t_sl = mx_imsheet/10-mn_imsheet
else
    t_sl =20;
end
if t_sl > 0
    t_sl = t_sl;
else
    t_sl = 20;
end

thresh = mw_imsheet-300
for i = 1:dim1_T1,
    for j = 1:dim2_T1,
        if mask(i,j)==0
            Objs(i,j,1) = thresh;
        end
        if Objs(i,j,1) <= thresh
           Objs(i,j,1) = thresh;
        end
    end
end
imsheet(:,:,1) = Objs(pos2ob:pos1un,pos2li:pos1re,1);

%Winkelzuordnung fuer Intensitaetsprofile festlegen
%fuer jedes Kreistriplett werden 11 Pfade in 1Grad-Schritten festgelegt
% erstes Kreistriplett
phi_n = 1;
for phi1 = 21:31
    phi1=phi1./180.*pi;
    for rn = 1:round(r_best)        
        [xc1,yc1] = pol2cart(phi1,rn);
        a1x(rn,phi_n) = xc1+r_best;
        b1y(rn,phi_n) = yc1+r_best;
        A1(rn,phi_n) = imsheet(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A1)-1
    A1max(i) = max(A1(i,:));
end

%Background Approximation
xi = 3:length(A1)-1;
p1 = polyfit(xi,A1max(3:end),4);
p1_bg = polyval(p1,xi);
f1_bg =p1_bg-50;
B1 = A1max(3:end)-f1_bg;
index = B1<0;
B1(index) = 0;
B1(1:3) = 0;
B1(end) = 0;

%zweites Kreistriplett
%phi2=63;
phi_n = 1;
for phi2 = 55:65
    phi2=phi2./180.*pi;
    for rn = 1:round(r_best)        
        [xc2,yc2] = pol2cart(phi2,rn);
        a2x(rn,phi_n) = xc2+r_best;
        b2y(rn,phi_n) = yc2+r_best;
        A2(rn,phi_n) = imsheet(round(a2x(rn,phi_n)),round(b2y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A2)-1
    A2max(i) = max(A2(i,:));
end

%Background Approximation
p2 = polyfit(xi,A2max(3:end),4);
p2_bg = polyval(p2,xi);
f2_bg = p2_bg-60;
B2 = A2max(3:end)-f2_bg;
index = B2<0;
B2(index) = 0;
B2(1:3) = 0;
B2(end) = 0;

%drittes Kreistriplett
%phi3=99;
phi_n = 1;
for phi3 = 91:101
    phi3=phi3./180.*pi;
    for rn = 1:round(r_best)        
        [xc3,yc3] = pol2cart(phi3,rn);
        a3x(rn,phi_n) = xc3+r_best;
        b3y(rn,phi_n) = yc3+r_best;
        A3(rn,phi_n) = imsheet(round(a3x(rn,phi_n)),floor(b3y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A3)-1
    A3max(i) = max(A3(i,:));
end

%Background Approximation
p3 = polyfit(xi,A3max(3:end),4);
p3_bg = polyval(p3,xi);
f3_bg = p3_bg-40;
B3 = A3max(3:end)-f3_bg;
index = B3<0;
B3(index) = 0;
B3(1:3) = 0;
B3(end) = 0;

%viertes Kreistriplett
%phi4 = 35;
phi_n = 1;
for phi4 = 128:138
    phi4=phi4./180.*pi;
    for rn = 1:round(r_best)        
        [xc4,yc4] = pol2cart(phi4,rn);
        a4x(rn,phi_n) = xc4+r_best;
        b4y(rn,phi_n) = yc4+r_best;
        A4(rn,phi_n) = imsheet(round(a4x(rn,phi_n)),round(b4y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A4)-1
    A4max(i) = max(A4(i,:));
end

%Background Approximation
p4 = polyfit(xi,A4max(3:end),4);
p4_bg = polyval(p4,xi);
f4_bg = p4_bg-25;
B4 = A4max(3:end)-f4_bg;
index = B4<0;
B4(index) = 0;
B4(1:3) = 0;
B4(end) = 0;

%fuenftes Kreistriplett
phi_n = 1;
for phi5 = 165:175
    phi5=phi5./180.*pi;
    for rn = 1:round(r_best)        
        [xc5,yc5] = pol2cart(phi5,rn);
        a5x(rn,phi_n) = xc5+r_best;
        b5y(rn,phi_n) = yc5+r_best;
        A5(rn,phi_n) = imsheet(ceil(abs(a5x(rn,phi_n))),round(b5y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A5)-1
    A5max(i) = max(A5(i,:));
end

%Background Approximation
p5 = polyfit(xi,A5max(3:end),4);
p5_bg = polyval(p5,xi);
f5_bg = p5_bg-25;
B5 = A5max(3:end)-f5_bg;
index = B5<0;
B5(index) = 0;
B5(1:3) = 0;
B5(end) = 0;

%sechstes Kreistriplett
phi_n = 1;
for phi6 = 202:212
    phi6=phi6./180.*pi;
    for rn = 1:round(r_best)        
        [xc6,yc6] = pol2cart(phi6,rn);
        a6x(rn,phi_n) = xc6+r_best;
        b6y(rn,phi_n) = yc6+r_best;
        A6(rn,phi_n) = imsheet(round(a6x(rn,phi_n)),round(b6y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A6)-1
    A6max(i) = max(A6(i,:));
end
%Background Approximation
p6 = polyfit(xi,A6max(3:end),4);
p6_bg = polyval(p6,xi);
f6_bg = p6_bg-20;
B6 = A6max(3:end)-f6_bg;
index = B6<0;
B6(index) = 0;
B6(1:3) = 0;
B6(end) = 0;

%siebtes Kreistriplett
phi_n = 1;
for phi7 = 239:249
    phi7=phi7./180.*pi;
    for rn = 1:round(r_best)        
        [xc7,yc7] = pol2cart(phi7,rn);
        a7x(rn,phi_n) = xc7+r_best;
        b7y(rn,phi_n) = yc7+r_best;
        A7(rn,phi_n) = imsheet(round(a7x(rn,phi_n)),round(b7y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A7)-1
    A7max(i) = max(A7(i,:));
end
%Background Approximation
p7 = polyfit(xi,A7max(3:end),4);
p7_bg = polyval(p7,xi);
f7_bg = p7_bg-20;
B7 = A7max(3:end)-f7_bg;
index = B7<0;
B7(index) = 0;
B7(1:3) = 0;
B7(end) = 0;

%achtes Kreistriplett
phi_n = 1;
for phi8 = 276:286
    phi8=phi8./180.*pi;
    for rn = 1:round(r_best)        
        [xc8,yc8] = pol2cart(phi8,rn);
        a8x(rn,phi_n) = xc8+r_best;
        b8y(rn,phi_n) = yc8+r_best;
        A8(rn,phi_n) = imsheet(round(a8x(rn,phi_n)),ceil(abs((b8y(rn,phi_n)))),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A8)-1
    A8max(i) = max(A8(i,:));
end
%Background Approximation
p8 = polyfit(xi,A8max(3:end),4);
p8_bg = polyval(p8,xi);
f8_bg = p8_bg-20;
B8 = A8max(3:end)-f8_bg;
index = B8<0;
B8(index) = 0;
B8(1:3) = 0;
B8(end) = 0;

%neuntes Kreistriplett
phi_n = 1;
for phi9 = 311:321
    phi9=phi9./180.*pi;
    for rn = 1:round(r_best)        
        [xc9,yc9] = pol2cart(phi9,rn);
        a9x(rn,phi_n) = xc9+r_best;
        b9y(rn,phi_n) = yc9+r_best;
        A9(rn,phi_n) = imsheet(ceil(abs(a9x(rn,phi_n))),ceil(abs((b9y(rn,phi_n)))),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A9)-1
    A9max(i) = max(A9(i,:));
end
%Background Approximation
p9 = polyfit(xi,A9max(3:end),4);
p9_bg = polyval(p9,xi);
f9_bg = p9_bg-30;
B9 = A9max(3:end)-f9_bg;
index = B9<0;
B9(index) = 0;
B9(1:3) = 0;
B9(end) = 0;

%zehntes Kreistriplett
phi_n = 1;
for phi10 = 346:356
    phi10 =phi10./180.*pi;
    for rn = 1:round(r_best)        
        [xc10,yc10] = pol2cart(phi10,rn);
        a10x(rn,phi_n) = xc10+r_best;
        b10y(rn,phi_n) = yc10+r_best;
        A10(rn,phi_n) = imsheet(round(abs(a10x(rn,phi_n))),round(abs((b10y(rn,phi_n)))),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A10)-1
    A10max(i) = max(A10(i,:));
end
%Background Approximation
p10 = polyfit(xi,A10max(3:end),4);
p10_bg = polyval(p10,xi);
f10_bg = p10_bg-30;
B10 = A10max(3:end)-f10_bg;
index = B10<0;
B10(index) = 0;
B10(1:3) = 0;
B10(end) = 0;

figure(4);
set(gcf,'Color','w');
imagesc(imsheet(:,:,1));
colormap(gray);
colorbar();

f=figure(5);
set(gcf,'Color','w');
imagesc(imsheet(:,:,1));
colormap(gray);
colorbar();
for phi_n = 1:11 
     line([a1x(round(r_best),phi_n) r_best],...
          [b1y(round(r_best),phi_n) r_best],'Color','b');
     line([a2x(round(r_best),phi_n) r_best],...
          [b2y(round(r_best),phi_n) r_best],'Color','b');
     line([a3x(round(r_best),phi_n) r_best],...
          [b3y(round(r_best),phi_n) r_best],'Color','b');
     line([a4x(round(r_best),phi_n) r_best],...
          [b4y(round(r_best),phi_n) r_best],'Color','b');
     line([a5x(round(r_best),phi_n) r_best],...
          [b5y(round(r_best),phi_n) r_best],'Color','b');
     line([a6x(round(r_best),phi_n) r_best],...
          [b6y(round(r_best),phi_n) r_best],'Color','b');
     line([a7x(round(r_best),phi_n) r_best],...
          [b7y(round(r_best),phi_n) r_best],'Color','b');
     line([a8x(round(r_best),phi_n) r_best],...
          [b8y(round(r_best),phi_n) r_best],'Color','b');
     line([a9x(round(r_best),phi_n) r_best],...
          [b9y(round(r_best),phi_n) r_best],'Color','b');  
     line([a10x(round(r_best),phi_n) r_best],...
          [b10y(round(r_best),phi_n) r_best],'Color','b');  
end
set(f,'Name','LCOD_sl12_t1');
print(f,[dir_results 'LCOD_sl12_t1'],'-dpng');

%figure(2);
%set(gcf,'Color','w');
%plot(A10max(3:end),'LineWidth',2);
%hold on;plot(xi,f10_bg,'-k','LineWidth',2);hold off;

figure(6);
set(gcf,'Color','w');
subplot(5,2,1)
plot(A1max(3:end));
%set(gca,'YLim',[mw_imsheet max_imsheet]);
hold on;plot(xi,f1_bg,'-k');hold off;
subplot(5,2,2)
plot(A2max(3:end));
hold on;plot(xi,f2_bg,'-k');hold off;
subplot(5,2,3)
plot(A3max(3:end));
hold on;plot(xi,f3_bg,'-k');hold off;
subplot(5,2,4)
plot(A4max(:));
hold on;plot(xi,f4_bg,'-k');hold off;
subplot(5,2,5)
plot(A5max(:));
hold on;plot(xi,f5_bg,'-k');hold off;
subplot(5,2,6)
plot(A6max(:));
hold on;plot(xi,f6_bg,'-k');hold off;
subplot(5,2,7)
plot(A7max(:));
hold on;plot(xi,f7_bg,'-k');hold off;
subplot(5,2,8)
plot(A8max(:));
hold on;plot(xi,f8_bg,'-k');hold off;
subplot(5,2,9)
plot(A9max(:));
hold on;plot(xi,f9_bg,'-k');hold off;
subplot(5,2,10)
plot(A10max(:));
hold on;plot(xi,f10_bg,'-k');hold off;

figure(7);
set(gcf,'Color','w');
subplot(5,2,1)
plot(B1);grid on;
subplot(5,2,2)
plot(B2);grid on;
subplot(5,2,3)
plot(B3);grid on;
subplot(5,2,4)
plot(B4);grid on;
subplot(5,2,5)
plot(B5);grid on;
subplot(5,2,6)
plot(B6);grid on;
subplot(5,2,7)
plot(B7);grid on;
subplot(5,2,8)
plot(B8);grid on;
subplot(5,2,9)
plot(B9);grid on;
subplot(5,2,10)
plot(B10);grid on;

t1 = max(B1)*0.45
[maxB1, minB1] = peakdet(B1,t_sl);
length(maxB1)
if length(maxB1) >= 3
    count1 = 1;
else
    count1 = 0;
end

t2 = max(B2)*0.45
[maxB2, minB2] = peakdet(B2,t_sl);
length(maxB2)
if length(maxB2) >= 3
    count2 = 1;
else
    count2 = 0;
end

t3 = max(B3)*0.45
[maxB3, minB3] = peakdet(B3,t_sl);
length(maxB3)
if length(maxB3) >= 3
    count3 = 1;
else
    count3 = 0;
end

t4 = max(B4)*0.45
[maxB4, minB4] = peakdet(B4,t_sl);
length(maxB4)
if length(maxB4) >= 3
    count4 = 1;
else
    count4 = 0;
end

t5 = max(B5)*0.25
[maxB5, minB5] = peakdet(B5,t_sl);
length(maxB5)
if length(maxB5) >= 3
    count5 = 1;
else
    count5 = 0;
end

t6 = max(B6)*0.45
[maxB6, minB6] = peakdet(B6,t_sl);
length(maxB6)
if length(maxB6) >= 3
    count6 = 1;
else
    count6 = 0;
end

t7 = max(B7)*0.45
[maxB7, minB7] = peakdet(B7,t_sl);
length(maxB7)
if length(maxB7) >= 3
    count7 = 1;
else
    count7 = 0;
end

t8 = max(B8)*0.45
[maxB8, minB8] = peakdet(B8,t_sl);
length(maxB8)
if length(maxB8) >= 3
    count8 = 1;
else
    count8 = 0;
end

t9 = max(B9)*0.45
[maxB9, minB9] = peakdet(B9,t_sl);
length(maxB9)
if length(maxB9) >= 3
    count9 = 1;
else
    count9 = 0;
end

t10 = max(B10)*0.45
[maxB10, minB10] = peakdet(B10,t_sl);
length(maxB10)
if length(maxB10) >= 3
    count10 = 1;
else
    count10 = 0;
end

score_sl12_t1 = count1+count2+count3+count4+count5+count6+count7+count8+count9+count10

