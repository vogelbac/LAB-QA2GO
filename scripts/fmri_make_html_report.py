#script to create a single and the overview html page report

import os
import parse_ini_file

menu_html_file_path = '/home/brain/qa/html/menu_html.html'
menu_html_file = open(menu_html_file_path, 'r')
menu_html = menu_html_file.readlines()
menu_html_file.close()

def main(result_folder, name):

	result_folder_list = os.listdir(result_folder)
	
	if not 'results.html' in result_folder_list:

		for i in result_folder_list:
		#wenn result.html noch nicht existiert
		
			html_file = open(result_folder +'/results.html','w')
			#read reportfile
			html_file.writelines(menu_html)
			html_file.write('\t\t<h1 style="margin-top:80px;">Translation </h1>\n')
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
									
						if (minus_settings_rot < rotx_mean and rotx_mean < plus_settings_rot) and (minus_settings_rot < rotx_min and rotx_min < plus_settings_rot) and (minus_settings_rot < rotx_max and rotx_max < plus_settings_rot) and (minus_settings_rot < roty_mean and roty_mean < plus_settings_rot) and(minus_settings_rot < roty_min and roty_min < plus_settings_rot) and (minus_settings_rot < roty_max and roty_max < plus_settings_rot) and (minus_settings_rot < rotz_mean and rotz_mean < plus_settings_rot) and (minus_settings_rot < rotz_min and rotz_min < plus_settings_rot) and (minus_settings_rot < rotz_max and rotz_max < plus_settings_rot) and (minus_settings_trans < transx_mean and transx_mean < plus_settings_trans) and (minus_settings_trans < transx_min and transx_min < plus_settings_trans) and (minus_settings_trans < transx_max and transx_max < plus_settings_trans) and (minus_settings_trans < transy_mean and transy_mean < plus_settings_trans) and (minus_settings_trans < transy_min and transy_min < plus_settings_trans) and (minus_settings_trans < transy_max and transy_max < plus_settings_trans) and (minus_settings_trans < transz_mean and transz_mean < plus_settings_trans) and (minus_settings_trans < transz_min and transz_min < plus_settings_trans) and (minus_settings_trans < transz_max and transz_max < plus_settings_trans):
							result_file.write('\t\t\t<li><a href="'+'/results/functional/'+i+'/'+j+'/'+k+'/results.html">'+k+'</a></li>\n')
						else:
							result_file.write('\t\t\t<li><img src="/warning.png"><a href="'+'/results/functional/'+i+'/'+j+'/'+k+'/results.html">'+k+'</a></li>\n')
				result_file.write('\t\t</ul>\n')	
	result_file.write('\t</body>\n</html>')

