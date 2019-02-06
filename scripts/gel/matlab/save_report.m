%%
%% This function writes all general settings in a file.
%%

function save_report(phantom_year,phantom_month,phantom_day,phantom_hour,phantom_minute,phantom_name,helium,temperature,dim1,dim2,dim3,dim4,tr,soi,remove_time_series,roi_length,roi_ghost_length,filename,spike_array,spike_array_counter)

    name = strcat('report_',phantom_name);
    fullname = strcat(name,'.txt');
    fid = fopen(fullname, 'w');
        
    fprintf(fid, 'Phantom_Year:\t%s\n', phantom_year);
    fprintf(fid, 'Phantom_Month:\t%s\n', phantom_month);
    fprintf(fid, 'Phantom_Day:\t%s\n', phantom_day);
    fprintf(fid, 'Phantom_Hour:\t%s\n', phantom_hour);
    fprintf(fid, 'Phantom_Minute:\t%s\n', phantom_minute);
    fprintf(fid, 'Phantom_Name:\t%s\n', phantom_name);
    fprintf(fid, 'Helium:\t%s\n', helium);
    fprintf(fid, 'Temperature:\t%s\n', temperature);
    fprintf(fid, 'Dimension_1:\t%.0f\n', dim1);
    fprintf(fid, 'Dimension_2:\t%.0f\n', dim2);
    fprintf(fid, 'Dimension_3:\t%.0f\n', dim3);
    fprintf(fid, 'Dimension_4:\t%.0f\n', dim4);
    fprintf(fid, 'TR:\t%.0f\n', tr);
    fprintf(fid, 'Slice_of_Intrest:\t%.0f\n', soi);
    fprintf(fid, 'Remove_Time_Series:\t%.0f\n', remove_time_series);
    fprintf(fid, 'ROI_Size:\t%.0f\n', roi_length);
    fprintf(fid, 'Ghost_ROI_Size:\t%.0f\n', roi_ghost_length);
    fprintf(fid, 'Filename:\t%s\n', filename);
    fclose(fid);
    
    name = strcat('spikes_',phantom_name);
    fullname = strcat(name,'.txt');
    fid = fopen(fullname, 'w');
    if spike_array_counter > 1
        fprintf(fid, 'Spikedetection\n');
        fprintf(fid, 'Propability\tFrequence\tMagnitude\n');
        for i = 1:spike_array_counter-1
            fprintf(fid, '%.4f\t%.4f\t%.4f\n',spike_array(i,1),spike_array(i,2),spike_array(i,3));
        end
    end

    fclose(fid);

end
