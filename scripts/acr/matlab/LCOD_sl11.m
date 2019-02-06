function LCOD_sl11()
global img2 dim1_T2 dim2_T2 score_sl11

%Bestimmung der Phantomgrenzen/-kanten (Segmentierung mit Otsu s Methode)
IDX = otsu(img2(:,:,10),2);
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
cutli = ph_edges1(1) %links
cutre = ph_edges1(length(ph_edges1)) %rechts
ph_edges2 = find(sumdim2 > 0);
cutob = ph_edges2(1) %oben
cutun = ph_edges2(length(ph_edges2)) %unten
%Phantommittelpunkt
ym = (cutun-cutob)/2+cutob; %dim1_ax
xm = (cutre-cutli)/2+cutli; %dim2_ax
center = [xm ym]

%Region fuer Low Contrast Objekt sheet finden
abldim1 = diff(sumdim1);
[mx1_li loc_mx1_li] = max(abldim1(40:100)); 
[mn1_li loc_mn1_li] = min(abldim1(40:100)); 
[mx1_re loc_mx1_re] = max(abldim1(130:180)); 
[mn1_re loc_mn1_re] = min(abldim1(130:180)); 
pos1li = loc_mn1_li+40
pos2li = loc_mx1_li+40
pos1re = loc_mn1_re+130
pos2re = loc_mx1_re+130
abldim2 = diff(sumdim2);
[mx2_ob loc_mx2_ob] = max(abldim2(40:110)); 
[mn2_ob loc_mn2_ob] = min(abldim2(40:100)); 
[mx2_un loc_mx2_un] = max(abldim2(150:200)); 
[mn2_un loc_mn2_un] = min(abldim2(140:200)); 
pos1ob = loc_mn2_ob+40
pos2ob = loc_mx2_ob+40
pos1un = loc_mn2_un+140
pos2un = loc_mx2_un+150

%Objekt sheet Mittelpunkt und Kreisflaeche bestimmen
ym1 = (pos1un-pos2ob)/2+pos2ob; %dim1
xm1 = (pos1re-pos2li)/2+pos2li; %dim2
r_vert = (pos1un-pos2ob)/2
RB = (pos1re-pos2li);
cc = [xm1 ym1]
phi=1:1:360;
phi=phi./180.*pi;
[xtmp,ytmp] = pol2cart(phi,r_vert);
x_circle=xtmp+xm1;
y_circle=ytmp+ym1;

r6 = 42;
r5 = 34;
r4 = 29;
r3 = 21;
r2 = 16;
r1 = 8;

alpha6 =1:1:360;
alpha6 = alpha6./180.*pi;
[xt6,yt6] = pol2cart(alpha6,r6);
x6_circle=xt6+xm1;
y6_circle=yt6+ym1;
xcl6 = ceil(xm1-r6);
xcr6 = floor(xm1+r6);
yco6 = ceil(ym1-r6);
ycu6 = floor(ym1+r6);

%Abstand von allen Bildpunkten zum Kreismittelpunkt berechen,um nur die
%Pixel,die innerhalb des Kreises liegen zu finden
for k =1:dim2_T2
    mask(:,k) = 1000;
end
for l =1:dim1_T2
    mask(l,:) = 1000;
end
for column = yco6:ycu6,
    for row = xcl6:xcr6,
        vec_xy = [row column];
        abst(row) = norm(cc-vec_xy);
    end
    pos_row = find(0< abst(:) & round(abst(:)) <= r6);
    pos_row_dim = length(pos_row);
    dim2_circle = pos_row(1):pos_row(pos_row_dim);
    im_circle = img2(column,dim2_circle,10);
    mask(column,dim2_circle)=1;  
end

%Werte ausserhalb des Kreises auf Null setzen
for j=1:dim1_T2,
        for k=1:dim2_T2,
            if mask(j,k)~=1
                mask(j,k)=0;
            end
        end
end

