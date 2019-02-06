function t1_noise_histogram(image_path, mask_path, in_default_threshold_faktor )
%This method detects the noise level in a structural image.
%First based on the given threshold a new threshold based on the given and the mean of a 10x10 Roi of a corner is
%used to get a first approach of the background. The bones have got a much higher intensity so that they were 
%detected as a border.
%Then the image is used to mask the whole head. Therefore in axial and sagital 
%direction in each slice in all four corners a region growing algorithm is started.
%The 9th neighborhood is searched for the similar values.
%At the end the mask is used to calculate the mean of it. This is used as "signal"
%The noise is calculated by the SD of all the detected noise values
%A histogram of the noise values is as well created


default_threshold_faktor = str2double (in_default_threshold_faktor);


genpath("/home/brain/qa/niak/");
addpath(genpath("/home/brain/qa/niak/"));
savepath ();
rehash ();


%Load images
[hdr,vol]=niak_read_vol(image_path);

[hdr2,vol2]=niak_read_vol(mask_path);

dim1 = hdr.info.dimensions(1);
dim2 = hdr.info.dimensions(2);
dim3 = hdr.info.dimensions(3);

image_org = zeros(dim1,dim2,dim3);
threshold = mean(reshape(vol(1:10,1:10,1:10),1,[])) * default_threshold_faktor;

%maskieren der nicht Threshold werte
image_org(vol(:,:,:) > threshold) = -1;
region_mask1 = zeros(dim1,dim2,dim3);


% sagittal
for k = 1:dim3
  bild1 = image_org(1:dim1-1,:,k);
  bild2 = image_org(2:dim1,:,k);
  diff_bild1 = bild1-bild2;

  bild3 = image_org(:,1:dim2-1,k);
  bild4 = image_org(:,2:dim2,k);
  diff_bild2 = bild3-bild4;

  for i = 1:dim2
    region_mask1(min(find(diff_bild1(:,i))):max(find(diff_bild1(:,i))),i,k)=-3;
  end

  for i = 1:dim1
    region_mask1(i, min(find(diff_bild2(i,:))):max(find(diff_bild2(i,:))),k)+= -3;
  end
end


% axial
region_mask2 = zeros(dim1,dim2,dim3);

for k = 1:dim2
  bild1 = image_org(1:dim1-1,k,:);
  bild2 = image_org(2:dim1,k,:);
  diff_bild1 = bild1-bild2;

  bild3 = image_org(:,k,1:dim3-1);
  bild4 = image_org(:,k,2:dim3);
  diff_bild2 = bild3-bild4;

  for i = 1:dim3
    region_mask2(min(find(diff_bild1(:,i))):max(find(diff_bild1(:,i))),k,i)=-3;
  end

  for i = 1:dim1
    region_mask2(i,k, min(find(diff_bild2(i,:))):max(find(diff_bild2(i,:))))+= -3;
  end
end


region_both = region_mask1+region_mask2;
region_both(region_both <-3) = 1;
region_both (region_both <1) = 0;

mask = zeros(dim1,dim2,dim3);
mask(region_both == 0) = 1;

noise = mask.*vol;
noise_histogram = reshape(noise(:,:,:),1,[]);

%output

