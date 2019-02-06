function locd_t2()

global hdr2 filenameT2 dim1_T2 dim2_T2 dir_results img2 global_result_file
global score_sl9 score_sl10 score_sl11 score_sl12



[hdr2,img2]=niak_read_vol(filenameT2);

[pathT2 nameT2 ext1]=fileparts(filenameT2);
hdr2.info.dimensions;
dim1_T2 =hdr2.info.dimensions(1);
dim2_T2 =hdr2.info.dimensions(2);

%Aufrufen der Unterfunktionen
LCOD_sl9_neu()
LCOD_sl10_neu()
LCOD_sl11()
LCOD_sl12_neu()

score_T2 = score_sl9+ score_sl10 + score_sl11 + score_sl12


cd(dir_results);
fname_result = sprintf('LCOD_Results_%s.txt',nameT2);

%Parameter speichern
FID        = fopen(fname_result,'w');
fprintf(FID,'Messung:%s\n',nameT2);
fprintf(FID,'Ergebnisse:\n');
fprintf(FID,'Slide\t\tSpeichen\n');
fprintf(FID,'8\t\t%2.0f\n',score_sl9);
fprintf(FID,'9\t\t%2.0f\n',score_sl10);
fprintf(FID,'10\t\t%2.0f\n',score_sl11);
fprintf(FID,'11\t\t%2.0f\n',score_sl12);
fprintf(FID,'Anzahl aller Speichen: %2.0f\n',score_T2);
fprintf(FID,'Kriterium um zu bestehen: 37 Speichen.\n');
if score_T2 >36;
    fprintf(FID,'Test wurde bestanden.');
else
        fprintf(FID,'Test wurde nicht bestanden.');
end
fclose(FID);

fprintf(global_result_file,'\n#13\nErgebnisse LCOD T2:\n');
fprintf(global_result_file,'Messung:%s\n',nameT2);
fprintf(global_result_file,'Ergebnisse:\n');
fprintf(global_result_file,'Slide\t\tSpeichen\n');
fprintf(global_result_file,'8\t\t%2.0f\n',score_sl9);
fprintf(global_result_file,'9\t\t%2.0f\n',score_sl10);
fprintf(global_result_file,'10\t\t%2.0f\n',score_sl11);
fprintf(global_result_file,'11\t\t%2.0f\n',score_sl12);
fprintf(global_result_file,'Anzahl aller Speichen: %2.0f\n',score_T2);
fprintf(global_result_file,'Kriterium um zu bestehen: 37 Speichen.\n');
if score_T2 >36;
    fprintf(global_result_file,'Test wurde bestanden.');
else
        fprintf(global_result_file,'Test wurde nicht bestanden.');
end


close all;
