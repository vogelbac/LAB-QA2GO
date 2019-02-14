# script to check the incoming data directory
# Main script for quality assurance
# First convert the incomming dicom files into nifti files.
# After this the name of the nifti file is used to start the specific procedure.
# The scripts looks for specific name tags and starts the appropriate skript (t1,functional,gel,acr)
# At the end the data is moved to the resultfolder and then the main and individual result pages were created.

import os
import shutil
import subprocess
import acr_generate_overview_measurement
import acr_generate_html_report
import acr_make_overview
import acr_generate_overview_overall
import gel_collect_results
import gel_make_html_report
import gel_make_overview_html
import fmri_generate_graph
import fmri_make_html_report
import structural_make_html_report
import parse_ini_file
import fmri_generate_overview_graphs
import structural_make_overview
import datetime
import time
import sys

#define paths
incoming_directory = '/home/brain/qa/conquest/data/incoming/'
working_directory = '/home/brain/qa/dicom/new/'
dicom_directory = '/home/brain/qa/dicom/converted/'
nifti_directory = '/home/brain/qa/nifti/'

nifti_realnames_new_directory = '/home/brain/qa/nifti_realnames/new/'
nifti_realnames_done_directory = '/home/brain/qa/nifti_realnames/done/'

acr_result_directory = '/home/brain/qa/html/results/acr/'
gel_result_directory = '/home/brain/qa/html/results/gel/'
functional_result_directory = '/home/brain/qa/html/results/functional/'
structural_result_directory = '/home/brain/qa/html/results/structural/'

acr_matlab_path = '/home/brain/qa/scripts/acr/matlab/'
gel_matlab_path = '/home/brain/qa/scripts/gel/matlab/'
structural_matlab_path ='/home/brain/qa/scripts/t1/'
functional_matlab_path ='/home/brain/qa/scripts/fmri/'

script_home_path = '/home/brain/qa/scripts/'

error_log_file_path = '/home/brain/qa/html/results/error_calc.log'

use_nifti = False

# get infos of ini-file
general_settings = parse_ini_file.parse_ini_file('genral_settings')
human_structural_settings = parse_ini_file.parse_ini_file('human_structural_settings')
phantom_settings = parse_ini_file.parse_ini_file('phantom_settings')
functional_settings = parse_ini_file.parse_ini_file('fmri_settings')
acr_view_settings = parse_ini_file.parse_ini_file('acr_settings')

# read timings from logfile
# @param: path to the logfile
# @return: list of date,time and name written in the logfile
def read_logfile(path):
	logfile = open(path,'r')
	hel = '-'
	temp = '-'
	for k in logfile:
		cut = k.strip()
		#print cut
		if cut.find('Image Date') > -1:
			date=cut.split()[-1][1:-1]
		if cut.find('Acquisition Time')> -1:
			time=cut.split()[-1][1:-8]
		if cut.find('Patient\'s Name') > -1:
			name=cut.split()[-1][1:-1]
		if cut.find('Patient Comments')>-1:
			line = cut.split()
			#search for helium and temperature
			hel_string = re.findall(r'[Hh][_?]\d+[.,]?\d+?',line[6])
			temp_string = re.findall(r'[Tt][_?]\d+[.,]?\d+?',line[6])
			if hel_string:			
				hel_value = re.findall(r'\d+[.,]?\d+?',hel_string[0])
				hel = hel_value[0].replace(',','.')
			if temp_string:
				temp_value = re.findall(r'\d+[.,]?\d+?',temp_string[0])
				temp = temp_value[0].replace(',','.')
				

	logfile.close()
	return [date,time,name,hel,temp]



