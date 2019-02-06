# script to generate the individual gel tesult page
import os



def main(result_folder):
	menu_html_file_path = '/home/brain/qa/html/menu_html.html'
	menu_html_file = open(menu_html_file_path, 'r')
	menu_html = menu_html_file.readlines()
	menu_html_file.close()

	result_folder_list = os.listdir(result_folder)

	for i in result_folder_list:
		if os.path.isdir(result_folder + i):
			measurement = os.listdir(result_folder + i)
			for j in measurement:
				all_files = os.listdir(result_folder + i+'/' + j)
				#wenn result.html noch nicht existiert
				if not 'results.html' in all_files:
					html_file = open(result_folder + i+'/' + j+'/results.html','w')
					value_file = open(result_folder + i+'/' + j+'/values_'+j+'.txt','r')
					report_file = open(result_folder + i+'/' + j+'/report_'+j+'.txt','r')
					#read reportfile
					report_file_list = []
					for line in report_file:
						for word in line.split():
							report_file_list.append(word)
					
					value_file_list = value_file.readlines()
					value_file_list = value_file_list[0].split()


					html_file.writelines(menu_html)
					html_file.write('\t\t<h1 style="margin-top:80px;">Result Gel-Phantom '+j+'</h1>\n')

					html_file.write('\t\t<table>\n\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>Measurement day</b></td><td>'+report_file_list[1]+'-'+report_file_list[3]+'-'+report_file_list[5]+'</td><td><b>Measurement time</b></td><td>'+report_file_list[7]+':'+report_file_list[9]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#ffffff>\n\t\t\t\t<td><b>Helium</b></td><td>'+report_file_list[13]+' %</td><td><b>Temperature</b></td><td>'+report_file_list[15]+' &deg; C</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>Dimensions</b></td><td>'+report_file_list[17]+'x'+report_file_list[19]+'x'+report_file_list[21]+'x'+report_file_list[23]+'</td><td><b>TR</b></td><td>'+report_file_list[25]+' sec</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#ffffff>\n\t\t\t\t<td><b>Slice of interest</b></td><td>'+report_file_list[27]+'</td><td><b>Removed time series</b></td><td>'+report_file_list[29]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>ROI size</b></td><td>'+report_file_list[31]+'</td><td><b>Ghosting ROI size</b></td><td>'+report_file_list[33]+'</td>\n\t\t\t</tr>\n\t\t</table>\n')
					html_file.write('\t\t<p>\n\t\t\t<b>File:</b> '+report_file_list[35]+'\n\t\t</p>\n')
					
					html_file.write('\t\t<table>\n\t\t\t<tr bgcolor=#dddddd> \n\t\t\t\t<td colspan="4"><b>Friedman parameters</b></td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>SNR</b></td><td>'+value_file_list[1]+'</td><td><b>SFNR</b></td><td>'+value_file_list[5]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#ffffff>\n\t\t\t\t<td><b>Signal summary value</b></td><td>'+value_file_list[2]+'</td><td><b>Variance summary value</b></td><td>'+value_file_list[3]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>Intrinsic noise</b></td><td>'+value_file_list[4]+'</td><td><b>Fluctuation</b></td><td>'+value_file_list[6]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#ffffff>\n\t\t\t\t<td><b>Drfit</b></td><td>'+value_file_list[7]+'</td><td><b>Drift(intensity)</b></td><td>'+value_file_list[8]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#dddddd>\n\t\t\t\t<td colspan="4"><b>Stoecker parameters</b></td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>Mean PSC</b></td><td>'+value_file_list[25]+'</td><td><b>SD PSC</b></td><td>'+value_file_list[26]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#ffffff>\n\t\t\t\t<td><b>Min PSC</b></td><td>'+value_file_list[28]+'</td><td><b>Max PSC</b></td><td>'+value_file_list[27]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#dddddd>\n\t\t\t\t<td colspan="4"><b>Ghosting parameters (Simmons)</b></td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>Mean max ghosting frequency</b></td><td>'+value_file_list[9]+'</td><td><b>SD max ghosting frequency</b></td><td>'+value_file_list[12]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#ffffff>\n\t\t\t\t<td><b>Min max ghosting frequency</b></td><td>'+value_file_list[10]+'</td><td><b>Max max ghosting frequency</b></td><td>'+value_file_list[11]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>Mean max ghosting phase</b></td><td>'+value_file_list[13]+'</td><td><b>SD max ghosting phase</b></td><td>'+value_file_list[16]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#ffffff>\n\t\t\t\t<td><b>Min max ghosting phase</b></td><td>'+value_file_list[14]+'</td><td><b>Max max ghosting phase</b></td><td>'+value_file_list[15]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>Mean mean ghosting frequency</b></td><td>'+value_file_list[17]+'</td><td><b>SD mean ghosting frequency</b></td><td>'+value_file_list[20]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#ffffff>\n\t\t\t\t<td><b>Min mean ghosting frequency</b></td><td>'+value_file_list[18]+'</td><td><b>Max mean ghosting frequency</b></td><td>'+value_file_list[19]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>Mean mean ghosting phase</b></td><td>'+value_file_list[21]+'</td><td><b>SD mean ghosting phase</b></td><td>'+value_file_list[24]+'</td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#ffffff>\n\t\t\t\t<td><b>Min mean ghosting phase</b></td><td>'+value_file_list[22]+'</td><td><b>Max mean ghosting phase</b></td><td>'+value_file_list[23]+'</td>\n\t\t\t</tr>\n')
					
					html_file.write('\t\t\t<tr bgcolor=#dddddd>\n\t\t\t\t<td colspan="4"><b>ACR - Parameter</b></td>\n\t\t\t</tr>\n')
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>mean PIU without mask</b></td><td>'+value_file_list[31]+'</td><td><b>SD PIU without mask</b></td><td>'+value_file_list[34]+'</td>\n\t\t\t</tr>\n')	
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>Min PIU without mask</b></td><td>'+value_file_list[32]+'</td><td><b>Max PIU without mask</b></td><td>'+value_file_list[33]+'</td>\n\t\t\t</tr>\n')	
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>mean PIU with mask</b></td><td>'+value_file_list[35]+'</td><td><b>SD PIU with mask</b></td><td>'+value_file_list[38]+'</td>\n\t\t\t</tr>\n')	
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>Min PIU with mask</b></td><td>'+value_file_list[36]+'</td><td><b>Max PIU with mask</b></td><td>'+value_file_list[37]+'</td>\n\t\t\t</tr>\n')	
					html_file.write('\t\t\t<tr bgcolor=#f6f6f6>\n\t\t\t\t<td><b>PSG volume</b></td><td>'+value_file_list[29]+'</td><td><b>PSG signal image</b></td><td>'+value_file_list[30]+'</td>\n\t\t\t</tr>\n\t\t</table>\n')

					html_file.write('\t\t<h1> Images </h1>\n')
					html_file.write('\t\t<h2>Signal Image</h2>\n\t\t<p>\n\t\t\t<img src="Signal_Image_'+j+'.png" alt="Signal_Image"\n\t\t</p>\n')
					html_file.write('\t\t<h2>Static Spatial Noise Image</h2>\n\t\t<p>\n\t\t\t<img src="Static_Spatial_Noise_Image_'+j+'.png" alt="Static_Spatial_Noise_Image"\n\t\t</p>\n')
					html_file.write('\t\t<h2>Temporal Fluctuation Noise Image</h2>\n\t\t<p>\n\t\t\t<img src="Temporal_Fluctuation_Noise_Image_'+j+'.png" alt="Temporal_Fluctuation_Noise_Image"\n\t\t</p>\n')
					html_file.write('\t\t<h2>Signal To Fluctuation Noise Image</h2>\n\t\t<p>\n\t\t\t<img src="Signal_To_Fluictuation_Noise_Image_ROI_'+j+'.png" alt="Signal_To_Fluictuation_Noise_Image_ROI"\n\t\t</p>\n')
					html_file.write('\t\t<h2>Binary mask phantom over time</h2>\n\t\t<p>\n\t\t\t<img src="Bin_mask_pahntom_time_'+j+'.png" alt="Bin_mask_pahntom_time"\n\t\t</p>\n')
					html_file.write('\t\t<h2>Fit ROI Intensity</h2>\n\t\t<p>\n\t\t\t<img src="Fit_ROI_Intensity_'+j+'.png" alt="Fit_ROI_Intensity"\n\t\t</p>\n')
					html_file.write('\t\t<h2>Fit ROI Intensity Zoom</h2>\n\t\t<p>\n\t\t\t<img src="Fit_ROI_Intensity_Zoom_'+j+'.png" alt="Fit_ROI_Intensity_Zoom"\n\t\t</p>\n')
					html_file.write('\t\t<h2>Fitted values</h2>\n\t\t<p>\n\t\t\t<img src="Fitted_values_'+j+'.png" alt="Fitted_values"\n\t\t</p>\n')
					html_file.write('\t\t<h2>PSC per slice</h2>\n\t\t<p>\n\t\t\t<img src="PSC_per_slice_'+j+'.png" alt="PSC_per_slice"\n\t\t</p>\n')
					html_file.write('\t\t<h2>PSG per slice</h2>\n\t\t<p>\n\t\t\t<img src="PSG_per_slice_'+j+'.png" alt="PSG_per_slice"\n\t\t</p>\n')
					html_file.write('\t\t<h2>Ghosting</h2>\n\t\t<p>\n\t\t\t<img src="Ghosting_'+j+'.png" alt="Ghosting"\n\t\t</p>\n')
					html_file.write('\t\t<h2>Fast Fourier Transformation</h2>\n\t\t<p>\n\t\t\t<img src="Fast_Fourier_Transformation_'+j+'.png" alt="Fast_Fourier_Transformation_"\n\t\t</p>\n')
					html_file.write('\t\t<h2>PIU without mask</h2>\n\t\t<p>\n\t\t\t<img src="PIU_'+j+'.png" alt="PIU"</p><p><img src="PIU_intensity_Roi_'+j+'.png" alt="PIU_intensity_Roi"\n\t\t</p>\n')
					html_file.write('\t\t<h2>PIU with mask</h2>\n\t\t<p>\n\t\t\t<img src="PIU_mask_'+j+'.png" alt="PIU_mask"</p><p><img src="PIU_intensity_Roi_mask_'+j+'.png" alt="PIU_intensity_mask_Roi"\n\t\t</p>\n')
					html_file.write('\t</body>\n</html>')
					
					html_file.close()
					value_file.close()
					report_file.close()