alpha5 =1:1:360;
alpha5 = alpha5./180.*pi;
[xt5,yt5] = pol2cart(alpha5,r5);
x5_circle=xt5+xm1;
y5_circle=yt5+ym1;
xcl5 = ceil(xm1-r5);
xcr5 = floor(xm1+r5);
yco5 = ceil(ym1-r5);
ycu5 = floor(ym1+r5);
%Abstand von allen Bildpunkten zum Kreismittelpunkt berechen,um nur die
%Pixel,die innerhalb des Kreises liegen zu finden
for column5 = yco5:ycu5,
    for row5 = xcl5:xcr5,
        vec5_xy = [row5 column5];
        abst5(row5) = norm(cc-vec5_xy);
    end
    pos_row5 = find(0 < abst5(:) & round(abst5(:)) <= r5);
    pos_row_dim5 = length(pos_row5);
    dim2_circle5 = pos_row5(1):pos_row5(pos_row_dim5);
    im_circle5 = img2(column5,dim2_circle5,10);
    mask(column5,dim2_circle5)=0;  
end

alpha4 =1:1:360;
alpha4 = alpha4./180.*pi;
[xt4,yt4] = pol2cart(alpha4,r4);
x4_circle=xt4+xm1;
y4_circle=yt4+ym1;
xcl4 = ceil(xm1-r4);
xcr4 = floor(xm1+r4);
yco4 = ceil(ym1-r4);
ycu4 = floor(ym1+r4);

%Abstand von allen Bildpunkten zum Kreismittelpunkt berechen,um nur die
%Pixel,die innerhalb des Kreises liegen zu finden
for k =1:dim2_T2
    mask1(:,k) = 1000;
end
for l =1:dim1_T2
    mask1(l,:) = 1000;
end
for column4 = yco4:ycu4,
    for row4 = xcl4:xcr4,
        vec4_xy = [row4 column4];
        abst4(row4) = norm(cc-vec4_xy);
    end
    pos_row4 = find(0< abst4(:) & round(abst4(:)) <= r4);
    pos_row_dim4 = length(pos_row4);
    dim2_circle4 = pos_row4(1):pos_row4(pos_row_dim4);
    im_circle4 = img2(column4,dim2_circle4,10);
    mask1(column4,dim2_circle4)=1;
end

%Werte ausserhalb des Kreises auf Null setzen
for j=1:dim1_T2,
        for k=1:dim2_T2,
            if mask1(j,k)~=1
                mask1(j,k)=0;
            end
        end
end

alpha3 =1:1:360;
alpha3 = alpha3./180.*pi;
[xt3,yt3] = pol2cart(alpha3,r3);
x3_circle=xt3+xm1;
y3_circle=yt3+ym1;
xcl3 = ceil(xm1-r3);
xcr3 = floor(xm1+r3);
yco3 = ceil(ym1-r3);
ycu3 = floor(ym1+r3);
%Abstand von allen Bildpunkten zum Kreismittelpunkt berechen,um nur die
%Pixel,die innerhalb des Kreises liegen zu finden
for column3 = yco3:ycu3,
    for row3 = xcl3:xcr3,
        vec3_xy = [row3 column3];
        abst3(row3) = norm(cc-vec3_xy);
    end
    pos_row3 = find(0 < abst3(:) & round(abst3(:)) <= r3);
    pos_row_dim3 = length(pos_row3);
    dim2_circle3 = pos_row3(1):pos_row3(pos_row_dim3);
    im_circle3 = img2(column3,dim2_circle3,10);
    mask1(column3,dim2_circle3)=0;  
end

alpha2 =1:1:360;
alpha2 = alpha2./180.*pi;
[xt2,yt2] = pol2cart(alpha2,r2);
x2_circle=xt2+xm1;
y2_circle=yt2+ym1;
xcl2 = ceil(xm1-r2);
xcr2 = floor(xm1+r2);
yco2 = ceil(ym1-r2);
ycu2 = floor(ym1+r2);

%Abstand von allen Bildpunkten zum Kreismittelpunkt berechen,um nur die
%Pixel,die innerhalb des Kreises liegen zu finden
for k =1:dim2_T2
    mask2(:,k) = 1000;
end
for l =1:dim1_T2
    mask2(l,:) = 1000;
