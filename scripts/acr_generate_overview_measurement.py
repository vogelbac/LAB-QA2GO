#script to rewrite the data of the logfile into a ; separated file named overview.txt

import os

def main(result_folder):
	in_result_folder_list = os.listdir(result_folder)

	for i in in_result_folder_list:
		if os.path.isdir(result_folder + i):
			all_files = os.listdir(result_folder + i+'/')
			resultpath = result_folder + i+'/'
			print resultpath
			
			date = i.split('_')
			result_date = date[0]+'-' + date[1] + '-' + date [2]
			
			if not 'overview.txt' in all_files:
				logfile = open(resultpath+'logfile.txt','r')
				#get list from logfile
				logfile_list = []
				for line in logfile:
					for word in line.split():
						logfile_list.append(word)
						
				result_file = open(resultpath+'overview.txt','w')
				result_file.write(result_date+';')
				x =  logfile_list.index('#1')
				#length
				result_file.write(logfile_list[x+11]+';')
				result_file.write(logfile_list[x+17]+';')
				result_file.write(logfile_list[x+23]+';')
				result_file.write(logfile_list[x+29]+';')
				result_file.write(logfile_list[x+35]+';')
				result_file.write(logfile_list[x+41]+';')
				result_file.write(logfile_list[x+47]+';')
				
				x =  logfile_list.index('#2')
				templist = []
				templist.append(int(logfile_list[x+11]))
				templist.append(int(logfile_list[x+13]))
				templist.append(int(logfile_list[x+15]))
				templist.append(int(logfile_list[x+17]))
				
				result_file.write(str(max(templist))+';')
				
				templist = []
				templist.append(int(logfile_list[x+12]))
				templist.append(int(logfile_list[x+14]))
				templist.append(int(logfile_list[x+16]))
				templist.append(int(logfile_list[x+18]))
				
				result_file.write(str(max(templist))+';')
				
				templist = []
				templist.append(int(logfile_list[x+25]))
				templist.append(int(logfile_list[x+27]))
				templist.append(int(logfile_list[x+29]))
				templist.append(int(logfile_list[x+31]))
				
				result_file.write(str(max(templist))+';')
				
				templist = []
				templist.append(int(logfile_list[x+26]))
				templist.append(int(logfile_list[x+28]))
				templist.append(int(logfile_list[x+30]))
				templist.append(int(logfile_list[x+32]))
				
				result_file.write(str(max(templist))+';')
				
				
				templist = []
				templist.append(int(logfile_list[x+39]))
				templist.append(int(logfile_list[x+41]))
				templist.append(int(logfile_list[x+43]))
				templist.append(int(logfile_list[x+45]))
				
				result_file.write(str(max(templist))+';')
				
				templist = []
				templist.append(int(logfile_list[x+40]))
				templist.append(int(logfile_list[x+42]))
				templist.append(int(logfile_list[x+44]))
				templist.append(int(logfile_list[x+46]))
				
				result_file.write(str(max(templist))+';')
				

				x =  logfile_list.index('#3')
				templist = []
				templist.append(int(logfile_list[x+11]))
				templist.append(int(logfile_list[x+13]))
				templist.append(int(logfile_list[x+15]))
				templist.append(int(logfile_list[x+17]))
				
				result_file.write(str(max(templist))+';')
				
				templist = []
				templist.append(int(logfile_list[x+12]))
				templist.append(int(logfile_list[x+14]))
				templist.append(int(logfile_list[x+16]))
				templist.append(int(logfile_list[x+18]))
				
				result_file.write(str(max(templist))+';')
				
				templist = []
				templist.append(int(logfile_list[x+25]))
				templist.append(int(logfile_list[x+27]))
				templist.append(int(logfile_list[x+29]))
				templist.append(int(logfile_list[x+31]))
				
				result_file.write(str(max(templist))+';')
				
				templist = []
				templist.append(int(logfile_list[x+26]))
				templist.append(int(logfile_list[x+28]))
				templist.append(int(logfile_list[x+30]))
				templist.append(int(logfile_list[x+32]))
				
				result_file.write(str(max(templist))+';')
				
				
				templist = []
				templist.append(int(logfile_list[x+39]))
				templist.append(int(logfile_list[x+41]))
				templist.append(int(logfile_list[x+43]))
				templist.append(int(logfile_list[x+45]))
				
				result_file.write(str(max(templist))+';')
				
				templist = []
				templist.append(int(logfile_list[x+40]))
				templist.append(int(logfile_list[x+42]))
				templist.append(int(logfile_list[x+44]))
				templist.append(int(logfile_list[x+46]))
				
				result_file.write(str(max(templist))+';')
				
				x =  logfile_list.index('#4')
				result_file.write(logfile_list[x+10]+';')
				
				x =  logfile_list.index('#5')
				result_file.write(logfile_list[x+10]+';')
				
				
				x =  logfile_list.index('#6')
				result_file.write(logfile_list[x+12]+';')
				result_file.write(logfile_list[x+14]+';')
				
				x =  logfile_list.index('#7')
				result_file.write(logfile_list[x+12]+';')
				result_file.write(logfile_list[x+14]+';')
				
				x =  logfile_list.index('#8')
				result_file.write(logfile_list[x+9]+';')
				x =  logfile_list.index('#9')
				result_file.write(logfile_list[x+9]+';')
				
				x =  logfile_list.index('#10')
				result_file.write(logfile_list[x+9]+';')
				x =  logfile_list.index('#11')
				result_file.write(logfile_list[x+9]+';')
				
				x =  logfile_list.index('#12')
				result_file.write(logfile_list[x+19]+';')
				x =  logfile_list.index('#13')
				result_file.write(logfile_list[x+19])
				
				
				
				result_file.close()
