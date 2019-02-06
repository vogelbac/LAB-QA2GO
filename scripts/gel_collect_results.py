# script to create a overview file with all measurements listed.
# a new text file is created and from all subfolders the values.txt file is copied into it

import os
import sys

def main(result_folder):
	######### Main routine

	erg_path = result_folder

	fobj = open(erg_path+'overview.txt','w')

	#liste mit Werten
	value_list =['Phantomname','SNR_Value','Signal_summary_Value','variance_summary_value','intrinsic_noise','SFNR_Value','percent_fluctuation','drift','drift_intensity','mean_max_ghost_freq','min_max_ghost_freq','max_max_ghost_freq','sd_max_ghost_freq','mean_max_ghost_phase','min_max_ghost_phase','max_max_ghost_phase','sd_max_ghost_phase','mean_mean_ghost_freq','min_mean_ghost_freq','max_mean_ghost_freq','sd_mean_ghost_freq','mean_mean_ghost_phase','min_mean_ghost_phase','max_mean_ghost_phase','sd_mean_ghost_phase','mean_psc','sd_psc','max_psc','min_psc','PSG_volume','PSG_signal_image','mean_piu_value','min_piu_value','max_piu_value','std_piu_value','mean_piu_value2','min_piu_value2','max_piu_value2','std_piu_value2']


	def is_in_list(value):
		temp = False
		for i in value_list:
			if value == i:
				temp = True
		return temp


	temp_list = []		

	erg_folder = os.listdir(erg_path)
	erg_folder.sort()

	for v in value_list:
		fobj.write(v+'\t')

	fobj.write('\n')

	for i in erg_folder:
		if os.path.isdir(erg_path+i):
			measurement_folder = os.listdir(erg_path+i+'/')
			measurement_folder.sort()
			for j in measurement_folder:
				value_path = erg_path+i+'/' + j +'/values_'+j+'.txt'
				if os.path.exists(value_path):
					values = open(value_path,'r')
					for k in values:
						fobj.write(k+'\t')
					fobj.write('\n')
					values.close()
		
	fobj.close()