end
for column2 = yco2:ycu2,
    for row2 = xcl2:xcr2,
        vec2_xy = [row2 column2];
        abst2(row2) = norm(cc-vec2_xy);
    end
    pos_row2 = find(0< abst2(:) & round(abst2(:)) <= r2);
    pos_row_dim2 = length(pos_row2);
    dim2_circle2 = pos_row2(1):pos_row2(pos_row_dim2);
    im_circle2 = img2(column2,dim2_circle2,10);
    mask2(column2,dim2_circle2)=1;
end

%Werte ausserhalb des Kreises auf Null setzen
for j=1:dim1_T2,
        for k=1:dim2_T2,
            if mask2(j,k)~=1
                mask2(j,k)=0;
            end
        end
end

alpha1 =1:1:360;
alpha1 = alpha1./180.*pi;
[xt1,yt1] = pol2cart(alpha1,r1);
x1_circle=xt1+xm1;
y1_circle=yt1+ym1;
xcl1 = ceil(xm1-r1);
xcr1 = floor(xm1+r1);
yco1 = ceil(ym1-r1);
ycu1 = floor(ym1+r1);
%Abstand von allen Bildpunkten zum Kreismittelpunkt berechen,um nur die
%Pixel,die innerhalb des Kreises liegen zu finden
for column1 = yco1:ycu1,
    for row1 = xcl1:xcr1,
        vec1_xy = [row1 column1];
        abst1(row1) = norm(cc-vec1_xy);
    end
    pos_row1 = find(0 < abst1(:) & round(abst1(:)) <= r1);
    pos_row_dim1 = length(pos_row1);
    dim2_circle1 = pos_row1(1):pos_row1(pos_row_dim1);
    im_circle1 = img2(column1,dim2_circle1,10);
    mask2(column1,dim2_circle1)=0;  
end

maskall = mask(:,:)+mask1(:,:)+mask2(:,:);
Objs(:,:,1) = img2(:,:,10).*maskall(:,:);
imsheet_nothresh(:,:,1) = Objs(pos2ob:pos1un,pos2li:pos1re,1);

%Intensitaetsanpassung fuer Ring1 (innerer Ring)
Obj1(:,:,1) = img2(:,:,10).*mask2(:,:);
imsheet1(:,:,1) = Obj1(pos2ob:pos1un,pos2li:pos1re,1);
mx_imsheet1 = max(max(nonzeros(imsheet1)))
mn_imsheet1 = min(min(nonzeros(imsheet1)))
R1 = mx_imsheet1*0.45

thresh = mn_imsheet1;
for i = 1:dim1_T2,
    for j = 1:dim2_T2,
        if mask2(i,j)==0
            Obj1(i,j,1) = thresh;
        end
        if Obj1(i,j,1) <= thresh
           Obj1(i,j,1) = thresh;
        end
    end
end
imsheet1(:,:,1) = Obj1(pos2ob:pos1un,pos2li:pos1re,1);

%Intensitaetsanpassung fuer Ring2 (mittlerer Ring)
Obj2(:,:,1) = img2(:,:,10).*mask1(:,:);
imsheet2(:,:,1) = Obj2(pos2ob:pos1un,pos2li:pos1re,1);
mn_imsheet2 = min(min(nonzeros(imsheet2)))
mx_imsheet2 = max(max(nonzeros(imsheet2)))
R2 = mx_imsheet2*0.45

thresh = mn_imsheet2;
for i = 1:dim1_T2,
    for j = 1:dim2_T2,
        if mask1(i,j)==0
            Obj2(i,j,1) = thresh;
        end
        if Obj2(i,j,1) <= thresh
           Obj2(i,j,1) = thresh;
        end
    end
end
imsheet2(:,:,1) = Obj2(pos2ob:pos1un,pos2li:pos1re,1);

%Intensitaetsanpassung fuer Ring3 (aeusserer Ring)
Obj3(:,:,1) = img2(:,:,10).*mask(:,:);
imsheet3(:,:,1) = Obj3(pos2ob:pos1un,pos2li:pos1re,1);
mn_imsheet3 = min(min(nonzeros(imsheet3)))
mx_imsheet3 = max(max(nonzeros(imsheet3)))
R3 = mx_imsheet3*0.45