if (len(sys.argv) == 1 ) or ((len(sys.argv)==2) and (sys.argv[1]=='dicom')):
	#list conquest incomming directory for new files
	incoming_directory_list = os.listdir(incoming_directory)
	#look for all directorys in /incoming/ and exclude permanent given directory /printer_files/
	#remove /printer_files/ from list
	incoming_directory_list.remove('printer_files')


	#convert and move files 
	#check if incoming directory list is not empty
	if len(incoming_directory_list) > 0:
		try:
			print ('Case working: ' + str(len(incoming_directory_list)) + ' object(s) remaining.')
			# for each element in the list
			for i in incoming_directory_list:
				# move data to working directory
				shutil.copytree(incoming_directory+i, working_directory +i)
				# remove incoming directory
				shutil.rmtree(incoming_directory+i)
				# make directory in nifti directory
				if not os.path.exists(nifti_directory + i):
		    			os.makedirs(nifti_directory + i)
				# convert dcm2nii
				os.chdir(script_home_path)
				subprocess.call('./convertdcm2nii.sh '+working_directory + str(i)+ ' ' + nifti_directory + str(i) + ' log_full' , shell=True)
				# move data to converted directory
				if  os.path.exists(working_directory+i+'/'):
					subprocess.call('cp -R '+working_directory+i+'/* '+dicom_directory+i+'/' , shell=True)
				else:
					shutil.copytree(working_directory+i+'/', dicom_directory+i+'/')
				shutil.rmtree(working_directory+i)
		except:
			error_log_file = open(error_log_file_path,'a')
			ts = time.time()
			st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
			error_log_file.write(st+' - Error during conversion of DICOM to NIfTI.\n')
			error_log_file.close()		
	else:
		print ('Case no new files')
		#incoming directory is empty
		#write error to logfile
		error_log_file = open(error_log_file_path,'a')
		ts = time.time()
		st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
		error_log_file.write(st+' - Incomming Conquest directory is empty.\n')
		error_log_file.close()	


if (len(sys.argv) == 3 and sys.argv[1] == 'nifti'):
	
	try:
		input_list = os.listdir(sys.argv[2])
		#copy data from input to custom_new_directory
		for i in input_list:
			shutil.copytree(sys.argv[2]+i,nifti_realnames_new_directory+i)
			shutil.copytree(sys.argv[2]+i,nifti_directory+i)
		use_nifti = True
	except:
		error_log_file = open(error_log_file_path,'a')
		ts = time.time()
		st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
		error_log_file.write(st+' - Manual calulation: Probelms during copy data.\n')
		error_log_file.close()	
#list nifti_realnames_new
nifti_realnames_new_directory_list = os.listdir(nifti_realnames_new_directory)

#flag values: set True if a specific calculation was performed
func_run_value = False
structural_run_value = False
acr_run_value = False
gel_run_value = False



