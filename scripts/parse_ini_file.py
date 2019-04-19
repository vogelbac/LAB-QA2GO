def parse_ini_file(option):
	if option == 'human_structural_settings':
		ini_file = open('/home/brain/qa/html/configuration/structural.ini','r')
		content = ini_file.readlines()
		content = [x.strip() for x in content] 
		return_array = []
		index = content.index('[human_structural_settings]')		
		return_array.append(content[index+1].split('=')[1])
		return_array.append(content[index+2].split('=')[1])
		return_array.append(content[index+3].split('=')[1])
		return_array.append(content[index+4].split('=')[1])
		return_array.append(content[index+5].split('=')[1])
		return_array.append(content[index+6].split('=')[1])
		return_array.append(content[index+7].split('=')[1])
		return_array.append(content[index+8].split('=')[1])
		return_array.append(content[index+9].split('=')[1])
		return_array.append(content[index+10].split('=')[1])
	
	elif option == 'phantom_settings':
		ini_file = open('/home/brain/qa/html/configuration/gel_phantom.ini','r')
		content = ini_file.readlines()
		content = [x.strip() for x in content] 
		return_array = []
		index = content.index('[phantom_settings]')		
		return_array.append(content[index+1].split('=')[1])
		return_array.append(content[index+2].split('=')[1])
		return_array.append(content[index+3].split('=')[1])
		return_array.append(content[index+4].split('=')[1])
		return_array.append(content[index+5].split('=')[1])
		return_array.append(content[index+6].split('=')[1])
		return_array.append(content[index+7].split('=')[1])
		return_array.append(content[index+8].split('=')[1])
		return_array.append(content[index+9].split('=')[1])
		return_array.append(content[index+10].split('=')[1])
		return_array.append(content[index+11].split('=')[1])
		return_array.append(content[index+12].split('=')[1])
		return_array.append(content[index+13].split('=')[1])
		return_array.append(content[index+14].split('=')[1])
		return_array.append(content[index+15].split('=')[1])


	elif option == 'genral_settings':
		ini_file = open('/home/brain/qa/html/configuration/general.ini','r')
		content = ini_file.readlines()
		content = [x.strip() for x in content] 
		return_array = []
		index = content.index('[genral_settings]')		
		return_array.append(content[index+1].split('=')[1])
		return_array.append(content[index+2].split('=')[1])
		return_array.append(content[index+3].split('=')[1])
		return_array.append(content[index+4].split('=')[1])
		return_array.append(content[index+5].split('=')[1])
		return_array.append(content[index+6].split('=')[1])
		return_array.append(content[index+7].split('=')[1])
		return_array.append(content[index+8].split('=')[1])
		return_array.append(content[index+9].split('=')[1])
		return_array.append(content[index+10].split('=')[1])
		return_array.append(content[index+11].split('=')[1])
		return_array.append(content[index+12].split('=')[1])
		return_array.append(content[index+13].split('=')[1])
		return_array.append(content[index+14].split('=')[1])
	
	elif option == 'acr_settings':
		ini_file = open('/home/brain/qa/html/configuration/acr_phantom.ini','r')
		content = ini_file.readlines()
		content = [x.strip() for x in content] 
		return_array = []
		index = content.index('[acr_settings]')		
		return_array.append(content[index+1].split('=')[1])
			
	
	elif option == 'fmri_settings':
		ini_file = open('/home/brain/qa/html/configuration/functional.ini','r')
		content = ini_file.readlines()
		content = [x.strip() for x in content] 
		return_array = []
		index = content.index('[fmri_settings]')		
		return_array.append(content[index+1].split('=')[1])
		return_array.append(content[index+2].split('=')[1])
		return_array.append(content[index+3].split('=')[1])
		return_array.append(content[index+4].split('=')[1])
		return_array.append(content[index+5].split('=')[1])

		
	ini_file.close()
	return return_array