thresh = mn_imsheet3+70;
for i = 1:dim1_T2,
    for j = 1:dim2_T2,
        if mask(i,j)==0
            Obj3(i,j,1) = thresh;
        end
        if Obj3(i,j,1) <= thresh
           Obj3(i,j,1) = thresh;
        end
    end
end
imsheet3(:,:,1) = Obj3(pos2ob:pos1un,pos2li:pos1re,1);

%Winkelzuordnung fuer Intensitaetsprofile festlegen
%fuer jedes Kreistriplett werden 11 Pfade in 1Grad-Schritten festgelegt
% erstes Kreistriplett
phi_n = 1;
for phi1 = 14:24
    phi1=phi1./180.*pi;
    for rn = 1:round(r_vert)        
        [xc1,yc1] = pol2cart(phi1,rn);
        a1x(rn,phi_n) = xc1+r_vert;
        b1y(rn,phi_n) = yc1+r_vert;
        A1(rn,phi_n) = imsheet1(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
        A1_R2(rn,phi_n) = imsheet2(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
        A1_R3(rn,phi_n) = imsheet3(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A1)-1
    A1max(i) = max(A1(i,:));
end
%Background Approximation
B1 = A1max(:)-R1;
index = B1<0;
B1(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A1_R2)-1
    A1_R2max(i) = max(A1_R2(i,:));
end
%Background Approximation
B1_R2 = A1_R2max(:)-R2;
index = B1_R2<0;
B1_R2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A1_R3)-1
    A1_R3max(i) = max(A1_R3(i,:));
end
%Background Approximation
B1_R3 = A1_R3max(:)-R3;
index = B1_R3<0;
B1_R3(index) = 0;

%zweites Kreistriplett
phi_n = 1;
for phi2 = 49:59
    phi2=phi2./180.*pi;
    for rn = 1:round(r_vert)        
        [xc2,yc2] = pol2cart(phi2,rn);
        a2x(rn,phi_n) = xc2+r_vert;
        b2y(rn,phi_n) = yc2+r_vert;
        A2(rn,phi_n) = imsheet1(round(a2x(rn,phi_n)),round(b2y(rn,phi_n)),1);
        A2_R2(rn,phi_n) = imsheet2(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
        A2_R3(rn,phi_n) = imsheet3(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A2)-1
    A2max(i) = max(A2(i,:));
end
%Background Approximation
B2 = A2max(:)-R1;
index = B2<0;
B2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A1_R2)-1
    A2_R2max(i) = max(A2_R2(i,:));
end
%Background Approximation
B2_R2 = A2_R2max(:)-R2;
index = B2_R2<0;
B2_R2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A2_R3)-1
    A2_R3max(i) = max(A2_R3(i,:));
end
%Background Approximation
B2_R3 = A2_R3max(:)-R3;
index = B2_R3<0;
B2_R3(index) = 0;

%drittes Kreistriplett
phi_n = 1;
for phi3 = 84:94
    phi3=phi3./180.*pi;
    for rn = 1:round(r_vert)        
        [xc3,yc3] = pol2cart(phi3,rn);
        a3x(rn,phi_n) = xc3+r_vert;
        b3y(rn,phi_n) = yc3+r_vert;
	if (ceil(abs((b3y(rn,phi_n)))) <= size(imsheet1)(2))
		A3(rn,phi_n) = imsheet1(round(a3x(rn,phi_n)),ceil(abs((b3y(rn,phi_n)))),1);
		A3_R2(rn,phi_n) = imsheet2(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
		A3_R3(rn,phi_n) = imsheet3(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
	end
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A3)-1
    A3max(i) = max(A3(i,:));
end
%Background Approximation
B3 = A3max(:)-R1;
index = B3<0;
B3(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A3_R2)-1
    A3_R2max(i) = max(A3_R2(i,:));
end
%Background Approximation
B3_R2 = A3_R2max(:)-R2;
index = B3_R2<0;
B3_R2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A3_R3)-1
    A3_R3max(i) = max(A3_R3(i,:));
end
%Background Approximation
B3_R3 = A3_R3max(:)-R3;
index = B3_R3<0;
B3_R3(index) = 0;


