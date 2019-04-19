# script to generate the overview and individual html report website.

import os
import numpy

def main(result_folder, name, header_comp):

	menu_html_file_path = '/home/brain/qa/html/menu_html.html'
	menu_html_file = open(menu_html_file_path, 'r')
	menu_html = menu_html_file.readlines()
	menu_html_file.close()

	result_folder_list = os.listdir(result_folder)
	
	if not 'results.html' in result_folder_list:

		report_file_name = ''

		for i in result_folder_list:
			if i.startswith('report_'):
				report_file_name = i
		
		

		report_file = open(result_folder +'/'+ report_file_name,'r')
		html_file = open(result_folder +'/results.html','w')
		#read reportfile
		report_file_list = []
		for line in report_file:
			for word in line.split():
				report_file_list.append(word)


		html_file.writelines(menu_html)
		html_file.write('\t\t<h1 style="margin-top:80px;">Result structural-data '+name+'</h1>\n')
		html_file.write('\t\t<table>\n\t\t\t<tr bgcolor=#f6f6f6><td><b>pSignal</b></td><td>'+report_file_list[1]+'</td></tr>\n')
		html_file.write('\t\t\t<tr bgcolor=#ffffff><td><b>pNoise</b></td><td>'+report_file_list[3]+'</td></tr>\n')
		html_file.write('\t\t\t<tr bgcolor=#f6f6f6><td><b>bSNR</b></td><td>'+report_file_list[5]+'</td></tr>\n\t\t</table>\n')
	
		html_file.write('\t\t<h2>Header comparison </h1>\n')
		if not header_comp:
			html_file.write('\t\t<p>No differences between headers or no DICOM file to compare available.</p>\n')
		else:
			html_file.write('\t\t<table>\n\t\t\t<th><td colspan="3"><b>DICOM header comparison</b></td></th>\n')
			html_file.write('\t\t\t<tr><td><b>Field name</b></td><td><b>Reference value</b></td><td><b>Value in data</b></td></tr>\n')
			for k in header_comp:
				try:
					html_file.write('\t\t\t<tr><td><i>'+str(k[0])+'</i></td><td>'+str(k[1])+'</td><td>'+str(k[2])+'</td></tr>\n')
				except:
					html_file.write('\t\t\t<tr><td><i>'+str(k[0])+'</i></td><td>'+k[1].encode('utf-8')+'</td><td>'+k[2].encode('utf-8')+'</td></tr>\n')
			html_file.write('\t\t</table>\n')
		html_file.write('\t\t<h2>Histogram of pNoise</h2>\n\t\t<p><img src="histogram_'+name+'.png" alt="histogram_of_noise"</p>\n')
		html_file.write('\t\t<h2>Histogram of pNoise (intensity > 30 )</h2>\n\t\t<p><img src="histogram_upper_values_'+name+'.png" alt="histogram_of_noise"</p>\n')
		html_file.write('\t\t<h2>Background mask slice 0</h2>\n\t\t<p><img src="slice0.png" alt="slice0"</p>\n')
		html_file.write('\t\t<h2>Background mask slice 25%</h2>\n\t\t<p><img src="slice25p.png" alt="slice25p"</p>\n')
		html_file.write('\t\t<h2>Background mask slice 50%</h2>\n\t\t<p><img src="slice50p.png" alt="slice50p"</p>\n')
		html_file.write('\t\t<h2>Background mask slice 75%</h2>\n\t\t<p><img src="slice75p.png" alt="slice75p"</p>\n')
		html_file.write('\t\t<h2>Background mask last slice </h2>\n\t\t<p><img src="sliceend.png" alt="sliceend"</p>\n')
		html_file.write('\t</body>\n')
		html_file.write('</html>')
		html_file.close()


