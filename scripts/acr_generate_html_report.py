#script to create a single html file for one measurement

import os,glob



def read_logfile(in_result_folder_terminal):

	menu_html_file_path = '/home/brain/qa/html/menu_html.html'
	menu_html_file = open(menu_html_file_path, 'r')
	menu_html = menu_html_file.readlines()
	menu_html_file.close()
	
	in_result_folder_list = os.listdir(in_result_folder_terminal)
		
	for i in in_result_folder_list:
		if os.path.isdir(in_result_folder_terminal + i):
			all_files = os.listdir(in_result_folder_terminal + i+'/')
			resultpath = in_result_folder_terminal + i+'/'
			os.chdir(resultpath)
			date = i.split('_')
			result_date = date[0]+'-' + date[1] + '-' +date [2]
			
			#wenn result.html noch nicht existiert
			if not 'results.html' in all_files:
				logfile = open(resultpath+'logfile.txt','r')
				#get list from logfile
				logfile_list = []
				for line in logfile:
					for word in line.split():
						logfile_list.append(word)   
				
				#Write HTML
				in_result_folder = os.listdir(resultpath)
				result_file = open(resultpath+'results.html','w')
				result_file.writelines(menu_html)
				result_file.write('\t\t<h1 style="margin-top:80px;">ACR Results '+result_date+'</h1>\n')
				#Test 1: Geometic
				#find #1
				x =  logfile_list.index('#1')
				
				
				result_file.write('\t\t<h2>Test 1: <i>Geometric accuracy </i></h2>\n\t\t<p>\n\t\t\t<img src="/info.png" name="Information">  <a href="/acr_helptext/1_geometry.html" target="_blank">Geometric accuracy</a>\n\t\t</p>\n\t\t <p>\n\t\t\t	Allowed is &plusmn; 2mm difference.	\n\t\t</p>\n\t\t<table>	\n\t\t\t\t<tr>	\n\t\t\t\t\t<th>Test</th>	<th>Sequence</th>	<th>Length</th>	<th>Norm</th>	<th>Error</th>	\n\t\t\t\t</tr>\n')
				#localizer
				#test
				if logfile_list[x+15] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+15] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				#name
				result_file.write('<td>'+logfile_list[x+10]+'</td>')
				#Lenth
				result_file.write('<td>'+logfile_list[x+11]+'</td>')
				#norm
				result_file.write('<td>'+logfile_list[x+12]+'</td>')
				#error
				result_file.write('<td>'+logfile_list[x+13]+'</td>\n\t\t\t\t</tr>\n')
				
				#T1_sl1_hor
				#test
				if logfile_list[x+21] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+21] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				#name
				result_file.write('<td>'+logfile_list[x+16]+'</td>')
				#Lenth
				result_file.write('<td>'+logfile_list[x+17]+'</td>')
				#norm
				result_file.write('<td>'+logfile_list[x+18]+'</td>')
				#error
				result_file.write('<td>'+logfile_list[x+19]+'</td>\n\t\t\t\t</tr>\n')

				
				#T1_sl1_ver
				#test
				if logfile_list[x+27] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+27] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				#name
				result_file.write('<td>'+logfile_list[x+22]+'</td>')
				#Lenth
				result_file.write('<td>'+logfile_list[x+23]+'</td>')
				#norm
				result_file.write('<td>'+logfile_list[x+24]+'</td>')
				#error
				result_file.write('<td>'+logfile_list[x+25]+'</td>\n\t\t\t\t</tr>\n')

				
				#T1_sl5_hor
				#test
				if logfile_list[x+33] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+33] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				#name
				result_file.write('<td>'+logfile_list[x+28]+'</td>')
				#Lenth
				result_file.write('<td>'+logfile_list[x+29]+'</td>')
				#norm
				result_file.write('<td>'+logfile_list[x+30]+'</td>')
				#error
				result_file.write('<td>'+logfile_list[x+31]+'</td>\n\t\t\t\t</tr>\n')
				
				#T1_sl5_ver
				#test
				if logfile_list[x+39] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+39] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				#name
				result_file.write('<td>'+logfile_list[x+34]+'</td>')
				#Lenth
				result_file.write('<td>'+logfile_list[x+35]+'</td>')
				#norm
				result_file.write('<td>'+logfile_list[x+36]+'</td>')
				#error
				result_file.write('<td>'+logfile_list[x+37]+'</td>\n\t\t\t\t</tr>\n')
				
				
				#T1_sl5_+45d
				#test
				if logfile_list[x+45] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+45] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				#name
				result_file.write('<td>'+logfile_list[x+40]+'</td>')
				#Lenth
				result_file.write('<td>'+logfile_list[x+41]+'</td>')
				#norm
				result_file.write('<td>'+logfile_list[x+42]+'</td>')
				#error
				result_file.write('<td>'+logfile_list[x+43]+'</td>\n\t\t\t\t</tr>\n')
				
				
				#T1_sl5_-45d
				#test
				if logfile_list[x+51] == 'Pass':
					result_file.write('\t\t\t\t<tr><td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+51] == 'Fail':
					result_file.write('\t\t\t\t<tr><td><img src="/fail.png" alt="Fail"></td>')
				#name
				result_file.write('<td>'+logfile_list[x+46]+'</td>')
				#Lenth
				result_file.write('<td>'+logfile_list[x+47]+'</td>')
				#norm
				result_file.write('<td>'+logfile_list[x+48]+'</td>')
				#error
				result_file.write('<td>'+logfile_list[x+49]+'</td>\n\t\t\t\t</tr>\n')

				image = glob.glob('geometry_*')
				result_file.write('\t\t\t</table>\n\t\t<p>\n\t\t\t	<img src="'+image[0]+'">\n\t\t</p>\n')
				
				#Test 2: Resolution T1
				#find #2
				x =  logfile_list.index('#2')
				
				result_file.write('\t\t<h2>Test 2: <i>High-contrast spatial resolution </i></h2>\n\t\t<p>\n\t\t\t<img src="/info.png" name="Information">  <a href="/acr_helptext/2_high-contrast.html" target="_blank">High-contrast spatial resolution</a>\n\t\t</p>\n\t\t    <p>\n\t\t\t	To pass the resolution test, 4 holes in any single row must be distinguishable from one another.		For both directions in both axial ACR series the measured resolution should be 1.0 mm or better.\n\t\t</p>\n\t\t<h3>T1</h3>\n\t\t<table>	\n\t\t\t\t<tr>\n\t\t\t\t\t<th>Test</th><th>Resolution</th><th>Location</th><th>Holes</th>\n\t\t\t\t	</tr>\n')
				#get counted values
				#+11 is the first value then in 2 steps because of 2 values left/right in one line
				#if one value == 4 
				#right 1.1 mm
				if int(logfile_list[x+11])==4 or int(logfile_list[x+13])==4 or int(logfile_list[x+15])==4 or int(logfile_list[x+17])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>1.1 mm</td><td>right</td>')
				result_file.write('<td>'+logfile_list[x+11]+', '+logfile_list[x+13] +', '+ logfile_list[x+15] +', '+ logfile_list[x+17]+'</td>\n\t\t\t\t</tr>\n')

				#left 1.1 mm
				if int(logfile_list[x+12])==4 or int(logfile_list[x+14])==4 or int(logfile_list[x+16])==4 or int(logfile_list[x+18])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>1.1 mm</td><td>left</td>')
				result_file.write('<td>'+logfile_list[x+12]+', '+logfile_list[x+14] +', '+ logfile_list[x+16] +', '+ logfile_list[x+18]+'</td>\n\t\t\t\t</tr>\n')
				
				#right 1.0 mm
				if int(logfile_list[x+25])==4 or int(logfile_list[x+27])==4 or int(logfile_list[x+29])==4 or int(logfile_list[x+31])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>1.0 mm</td><td>right</td>')
				result_file.write('<td>'+logfile_list[x+25]+', '+logfile_list[x+27] +', '+ logfile_list[x+29] +', '+ logfile_list[x+31]+'</td>\n\t\t\t\t</tr>\n')

				#left 1.0 mm
				if int(logfile_list[x+26])==4 or int(logfile_list[x+28])==4 or int(logfile_list[x+30])==4 or int(logfile_list[x+32])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>1.0 mm</td><td>left</td>')
				result_file.write('<td>'+logfile_list[x+26]+', '+logfile_list[x+28] +', '+ logfile_list[x+30] +', '+ logfile_list[x+32]+'</td>\n\t\t\t\t</tr>\n')
				
				#right 0.9 mm
				if int(logfile_list[x+39])==4 or int(logfile_list[x+41])==4 or int(logfile_list[x+43])==4 or int(logfile_list[x+45])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>0.9 mm</td><td>right</td>')
				result_file.write('<td>'+logfile_list[x+39]+', '+logfile_list[x+41] +', '+ logfile_list[x+43] +', '+ logfile_list[x+45]+'</td>\n\t\t\t\t</tr>\n')

				#left 0.9 mm
				if int(logfile_list[x+40])==4 or int(logfile_list[x+42])==4 or int(logfile_list[x+44])==4 or int(logfile_list[x+46])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\n\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>0.9 mm</td><td>left</td>')
				result_file.write('<td>'+logfile_list[x+40]+', '+logfile_list[x+42] +', '+ logfile_list[x+44] +', '+ logfile_list[x+46]+'</td>\n\t\t\t\t</tr>\n')
				

				image = glob.glob('resolution_*t1fl2d*')
				result_file.write('\t\t\t</table>\n\t\t<p>\n\t\t\t	<img src="'+image[0]+'">\n\t\t</p>\n')
				
				#Test 2: Resolution T2
				#find #3
				x =  logfile_list.index('#3')
				
				result_file.write('\n\t\t<h3>T2</h3>\n\t\t	<table>\n\t\t\t\t	<tr>\n\t\t\t\t\t<th>Test</th><th>Resolution</th><th>Location</th><th>Holes</th>	\n\t\t\t\t</tr>\n')
				#get counted values
				#+11 is the first value then in 2 steps because of 2 values left/right in one line
				#if one value == 4 
				#right 1.1 mm
				if int(logfile_list[x+11])==4 or int(logfile_list[x+13])==4 or int(logfile_list[x+15])==4 or int(logfile_list[x+17])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>1.1 mm</td><td>right</td>')
				result_file.write('<td>'+logfile_list[x+11]+', '+logfile_list[x+13] +', '+ logfile_list[x+15] +', '+ logfile_list[x+17]+'</td>\n\t\t\t\t</tr>\n')

				#left 1.1 mm
				if int(logfile_list[x+12])==4 or int(logfile_list[x+14])==4 or int(logfile_list[x+16])==4 or int(logfile_list[x+18])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>1.1 mm</td><td>left</td>')
				result_file.write('<td>'+logfile_list[x+12]+', '+logfile_list[x+14] +', '+ logfile_list[x+16] +', '+ logfile_list[x+18]+'</td>\n\t\t\t\t</tr>\n')
				
				#right 1.0 mm
				if int(logfile_list[x+25])==4 or int(logfile_list[x+27])==4 or int(logfile_list[x+29])==4 or int(logfile_list[x+31])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>1.0 mm</td><td>right</td>')
				result_file.write('<td>'+logfile_list[x+25]+', '+logfile_list[x+27] +', '+ logfile_list[x+29] +', '+ logfile_list[x+31]+'</td>\n\t\t\t\t</tr>\n')

				#left 1.0 mm
				if int(logfile_list[x+26])==4 or int(logfile_list[x+28])==4 or int(logfile_list[x+30])==4 or int(logfile_list[x+32])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>1.0 mm</td><td>left</td>')
				result_file.write('<td>'+logfile_list[x+26]+', '+logfile_list[x+28] +', '+ logfile_list[x+30] +', '+ logfile_list[x+32]+'</td>\n\t\t\t\t</tr>\n')
				
				#right 0.9 mm
				if int(logfile_list[x+39])==4 or int(logfile_list[x+41])==4 or int(logfile_list[x+43])==4 or int(logfile_list[x+45])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>0.9 mm</td><td>right</td>')
				result_file.write('<td>'+logfile_list[x+39]+', '+logfile_list[x+41] +', '+ logfile_list[x+43] +', '+ logfile_list[x+45]+'</td>\n\t\t\t\t</tr>\n')

				#left 0.9 mm
				if int(logfile_list[x+40])==4 or int(logfile_list[x+42])==4 or int(logfile_list[x+44])==4 or int(logfile_list[x+46])==4:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write('<td>0.9 mm</td><td>left</td>')
				result_file.write('<td>'+logfile_list[x+40]+', '+logfile_list[x+42] +', '+ logfile_list[x+44] +', '+ logfile_list[x+46]+'</td>\n\t\t\t\t</tr>\n')
				

				image = glob.glob('resolution_*pdt2*')
				result_file.write('\n\t\t\t</table>	\n\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>')
				
				
				#Test 3: Slice Thickness 
				#find #4 and #5
				#T1
				x =  logfile_list.index('#4')
				y =  logfile_list.index('#5')

				result_file.write('\n\t\t<h2>Test 3: <i>Slice thickness accuracy </i></h2>\n\t\t<p>\n\t\t\t<img src="/info.png" name="Information">  <a href="/acr_helptext/3_slice-thickness.html" target="_blank">Slice thickness accuracy</a>\n\t\t</p>\n\t\t<p>	\n\t\t\tFor both ACR series the measured slice thickness should be 5.0 mm &plusmn; 0.7 mm \n\t\t</p>\n\t\t\t<table>\n\t\t\t\t	<tr>\n\t\t\t\t\t<th>Test</th><th>Sequence</th><th>Slice thickness</th><th>Norm</th>	<th>Error</th>	\n\t\t\t\t</tr>\n')
				if logfile_list[x+14] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+14] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				
				result_file.write ('<td>T1</td>')
				result_file.write ('<td>'+logfile_list[x+10]+'</td>')
				result_file.write ('<td>'+logfile_list[x+11]+'</td>')
				result_file.write ('<td>'+logfile_list[x+12]+'</td>\n\t\t\t\t</tr>\n')
				
				#T2
				if logfile_list[y+14] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[y+14] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				
				result_file.write ('<td>T2</td>')
				result_file.write ('<td>'+logfile_list[y+10]+'</td>')
				result_file.write ('<td>'+logfile_list[y+11]+'</td>')
				result_file.write ('<td>'+logfile_list[y+12]+'</td>\n\t\t\t\t</tr>\n')


				image = glob.glob('Schichtdicke_*t1fl2d*')
				result_file.write('\t\t\t</table>	\n\t\t\t<h4>T1</h4>\n\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>\n')
				image = glob.glob('Schichtdicke_*pdt2*')
				result_file.write('\t\t\t<h4>T2</h4>\n\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>\n')
				
				# Test 4 Slice position accuracy
				#find #6 and #7
				x =  logfile_list.index('#6')
				y =  logfile_list.index('#7')

				result_file.write('\t\t<h2>Test 4: <i>Slice position accuracy </i></h2>\n\t\t<p>\n\t\t\t<img src="/info.png" name="Information">  <a href="/acr_helptext/4_slice-position.html" target="_blank">Slice position accuracy</a>\n\t\t</p>\n\t\t<p>\n\t\t\tThe absolute bar length difference should be 5 mm or less.\n\t\t</p>\n\t\t\t<table>\n\t\t\t\t<tr>\n\t\t\t\t\t<th>Test</th><th>Sequence</th><th>Slice number</th><th>Length difference</th>\n\t\t\t\t</tr>\n')
				#T1
				#slice 2
				if logfile_list[x+13] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+13] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write ('<td>T1</td>')
				result_file.write ('<td>2</td>')
				result_file.write ('<td>'+logfile_list[x+12]+'</td>\n\t\t\t\t</tr>\n')
				#slice 12
				if logfile_list[x+15] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+15] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write ('<td>T1</td>')
				result_file.write ('<td>12</td>')
				result_file.write ('<td>'+logfile_list[x+14]+'</td>\n\t\t\t\t</tr>\n')

				#T2
				#slice 2
				if logfile_list[y+13] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[y+13] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write ('<td>T2</td>')
				result_file.write ('<td>2</td>')
				result_file.write ('<td>'+logfile_list[y+12]+'</td>\n\t\t\t\t</tr>\n')
				#slice 12
				if logfile_list[y+15] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[y+15] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write ('<td>T2</td>')
				result_file.write ('<td>12</td>')
				result_file.write ('<td>'+logfile_list[y+14]+'</td>\n\t\t\t\t</tr>\n')
				

				image = glob.glob('Schichtposition_*t1fl2d*')
				result_file.write('\t\t\t</table>\n\t\t\t	<h4>T1</h4>\n\t\t\t\n\t\t<p><img src="'+image[0]+'">\n\t\t</p>\n')
				image = glob.glob('Schichtposition_*pdt2*')
				result_file.write('\t\t\t<h4>T2</h4>\n\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>')
				
				# Test 5 Image intensity uniformity
				#find #8 and #9
				x =  logfile_list.index('#8')
				y =  logfile_list.index('#9')

				result_file.write('\n\t\t<h2>Test 5: <i>Image intensity uniformity </i></h2>\n\t\t<p>\n\t\t\t<img src="/info.png" name="Information">  <a href="/acr_helptext/5_image-intensity.html" target="_blank">Image intensity uniformity</a>\n\t\t</p>\n\t\t<p>\n\t\t\tPIU should be greater than or equal to 87.5% for MRI systems with field strengths less than 3 Tesla. PIU should be greater than or equal to 82.0% for MRI systems with field strength of 3 Tesla.\n\t\t</p>\n\t\t\t<table>\n\t\t\t\t<tr>\n\t\t\t\t\t<th>Test</th><th>Sequence</th><th>PIU</th><th>Norm</th><th>Discrepancy</th>\n\t\t\t\t</tr>\n')
				#T1
				if logfile_list[x+12] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+12] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write ('<td>T1</td>')
				result_file.write ('<td>'+logfile_list[x+9]+'</td>')
				result_file.write ('<td>'+logfile_list[x+10]+'</td>')
				result_file.write ('<td>'+logfile_list[x+11]+'</td>\n\t\t\t\t</tr>\n')
				#T2
				if logfile_list[y+12] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[y+12] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write ('<td>T2</td>')
				result_file.write ('<td>'+logfile_list[y+9]+'</td>')
				result_file.write ('<td>'+logfile_list[y+10]+'</td>')
				result_file.write ('<td>'+logfile_list[y+11]+'</td>\n\t\t\t\t</tr>\n')
				
				image = glob.glob('piu_*t1fl2d*')
				result_file.write('\t\t\t</table>\n\t\t\t	<h4>T1</h4>\n\t\t<p><img src="'+image[0]+'">\n\t\t</p>\n')
				image = glob.glob('piu_*pdt2*')
				result_file.write('\t\t\t<h4>T2</h4>\n\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>\n')
				
				# Test 6 Percent-signal ghosting
				#find #10 and #11
				x =  logfile_list.index('#10')
				y =  logfile_list.index('#11')

				result_file.write('\t\t<h2>Test 6: <i>Percent-signal ghosting </i></h2>\n\t\t<p>\n\t\t\t<img src="/info.png" name="Information">  <a href="/acr_helptext/6_psg.html" target="_blank">Percent-signal ghosting</a>\n\t\t</p>\n\t\t<p>\n\t\t\tThe ghosting ratio should be less than or equal to 0.025.\n\t\t</p>\n\t\t\t<table>\n\t\t\t\t<tr>\n\t\t\t\t\t<th>Test</th><th>Sequence</th><th>PSG</th><th>Norm</th><th>Discrepancy</th>\n\t\t\t\t</tr>\n')	
				#T1
				if logfile_list[x+13] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[x+13] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write ('<td>T1</td>')
				result_file.write ('<td>'+logfile_list[x+9]+'</td>')
				result_file.write ('<td>'+logfile_list[x+11]+'</td>')
				result_file.write ('<td>'+logfile_list[x+12]+'</td>\n\t\t\t\t</tr>\n')
				#T2
				if logfile_list[y+13] == 'Pass':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				elif logfile_list[y+13] == 'Fail':
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write ('<td>T2</td>')
				result_file.write ('<td>'+logfile_list[y+9]+'</td>')
				result_file.write ('<td>'+logfile_list[y+11]+'</td>')
				result_file.write ('<td>'+logfile_list[y+12]+'</td>\n\t\t\t\t</tr>\n')
				

				image = glob.glob('Ghosting_*t1fl2d*')
				result_file.write('\n\t\t\t</table>\n\t\t\t	<h4>T1</h4>\n\t\t<p><img src="'+image[0]+'">\n\t\t</p>\n')
				image = glob.glob('Ghosting_*pdt2*')
				result_file.write('\t\t\t<h4>T2</h4>\n\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>\n')

				# Test 7 LCOD
				#find #12 and #13	
				x =  logfile_list.index('#12')
				y =  logfile_list.index('#13')

				
				result_file.write('\t\t<h2>Test 7: <i>Low-contrast object detectability </i></h2>\n\t\t<p>\n\t\t\t<img src="/info.png" name="Information">  <a href="/acr_helptext/7_lcod.html" target="_blank">Low-contrast object detectability</a>\n\t\t</p>\n\t\t<p>\n\t\t\tEach of the ACR series should have a total score of at least 9 spokes for MRI systems with field strengths less than 3 Tesla, and 37 spokes for MRI systems with field strengths of 3 Tesla.\n\t\t</p>\\n\t\t\t<table>\n\t\t\t\t<tr>\n\t\t\t\t\t<th>Test</th><th>Sequence</th><th>Spokes per slice (8,9,10,11)</th><th>Norm</th><th>Sum</th>\n\t\t\t\t</tr>')	
				#T1
				if int(logfile_list[x+19]) > 36:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else :
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write ('<td>T1</td>')
				result_file.write ('<td>'+logfile_list[x+9]+', '+logfile_list[x+11]+', '+logfile_list[x+13]+', '+logfile_list[x+15]+'</td>')
				result_file.write ('<td>&lt; 36 </td>')
				result_file.write ('<td>'+logfile_list[x+19]+'</td>\n\t\t\t\t</tr>\n')

				#T2
				if int(logfile_list[y+19]) > 36:
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/pass.png" alt="Pass"></td>')
				else :
					result_file.write('\t\t\t\t<tr>\n\t\t\t\t\t<td><img src="/fail.png" alt="Fail"></td>')
				result_file.write ('<td>T2</td>')
				result_file.write ('<td>'+logfile_list[y+9]+', '+logfile_list[y+11]+', '+logfile_list[y+13]+', '+logfile_list[y+15]+'</td>')
				result_file.write ('<td>&lt; 36 </td>')
				result_file.write ('<td>'+logfile_list[y+19]+'</td>\n\t\t\t\t</tr>\n')
				
				image = glob.glob('LCOD_sl9_t1*')
				result_file.write('\t\t\t</table>\n\t\t\t<h4>T1</h4>\n\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n')
				image = glob.glob('LCOD_sl10_t1*')
				result_file.write('\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>\n')
				image = glob.glob('LCOD_sl11_t1*')
				result_file.write('\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>\n')
				image = glob.glob('LCOD_sl12_t1*')
				result_file.write('\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>\n')
				image = glob.glob('LCOD_sl9_t2*')
				result_file.write('\t\t\t<h4>T2</h4>\n\t\t<p><img src="'+image[0]+'">\n\t\t</p>\n')
				image = glob.glob('LCOD_sl10_t2*')
				result_file.write('\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>\n')
				image = glob.glob('LCOD_sl11_t2*')
				result_file.write('\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>\n')
				image = glob.glob('LCOD_sl12_t2*')
				result_file.write('\t\t<p>\n\t\t\t<img src="'+image[0]+'">\n\t\t</p>\n\t</body>\n</html>')