%viertes Kreistriplett
phi_n = 1;
for phi4 = 120:130
    phi4=phi4./180.*pi;
    for rn = 1:round(r_vert)        
        [xc4,yc4] = pol2cart(phi4,rn);
        a4x(rn,phi_n) = xc4+r_vert;
        b4y(rn,phi_n) = yc4+r_vert;
        A4(rn,phi_n) = imsheet1(round(a4x(rn,phi_n)),round(b4y(rn,phi_n)),1);
        A4_R2(rn,phi_n) = imsheet2(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
        A4_R3(rn,phi_n) = imsheet3(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A4)-1
    A4max(i) = max(A4(i,:));
end
%Background Approximation
B4 = A4max(:)-R1;
index = B4<0;
B4(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A4_R2)-1
    A4_R2max(i) = max(A4_R2(i,:));
end
%Background Approximation
B4_R2 = A4_R2max(:)-R2;
index = B4_R2<0;
B4_R2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A4_R3)-1
    A4_R3max(i) = max(A4_R3(i,:));
end
%Background Approximation
B4_R3 = A4_R3max(:)-R3;
index = B4_R3<0;
B4_R3(index) = 0;


%fuenftes Kreistriplett
phi_n = 1;
for phi5 = 155:165
    phi5=phi5./180.*pi;
    for rn = 1:round(r_vert)        
        [xc5,yc5] = pol2cart(phi5,rn);
        a5x(rn,phi_n) = xc5+r_vert;
        b5y(rn,phi_n) = yc5+r_vert;
        A5(rn,phi_n) = imsheet1(ceil(abs(a5x(rn,phi_n))),round(b5y(rn,phi_n)),1);
        A5_R2(rn,phi_n) = imsheet2(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
        A5_R3(rn,phi_n) = imsheet3(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A5)-1
    A5max(i) = max(A5(i,:));
end
%Background Approximation
B5 = A5max(:)-R1;
index = B5<0;
B5(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A5_R2)-1
    A5_R2max(i) = max(A5_R2(i,:));
end
%Background Approximation
B5_R2 = A5_R2max(:)-R2;
index = B5_R2<0;
B5_R2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A5_R3)-1
    A5_R3max(i) = max(A5_R3(i,:));
end
%Background Approximation
B5_R3 = A5_R3max(:)-R3;
index = B5_R3<0;
B5_R3(index) = 0;

%sechstes Kreistriplett
phi_n = 1;
for phi6 = 192:202
    phi6=phi6./180.*pi;
    for rn = 1:round(r_vert)        
        [xc6,yc6] = pol2cart(phi6,rn);
        a6x(rn,phi_n) = xc6+round(r_vert);
        b6y(rn,phi_n) = yc6+r_vert;
        A6(rn,phi_n) = imsheet1(round(a6x(rn,phi_n)),round(b6y(rn,phi_n)),1);
        A6_R2(rn,phi_n) = imsheet2(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
        A6_R3(rn,phi_n) = imsheet3(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A6)-1
    A6max(i) = max(A6(i,:));
end
%Background Approximation
B6 = A6max(:)-R1;
index = B6<0;
B6(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A6_R2)-1
    A6_R2max(i) = max(A6_R2(i,:));
end
%Background Approximation
B6_R2 = A6_R2max(:)-R2;
index = B6_R2<0;
B6_R2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A6_R3)-1
    A6_R3max(i) = max(A6_R3(i,:));
end
%Background Approximation
B6_R3 = A6_R3max(:)-R3;
index = B6_R3<0;
B6_R3(index) = 0;

%siebtes Kreistriplett
phi_n = 1;
for phi7 = 228:238
    phi7=phi7./180.*pi;
    for rn = 1:round(r_vert)        
        [xc7,yc7] = pol2cart(phi7,rn);
        a7x(rn,phi_n) = xc7+r_vert;
        b7y(rn,phi_n) = yc7+r_vert;
        A7(rn,phi_n) = imsheet1(round(a7x(rn,phi_n)),round(b7y(rn,phi_n)),1);
        A7_R2(rn,phi_n) = imsheet2(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
        A7_R3(rn,phi_n) = imsheet3(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A7)-1
    A7max(i) = max(A7(i,:));
end
%Background Approximation
B7 = A7max(:)-R1;
index = B7<0;
B7(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A7_R2)-1
    A7_R2max(i) = max(A7_R2(i,:));
end
%Background Approximation
B7_R2 = A7_R2max(:)-R2;
index = B7_R2<0;
B7_R2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A7_R3)-1
    A7_R3max(i) = max(A7_R3(i,:));
