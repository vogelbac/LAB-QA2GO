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




def run(structural_result_directory):
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
	axes.axhspan(minus_settings_mean, plus_settings_mean, alpha=0.5, color='green')
	axes.set_ylim([min(mean)-50,max(mean)+50])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
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
	axes.axhspan(minus_settings_noise, plus_settings_noise, alpha=0.5, color='green')
	axes.set_ylim([min(noise)-50,max(noise)+50])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
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
	axes.axhspan(minus_settings_snr, plus_settings_snr, alpha=0.5, color='green')
	axes.set_ylim([min(snr)-10,max(snr)+10])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='bSNR range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=10)
	matplotlib.pyplot.savefig('bSNR')