%maske ausgeben 6 Schichten
if (dim1 == dim2)
	f = figure();
	set(f, 'Position', [300,300, 740, 600])
	set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
	set(gcf,'Color','w');
	set(f,'Name','slice0');
	imagesc(mask(:,:,1))
	print(f,'slice0','-dpng');

	f = figure();
	set(f, 'Position', [300,300, 740, 600])
	set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
	set(gcf,'Color','w');
	set(f,'Name','slice25p');
	slice_cut = round(dim3*0.25);
	imagesc(mask(:,:,slice_cut))
	print(f,'slice25p','-dpng');

	f = figure();
	set(f, 'Position', [300,300, 740, 600])
	set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
	set(gcf,'Color','w');
	set(f,'Name','slice50p');
	slice_cut = round(dim3*0.5);
	imagesc(mask(:,:,slice_cut))
	print(f,'slice50p','-dpng');

	f = figure();
	set(f, 'Position', [300,300, 740, 600])
	set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
	set(gcf,'Color','w');
	set(f,'Name','slice75p');
	slice_cut = round(dim3*0.75);
	imagesc(mask(:,:,slice_cut))
	print(f,'slice75p','-dpng');


	f = figure();
	set(f, 'Position', [300,300, 740, 600])
	set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
	set(gcf,'Color','w');
	set(f,'Name','sliceend');
	imagesc(mask(:,:,dim3-2))
	print(f,'sliceend','-dpng');	
else
	f = figure();
	set(f, 'Position', [300,300, 740, 600])
	set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
	set(gcf,'Color','w');
	set(f,'Name','slice0');
	imagesc(mask(:,1,:))
	print(f,'slice0','-dpng');

	f = figure();
	set(f, 'Position', [300,300, 740, 600])
	set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
	set(gcf,'Color','w');
	set(f,'Name','slice25p');
	slice_cut = round(dim3*0.25);
	imagesc(mask(:,slice_cut,:))
	print(f,'slice25p','-dpng');

	f = figure();
	set(f, 'Position', [300,300, 740, 600])
	set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
	set(gcf,'Color','w');
	set(f,'Name','slice50p');
	slice_cut = round(dim3*0.5);
	imagesc(mask(:,slice_cut,:))
	print(f,'slice50p','-dpng');

	f = figure();
	set(f, 'Position', [300,300, 740, 600])
	set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
	set(gcf,'Color','w');
	set(f,'Name','slice75p');
	slice_cut = round(dim3*0.75);
	imagesc(mask(:,slice_cut,:))
	print(f,'slice75p','-dpng');


	f = figure();
	set(f, 'Position', [300,300, 740, 600])
	set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
	set(gcf,'Color','w');
	set(f,'Name','sliceend');
	imagesc(mask(:,dim2-2,:))
	print(f,'sliceend','-dpng');
end												


%SNR berechnen


[pathstr,name,ext] = fileparts(image_path) ;

file_name = strcat('report_',name);
fullname = strcat(file_name,'.txt');
fid = fopen(fullname, 'w');

if ((dim1 == hdr2.info.dimensions(1)) && (dim3 == hdr2.info.dimensions(3)) && (dim3 == hdr2.info.dimensions(3)) )
    signal_brain = (mean(nonzeros(reshape(vol2(:,:,:),1,[]))));
    snr = signal_brain / std(noise_histogram);
    
    fprintf(fid, 'Mean_Signal_Brainmask:\t%.4f\n', signal_brain);
    fprintf(fid, 'Std_Noise_Mask:\t%.4f\n', std(noise_histogram));
    fprintf(fid, 'SNR:\t%.4f\n', snr);
    
else
    fprintf(fid, 'ERROR:Dimension of image and mask unequal');
end

fclose(fid);

%Histogram

f = figure();
set(f, 'Position', [300,300, 740, 600])
set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
set(gcf,'Color','w');
hist_name = strcat('histogram_', name);
set(f,'Name',hist_name);
hist(noise_histogram);
xlabel ("Intensity");
ylabel ("Count of values");
print(f,hist_name,'-dpng');

hist_without_lower_values = noise_histogram(noise_histogram >= 30);

f = figure();
set(f, 'Position', [300,300, 740, 600])
set(gcf,'PaperUnits','centimeters','PaperPosition',[3 3 12.8 10])
set(gcf,'Color','w');
hist_name = strcat('histogram_upper_values_', name);
xlabel ("Intensity");
ylabel ("Count of values");
set(f,'Name',hist_name);
hist(hist_without_lower_values)
print(f,hist_name,'-dpng');

close all;
end

