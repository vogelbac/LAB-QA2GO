#script to generate the graphs for the overview page and to create the overview page for the acr


#!/usr/bin/python


# script to generate the overview graphs and to generate the overview html page for the gel phantoms

import os,sys
sys.path.append('/home/brain/qa/scripts/')
import cgi
import cgitb; cgitb.enable()


# set HOME environment variable to a directory the httpd server can write to
os.environ[ 'HOME' ] = '/tmp/'
 
os.chdir('/home/brain/qa/html/results/acr/')	
import matplotlib
# chose a non-GUI backend
matplotlib.use( 'Agg' )

import pylab


	
def generate_graph(overview_logfile,matlab_path,resultpath,number_of_shown_values):
	rfile = open(overview_logfile,'r')

	lines = rfile.readlines()
	#last 10 lines
	if (len(lines)-1 >= int(number_of_shown_values)):
		lines = lines[-int(number_of_shown_values):]	
	else:
		lines = lines[1:]

	date_list = []
	geo_loc = []
	geo_T1sl1hor = []
	geo_T1sl1ver = []
	geo_T1sl5hor = []
	geo_T1sl5ver = []
	geo_T1sl5_p45 = []
	geo_T1sl5_m45 = []
	res_maxT1rechts1_1 = []
	res_maxT1links1_1 = []
	res_maxT1rechts1_0 = []
	res_maxT1links1_0 = []
	res_maxT1rechts0_9 = []
	res_maxT1links0_9 = []
	res_maxT2rechts1_1 = []
	res_maxT2links1_1 = []
	res_maxT2rechts1_0 = []
	res_maxT2links1_0 = []
	res_maxT2rechts0_9 = []
	res_maxT2links0_9 = []
	thick_T1 = []
	thick_T2 = []
	pos_T1sl2 = []
	pos_T1sl12 = []
	pos_T2sl2 = []
	pos_T2sl12 = []
	pIU_T1 = []
	pIU_T2 = []
	pSG_T1 = []
	pSG_T2 = []
	lCOD_sum_T1 = []
	lCOD_sum_T2 = []

	for i in lines:
		entry = i.split(';')
		try:
			date_list.append(entry[0])
		except: 
			date_list.appent('XXXX-XX-XX')
		try:
			geo_loc.append(float(entry[1].replace(',','.')))
		except:
			geo_loc.append(float(0.0))
		try:
			geo_T1sl1hor.append(float(entry[2].replace(',','.')))
		except:
			geo_T1sl1hor.append(float(0.0))
		try:
			geo_T1sl1ver.append(float(entry[3].replace(',','.')))
		except:
			geo_T1sl1ver.append(float(0.0))
		try:
			geo_T1sl5hor.append(float(entry[4].replace(',','.')))
		except:	
			geo_T1sl5hor.append(float(0.0))
		try:
			geo_T1sl5ver.append(float(entry[5].replace(',','.')))
		except:
			geo_T1sl5ver.append(float(0.0))
		try:
			geo_T1sl5_p45.append(float(entry[6].replace(',','.')))
		except:
			geo_T1sl5_p45.append(float(0.0))
		try:
			geo_T1sl5_m45.append(float(entry[7].replace(',','.')))
		except:
			gep_T1sl5_m45.append(float(0.0))
		try:
			res_maxT1rechts1_1.append(float(entry[8].replace(',','.')))
		except:
			res_maxT1rechts1_1.append(float(0.0))
		try:
			res_maxT1links1_1.append(float(entry[9].replace(',','.')))
		except:
			res_maxT1links1_1.append(float(0.0))
		try:
			res_maxT1rechts1_0.append(float(entry[10].replace(',','.')))
		except:
			res_maxT1rechts1_0.append(float(0.0))
		try:
			res_maxT1links1_0.append(float(entry[11].replace(',','.')))
		except:
			res_maxT1links1_0.append(float(0.0))
		try:		
			res_maxT1rechts0_9.append(float(entry[12].replace(',','.')))
		except:
			res_maxT1rechts0_9.append(float(0.0))
		try:
			res_maxT1links0_9.append(float(entry[13].replace(',','.')))
		except:
			res_maxT1links0_9.append(float(0.0))
		try:
			res_maxT2rechts1_1.append(float(entry[14].replace(',','.')))
		except:
			res_maxT2rechts1_1.append(float(0.0))
		try:
			res_maxT2links1_1.append(float(entry[15].replace(',','.')))
		except:
			res_maxT2links1_1.append(float(0.0))
		try:
			res_maxT2rechts1_0.append(float(entry[16].replace(',','.')))
		except:
			res_maxT2rechts1_0.append(float(0.0))
		try:
			res_maxT2links1_0.append(float(entry[17].replace(',','.')))
		except:
			res_maxT2links1_0.append(float(0.0))
		try:
			res_maxT2rechts0_9.append(float(entry[18].replace(',','.')))
		except:
			res_maxT2rechts0_9.append(float(0.0))
		try:
			res_maxT2links0_9.append(float(entry[19].replace(',','.')))
		except:
			res_maxT2links0_9.append(float(0.0))
		try:
			thick_T1.append(float(entry[20].replace(',','.')))
		except:
			thick_T1.append(float(0.0))
		try:
			thick_T2.append(float(entry[21].replace(',','.')))
		except:
			thick_T2.append(float(0.0))
		try:
			pos_T1sl2.append(float(entry[22].replace(',','.')))
		except:
			pos_T1sl2.append(float(0.0))
		try:
			pos_T1sl12.append(float(entry[23].replace(',','.')))
		except:
			pos_T1sl12.append(float(0.0))
		try:
			pos_T2sl2.append(float(entry[24].replace(',','.')))
		except:
			pos_T2sl2.append(float(0.0))
		try:
			pos_T2sl12.append(float(entry[25].replace(',','.')))
		except:
			pos_T2sl12.append(float(0.0))
		try:
			pIU_T1.append(float(entry[26].replace(',','.')))
		except:
			pIU_T1.append(float(0.0))
		try:
			pIU_T2.append(float(entry[27].replace(',','.')))
		except:
			pIU_T2.append(float(0.0))
		try:
			pSG_T1.append(float(entry[28].replace(',','.')))
		except:
			pSG_T1.append(float(0.0))
		try:
			pSG_T2.append(float(entry[29].replace(',','.')))
		except:
			pSG_T2.append(float(0.0))
		try:
			lCOD_sum_T1.append(float(entry[30].replace(',','.')))
		except:
			lCOD_sum_T1.append(float(0.0))
		try:
			lCOD_sum_T2.append(float(entry[31].strip().replace(',','.')))
		except:
			lCOD_sum_T2.append(float(0.0))


	rfile.close()	
	os.chdir(matlab_path)

	
	dateliste = ''
	
	for i in date_list:
		dateliste = dateliste+i+','

	
	dateliste = dateliste[:-1]
	
	numElements=[i for i in range(len(date_list))]
	

	os.chdir('/home/brain/qa/html/results/acr/')

	if int(number_of_shown_values)==5:
		normal_overview_width=10
		normal_overview_height=6
		normal_overview_fontsize=11
		normal_overview_tickrota=40
		two_subplot_overview_width=10
		two_subplot_overview_height=8
		two_subplot_overview_fontsize=11
		two_subplot_overview_tickrota=40
		four_subplot_overview_width=10
		four_subplot_overview_height=10
		four_subplot_overview_fontsize=11
		four_subplot_overview_tickrota=40
		six_subplot_overview_width=10
		six_subplot_overview_height=12
		six_subplot_overview_fontsize=11
		six_subplot_overview_tickrota=40
	elif int(number_of_shown_values)==10:
		normal_overview_width=12
		normal_overview_height=6
		normal_overview_fontsize=11
		normal_overview_tickrota=60
		two_subplot_overview_width=12
		two_subplot_overview_height=8
		two_subplot_overview_fontsize=11
		two_subplot_overview_tickrota=60
		four_subplot_overview_width=12
		four_subplot_overview_height=10
		four_subplot_overview_fontsize=11
		four_subplot_overview_tickrota=60
		six_subplot_overview_width=12
		six_subplot_overview_height=12
		six_subplot_overview_fontsize=11
		six_subplot_overview_tickrota=60
	elif int(number_of_shown_values)==15:
		normal_overview_width=14
		normal_overview_height=6
		normal_overview_fontsize=11
		normal_overview_tickrota=70
		two_subplot_overview_width=14
		two_subplot_overview_height=8
		two_subplot_overview_fontsize=11
		two_subplot_overview_tickrota=70
		four_subplot_overview_width=14
		four_subplot_overview_height=10
		four_subplot_overview_fontsize=11
		four_subplot_overview_tickrota=70
		six_subplot_overview_width=14
		six_subplot_overview_height=12
		six_subplot_overview_fontsize=11
		six_subplot_overview_tickrota=70
	elif int(number_of_shown_values)==20:
		normal_overview_width=16
		normal_overview_height=6
		normal_overview_fontsize=11
		normal_overview_tickrota=75
		two_subplot_overview_width=16
		two_subplot_overview_height=8
		two_subplot_overview_fontsize=11
		two_subplot_overview_tickrota=75
		four_subplot_overview_width=16
		four_subplot_overview_height=10
		four_subplot_overview_fontsize=11
		four_subplot_overview_tickrota=75
		six_subplot_overview_width=16
		six_subplot_overview_height=12
		six_subplot_overview_fontsize=11
		six_subplot_overview_tickrota=75
	elif int(number_of_shown_values)==50:
		normal_overview_width=18
		normal_overview_height=6
		normal_overview_fontsize=11
		normal_overview_tickrota=90
		two_subplot_overview_width=18
		two_subplot_overview_height=8
		two_subplot_overview_fontsize=11
		two_subplot_overview_tickrota=90
		four_subplot_overview_width=18
		four_subplot_overview_height=10
		four_subplot_overview_fontsize=11
		four_subplot_overview_tickrota=90
		six_subplot_overview_width=18
		six_subplot_overview_height=12
		six_subplot_overview_fontsize=11
		six_subplot_overview_tickrota=90



	#Geometry Localizer
	matplotlib.pyplot.figure(figsize=(normal_overview_width,normal_overview_height))	
	matplotlib.pyplot.plot(numElements, geo_loc, 'bo',markersize=4)
	matplotlib.pyplot.xticks(numElements, date_list,rotation=normal_overview_tickrota)
	matplotlib.pyplot.title('Geometry Localizer')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Date')
	axes.set_ylabel('Size in mm')
	axes.axhspan(146, 150, alpha=0.5, color='green')
	ymin = min(geo_loc) - 10
	ymax = max(geo_loc) + 10 
	axes.set_ylim([ymin,ymax])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	matplotlib.pyplot.savefig('Geometry_Localizer')

	#Geometry T1
	ymin = 177
	ymax = 200
	f, axes = matplotlib.pyplot.subplots(3, 2, sharex='col', sharey='row')
	f.set_figheight(six_subplot_overview_height)
	f.set_figwidth(six_subplot_overview_width)
	axes[0, 0].plot(numElements, geo_T1sl1hor, 'bo',markersize=4)
	axes[0, 0].set_title('slice 1 horizontal')
	axes[0, 0].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes[0, 0].set_ylabel('Size in mm')
	axes[0, 0].axhspan(188, 192, alpha=0.5, color='green')
	axes[0, 0].set_ylim([ymin,ymax])	
	axes[0, 1].plot(numElements, geo_T1sl1ver, 'bo',markersize=4)
	axes[0, 1].set_title('slice 1 vertical')	
	axes[0, 1].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes[0, 1].axhspan(188, 192, alpha=0.5, color='green')
	axes[0, 1].set_ylim([ymin,ymax])
	axes[1, 0].plot(numElements, geo_T1sl5hor, 'bo',markersize=4)
	axes[1, 0].set_title('slice 5 horizontal')
	axes[1, 0].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes[1, 0].set_ylabel('Size in mm')
	axes[1, 0].axhspan(188, 192, alpha=0.5, color='green')
	axes[1, 0].set_ylim([ymin,ymax])
	axes[1, 1].plot(numElements, geo_T1sl5ver, 'bo',markersize=4)
	axes[1, 1].set_title('slice 5 vertical')
	axes[1, 1].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes[1, 1].axhspan(188, 192, alpha=0.5, color='green')
	axes[1, 1].set_ylim([ymin,ymax])
	axes[2, 0].plot(numElements, geo_T1sl5_p45, 'bo',markersize=4)
	axes[2, 0].set_title('slice 5 plus 45 degree')
	axes[2, 0].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes[2, 0].set_xlabel('Date')
	axes[2, 0].set_ylabel('Size in mm')
	matplotlib.pyplot.sca(axes[2, 0])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=six_subplot_overview_tickrota)
	axes[2, 0].axhspan(188, 192, alpha=0.5, color='green')
	axes[2, 0].set_ylim([ymin,ymax])	
	axes[2, 1].plot(numElements, geo_T1sl5_m45, 'bo',markersize=4)
	axes[2, 1].set_title('slice 5 minus 45 degree')	
	axes[2, 1].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes[2, 1].set_xlabel('Date')
	axes[2, 1].set_ylabel('Size in mm')
	axes[2, 1].axhspan(188, 192, alpha=0.5, color='green')
	axes[2, 1].set_ylim([ymin,ymax])
	axes[0 ,0].yaxis.grid()
	axes[0 ,1].yaxis.grid()
	axes[1 ,0].yaxis.grid()
	axes[1 ,1].yaxis.grid()
	axes[2 ,0].yaxis.grid()
	axes[2 ,1].yaxis.grid()
	matplotlib.pyplot.sca(axes[2, 1])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=six_subplot_overview_tickrota)
	matplotlib.pyplot.tight_layout()
	matplotlib.pyplot.savefig('Geometry_T1')

	#Resolution T1 
	ymin = 0
	ymax = 7
	f, axes = matplotlib.pyplot.subplots(3, 2, sharex='col', sharey='row')
	f.set_figheight(six_subplot_overview_height)
	f.set_figwidth(six_subplot_overview_width)
	axes[0, 0].plot(numElements, res_maxT1rechts1_1, 'bo',markersize=4)
	axes[0, 0].set_title('1.1 mm right')
	axes[0, 0].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[0, 0].set_ylabel('Maximum number of holes')
	axes[0, 0].axhspan(0, 4, alpha=0.5, color='green')
	axes[0, 0].set_ylim([ymin,ymax])	
	axes[0, 1].plot(numElements, res_maxT1links1_1, 'bo',markersize=4)
	axes[0, 1].set_title('1.1 mm left')	
	axes[0, 1].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[0, 1].axhspan(0, 4, alpha=0.5, color='green')
	axes[0, 1].set_ylim([ymin,ymax])
	axes[1, 0].plot(numElements, res_maxT1rechts1_0, 'bo',markersize=4)
	axes[1, 0].set_title('1.0 mm right')
	axes[1, 0].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[1, 0].set_ylabel('Maximum number of holes')
	axes[1, 0].axhspan(0, 4, alpha=0.5, color='green')
	axes[1, 0].set_ylim([ymin,ymax])
	axes[1, 1].plot(numElements, res_maxT1links1_0, 'bo',markersize=4)
	axes[1, 1].set_title('1.0 mm left')
	axes[1, 1].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[1, 1].axhspan(0, 4, alpha=0.5, color='green')
	axes[1, 1].set_ylim([ymin,ymax])
	axes[2, 0].plot(numElements, res_maxT1rechts0_9, 'bo',markersize=4)
	axes[2, 0].set_title('0.9 mm right')
	axes[2, 0].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[2, 0].set_xlabel('Date')
	axes[2, 0].set_ylabel('Maximum number of holes')
	matplotlib.pyplot.sca(axes[2, 0])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=six_subplot_overview_tickrota)
	axes[2, 0].axhspan(0, 4, alpha=0.5, color='green')
	axes[2, 0].set_ylim([ymin,ymax])	
	axes[2, 1].plot(numElements, res_maxT1links0_9, 'bo',markersize=4)
	axes[2, 1].set_title('0.9 mm left')	
	axes[2, 1].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[2, 1].set_xlabel('Date')
	axes[2, 1].axhspan(0, 4, alpha=0.5, color='green')
	axes[2, 1].set_ylim([ymin,ymax])
	matplotlib.pyplot.sca(axes[2, 1])
	axes[0 ,0].yaxis.grid()
	axes[0 ,1].yaxis.grid()
	axes[1 ,0].yaxis.grid()
	axes[1 ,1].yaxis.grid()
	axes[2 ,0].yaxis.grid()
	axes[2 ,1].yaxis.grid()
	matplotlib.pyplot.xticks(numElements, date_list,rotation=six_subplot_overview_tickrota)
	matplotlib.pyplot.tight_layout()
	matplotlib.pyplot.savefig('Resolution_T1')

	#Resolution T2
	ymin = 0
	ymax = 7
	f, axes = matplotlib.pyplot.subplots(3, 2, sharex='col', sharey='row')
	f.set_figheight(six_subplot_overview_height)
	f.set_figwidth(six_subplot_overview_width)
	axes[0, 0].plot(numElements, res_maxT2rechts1_1, 'bo',markersize=4)
	axes[0, 0].set_title('1.1 mm right')
	axes[0, 0].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[0, 0].set_ylabel('Maximum number of holes')
	axes[0, 0].axhspan(0, 4, alpha=0.5, color='green')
	axes[0, 0].set_ylim([ymin,ymax])	
	axes[0, 1].plot(numElements, res_maxT2links1_1, 'bo',markersize=4)
	axes[0, 1].set_title('1.1 mm left')	
	axes[0, 1].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[0, 1].axhspan(0, 4, alpha=0.5, color='green')
	axes[0, 1].set_ylim([ymin,ymax])
	axes[1, 0].plot(numElements, res_maxT2rechts1_0, 'bo',markersize=4)
	axes[1, 0].set_title('1.0 mm right')
	axes[1, 0].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[1, 0].set_ylabel('Maximum number of holes')
	axes[1, 0].axhspan(0, 4, alpha=0.5, color='green')
	axes[1, 0].set_ylim([ymin,ymax])
	axes[1, 1].plot(numElements, res_maxT2links1_0, 'bo',markersize=4)
	axes[1, 1].set_title('1.0 mm left')
	axes[1, 1].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[1, 1].axhspan(0, 4, alpha=0.5, color='green')
	axes[1, 1].set_ylim([ymin,ymax])
	axes[2, 0].plot(numElements, res_maxT2rechts0_9, 'bo',markersize=4)
	axes[2, 0].set_title('0.9 mm right')
	axes[2, 0].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[2, 0].set_xlabel('Date')
	axes[2, 0].set_ylabel('Maximum number of holes')
	matplotlib.pyplot.sca(axes[2, 0])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=six_subplot_overview_tickrota)
	axes[2, 0].axhspan(0, 4, alpha=0.5, color='green')
	axes[2, 0].set_ylim([ymin,ymax])	
	axes[2, 1].plot(numElements, res_maxT2links0_9, 'bo',markersize=4)
	axes[2, 1].set_title('0.9 mm left')	
	axes[2, 1].set_xlim([-0.5,float(number_of_shown_values)+ 0.5])
	axes[2, 1].set_xlabel('Date')
	axes[2, 1].axhspan(0, 4, alpha=0.5, color='green')
	axes[2, 1].set_ylim([ymin,ymax])
	axes[0 ,0].yaxis.grid()
	axes[0 ,1].yaxis.grid()
	axes[1 ,0].yaxis.grid()
	axes[1 ,1].yaxis.grid()
	axes[2 ,0].yaxis.grid()
	axes[2 ,1].yaxis.grid()
	matplotlib.pyplot.sca(axes[2, 1])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=six_subplot_overview_tickrota)
	matplotlib.pyplot.tight_layout()
	matplotlib.pyplot.savefig('Resolution_T2')

	# Thickness
	f, axarr = matplotlib.pyplot.subplots(2, sharex=True)
	f.set_figheight(two_subplot_overview_height)
	f.set_figwidth(two_subplot_overview_width)
	ymin = 0
	ymax = 10
	axarr[0].set_ylim([ymin,ymax])	
	axarr[0].plot(numElements, thick_T1, 'bo',markersize=4)
	axarr[0].set_title('Slice thickness T1')	
	axarr[0].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axarr[0].set_ylabel('Size in mm')
	axarr[0].axhspan(4.3, 5.7, alpha=0.5, color='green')
	axarr[0].set_ylim([ymin,ymax])
	axarr[1].axhspan(4.3, 5.7, alpha=0.5, color='green')
	axarr[1].set_ylim([ymin,ymax])	
	axarr[1].plot(numElements, thick_T2, 'bo',markersize=4)
	axarr[1].set_title('Slice thickness T2')	
	axarr[1].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axarr[1].set_xlabel('Date')
	axarr[1].set_ylabel('Size in mm')
	axarr[1].set_ylim([ymin,ymax])
	axarr[0].yaxis.grid()
	axarr[0].yaxis.grid()
	
	matplotlib.pyplot.sca(axarr[1])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=two_subplot_overview_tickrota)
	matplotlib.pyplot.tight_layout()
	matplotlib.pyplot.savefig('Thickness')


	#Position
	ymin = 0
	ymax = 10
	f, axes = matplotlib.pyplot.subplots(2, 2, sharex='col', sharey='row')
	f.set_figheight(four_subplot_overview_height)
	f.set_figwidth(four_subplot_overview_width)
	axes[0, 0].plot(numElements, pos_T1sl2, 'bo',markersize=4)
	axes[0, 0].set_title('T1 slice 2')
	axes[0, 0].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes[0, 0].set_ylabel('Difference in mm')
	axes[0, 0].axhspan(0, 5, alpha=0.5, color='green')
	axes[0, 0].set_ylim([ymin,ymax])
	axes[0, 1].plot(numElements, pos_T1sl12, 'bo',markersize=4)
	axes[0, 1].set_title('T1 slice 12')	
	axes[0, 1].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes[0, 1].axhspan(0, 5, alpha=0.5, color='green')
	axes[0, 1].set_ylim([ymin,ymax])
	axes[1, 0].plot(numElements, pos_T2sl2, 'bo',markersize=4)
	axes[1, 0].set_title('T2 slice 2')
	axes[1, 0].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes[1, 0].set_xlabel('Date')
	axes[1, 0].set_ylabel('Difference in mm')
	matplotlib.pyplot.sca(axes[1, 0])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=four_subplot_overview_tickrota)
	axes[1, 0].axhspan(0, 5, alpha=0.5, color='green')
	axes[1, 0].set_ylim([ymin,ymax])	
	axes[1, 1].plot(numElements, pos_T2sl12, 'bo',markersize=4)
	axes[1, 1].set_title('T2 slice 12')	
	axes[1, 1].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes[1, 1].set_xlabel('Date')
	axes[1, 1].axhspan(0, 5, alpha=0.5, color='green')
	axes[1, 1].set_ylim([ymin,ymax])
	axes[0 ,0].yaxis.grid()
	axes[0 ,1].yaxis.grid()
	axes[1 ,0].yaxis.grid()
	axes[1 ,1].yaxis.grid()
	matplotlib.pyplot.sca(axes[1, 1])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=four_subplot_overview_tickrota)
	matplotlib.pyplot.tight_layout()
	matplotlib.pyplot.savefig('Position')


	# PIU
	f, axarr = matplotlib.pyplot.subplots(2, sharex=True)
	f.set_figheight(two_subplot_overview_height)
	f.set_figwidth(two_subplot_overview_width)
	ymin = 65
	ymax = 100
	axarr[0].set_ylim([ymin,ymax])	
	axarr[0].plot(numElements, pIU_T1, 'bo',markersize=4)
	axarr[0].set_title('PIU T1')	
	axarr[0].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axarr[0].set_ylabel('PIU in percentage')
	axarr[0].axhspan(82, 100, alpha=0.5, color='green')
	axarr[0].set_ylim([ymin,ymax])
	axarr[1].axhspan(82,100, alpha=0.5, color='green')
	axarr[1].set_ylim([ymin,ymax])	
	axarr[1].plot(numElements, pIU_T2, 'bo',markersize=4)
	axarr[1].set_title('PIU T2')	
	axarr[1].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axarr[1].set_xlabel('Date')
	axarr[1].set_ylabel('PIU in percentage')
	axarr[1].set_ylim([ymin,ymax])
	axarr[0].yaxis.grid()
	axarr[0].yaxis.grid()
	matplotlib.pyplot.sca(axarr[1])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=two_subplot_overview_tickrota)
	matplotlib.pyplot.tight_layout()
	matplotlib.pyplot.savefig('PIU')

	# PSG
	f, axarr = matplotlib.pyplot.subplots(2, sharex=True)
	f.set_figheight(two_subplot_overview_height)
	f.set_figwidth(two_subplot_overview_width)
	ymin = 0
	ymax = 0.1
	axarr[0].set_ylim([ymin,ymax])	
	axarr[0].plot(numElements, pSG_T1, 'bo',markersize=4)
	axarr[0].set_title('PSG T1')	
	axarr[0].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axarr[0].set_ylabel('PSG in percentage')
	axarr[0].axhspan(0, 0.025, alpha=0.5, color='green')
	axarr[0].set_ylim([ymin,ymax])
	axarr[1].axhspan(0,0.025, alpha=0.5, color='green')
	axarr[1].set_ylim([ymin,ymax])	
	axarr[1].plot(numElements, pSG_T2, 'bo',markersize=4)
	axarr[1].set_title('PSG T2')	
	axarr[1].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axarr[1].set_xlabel('Date')
	axarr[1].set_ylabel('PSG in percentage')
	axarr[1].set_ylim([ymin,ymax])
	axarr[0].yaxis.grid()
	axarr[0].yaxis.grid()
	matplotlib.pyplot.sca(axarr[1])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=two_subplot_overview_tickrota)
	matplotlib.pyplot.tight_layout()
	matplotlib.pyplot.savefig('PSG')
	
	# Low-contrast object
	f, axarr = matplotlib.pyplot.subplots(2, sharex=True)
	f.set_figheight(two_subplot_overview_height)
	f.set_figwidth(two_subplot_overview_width)
	ymin = 0
	ymax = 45
	axarr[0].set_ylim([ymin,ymax])	
	axarr[0].plot(numElements, lCOD_sum_T1, 'bo',markersize=4)
	axarr[0].set_title('PSG T1')	
	axarr[0].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axarr[0].set_ylabel('Number of objects')
	axarr[0].axhspan(36, 40, alpha=0.5, color='green')
	axarr[0].set_ylim([ymin,ymax])
	axarr[1].axhspan(36,40, alpha=0.5, color='green')
	axarr[1].set_ylim([ymin,ymax])	
	axarr[1].plot(numElements, lCOD_sum_T1, 'bo',markersize=4)
	axarr[1].set_title('PSG T2')	
	axarr[1].set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axarr[1].set_xlabel('Date')
	axarr[1].set_ylabel('Number of objects')
	axarr[1].set_ylim([ymin,ymax])
	axarr[0].yaxis.grid()
	axarr[0].yaxis.grid()
	matplotlib.pyplot.sca(axarr[1])
	matplotlib.pyplot.xticks(numElements, date_list,rotation=two_subplot_overview_tickrota)
	matplotlib.pyplot.tight_layout()
	matplotlib.pyplot.savefig('LCOD')

	
	
	
	
	
	# HTML
