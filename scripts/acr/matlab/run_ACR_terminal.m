function run_ACR_terminal(localizer_path,t1_path,t2_path,result_path_in)
    
    global localizer_file filenameT1 filenameT2 dir_results global_result_file
    global hdr img hdr1 img1 hdr2 img2 
    
   
genpath("/home/brain/qa/niak/")
addpath(genpath("/home/brain/qa/niak/"))
rehash ()




    
    localizer_file = localizer_path;
    filenameT1 = t1_path;
    filenameT2 = t2_path;
    dir_results = result_path_in;

    global_result_file = fopen([dir_results 'logfile.txt'],'w');
    
    %Load Localizer
    [hdr,img]=niak_read_vol(localizer_file);

    %Load T1 Image
    [hdr1,img1]=niak_read_vol(filenameT1);

    %Load T2 Image
    [hdr2,img2]=niak_read_vol(filenameT2);

     %Geometric accuracy
    try    
	geom_test()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch

    %High-contrast spatial resolution
    try    
	spatial_res_T1()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch
    try
    	spatial_res_T2()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch
    

    %Slice thickness accuracy
    try    
	slice_th_T1()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch    
    try
	slice_th_T2()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch
    

    %Slice position accuracy
    try
	slice_pos_T1()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch
    try
	slice_pos_T2()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch
    

    %Image intensity uniformity
    try
	piu_T1()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch
    try
    	piu_T2()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch
    

    %Percent-signal ghosting
    try
	ghosting_T1()	
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch
    try
	ghosting_T2()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch


    %Low-contrast object detectability
    try
	lcod_t1()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch
    try
	lcod_t2()
    catch
	cd(dir_results);
	FID = fopen('error.txt','w');
	msg = lasterror.message;
	fprintf(FID,msg);
	fclose(FID);
	cd(CWD);
    end_try_catch

    fclose(global_result_file);
end

