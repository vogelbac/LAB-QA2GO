# script to generate the overview and individual html report website.

import os

def main(result_folder, name):

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



