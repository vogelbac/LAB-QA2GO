#script to create a single and the overview html page report

import os
import parse_ini_file
import numpy

menu_html_file_path = '/home/brain/qa/html/menu_html.html'
menu_html_file = open(menu_html_file_path, 'r')
menu_html = menu_html_file.readlines()
menu_html_file.close()

def main(result_folder, name, header_comp):

	result_folder_list = os.listdir(result_folder)
	
	if not 'results.html' in result_folder_list:

		for i in result_folder_list:
		#wenn result.html noch nicht existiert
		
			html_file = open(result_folder +'/results.html','w')
			#read reportfile
			html_file.writelines(menu_html)
			html_file.write('\t\t<h1 style="margin-top:80px;">Header comparison </h1>\n')
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
				
					
			html_file.write('\t\t<h1>Rotation </h1>\n')
			html_file.write('\t\t<h2>Rotation graph</h2>\n\t\t<p><img src="Rotation_'+name+'.png" alt="Rotation graph"</p>\n')
			html_file.write('\t\t<h2>Rotation histogram Pitch</h2>\n\t\t<p><img src="Histogram_Pitch_'+name+'.png" alt="Rotation Pitch"</p>\n')
			html_file.write('\t\t<h2>Rotation histogram Roll</h2>\n\t\t<p><img src="Histogram_Roll_'+name+'.png" alt="Rotation Roll"</p>\n')
			html_file.write('\t\t<h2>Rotation histogram Yaw</h2>\n\t\t<p><img src="Histogram_Yaw_'+name+'.png" alt="Rotation Yaw"</p>\n')
			html_file.write('\t\t<h1>Translation </h1>\n')
			html_file.write('\t\t<h2>Translation graph</h2>\n\t\t<p><img src="Translation_'+name+'.png" alt="Translation graph"</p>\n')
			html_file.write('\t\t<h2>Translation histogram X</h2>\n\t\t<p><img src="Histogram_Translation_X_'+name+'.png" alt="Translation histogram X"</p>\n')
			html_file.write('\t\t<h2>Translation histogram Y</h2>\n\t\t<p><img src="Histogram_Translation_Y_'+name+'.png" alt="Translation histogram Y"</p>\n')
			html_file.write('\t\t<h2>Translation histogram Z</h2>\n\t\t<p><img src="Histogram_Translation_Z_'+name+'.png" alt="Translation histogram Z"</p>\n')
	
			html_file.write('\t</body>\n</html>')
		
			html_file.close()