# Description of measurement
for i in nifti_realnames_new_directory_list:
	nifti_realnames_new_sub_directory_list = os.listdir(nifti_realnames_new_directory+i)
	# measurements level
	for j in nifti_realnames_new_sub_directory_list:
		# check if dataset is phantomdata or humandata
		# nameconvention (if Phantom) is in name
		if ('Phantom' in j) or (general_settings[2] in j):
			# nameconvention ACR or GEL
			if ('ACR' in j) or (general_settings[3] in j):
				nifti_realnames_new_sub_acr_directory_list = os.listdir(nifti_realnames_new_directory+i+'/'+j)
				# phantom name convention for center marburg 
				# YYYYMMDD_AGB_QA_ACR_Phantom 
				# phantom name will be YYYY_MM_DD
				# phantom_name = j.split('_')[0][0:4]+'_'+j.split('_')[0][4:6]+'_'+j.split('_')[0][6:8]
				phantom_name = j
				result_path = acr_result_directory + phantom_name + '/'
				if not os.path.exists(result_path):
					os.mkdir(result_path)
				for k in nifti_realnames_new_sub_acr_directory_list:
					#use localizer 
					if ('001__localizer' in k) or ('002__localizer' in k) or (general_settings[9] in j):
						try:
							if use_nifti:
								real_path = nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'
							else:
								real_path = (os.path.realpath(nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'))
								subprocess.call('gunzip '+real_path+'/*.gz' , shell=True)
							real_path_list = os.listdir(real_path)
							for l in real_path_list:
								if l.endswith('.nii'):
									localizer_image = real_path+'/'+l
						except:
							shutil.rmtree(result_path, ignore_errors=True)
							error_log_file = open(error_log_file_path,'a')
							ts = time.time()
							st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
							error_log_file.write(st+' - Error: Can not find ACR localizer.\n')
							error_log_file.close()	
					# use T1 of ACR protocol
					if ('002__t1_fl2d_tra' in k) or ('003__t1_fl2d_tra' in k) or (general_settings[10] in j):
						try:
							if use_nifti:
								real_path = nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'
							else:
								real_path = (os.path.realpath(nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'))
								subprocess.call('gunzip '+real_path+'/*.gz' , shell=True)
							real_path_list = os.listdir(real_path)
							for l in os.listdir(real_path):
								if l.endswith('.nii'):
									t1_image = real_path+'/'+l
						except:
							shutil.rmtree(result_path, ignore_errors=True)
							error_log_file = open(error_log_file_path,'a')
							ts = time.time()
							st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
							error_log_file.write(st+' - Error: Can not find standard ACR t1.\n')
							error_log_file.close()
					# use T2 of ACR protocol
					if ('003__pd+t2_tse_tra' in k) or ('004__pd+t2_tse_tra' in k) or (general_settings[11] in j):
						try:
							if use_nifti:
								real_path = nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'
							else:
								real_path = (os.path.realpath(nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'))
								subprocess.call('gunzip '+real_path+'/*.gz' , shell=True)
							real_path_list = os.listdir(real_path)
							for l in os.listdir(real_path):
								if l.endswith('.nii'):
									t2_image = real_path+'/'+l
						except:
							shutil.rmtree(result_path, ignore_errors=True)
							error_log_file = open(error_log_file_path,'a')
							ts = time.time()
							st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
							error_log_file.write(st+' - Error: Can not find standard ACR t2.\n')
							error_log_file.close()
				try:		
					# change to matab/octave script folder 
					os.chdir(acr_matlab_path)
					# start octave
					subprocess.call ('octave --eval \"run_ACR_terminal(\''+localizer_image+'\',\''+t1_image+' \',\''+t2_image+' \',\''+result_path+'\')\"', shell=True)
					os.chdir(script_home_path)
					# move folder 
					shutil.move(nifti_realnames_new_directory+i+'/'+j+'/', nifti_realnames_done_directory+i+'/'+j+'/')
					acr_run_value = True
				
				except:
					shutil.rmtree(result_path, ignore_errors=True)
					error_log_file = open(error_log_file_path,'a')
					ts = time.time()
					st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
					error_log_file.write(st+' - Error during calculation or moving the ACR phantom QA values.\n')
					error_log_file.close()
			#start gel phantom pipeline
			if ('GEL' in j) or (general_settings[4] in j):
				nifti_realnames_new_sub_gel_directory_list = os.listdir(nifti_realnames_new_directory+i+'/'+j)
				# phantom name convention for center marburg 
				# YYYYMMDD_AGB_QA_ACR_Phantom 
				# phantom name will be YYYY_MM_DD
				# phantom_name = j.split('_')[0][0:4]+'_'+j.split('_')[0][4:6]+'_'+j.split('_')[0][6:8]
				phantom_name = j
				#if prae or post measurement for example before and after maintanance service should be performed
				if ('Prae' in j) or ('vor' in j) or ('Vor' in j) or (general_settings[5] in j):
					phantom_name = phantom_name + '_prae'
				if ('Post' in j) or ('nach' in j) or ('Nach' in j) or (general_settings[6] in j):
					phantom_name = phantom_name + '_post'
				if not os.path.exists(gel_result_directory + phantom_name + '/'):
					os.mkdir(gel_result_directory + phantom_name)
				result_path = gel_result_directory + phantom_name + '/'
				for k in nifti_realnames_new_sub_gel_directory_list:
					if ('004__ep2d_bold_TR2000' in k) or ('008__ep2d_bold_TR2000' in k) or (general_settings[7] in k) or(general_settings[8] in k):
						phantom_name_matlab = ''
						try:
							if use_nifti:
								real_path = nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'
							else:
								real_path = (os.path.realpath(nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'))
								subprocess.call('gunzip '+real_path+'/*.gz' , shell=True)
					
							real_path_list = os.listdir(real_path)
						
							phantom_date = ['-','-','-']
							phantom_time = ['-','-']
							helium = '-'
							temperature = '-'
							
							if os.path.exists(real_path+'/_logfile.txt')	:	
								logfile = read_logfile(real_path+'/_logfile.txt')
								phantom_date = logfile[0].split('.')
								phantom_time = logfile[1].split(':')
								helium = logfile[3]
								temperature = logfile[4]
								
					
							#add ending for baseline (1) or after heating process (2) if nothing matches then a (0)
							if ('004__ep2d_bold_TR2000' in k) or (general_settings[7] in k):
								phantom_name_matlab = phantom_name+'_1'
							elif ('008__ep2d_bold_TR2000' in k) or(general_settings[8] in k):
								phantom_name_matlab = phantom_name+'_2'
							else:
								phantom_name_matlab = phantom_name+'_0'						

							os.mkdir(gel_result_directory + phantom_name +'/'+phantom_name_matlab)
							result_path_matlab = gel_result_directory + phantom_name +'/'+phantom_name_matlab+'/'
						
							
						
					
						except:
							shutil.rmtree(gel_result_directory + phantom_name +'/'+phantom_name_matlab, ignore_errors=True)
							error_log_file = open(error_log_file_path,'a')
							ts = time.time()
							st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
							error_log_file.write(st+' - Error during reading LOG file of gel phantom.\n')
							error_log_file.close()

						try:
							for l in real_path_list:
								if '.nii' in l:
									#start matlab script
									in_file = real_path + l
									os.chdir(gel_matlab_path)
									subprocess.call ('octave --eval \"start_auswertung(\''+in_file+'\',\''+phantom_name_matlab+' \',\''+phantom_date[0]+' \',\''+phantom_date[1]+' \',\''+phantom_date[2]+' \',\''+phantom_time[0]+' \',\''+phantom_time[1]+' \',\''+helium +' \',\''+ temperature+'\')\"', shell=True)
							
			
									#copy into result folder
									subprocess.call('mv '+gel_matlab_path+'*.png '+result_path_matlab,shell=True)
									subprocess.call('mv '+gel_matlab_path+'*.txt '+result_path_matlab,shell=True)
									os.chdir(script_home_path)
						except:
							subprocess.call('rm -rf '+gel_matlab_path+'*.png',shell=True)							
							subprocess.call('rm -rf '+gel_matlab_path+'*.txt',shell=True)
							error_log_file = open(error_log_file_path,'a')
							ts = time.time()
							st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
							error_log_file.write(st+' - Error during calculation and moving the gel phantom QA values.\n')
							error_log_file.close()


			
				# flag for writing results	
				gel_run_value = True
			
					
	
		# check if dataset is structural or functional
		else:
			nifti_realnames_sub_sub_directory_list = os.listdir(nifti_realnames_new_directory+i+'/'+j)
			for k in nifti_realnames_sub_sub_directory_list: 			
				# if t1 -> use noise calculation
				if (('T1' in k) or ('t1' in k) or (general_settings[12] in k)) and (general_settings[0]=='1'): 
					if use_nifti:
						real_path = nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'
					else:					
						real_path = (os.path.realpath(nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'))
						subprocess.call('gunzip '+real_path+'/*.gz' , shell=True)
					real_path_list = os.listdir(real_path)
					# create result directories
					if not os.path.exists(structural_result_directory+i):
						os.mkdir(structural_result_directory+i)
					if not os.path.exists(structural_result_directory+i+'/'+j):
						os.mkdir(structural_result_directory+i+'/'+j)
					temp_result_directory = structural_result_directory+ i + '/' + j +'/'+k
					if not os.path.exists(structural_result_directory+i+'/'+j + '/' + k):
						os.mkdir(temp_result_directory)

					try:
						for l in real_path_list:
							if l.endswith('.nii') and not(l.startswith('o') or l.startswith('co')):
								name = l[:-4]
								#extract brain mask and start the measurement
								subprocess.call ('fsl5.0-bet '+ real_path+'/'+l +' ' +real_path+'/mask_'+l , shell=True)
								os.chdir(structural_matlab_path)
								image_path = real_path+'/'+l
								mask_path = real_path+'/mask_'+l+'.gz'
								default_threshold_faktor = human_structural_settings[0]
								subprocess.call ('octave --eval \"t1_noise_histogram(\''+image_path+'\',\''+mask_path+'\',\''+default_threshold_faktor+'\')\"', shell=True)
								subprocess.call('mv '+structural_matlab_path+'*.png '+temp_result_directory,shell=True)
								subprocess.call('mv '+structural_matlab_path+'*.txt '+temp_result_directory,shell=True)
				
								structural_make_html_report.main(temp_result_directory, name)
								structural_run_value = True
					except:
						shutil.rmtree(temp_result_directory, ignore_errors=True)
						subprocess.call('rm -rf '+structural_matlab_path+'*.png',shell=True)
						subprocess.call('rm -rf '+structural_matlab_path+'*.txt',shell=True)
						error_log_file = open(error_log_file_path,'a')
						ts = time.time()
						st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
						error_log_file.write(st+' - Error during structural calculation.\n')
						error_log_file.close()
				
				#human functional workflow- movement parameters
				if (('ep2d' in k) or (general_settings[12] in k)) and (general_settings[1] == '1'):
					try:					
						if use_nifti:
							real_path = nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'
						else:
							real_path = (os.path.realpath(nifti_realnames_new_directory+i+'/'+j+'/'+k+'/'))
							subprocess.call('gunzip '+real_path+'/*.gz' , shell=True)
						real_path_list = os.listdir(real_path)
						#create resulfolder
						if not os.path.exists(functional_result_directory+i):
							os.mkdir(functional_result_directory+i)
						if not os.path.exists(functional_result_directory+i+'/'+j):
							os.mkdir(functional_result_directory+i+'/'+j)
						temp_result_directory = functional_result_directory+ i + '/' + j +'/'+k
						if not os.path.exists(functional_result_directory+i+'/'+j + '/' + k):
							os.mkdir(temp_result_directory)
				

				
						for l in real_path_list:
							if l.endswith('.nii'):
								name = l[:-4]
								subprocess.call('fsl5.0-mcflirt -in '+real_path+'/'+l +' -plots', shell=True)
								subprocess.call('fsl5.0-fslinfo '+real_path+'/'+l +' > '+real_path+'/'+l+'_info.txt'  , shell=True)
								fmri_generate_graph.make_graphs(functional_matlab_path , real_path+'/'+name+'_mcf.par', name,j)
								subprocess.call('mv '+functional_matlab_path+'*.png '+temp_result_directory,shell=True)
								subprocess.call('mv '+functional_matlab_path+'values.txt '+temp_result_directory,shell=True)

								fmri_make_html_report.main(temp_result_directory,name)
					
						func_run_value = True
					except:
						shutil.rmtree(temp_result_directory, ignore_errors=True)
						subprocess.call('rm -rf '+functional_matlab_path+'*.png',shell=True)
						subprocess.call('rm -rf '+functional_matlab_path+'values.txt',shell=True)
						error_log_file = open(error_log_file_path,'a')
						ts = time.time()
						st = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
						error_log_file.write(st+' - Error during functional calculation.\n')
						error_log_file.close()
				
		shutil.move(nifti_realnames_new_directory+i+'/'+j+'/', nifti_realnames_done_directory+i+'/'+j+'/')
	if os.path.exists(nifti_realnames_new_directory+i) and len(os.listdir(nifti_realnames_new_directory+i)) == 0:
		os.rmdir(nifti_realnames_new_directory+i)
		



# collect and create results	
if (func_run_value): 
	number_of_shown_values = functional_settings[2]
	fmri_generate_overview_graphs.read_values_file(functional_result_directory, number_of_shown_values)
	fmri_make_html_report.generate_overview_html(functional_result_directory)
if (structural_run_value):
	structural_make_overview.run(structural_result_directory)
	structural_make_html_report.generate_overview_html(structural_result_directory,human_structural_settings)
if (acr_run_value):
	acr_generate_overview_measurement.main(acr_result_directory)
	acr_generate_html_report.read_logfile(acr_result_directory)
	acr_make_overview.main(acr_result_directory)
	number_of_shown_values = acr_view_settings[0]
	acr_generate_overview_overall.main(acr_result_directory+'overview.txt',acr_matlab_path,acr_result_directory,number_of_shown_values)
if (gel_run_value):
	gel_collect_results.main(gel_result_directory)
	gel_make_html_report.main(gel_result_directory)
	gel_make_overview_html.main(gel_result_directory+'overview.txt',gel_matlab_path,gel_result_directory,phantom_settings[12])			
	

