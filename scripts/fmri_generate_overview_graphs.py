#script for collection all values and mark outlier for the overview page
import os,sys
sys.path.append('/home/brain/qa/scripts/')
import cgi
import cgitb; cgitb.enable()


# set HOME environment variable to a directory the httpd server can write to
os.environ[ 'HOME' ] = '/tmp/'
 
os.chdir('/home/brain/qa/html/results/functional/')	
import matplotlib
# chose a non-GUI backend
matplotlib.use( 'Agg' )

import pylab

import parse_ini_file

def read_values_file(functional_result_directory, number_of_shown_values):

	os.chdir(functional_result_directory)

	functional_result_directory_list = os.listdir(functional_result_directory)

	overview_file = open(functional_result_directory + 'overview.txt','w')
	
	#all results
	for i in functional_result_directory_list:
		#all measurements of results
		if os.path.isdir(functional_result_directory + i):
			sub_folder = os.listdir(functional_result_directory + i)
			for j in sub_folder:
				# all measurents of study
				if os.path.isdir(functional_result_directory + i + '/' + j):
					sub_sub_folder = os.listdir(functional_result_directory + i + '/' + j)
					for k in sub_sub_folder:
						# all measurents of study
						if os.path.isdir(functional_result_directory + i + '/' + j + '/' + k):
							val_file = functional_result_directory + i + '/' + j + '/' + k + '/values.txt'
							if os.path.exists(val_file):
								val_file_id = open(val_file, 'r')
								val_file_content = val_file_id.readlines()
								val_file_id.close()
								overview_file.writelines(val_file_content)

	overview_file.close()

	overview_file = open(functional_result_directory + 'overview.txt','r')

	lines = overview_file.readlines()

	if (len(lines)-1 >= int(number_of_shown_values)):
		lines = lines[-int(number_of_shown_values):]	
	else:
		lines = lines[0:]

	name = []
	rotx_mean = []
	rotx_min = []
	rotx_max = []
	roty_mean = []
	roty_min = []
	roty_max = []
	rotz_mean = []
	rotz_min = []
	rotz_max = []
	transx_mean = []
	transx_min = []
	transx_max = []
	transy_mean = []
	transy_min = []
	transy_max = []
	transz_mean = []
	transz_min = []
	transz_max = []

	for i in lines:
		entry = i.split('\t')
		name.append(entry[0]+'\n'+entry[1])
		rotx_mean.append(entry[2])
		rotx_min.append(entry[3])
		rotx_max.append(entry[4])
		roty_mean.append(entry[5])
		roty_min.append(entry[6])
		roty_max.append(entry[7])
		rotz_mean.append(entry[8])
		rotz_min.append(entry[9])
		rotz_max.append(entry[10])
		transx_mean.append(entry[11])
		transx_min.append(entry[12])
		transx_max.append(entry[13])
		transy_mean.append(entry[14])
		transy_min.append(entry[15])
		transy_max.append(entry[16])
		transz_mean.append(entry[17])
		transz_min.append(entry[18])
		transz_max.append(entry[19].split('\n')[0])
		
	#get mean and 
	fmri_settings = parse_ini_file.parse_ini_file('fmri_settings')
	plus_settings_rot = float(fmri_settings[0]) 
	minus_settings_rot = -float(fmri_settings[0]) 
	plus_settings_trans = float(fmri_settings[1]) 
	minus_settings_trans = -float(fmri_settings[1]) 

	for i in range(0,len(name)):
		if float(rotx_min[i]) < minus_settings_rot:
			print (str(rotx_min[i]) + ' rot x min out of range')
		if float(rotx_max[i]) > plus_settings_rot:
			print (str(rotx_max[i]) + ' rot x max out of range')
		if float(roty_min[i]) < minus_settings_rot:
			print (str(roty_min[i]) + ' rot y min out of range')
		if float(roty_max[i]) > plus_settings_rot:
			print (str(roty_max[i]) + ' rot y max out of range')
		if float(rotz_min[i]) < minus_settings_rot:
			print (str(rotz_min[i]) + ' rot z min out of range')
		if float(rotz_max[i]) > plus_settings_rot:
			print (str(rotz_max[i]) + ' rot z max out of range')
		if float(transx_min[i]) < minus_settings_trans:
			print (str(transx_min[i]) + ' trans x min out of range')
		if float(transx_max[i]) > plus_settings_trans:
			print (str(transx_max[i]) + ' trans x max out of range')
		if float(transy_min[i]) < minus_settings_trans:
			print (str(transy_min[i]) + ' trans y min out of range')
		if float(transy_max[i]) > plus_settings_trans:
			print (str(transy_max[i]) + ' trans y max out of range')
		if float(transz_min[i]) < minus_settings_trans:
			print (str(transz_min[i]) + ' trans z min out of range')
		if float(transz_max[i]) > plus_settings_trans:
			print (str(transz_max[i]) + ' trans z max out of range')

	numElements= range(1,len(name)+1)

	min_rot = float(max(max(rotx_min),max(roty_min),max(rotz_min)))-0.05
	max_rot = float(max(max(rotx_max),max(roty_max),max(rotz_max)))+0.05
	min_trans = float(max(max(transx_min),max(transy_min),max(transz_min)))-1
	max_trans = float(max(max(transx_max),max(transy_max),max(transz_max)))+1

	

	
	if int(number_of_shown_values)==5:
		rotation_pitch_width=14
		rotation_pitch_height=7
		rotation_pitch_fontsize=6
		rotation_pitch_tickrota=40
		rotation_roll_width=14
		rotation_roll_height=7
		rotation_roll_fontsize=4
		rotation_roll_tickrota=40
		rotation_yaw_width=14
		rotation_yaw_height=7
		rotation_yaw_fontsize=4
		rotation_yaw_tickrota=40
		translation_x_width=14
		translation_x_height=7
		translation_x_fontsize=6
		translation_x_tickrota=40
		translation_y_width=14
		translation_y_height=7
		translation_y_fontsize=6
		translation_y_tickrota=40
		translation_z_width=14
		translation_z_height=7
		translation_z_fontsize=6
		translation_z_tickrota=40
	elif int(number_of_shown_values)==10:
		rotation_pitch_width=15
		rotation_pitch_height=7
		rotation_pitch_fontsize=4
		rotation_pitch_tickrota=60
		rotation_roll_width=15
		rotation_roll_height=7
		rotation_roll_fontsize=4
		rotation_roll_tickrota=60
		rotation_yaw_width=15
		rotation_yaw_height=7
		rotation_yaw_fontsize=4
		rotation_yaw_tickrota=60
		translation_x_width=15
		translation_x_height=7
		translation_x_fontsize=4
		translation_x_tickrota=60
		translation_y_width=15
		translation_y_height=7
		translation_y_fontsize=4
		translation_y_tickrota=60
		translation_z_width=15
		translation_z_height=7
		translation_z_fontsize=4
		translation_z_tickrota=60
	elif int(number_of_shown_values)==15:
		rotation_pitch_width=23
		rotation_pitch_height=10
		rotation_pitch_fontsize=16
		rotation_pitch_tickrota=70
		rotation_roll_width=23
		rotation_roll_height=10
		rotation_roll_fontsize=16
		rotation_roll_tickrota=70
		rotation_yaw_width=23
		rotation_yaw_height=10
		rotation_yaw_fontsize=16
		rotation_yaw_tickrota=70
		translation_x_width=23
		translation_x_height=10
		translation_x_fontsize=16
		translation_x_tickrota=70
		translation_y_width=23
		translation_y_height=10
		translation_y_fontsize=16
		translation_y_tickrota=70
		translation_z_width=23
		translation_z_height=10
		translation_z_fontsize=16
		translation_z_tickrota=70
	elif int(number_of_shown_values)==20:
		rotation_pitch_width=20
		rotation_pitch_height=7
		rotation_pitch_fontsize=6
		rotation_pitch_tickrota=75
		rotation_roll_width=20
		rotation_roll_height=7
		rotation_roll_fontsize=8
		rotation_roll_tickrota=75
		rotation_yaw_width=20
		rotation_yaw_height=7
		rotation_yaw_fontsize=6
		rotation_yaw_tickrota=75
		translation_x_width=20
		translation_x_height=7
		translation_x_fontsize=6
		translation_x_tickrota=75
		translation_y_width=20
		translation_y_height=7
		translation_y_fontsize=6
		translation_y_tickrota=75
		translation_z_width=20
		translation_z_height=7
		translation_z_fontsize=6
		translation_z_tickrota=75
	elif int(number_of_shown_values)==50:
		rotation_pitch_width=25
		rotation_pitch_height=7
		rotation_pitch_fontsize=4
		rotation_pitch_tickrota=90
		rotation_roll_width=30
		rotation_roll_height=10
		rotation_roll_fontsize=4
		rotation_roll_tickrota=90
		rotation_yaw_width=35
		rotation_yaw_height=12.5
		rotation_yaw_fontsize=4
		rotation_yaw_tickrota=90
		translation_x_width=40
		translation_x_height=15
		translation_x_fontsize=4
		translation_x_tickrota=90
		translation_y_width=45
		translation_y_height=17.5
		translation_y_fontsize=4
		translation_y_tickrota=90
		translation_z_width=50
		translation_z_height=20
		translation_z_fontsize=4
		translation_z_tickrota=90
	min_rot = float(max(max(rotx_min),max(roty_min),max(rotz_min)))-0.05
	max_rot = float(max(max(rotx_max),max(roty_max),max(rotz_max)))+0.05
	min_trans = float(max(max(transx_min),max(transy_min),max(transz_min)))-1
	max_trans = float(max(max(transx_max),max(transy_max),max(transz_max)))+1

	matplotlib.pyplot.figure(figsize=(rotation_pitch_width,rotation_pitch_height))
	matplotlib.pyplot.plot(numElements, rotx_mean, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, rotx_min, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, rotx_max, 'bo',markersize=2)
	matplotlib.pyplot.xticks(numElements, name,rotation=rotation_pitch_tickrota,fontsize=8)
	matplotlib.pyplot.title('Rotation Pitch')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Name')
	axes.set_ylabel('Rotation in rads')
	axes.axhspan(minus_settings_rot, plus_settings_rot, alpha=0.5, color='green')
	axes.set_ylim([min_rot,max_rot])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='Rotation range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=rotation_pitch_fontsize)
	matplotlib.pyplot.savefig('Rotation_Pitch')

	matplotlib.pyplot.figure(figsize=(rotation_roll_width,rotation_roll_height))
	matplotlib.pyplot.plot(numElements, roty_mean, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, roty_min, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, roty_max, 'bo',markersize=2)
	matplotlib.pyplot.xticks(numElements, name,rotation=rotation_roll_tickrota,fontsize=8)
	matplotlib.pyplot.title('Rotation Roll')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Name')
	axes.set_ylabel('Rotation in rads')
	axes.axhspan(minus_settings_rot, plus_settings_rot, alpha=0.5, color='green')
	axes.set_ylim([min_rot,max_rot])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='Rotation range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=rotation_roll_fontsize)
	matplotlib.pyplot.savefig('Rotation_Roll')

	matplotlib.pyplot.figure(figsize=(rotation_yaw_width,rotation_yaw_height))
	matplotlib.pyplot.plot(numElements, rotz_mean, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, rotz_min, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, rotz_max, 'bo',markersize=2)
	matplotlib.pyplot.xticks(numElements, name,rotation=rotation_yaw_tickrota,fontsize=8)
	matplotlib.pyplot.title('Rotation Yaw')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Name')
	axes.set_ylabel('Rotation in rads')
	axes.axhspan(minus_settings_rot, plus_settings_rot, alpha=0.5, color='green')
	axes.set_ylim([min_rot,max_rot])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='Rotation range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=rotation_yaw_fontsize)
	matplotlib.pyplot.savefig('Rotation_Yaw')

	matplotlib.pyplot.figure(figsize=(translation_x_width,translation_x_height))
	matplotlib.pyplot.plot(numElements, transx_mean, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, transx_min, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, transx_max, 'bo',markersize=2)
	matplotlib.pyplot.xticks(numElements, name,rotation=translation_x_tickrota,fontsize=8)
	matplotlib.pyplot.title('Translation X')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Name')
	axes.set_ylabel('Translation in mm')
	axes.axhspan(minus_settings_trans, plus_settings_trans, alpha=0.5, color='green')
	axes.set_ylim([min_trans,max_trans])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='Translation range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=translation_x_fontsize)
	matplotlib.pyplot.savefig('Translation_X')

	matplotlib.pyplot.figure(figsize=(translation_y_width,translation_y_height))
	matplotlib.pyplot.plot(numElements, transy_mean, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, transy_min, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, transy_max, 'bo',markersize=2)
	matplotlib.pyplot.xticks(numElements, name,rotation=translation_y_tickrota,fontsize=8)
	matplotlib.pyplot.title('Translation Y')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Name')
	axes.set_ylabel('Translation in mm')
	axes.axhspan(minus_settings_trans, plus_settings_trans, alpha=0.5, color='green')
	axes.set_ylim([min_trans,max_trans])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='Translation range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=translation_y_fontsize)
	matplotlib.pyplot.savefig('Translation_Y')

	matplotlib.pyplot.figure(figsize=(translation_z_width,translation_z_height))
	matplotlib.pyplot.plot(numElements, transz_mean, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, transz_min, 'bo',markersize=2)
	matplotlib.pyplot.plot(numElements, transz_max, 'bo',markersize=2)
	matplotlib.pyplot.xticks(numElements, name,rotation=translation_z_tickrota,fontsize=8)
	matplotlib.pyplot.title('Translation Z')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Name')
	axes.set_ylabel('Translation in mm')
	axes.axhspan(minus_settings_trans, plus_settings_trans, alpha=0.5, color='green')
	axes.set_ylim([min_trans,max_trans])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='Translation range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=translation_z_fontsize)
	matplotlib.pyplot.savefig('Translation_Z')
