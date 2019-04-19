import os,sys
sys.path.append('/home/brain/qa/scripts/')
import cgi
import cgitb; cgitb.enable()


# set HOME environment variable to a directory the httpd server can write to
os.environ[ 'HOME' ] = '/tmp/'
 
os.chdir('/home/brain/qa/html/results/structural/')	
import matplotlib
# chose a non-GUI backend
matplotlib.use( 'Agg' )

import pylab

import parse_ini_file
import numpy




def run(structural_result_directory):
	
	human_structural_settings = parse_ini_file.parse_ini_file('human_structural_settings')
	if human_structural_settings[8] == 0:
		automatic_flag = False
	else: 
		automatic_flag = True

	std_automatic_multiplier = human_structural_settings[9]

	os.chdir('/home/brain/qa/html/results/structural/')	
	human_structural_settings = parse_ini_file.parse_ini_file('human_structural_settings')
	result_folder_list = os.listdir(structural_result_directory)
	names = []
	mean = []
	noise = []
	snr = []

	for i in result_folder_list:
		if os.path.isdir(structural_result_directory+i):
			sub_result_folder_list = os.listdir(structural_result_directory+i)

			for j in sub_result_folder_list:
				sub_sub_result_folder_list = os.listdir(structural_result_directory+i+'/'+j)

				for k in sub_sub_result_folder_list:
					sub_sub_sub_result_folder_list = os.listdir(structural_result_directory+i+'/'+j+'/'+k)
		
					for l in sub_sub_sub_result_folder_list:
						if l.startswith('report'):
							names.append(i+'_'+j+'\n'+k)
							report_file = open(structural_result_directory+i+'/'+j+'/'+k+'/'+l,'r')
							for data in report_file:
								values = data.split()
								if values[0].startswith('Mean_'):
									mean.append(float(values[1]))
								if values[0].startswith('Std_'):
									noise.append(float(values[1]))
								if values[0].startswith('SNR'):
									snr.append(float(values[1]))
							report_file.close()
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


	#calculate mean und std.
	auto_mean_mean = numpy.mean(mean)
	auto_mean_std = numpy.std(mean) * float(std_automatic_multiplier)
	auto_noise_mean = numpy.mean(noise)
	auto_noise_std = numpy.std(noise) * float(std_automatic_multiplier)
	auto_snr_mean = numpy.mean(snr)
	auto_snr_std = numpy.std(snr) * float(std_automatic_multiplier)
	
	numElements = range(1,len(names)+1)
	number_of_shown_values = human_structural_settings[7]


	matplotlib.pyplot.figure(figsize=(15,8))
	matplotlib.pyplot.plot(numElements, mean, 'bo',markersize=2)
	matplotlib.pyplot.xticks(numElements, names,rotation=75,fontsize=8)
	matplotlib.pyplot.title('pSignal')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Name')
	axes.set_ylabel('pSignal in intensity')
	if automatic_flag:
		axes.axhspan((auto_mean_mean-auto_mean_std), (auto_mean_mean+auto_mean_std), alpha=0.5, color='blue')
	else:
		axes.axhspan(minus_settings_mean, plus_settings_mean, alpha=0.5, color='green')
	axes.set_ylim([min(mean)-50,max(mean)+50])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	if automatic_flag:
		blue_patch = matplotlib.patches.Patch(color='blue', label='Mean intensity +/- std')
		matplotlib.pyplot.legend(handles=[blue_patch], fontsize=10)	
	else:
		green_patch = matplotlib.patches.Patch(color='green', label='Mean intensity range value')
		matplotlib.pyplot.legend(handles=[green_patch], fontsize=10)
	matplotlib.pyplot.savefig('pMean')

	matplotlib.pyplot.figure(figsize=(15,8))
	matplotlib.pyplot.plot(numElements, noise, 'bo',markersize=2)
	matplotlib.pyplot.xticks(numElements, names,rotation=75,fontsize=8)
	matplotlib.pyplot.title('pNoise')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Name')
	axes.set_ylabel('pNoise in intensity')
	if automatic_flag:
		axes.axhspan((auto_noise_mean-auto_noise_std), (auto_noise_mean+auto_noise_std), alpha=0.5, color='blue')
	else:
		axes.axhspan(minus_settings_noise, plus_settings_noise, alpha=0.5, color='green')
	axes.set_ylim([min(noise)-50,max(noise)+50])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	if automatic_flag:
		blue_patch = matplotlib.patches.Patch(color='blue', label='Mean noise +/- std')
		matplotlib.pyplot.legend(handles=[blue_patch], fontsize=10)	
	else:
		green_patch = matplotlib.patches.Patch(color='green', label='Mean noise range value')
		matplotlib.pyplot.legend(handles=[green_patch], fontsize=10)
	matplotlib.pyplot.savefig('pNoise')

	matplotlib.pyplot.figure(figsize=(15,8))
	matplotlib.pyplot.plot(numElements, snr, 'bo',markersize=2)
	matplotlib.pyplot.xticks(numElements, names,rotation=75,fontsize=8)
	matplotlib.pyplot.title('bSNR')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Name')
	axes.set_ylabel('bSNR')
	if automatic_flag:
		axes.axhspan((auto_snr_mean-auto_snr_std), (auto_snr_mean+auto_snr_std), alpha=0.5, color='blue')
	else:
		axes.axhspan(minus_settings_snr, plus_settings_snr, alpha=0.5, color='green')
	axes.set_ylim([min(snr)-10,max(snr)+10])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	if automatic_flag:
		blue_patch = matplotlib.patches.Patch(color='blue', label='Mean bSNR +/- std')
		matplotlib.pyplot.legend(handles=[blue_patch], fontsize=10)	
	else:
		green_patch = matplotlib.patches.Patch(color='green', label='bSNR range value')
		matplotlib.pyplot.legend(handles=[green_patch], fontsize=10)
	matplotlib.pyplot.savefig('bSNR')

