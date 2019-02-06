# script to generate an overview file of all measurentoverview files

import os
import sys

def main(result_folder):
	######### Main routine

	erg_path = result_folder

	fobj = open(erg_path+'overview.txt','w')

	#liste mit Werten
	value_list =['Datum','Geo_loc','Geo_T1sl1hor','Geo_T1sl1ver','Geo_T1sl5hor','Geo_T1sl5ver','Geo_T1sl5+45','Geo_T1sl5-45','Res_maxT1rechts1_1','Res_maxT1links1_1','Res_maxT1rechts1_0','Res_maxT1links1_0','Res_maxT1rechts0_9','Res_maxT1links0_9','Res_maxT2rechts1_1','Res_maxT2links1_1','Res_maxT2rechts1_0','Res_maxT2links1_0','Res_maxT2rechts0_9','Res_maxT2links0_9','Thick_T1','Thick_T2','Pos_T1sl2','Pos_T1sl12','Pos_T2sl2','Pos_T2sl12','PIU_T1','PIU_T2','PSG_T1','PSG_T2','LCOD_sum_T1','LCOD_sum_T2']

	for v in value_list:
		fobj.write(v+'\t')

	fobj.write('\n')
	
	temp_list = []		

	erg_folder = os.listdir(erg_path)
	erg_folder.sort()

	for i in erg_folder:
		if os.path.isdir(erg_path+i):
			measurement_folder = os.listdir(erg_path+i+'/')
			measurement_folder.sort()
			value_path = erg_path+i+'/overview.txt'
			if os.path.exists(value_path):
				values = open(value_path,'r')
				for k in values:
					fobj.write(k+'\t')
				fobj.write('\n')
				values.close()
		
	fobj.close()