def generate_overview_html(result_folder):
	result_file = open(result_folder+'overview.html','w')
	result_file.writelines(menu_html)
	result_file.write('\t\t<h1 style="margin-top:80px;">Functional Overview</h1>\n')
	result_file.write('\t\t<h2>Rotation Pitch</h2>\n\t\t<p><img src="Rotation_Pitch.png" alt="Rotation Pitch"></p>\n')
	result_file.write('\t\t<h2>Rotation Roll</h2>\n\t\t<p><img src="Rotation_Roll.png" alt="Rotation Roll"></p>\n')
	result_file.write('\t\t<h2>Rotation Yaw</h2>\n\t\t<p><img src="Rotation_Yaw.png" alt="Rotation Yaw"></p>\n')
	result_file.write('\t\t<h2>Translation X</h2>\n\t\t<p><img src="Translation_X.png" alt="Translation X"></p>\n')
	result_file.write('\t\t<h2>Translation Y</h2>\n\t\t<p><img src="Translation_Y.png" alt="Translation Y"></p>\n')
	result_file.write('\t\t<h2>Translation Z</h2>\n\t\t<p><img src="Translation_Z.png" alt="Translation Z"></p>\n')


	#for automatic part
	functional_settings = parse_ini_file.parse_ini_file('fmri_settings')
	number_of_shown_values = functional_settings[2]
	if functional_settings[3] == 0:
		automatic_flag = False
	else: 
		automatic_flag = True

	std_automatic_multiplier = functional_settings[4]
	
	if automatic_flag:
		overview_file = open(result_folder + 'overview.txt','r')

		lines = overview_file.readlines()

		if (len(lines)-1 >= int(number_of_shown_values)):
			lines = lines[-int(number_of_shown_values):]	
		else:
			lines = lines[0:]

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
			rotx_mean.append(float(entry[2]))
			roty_mean.append(float(entry[5]))
			rotz_mean.append(float(entry[8]))
			transx_mean.append(float(entry[11]))
			transy_mean.append(float(entry[14]))
			transz_mean.append(float(entry[17]))
		
		auto_rot_x_mean = numpy.mean(rotx_mean)
		auto_rot_x_std = numpy.std(rotx_mean) * float(std_automatic_multiplier)
		auto_rot_y_mean = numpy.mean(roty_mean)
		auto_rot_y_std = numpy.std(roty_mean) * float(std_automatic_multiplier)
		auto_rot_z_mean = numpy.mean(rotz_mean)
		auto_rot_z_std = numpy.std(rotz_mean) * float(std_automatic_multiplier)
		auto_trans_x_mean = numpy.mean(transx_mean)
		auto_trans_x_std = numpy.std(transx_mean) * float(std_automatic_multiplier)
		auto_trans_y_mean = numpy.mean(transy_mean)
		auto_trans_y_std = numpy.std(transy_mean) * float(std_automatic_multiplier)
		auto_trans_z_mean = numpy.mean(transz_mean)
		auto_trans_z_std = numpy.std(transz_mean) * float(std_automatic_multiplier)
	

	else:
		fmri_settings = parse_ini_file.parse_ini_file('fmri_settings')
		plus_settings_rot = float(fmri_settings[0]) 
		minus_settings_rot = -float(fmri_settings[0]) 
		plus_settings_trans = float(fmri_settings[1]) 
		minus_settings_trans = -float(fmri_settings[1]) 

	result_folder_list = os.listdir(result_folder)
	result_folder_list.sort(reverse=True)
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
					val_file = result_folder + i + '/' + j + '/' + k + '/values.txt'
					if os.path.exists(val_file):
						val_file_id = open(val_file, 'r')
						#read val file
						val_file_content = val_file_id.readlines()
						#hier noch alles richtig eintragen
						for l in val_file_content:
							entry = l.split('\t')
							rotx_mean = float(entry[2])
							rotx_min = float(entry[3])
							rotx_max = float(entry[4])
							roty_mean = float(entry[5])
							roty_min = float(entry[6])
							roty_max = float(entry[7])
							rotz_mean = float(entry[8])
							rotz_min = float(entry[9])
							rotz_max = float(entry[10])
							transx_mean = float(entry[11])
							transx_min = float(entry[12])
							transx_max = float(entry[13])
							transy_mean = float(entry[14])
							transy_min = float(entry[15])
							transy_max = float(entry[16])
							transz_mean = float(entry[17])
							transz_min = float(entry[18])
							transz_max = float(entry[19].split('\n')[0])
						val_file_id.close()
						
						if automatic_flag:
							#only mean is compared. The minimum and maximum is not included, because the mean and std is calculated by the mean
							if (auto_rot_x_mean-auto_rot_x_std < rotx_mean and rotx_mean < auto_rot_x_mean+auto_rot_x_std) and (auto_rot_y_mean-auto_rot_y_std < roty_mean and roty_mean < auto_rot_y_mean+auto_rot_y_std) and (auto_rot_z_mean-auto_rot_z_std < rotz_mean and rotz_mean < auto_rot_z_mean+auto_rot_z_std) and (auto_trans_x_mean-auto_trans_x_std < transx_mean and transx_mean < auto_trans_x_mean+auto_trans_x_std) and (auto_trans_y_mean-auto_trans_y_std < transy_mean and transy_mean < auto_trans_y_mean+auto_trans_y_std) and (auto_trans_z_mean-auto_trans_z_std < transz_mean and transz_mean < auto_trans_z_mean+auto_trans_z_std):
								result_file.write('\t\t\t<li><a href="'+'/results/functional/'+i+'/'+j+'/'+k+'/results.html">'+k+'</a></li>\n')
							else:
								result_file.write('\t\t\t<li><img src="/warning.png"><a href="'+'/results/functional/'+i+'/'+j+'/'+k+'/results.html">'+k+'</a></li>\n')
						else: 
							if (minus_settings_rot < rotx_mean and rotx_mean < plus_settings_rot) and (minus_settings_rot < rotx_min and rotx_min < plus_settings_rot) and (minus_settings_rot < rotx_max and rotx_max < plus_settings_rot) and (minus_settings_rot < roty_mean and roty_mean < plus_settings_rot) and(minus_settings_rot < roty_min and roty_min < plus_settings_rot) and (minus_settings_rot < roty_max and roty_max < plus_settings_rot) and (minus_settings_rot < rotz_mean and rotz_mean < plus_settings_rot) and (minus_settings_rot < rotz_min and rotz_min < plus_settings_rot) and (minus_settings_rot < rotz_max and rotz_max < plus_settings_rot) and (minus_settings_trans < transx_mean and transx_mean < plus_settings_trans) and (minus_settings_trans < transx_min and transx_min < plus_settings_trans) and (minus_settings_trans < transx_max and transx_max < plus_settings_trans) and (minus_settings_trans < transy_mean and transy_mean < plus_settings_trans) and (minus_settings_trans < transy_min and transy_min < plus_settings_trans) and (minus_settings_trans < transy_max and transy_max < plus_settings_trans) and (minus_settings_trans < transz_mean and transz_mean < plus_settings_trans) and (minus_settings_trans < transz_min and transz_min < plus_settings_trans) and (minus_settings_trans < transz_max and transz_max < plus_settings_trans):
								result_file.write('\t\t\t<li><a href="'+'/results/functional/'+i+'/'+j+'/'+k+'/results.html">'+k+'</a></li>\n')
							else:
								result_file.write('\t\t\t<li><img src="/warning.png"><a href="'+'/results/functional/'+i+'/'+j+'/'+k+'/results.html">'+k+'</a></li>\n')
				result_file.write('\t\t</ul>\n')	
	result_file.write('\t</body>\n</html>')