def generate_html(resultpath):
	menu_html_file_path = '/home/brain/qa/html/menu_html.html'
	menu_html_file = open(menu_html_file_path, 'r')
	menu_html = menu_html_file.readlines()
	menu_html_file.close()

	result_file = open(resultpath+'overview.html','w')
	result_file.writelines(menu_html)
	result_file.write('\t\t<h1 style="margin-top:80px;">ACR-Overview</h1>\n')
	result_file.write('\t\t<h2>Geometry Localizer</h2>\n\t\t<p>\n\t\t\t<img src="Geometry_Localizer.png" alt="Geometry Localizer">\n\t\t</p>\n')
	result_file.write('\t\t<h2>Geometry T1</h2>\n\t\t<p>\n\t\t\t<img src="Geometry_T1.png" alt="Geometry T1">\n\t\t</p>\n')
	result_file.write('\t\t<h2>Resolution T1</h2>\n\t\t<p>\n\t\t\t<img src="Resolution_T1.png" alt="Resolution T1">\n\t\t</p>\n')
	result_file.write('\t\t<h2>Resolution T2</h2>\n\t\t<p>\n\t\t\t<img src="Resolution_T2.png" alt="Resolution T2">\n\t\t</p>\n')
	result_file.write('\t\t<h2>Slice Thickness</h2>\n\t\t<p>\n\t\t\t<img src="Thickness.png" alt="Slice Thickness">\n\t\t</p>\n')
	result_file.write('\t\t<h2>Slice Position</h2>\n\t\t<p>\n\t\t\t<img src="Position.png" alt="Slice Position">\n\t\t</p>\n')
	result_file.write('\t\t<h2>PIU</h2>\n\t\t<p>\n\t\t\t<img src="PIU.png" alt="PIU"></p>\n')
	result_file.write('\t\t<h2>PSG</h2>\n\t\t<p>\n\t\t\t<img src="PSG.png" alt="PSG"></p>\n')
	result_file.write('\t\t<h2>LCOD</h2>\n\t\t<p>\n\t\t\t<img src="LCOD.png" alt="LCOD">\n\t\t</p>\n')

	result_file.write('\t\t<h1>Results</h1>\n')
	result_file.write('\t\t<ul>\n')
	
	result_list = os.listdir(resultpath)
	result_list.sort(reverse=True)
	for i in result_list:
		if os.path.isdir(resultpath+i):
			rfile = open(i+'/overview.txt','r')
			lines = rfile.readlines()

			for j in lines:
				entry = j.split(';')
				geo_loc = float(entry[1].replace(',','.'))
				geo_T1sl1hor = float(entry[2].replace(',','.'))
				geo_T1sl1ver = float(entry[3].replace(',','.'))
				geo_T1sl5hor = float(entry[4].replace(',','.'))
				geo_T1sl5ver = float(entry[5].replace(',','.'))
				geo_T1sl5_p45 = float(entry[6].replace(',','.'))
				geo_T1sl5_m45 = float(entry[7].replace(',','.'))
				res_maxT1rechts1_1 = float(entry[8].replace(',','.'))
				res_maxT1links1_1 = float(entry[9].replace(',','.'))
				res_maxT1rechts1_0 = float(entry[10].replace(',','.'))
				res_maxT1links1_0 = float(entry[11].replace(',','.'))
				res_maxT1rechts0_9 = float(entry[12].replace(',','.'))
				res_maxT1links0_9 = float(entry[13].replace(',','.'))
				res_maxT2rechts1_1 = float(entry[14].replace(',','.'))
				res_maxT2links1_1 = float(entry[15].replace(',','.'))
				res_maxT2rechts1_0 = float(entry[16].replace(',','.'))
				res_maxT2links1_0 = float(entry[17].replace(',','.'))
				res_maxT2rechts0_9 = float(entry[18].replace(',','.'))
				res_maxT2links0_9 = float(entry[19].replace(',','.'))
				thick_T1 = float(entry[20].replace(',','.'))
				thick_T2 = float(entry[21].replace(',','.'))
				pos_T1sl2 = float(entry[22].replace(',','.'))
				pos_T1sl12 = float(entry[23].replace(',','.'))
				pos_T2sl2 = float(entry[24].replace(',','.'))
				pos_T2sl12 = float(entry[25].replace(',','.'))
				pIU_T1 = float(entry[26].replace(',','.'))
				pIU_T2 = float(entry[27].replace(',','.'))
				pSG_T1 = float(entry[28].replace(',','.'))
				pSG_T2 = float(entry[29].replace(',','.'))
				lCOD_sum_T1 = float(entry[30].replace(',','.'))
				try:
					lCOD_sum_T2 = float(entry[31].replace(',','.'))
				except:
					lCOD_sum_T2 = 0

			rfile.close()

			if (146 <= geo_loc and geo_loc <= 150) and (188 <= geo_T1sl1hor and geo_T1sl1hor <= 192) and (188 <= geo_T1sl1ver and geo_T1sl1ver <= 192) and (188 <= geo_T1sl5hor and geo_T1sl5hor <= 192) and (188 <= geo_T1sl5ver and geo_T1sl5ver <= 192) and (188 <= geo_T1sl5_p45 and geo_T1sl5_p45 <= 192) and (188 <= geo_T1sl5_m45 and geo_T1sl5_m45 <= 192) and (res_maxT1rechts1_1 >= 4) and (res_maxT1links1_1 >= 4) and (res_maxT1rechts1_0 >= 4) and (res_maxT1links1_0 >= 4) and (res_maxT1rechts0_9 >= 4) and (res_maxT1links0_9 >= 4) and (res_maxT2rechts1_1 >= 4) and (res_maxT2links1_1 >= 4) and (res_maxT2rechts1_0 >= 4) and (res_maxT2links1_0 >= 4) and (res_maxT2rechts0_9 >= 4) and (res_maxT2links0_9 >= 4) and (4.3 <= thick_T1 and thick_T1 <= 5.7) and (4.3 <= thick_T1 and thick_T1 <= 5.7) and (0 <= pos_T1sl2 and pos_T1sl2 <= 5) and (0 <= pos_T1sl12 and pos_T1sl12 <= 5) and (0 <= pos_T2sl2 and pos_T2sl2 <= 5) and (0 <= pos_T2sl12 and pos_T2sl12 <= 5) and (82 <= pIU_T1 and pIU_T1 <= 100) and ( 82 <= pIU_T2 and pIU_T2 <= 100) and (0 <= pSG_T1 and pSG_T1 <= 0.025) and (0 <= pSG_T2 and pSG_T2 <= 0.025) and (36 <= lCOD_sum_T1 and lCOD_sum_T1 <= 40) and (36 <= lCOD_sum_T2 and lCOD_sum_T2 <= 40):

				result_file.write('\t\t\t<li><a href="'+i+'/results.html">'+i+'</a></li>\n')
			else:
				result_file.write('\t\t\t<li><img src="/warning.png"><a href="'+i+'/results.html">'+i+'</a></li>\n')
			
			
	result_file.write('\t\t</ul>\n')	
	result_file.write('\t</body>\n</html>')
	
def main(overview_logfile,matlab_path,resultpath,number_of_shown_values):
	os.chdir('/home/brain/qa/html/results/acr/')
	generate_graph(overview_logfile,matlab_path,resultpath,number_of_shown_values)
	generate_html(resultpath)

