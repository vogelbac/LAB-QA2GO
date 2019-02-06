function run_ACR_qa()

global dir_results global_result_file

%dir_results = 'C:\Users\vogelbacher\Documents\#1-UNI\Phantome\Programme_ACR_Phantom\Programme_ACR_Phantom\results\';
dir_results = 'C:\Users\vogelbacher\Documents\#1-UNI\Phantome\Programme_ACR_Phantom\Programme_ACR_Phantom\results\neu\';
global_result_file = fopen([dir_results 'logfile.txt'],'w');

check1 = evalin('base','type1'); %all parameter
check2 = evalin('base','type2'); %geometry
check3 = evalin('base','type3'); %resolution
check4 = evalin('base','type4'); %slice thickness
check5 = evalin('base','type5'); %slice position
check6 = evalin('base','type6'); %PIU
check7 = evalin('base','type7'); %PSG
check8 = evalin('base','type8'); %LCOD

if (check1==1);
   geom_test()
   spatial_res_T1()
   spatial_res_T2()
   slice_th_T1()
   slice_th_T2()
   slice_pos_T1()
   slice_pos_T2()
   piu_T1()
   piu_T2()
   ghosting_T1()
   ghosting_T2()
   lcod_t1()
   lcod_t2()
end

if (check2==1);
   geom_test()
end

if (check3==1);
   spatial_res_T1()
   spatial_res_T2()
end

if (check4==1);
   slice_th_T1()
   slice_th_T2()
end

if (check5==1);
   slice_pos_T1()
   slice_pos_T2()
end

if (check6==1);
   piu_T1()
   piu_T2()
end

if (check7==1);
   ghosting_T1()
   ghosting_T2()
end

if (check8==1);
   %lcod_t1()
   lcod_t2()
end

fclose(global_result_file);