end
%Background Approximation
B7_R3 = A7_R3max(:)-R3;
index = B7_R3<0;
B7_R3(index) = 0;

%achtes Kreistriplett
phi_n = 1;
for phi8 = 264:274
    phi8=phi8./180.*pi;
    for rn = 1:round(r_vert)        
        [xc8,yc8] = pol2cart(phi8,rn);
        a8x(rn,phi_n) = xc8+r_vert;
        b8y(rn,phi_n) = yc8+r_vert;
        if b8y(rn,phi_n) == 0
            b8y(rn,phi_n) = yc8+round(43.5);
        end
        if b8y(rn,phi_n) == 0
            b8y(rn,phi_n) = yc8+43.5;
        end
        A8(rn,phi_n) = imsheet1(round(a8x(rn,phi_n)),ceil(abs((b8y(rn,phi_n)))),1);
        A8_R2(rn,phi_n) = imsheet2(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
        A8_R3(rn,phi_n) = imsheet3(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A8)-1
    A8max(i) = max(A8(i,:));
end
%Background Approximation
B8 = A8max(:)-R1;
index = B8<0;
B8(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A8_R2)-1
    A8_R2max(i) = max(A8_R2(i,:));
end
%Background Approximation
B8_R2 = A8_R2max(:)-R2;
index = B8_R2<0;
B8_R2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A8_R3)-1
    A8_R3max(i) = max(A8_R3(i,:));
end
%Background Approximation
B8_R3 = A8_R3max(:)-R3;
index = B8_R3<0;
B8_R3(index) = 0;

%neuntes Kreistriplett
phi_n = 1;
for phi9 = 301:311
    phi9=phi9./180.*pi;
    for rn = 1:round(r_vert)        
        [xc9,yc9] = pol2cart(phi9,rn);
        a9x(rn,phi_n) = xc9+r_vert;
        b9y(rn,phi_n) = yc9+r_vert;
        A9(rn,phi_n) = imsheet1(ceil(abs(a9x(rn,phi_n))),ceil(abs((b9y(rn,phi_n)))),1);
        A9_R2(rn,phi_n) = imsheet2(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
        A9_R3(rn,phi_n) = imsheet3(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A9)-1
    A9max(i) = max(A9(i,:));
end
%Background Approximation
B9 = A9max(:)-R1;
index = B9<0;
B9(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A9_R2)-1
    A9_R2max(i) = max(A9_R2(i,:));
end
%Background Approximation
B9_R2 = A9_R2max(:)-R2;
index = B9_R2<0;
B9_R2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A9_R3)-1
    A9_R3max(i) = max(A9_R3(i,:));
end
%Background Approximation
B9_R3 = A9_R3max(:)-R3;
index = B9_R3<0;
B9_R3(index) = 0;

