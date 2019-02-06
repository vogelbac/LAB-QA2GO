function locd_t1()

global img1 dim1_T1 dim2_T1 dir_results global_result_file filenameT1
global score_sl9_t1 score_sl10_t1 score_sl11_t1 score_sl12_t1

CWD = pwd;
[hdr1,img1]=niak_read_vol(filenameT1);

[pathT1 nameT1 ext1]=fileparts(filenameT1);


hdr1.info.dimensions;
dim1_T1 =hdr1.info.dimensions(1);
dim2_T1 =hdr1.info.dimensions(2);

%Aufrufen der Unterfunktionen
LCOD_sl9_t1_neu()
LCOD_sl10_t1_neu()
LCOD_sl11_t1_neu()
LCOD_sl12_t1_neu()

score_T1 = score_sl9_t1 + score_sl10_t1 + score_sl11_t1 + score_sl12_t1


cd(dir_results);
fname_result = sprintf('LCOD_Results_T1_%s.txt',nameT1);
%Parameter speichern
FID        = fopen(fname_result,'w');
fprintf(FID,'Messung:%s\n',nameT1);
fprintf(FID,'Ergebnisse:\n');
fprintf(FID,'Slide\t\tSpeichen\n');
fprintf(FID,'8\t\t%2.0f\n',score_sl9_t1);
fprintf(FID,'9\t\t%2.0f\n',score_sl10_t1);
fprintf(FID,'10\t\t%2.0f\n',score_sl11_t1);
fprintf(FID,'11\t\t%2.0f\n',score_sl12_t1);
fprintf(FID,'Anzahl aller Speichen: %2.0f\n',score_T1);
fprintf(FID,'Kriterium um zu bestehen: 37 Speichen.\n');
if score_T1 >36;
    fprintf(FID,'Test wurde bestanden.');
else
        fprintf(FID,'Test wurde nicht bestanden.');
end
fclose(FID);
cd(CWD);

fprintf(global_result_file,'\n#12\nErgebnisse LCOD T1:\n');
fprintf(global_result_file,'Messung:%s\n',nameT1);
fprintf(global_result_file,'Ergebnisse:\n');
fprintf(global_result_file,'Slide\t\tSpeichen\n');
fprintf(global_result_file,'8\t\t%2.0f\n',score_sl9_t1);
fprintf(global_result_file,'9\t\t%2.0f\n',score_sl10_t1);
fprintf(global_result_file,'10\t\t%2.0f\n',score_sl11_t1);
fprintf(global_result_file,'11\t\t%2.0f\n',score_sl12_t1);
fprintf(global_result_file,'Anzahl aller Speichen: %2.0f\n',score_T1);
fprintf(global_result_file,'Kriterium um zu bestehen: 37 Speichen.\n');
if score_T1 >36;
    fprintf(global_result_file,'Test wurde bestanden.');
else
    fprintf(global_result_file,'Test wurde nicht bestanden.');
end
close all;