def generate_overview_html(result_folder,human_structural_settings):
	menu_html_file_path = '/home/brain/qa/html/menu_html.html'
	menu_html_file = open(menu_html_file_path, 'r')
	menu_html = menu_html_file.readlines()
	menu_html_file.close()

	result_file = open(result_folder+'overview.html','w')
	result_file.writelines(menu_html)
	result_file.write('\t\t<h1 style="margin-top:80px;">Structural Results Overview</h1>\n')
	result_file.write('\t\t<h2>Primitive mean intensity of brainmask (pSignal)</h2>\n\t\t<p><img src="pMean.png" alt="Mean intensity of brainmask"></p>\n')
	result_file.write('\t\t<h2>standard deviation of background (pNoise)</h2>\n\t\t<p><img src="pNoise.png" alt="Std of background"></p>\n')
	result_file.write('\t\t<h2>Signal to noise ratio (bSNR)</h2>\n\t\t<p><img src="bSNR.png" alt="Signal to noise ratio"></p>\n')
	
	if human_structural_settings[8] == 0:
		automatic_flag = False
	else: 
		automatic_flag = True

	std_automatic_multiplier = human_structural_settings[9]

	if automatic_flag:
		os.chdir('/home/brain/qa/html/results/structural/')	
		result_folder_list = os.listdir(result_folder)
		names = []
		mean = []
		noise = []
		snr = []

		for i in result_folder_list:
			if os.path.isdir(result_folder+i):
				sub_result_folder_list = os.listdir(result_folder+i)

				for j in sub_result_folder_list:
					sub_sub_result_folder_list = os.listdir(result_folder+i+'/'+j)

					for k in sub_sub_result_folder_list:
						sub_sub_sub_result_folder_list = os.listdir(result_folder+i+'/'+j+'/'+k)
		
						for l in sub_sub_sub_result_folder_list:
							if l.startswith('report'):
								names.append(i+'_'+j+'\n'+k)
								report_file = open(result_folder+i+'/'+j+'/'+k+'/'+l,'r')
								for data in report_file:
									values = data.split()
									if values[0].startswith('Mean_'):
										mean.append(float(values[1]))
									if values[0].startswith('Std_'):
										noise.append(float(values[1]))
									if values[0].startswith('SNR'):
										snr.append(float(values[1]))
								report_file.close()

		auto_mean_mean = numpy.mean(mean)
		auto_mean_std = numpy.std(mean) * float(std_automatic_multiplier)
		auto_noise_mean = numpy.mean(noise)
		auto_noise_std = numpy.std(noise) * float(std_automatic_multiplier)
		auto_snr_mean = numpy.mean(snr)
		auto_snr_std = numpy.std(snr) * float(std_automatic_multiplier)

		plus_settings_mean = auto_mean_mean + auto_mean_std
		minus_settings_mean = auto_mean_mean - auto_mean_std
		plus_settings_noise =  auto_noise_mean+ auto_noise_std
		minus_settings_noise = auto_noise_mean - auto_noise_std
		plus_settings_snr = auto_snr_mean + auto_snr_std
		minus_settings_snr = auto_snr_mean - auto_snr_std
	else:
		mean_mean = float(human_structural_settings[1])
		range_mean = float(human_structural_settings[2])
		noise_mean = float(human_structural_settings[3])
		range_noise = float(human_structural_settings[4])
		snr_mean = float(human_structural_settings[5])
		range_snr = float(human_structural_settings[6])

		plus_settings_mean = mean_mean + range_mean
		minus_settings_mean = mean_mean - range_mean
		plus_settings_noise =  noise_mean+ range_noise
		minus_settings_noise = noise_mean - range_noise
		plus_settings_snr = snr_mean + range_snr
		minus_settings_snr = snr_mean - range_snr


	

	result_folder_list = os.listdir(result_folder)
	for i in result_folder_list:
		if os.path.isdir(result_folder+i):
			result_file.write('\t\t<h2>'+i+'</h2>\n')
			result_sub_folder_list = os.listdir(result_folder+i)
			result_sub_folder_list .sort()
			for j in result_sub_folder_list:
				result_file.write('\t\t<h3>'+j+'</h3>\n')
				result_sub_sub_folder_list = os.listdir(result_folder+i+'/'+j)
				result_sub_sub_folder_list .sort()
				result_file.write('\t\t<ul>\n')
				for k in result_sub_sub_folder_list:
					sub_sub_sub_result_folder_list = os.listdir(result_folder+i+'/'+j+'/'+k)
					mean = 0
					noise = 0
					snr = 0	
					for l in sub_sub_sub_result_folder_list:
						if l.startswith('report'):
							
							report_file = open(result_folder+i+'/'+j+'/'+k+'/'+l,'r')
							for data in report_file:
								values = data.split()
								if values[0].startswith('Mean_'):
									mean = float(values[1])
								if values[0].startswith('Std_'):
									noise = float(values[1])
								if values[0].startswith('SNR'):
									snr = float(values[1])
							report_file.close()

					if(mean > plus_settings_mean) or (mean < minus_settings_mean) or (noise > plus_settings_noise) or (noise < minus_settings_noise) or (snr > plus_settings_snr) or (snr < minus_settings_snr):
						result_file.write('\t\t\t<li><img src="/warning.png"><a href="/results/structural/'+i+'/'+j+'/'+k+'/results.html">'+k+'</a></li>\n')
					else:					
						result_file.write('\t\t\t<li><a href="/results/structural/'+i+'/'+j+'/'+k+'/results.html">'+k+'</a></li>\n')
				result_file.write('\t\t</ul>\n')


	result_file.write('\t</body>\n</html>')

	result_file.close()