%zehntes Kreistriplett
phi_n = 1;
for phi10 = 338:348
    phi10 =phi10./180.*pi;
    for rn = 1:round(r_vert)        
        [xc10,yc10] = pol2cart(phi10,rn);
        a10x(rn,phi_n) = xc10+r_vert;
        b10y(rn,phi_n) = yc10+r_vert;
        A10(rn,phi_n) = imsheet1(round(abs(a10x(rn,phi_n))),round(abs((b10y(rn,phi_n)))),1);
        A10_R2(rn,phi_n) = imsheet2(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
        A10_R3(rn,phi_n) = imsheet3(round(a1x(rn,phi_n)),round(b1y(rn,phi_n)),1);
    end 
    phi_n = phi_n+1;
end
for i = 1:length(A10)-1
    A10max(i) = max(A10(i,:));
end
%Background Approximation
B10 = A10max(:)-R1;
index = B10<0;
B10(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A10_R2)-1
    A10_R2max(i) = max(A10_R2(i,:));
end
%Background Approximation
B10_R2 = A10_R2max(:)-R2;
index = B10_R2<0;
B10_R2(index) = 0;
%Maximalwert aus den 11 Pfaden auswaehlen
for i = 1:length(A1_R3)-1
    A10_R3max(i) = max(A10_R3(i,:));
end
%Background Approximation
B10_R3 = A10_R3max(:)-R3;
index = B10_R3<0;
B10_R3(index) = 0;

figure(3);
set(gcf,'Color','w');
imagesc(imsheet1(:,:,1));
colormap(gray);
colorbar();

[maxB1, minB1] = peakdet(B1,50);
length(maxB1);
if length(maxB1) >= 1
    count1_R1 = 1;
else
    count1_R1 = 0;
end
[maxB1_R2, minB1_R2] = peakdet(B1_R2,50);
length(maxB1_R2);
if length(maxB1_R2) >= 1
    count1_R2 = 1;
else
    count1_R2 = 0;
end
[maxB1_R3, minB1_R3] = peakdet(B1_R3,50);
length(maxB1_R3);
if length(maxB1_R3) >= 1
    count1_R3 = 1;
else
    count1_R3 = 0;
end

count1 = count1_R1+count1_R2+count1_R3;
if count1 >=3
    count1 = 1;
else
    count1 = 0;
end


[maxB2, minB2] = peakdet(B2,50);
length(maxB2);
if length(maxB2) >= 1
    count2_R1 = 1;
else
    count2_R1 = 0;
end
[maxB2_R2, minB2_R2] = peakdet(B2_R2,50);
length(maxB2_R2);
if length(maxB2_R2) >= 1
    count2_R2 = 1;
else
    count2_R2 = 0;
end
[maxB2_R3, minB2_R3] = peakdet(B2_R3,50);
length(maxB2_R3);
if length(maxB2_R3) >= 1
    count2_R3 = 1;
else
    count2_R3 = 0;
end

count2 = count2_R1+count2_R2+count2_R3;
if count2 >=3
    count2 = 1;
else
    count2 = 0;
end


[maxB3, minB3] = peakdet(B3,50);
length(maxB3);
if length(maxB3) >= 1
    count3_R1 = 1;
else
    count3_R1 = 0;
end
[maxB3_R2, minB3_R2] = peakdet(B3_R2,50);
length(maxB3_R2);
if length(maxB3_R2) >= 1
    count3_R2 = 1;
else
    count3_R2 = 0;
end
[maxB3_R3, minB3_R3] = peakdet(B3_R3,50);
length(maxB3_R3);
if length(maxB3_R3) >= 1
    count3_R3 = 1;
else
    count3_R3 = 0;
end

count3 = count3_R1+count3_R2+count3_R3;
if count3 >=3
    count3 = 1;
else
    count3 = 0;
end


[maxB4, minB4] = peakdet(B4,50);
length(maxB4);
if length(maxB4) >= 1
    count4_R1 = 1;
else
    count4_R1 = 0;
end
[maxB4_R2, minB4_R2] = peakdet(B4_R2,50);
length(maxB4_R2);
if length(maxB4_R2) >= 1
    count4_R2 = 1;
else
    count4_R2 = 0;
end
[maxB4_R3, minB4_R3] = peakdet(B4_R3,50);
length(maxB4_R3);
if length(maxB4_R3) >= 1
    count4_R3 = 1;
else
    count4_R3 = 0;
end

count4 = count4_R1+count4_R2+count4_R3;
if count4 >=3
    count4 = 1;
else
    count4 = 0;
end


[maxB5, minB5] = peakdet(B5,50);
length(maxB5);
if length(maxB5) >= 1
    count5_R1 = 1;
else
    count5_R1 = 0;
end
[maxB5_R2, minB5_R2] = peakdet(B5_R2,50);
length(maxB5_R2)
if length(maxB5_R2) >= 1
    count5_R2 = 1;
else
    count5_R2 = 0;
end
[maxB5_R3, minB5_R3] = peakdet(B5_R3,50);
length(maxB5_R3);
if length(maxB5_R3) >= 1
    count5_R3 = 1;
else
    count5_R3 = 0;
end

count5 = count5_R1+count5_R2+count5_R3;
if count5 >=3
    count5 = 1;
else
    count5 = 0;
end


[maxB6, minB6] = peakdet(B6,50);
length(maxB6);
if length(maxB6) >= 1
    count6_R1 = 1;
else
    count6_R1 = 0;
end
[maxB6_R2, minB6_R2] = peakdet(B6_R2,50);
length(maxB6_R2);
if length(maxB6_R2) >= 1
    count6_R2 = 1;
else
    count6_R2 = 0;
end
[maxB6_R3, minB6_R3] = peakdet(B6_R3,50);
length(maxB4_R3);
if length(maxB4_R3) >= 1
    count6_R3 = 1;
else
    count6_R3 = 0;
end

count6 = count6_R1+count6_R2+count6_R3;
if count6 >=3
    count6 = 1;
else
    count6 = 0;
end


[maxB7, minB7] = peakdet(B7,50);
length(maxB7);
if length(maxB7) >= 1
    count7_R1 = 1;
else
    count7_R1 = 0;
end
[maxB7_R2, minB7_R2] = peakdet(B7_R2,50);
length(maxB7_R2);
if length(maxB7_R2) >= 1
    count7_R2 = 1;
else
    count7_R2 = 0;
end
[maxB7_R3, minB7_R3] = peakdet(B7_R3,50);
length(maxB7_R3);
if length(maxB7_R3) >= 1
    count7_R3 = 1;
else
    count7_R3 = 0;
end

count7 = count7_R1+count7_R2+count7_R3;
if count7 >=3
    count7 = 1;
else
    count7 = 0;
end


[maxB8, minB8] = peakdet(B8,50);
length(maxB8);
if length(maxB8) >= 1
    count8_R1 = 1;
else
    count8_R1 = 0;
end
[maxB8_R2, minB8_R2] = peakdet(B8_R2,50);
length(maxB8_R2)
if length(maxB8_R2) >= 1
    count8_R2 = 1;
else
    count8_R2 = 0;
end
[maxB8_R3, minB8_R3] = peakdet(B8_R3,50);
length(maxB8_R3);
if length(maxB8_R3) >= 1
    count8_R3 = 1;
else
    count8_R3 = 0;
end

count8 = count8_R1+count8_R2+count8_R3;
if count8 >=3
    count8 = 1;
else
    count8 = 0;
end


[maxB9, minB9] = peakdet(B9,50);
length(maxB9);
if length(maxB9) >= 1
    count9_R1 = 1;
else
    count9_R1 = 0;
end
[maxB9_R2, minB9_R2] = peakdet(B9_R2,50);
length(maxB9_R2);
if length(maxB9_R2) >= 1
    count9_R2 = 1;
else
    count9_R2 = 0;
end
[maxB9_R3, minB9_R3] = peakdet(B9_R3,50);
length(maxB9_R3);
if length(maxB9_R3) >= 1
    count9_R3 = 1;
else
    count9_R3 = 0;
end

count9 = count9_R1+count9_R2+count9_R3;
if count9 >=3
    count9 = 1;
else
    count9 = 0;
end


[maxB10, minB10] = peakdet(B10,50);
length(maxB10);
if length(maxB10) >= 1
    count10_R1 = 1;
else
    count10_R1 = 0;
end
[maxB10_R2, minB10_R2] = peakdet(B10_R2,50);
length(maxB10_R2);
if length(maxB10_R2) >= 1
    count10_R2 = 1;
else
    count10_R2 = 0;
end
[maxB10_R3, minB10_R3] = peakdet(B10_R3,50);
length(maxB10_R3);
if length(maxB10_R3) >= 1
    count10_R3 = 1;
else
    count10_R3 = 0;
end

count10 = count10_R1+count10_R2+count10_R3;
if count10 >=3
    count10 = 1;
else
    count10 = 0;
end

score_sl11 = count1+count2+count3+count4+count5+count6+count7+count8+count9+count10

