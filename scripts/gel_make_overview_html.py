#!/usr/bin/python


# script to generate the overview graphs and to generate the overview html page for the gel phantoms

import os,sys
sys.path.append('/home/brain/qa/scripts/')
import cgi
import cgitb; cgitb.enable()


# set HOME environment variable to a directory the httpd server can write to
os.environ[ 'HOME' ] = '/tmp/'
 
os.chdir('/home/brain/qa/html/results/gel/')	
import matplotlib
# chose a non-GUI backend
matplotlib.use( 'Agg' )

import pylab
import parse_ini_file



menu_html_file_path = '/home/brain/qa/html/menu_html.html'
menu_html_file = open(menu_html_file_path, 'r')
menu_html = menu_html_file.readlines()
menu_html_file.close()

	
def generate_graph(overview_logfile,matlab_path,resultpath,number_of_shown_values):
	rfile = open(overview_logfile,'r')

	lines = rfile.readlines()
	
	if (len(lines)-1 >= int(number_of_shown_values)):
		lines = lines[-int(number_of_shown_values):]	
	else:
		lines = lines[1:]

	date_list = []
	snr = []
	sfnr = []
	fluctuation = []
	drift = []
	psc = []
	psg_signal_image = []



	for i in lines:
		entry = i.split('\t')
		date_pre_list = entry[0].split('_')
		date_list.append(date_pre_list[-4]+'-'+date_pre_list[-3]+'-'+date_pre_list[-2]+'-'+date_pre_list[-1])
		snr.append(float(entry[1].replace(',','.')))
		sfnr.append(float(entry[5].replace(',','.')))
		fluctuation.append(float(entry[6].replace(',','.')))
		drift.append(float(entry[7].replace(',','.')))
		psc.append(float(entry[25].replace(',','.')))
		psg_signal_image.append(float(entry[30].replace(',','.')))
	
	rfile.close()	


	dateliste = ''

	for i in date_list:
		dateliste = dateliste+i+','

	dateliste = dateliste[:-1].split(",")

	numElements= range(1,len(dateliste)+1)

	
	phantom_settings = parse_ini_file.parse_ini_file('phantom_settings')


	mean_snr = float(phantom_settings[0])
	range_snr = float(phantom_settings[1])
	mean_sfnr = float(phantom_settings[2])
	range_sfnr = float(phantom_settings[3])
	mean_fluct = float(phantom_settings[4])
	range_fluct = float(phantom_settings[5])
	mean_drift = float(phantom_settings[6])
	range_drift = float(phantom_settings[7])
	mean_psc = float(phantom_settings[8])
	range_psc = float(phantom_settings[9])
	mean_psg = float(phantom_settings[10])
	range_psg = float(phantom_settings[11])

	plus_snr = mean_snr + range_snr
	minus_snr = mean_snr - range_snr
	 	
	plus_sfnr = mean_sfnr + range_sfnr
	minus_sfnr = mean_sfnr - range_sfnr
	
	plus_fluct = mean_fluct + range_fluct
	minus_fluct = mean_fluct - range_fluct
	
	plus_drift = mean_drift + range_drift
	minus_drift = mean_drift - range_drift

	plus_psc = mean_psc + range_psc
	minus_psc = mean_psc - range_psc

	plus_psg = mean_psg + range_psg
	minus_psg = mean_psg - range_psg

	if int(number_of_shown_values)==5:
		snr_overview_width=10
		snr_overview_height=6
		snr_overview_fontsize=11
		snr_overview_tickrota=40
		sfnr_overview_width=10
		sfnr_overview_height=6
		sfnr_overview_fontsize=11
		sfnr_overview_tickrota=40
		fluctuation_overview_width=10
		fluctuation_overview_height=6
		fluctuation_overview_fontsize=11
		fluctuation_overview_tickrota=40
		drift_overview_width=10
		drift_overview_height=6
		drift_overview_fontsize=11
		drift_overview_tickrota=40
		psc_overview_width=10
		psc_overview_height=6
		psc_overview_fontsize=11
		psc_overview_tickrota=40
		psg_overview_width=10
		psg_overview_height=6
		psg_overview_fontsize=11
		psg_overview_tickrota=40
	elif int(number_of_shown_values)==10:
		snr_overview_width=12
		snr_overview_height=6
		snr_overview_fontsize=11
		snr_overview_tickrota=60
		sfnr_overview_width=12
		sfnr_overview_height=6
		sfnr_overview_fontsize=11
		sfnr_overview_tickrota=60
		fluctuation_overview_width=12
		fluctuation_overview_height=6
		fluctuation_overview_fontsize=11
		fluctuation_overview_tickrota=60
		drift_overview_width=12
		drift_overview_height=6
		drift_overview_fontsize=11
		drift_overview_tickrota=60
		psc_overview_width=12
		psc_overview_height=6
		psc_overview_fontsize=11
		psc_overview_tickrota=60
		psg_overview_width=12
		psg_overview_height=6
		psg_overview_fontsize=11
		psg_overview_tickrota=60
	elif int(number_of_shown_values)==15:
		snr_overview_width=14
		snr_overview_height=6
		snr_overview_fontsize=11
		snr_overview_tickrota=70
		sfnr_overview_width=14
		sfnr_overview_height=6
		sfnr_overview_fontsize=11
		sfnr_overview_tickrota=70
		fluctuation_overview_width=14
		fluctuation_overview_height=6
		fluctuation_overview_fontsize=11
		fluctuation_overview_tickrota=70
		drift_overview_width=14
		drift_overview_height=6
		drift_overview_fontsize=11
		drift_overview_tickrota=70
		psc_overview_width=14
		psc_overview_height=6
		psc_overview_fontsize=11
		psc_overview_tickrota=70
		psg_overview_width=14
		psg_overview_height=6
		psg_overview_fontsize=11
		psg_overview_tickrota=70
	elif int(number_of_shown_values)==20:
		snr_overview_width=16
		snr_overview_height=6
		snr_overview_fontsize=11
		snr_overview_tickrota=75
		sfnr_overview_width=16
		sfnr_overview_height=6
		sfnr_overview_fontsize=11
		sfnr_overview_tickrota=75
		fluctuation_overview_width=16
		fluctuation_overview_height=6
		fluctuation_overview_fontsize=11
		fluctuation_overview_tickrota=75
		drift_overview_width=16
		drift_overview_height=6
		drift_overview_fontsize=11
		drift_overview_tickrota=75
		psc_overview_width=16
		psc_overview_height=6
		psc_overview_fontsize=11
		psc_overview_tickrota=75
		psg_overview_width=16
		psg_overview_height=6
		psg_overview_fontsize=11
		psg_overview_tickrota=75
	elif int(number_of_shown_values)==50:
		snr_overview_width=18
		snr_overview_height=6
		snr_overview_fontsize=11
		snr_overview_tickrota=90
		sfnr_overview_width=18
		sfnr_overview_height=6
		sfnr_overview_fontsize=11
		sfnr_overview_tickrota=90
		fluctuation_overview_width=18
		fluctuation_overview_height=6
		fluctuation_overview_fontsize=11
		fluctuation_overview_tickrota=90
		drift_overview_width=18
		drift_overview_height=6
		drift_overview_fontsize=11
		drift_overview_tickrota=90
		psc_overview_width=18
		psc_overview_height=6
		psc_overview_fontsize=11
		psc_overview_tickrota=90
		psg_overview_width=18
		psg_overview_height=6
		psg_overview_fontsize=11
		psg_overview_tickrota=90


	#SNR
	matplotlib.pyplot.figure(figsize=(snr_overview_width,snr_overview_height))
	matplotlib.pyplot.plot(numElements, snr, 'bo',markersize=4)
	matplotlib.pyplot.xticks(numElements, dateliste,rotation=snr_overview_tickrota)
	matplotlib.pyplot.title('SNR')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Date')
	axes.set_ylabel('SNR')
	axes.axhspan(minus_snr, plus_snr, alpha=0.5, color='green')
	ymin = min(snr[-int(number_of_shown_values):]) - 50
	ymax = max(snr[-int(number_of_shown_values):]) + 50 
	axes.set_ylim([ymin,ymax])
	axes.yaxis.grid()
	green_patch = matplotlib.patches.Patch(color='green', label='SNR range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=snr_overview_fontsize)
	matplotlib.pyplot.tight_layout()
	matplotlib.pyplot.savefig('snr')





	#SFNR
	matplotlib.pyplot.figure(figsize=(sfnr_overview_width,sfnr_overview_height))
	matplotlib.pyplot.plot(numElements, sfnr, 'bo',markersize=4)
	matplotlib.pyplot.xticks(numElements, dateliste,rotation=sfnr_overview_tickrota)
	matplotlib.pyplot.title('SFNR')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Date')
	axes.set_ylabel('SFNR')
	axes.axhspan(minus_sfnr, plus_sfnr, alpha=0.5, color='green')
	ymin = min(sfnr[-int(number_of_shown_values):]) - 50
	ymax = max(sfnr[-int(number_of_shown_values):]) + 50 
	axes.set_ylim([ymin,ymax])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='SFNR range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=sfnr_overview_fontsize)
	matplotlib.pyplot.savefig('sfnr')






	#Fluctuation
	matplotlib.pyplot.figure(figsize=(fluctuation_overview_width,fluctuation_overview_height))
	matplotlib.pyplot.plot(numElements, fluctuation, 'bo',markersize=4)
	matplotlib.pyplot.xticks(numElements, dateliste,rotation=fluctuation_overview_tickrota)
	matplotlib.pyplot.title('Fluctuation')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Date')
	axes.set_ylabel('Fluctuation')
	axes.axhspan(minus_fluct, plus_fluct, alpha=0.5, color='green')
	ymin = 0
	ymax = max(fluctuation[-int(number_of_shown_values):]) + 1
	axes.set_ylim([ymin,ymax])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='Fluctuation range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=fluctuation_overview_fontsize)
	matplotlib.pyplot.savefig('fluctuation')



	#Drift
	matplotlib.pyplot.figure(figsize=(drift_overview_width,drift_overview_height))
	matplotlib.pyplot.plot(numElements, drift, 'bo',markersize=4)
	matplotlib.pyplot.xticks(numElements, dateliste,rotation=drift_overview_tickrota)
	matplotlib.pyplot.title('Drift')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Date')
	axes.set_ylabel('Drift')
	axes.axhspan(minus_drift, plus_drift, alpha=0.5, color='green')
	ymin = 0
	ymax = max(drift[-int(number_of_shown_values):]) + 1
	axes.set_ylim([ymin,ymax])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='Drift range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=drift_overview_fontsize)
	matplotlib.pyplot.savefig('drift')



	#PSC
	matplotlib.pyplot.figure(figsize=(psc_overview_width,psc_overview_height))
	matplotlib.pyplot.plot(numElements, psc, 'bo',markersize=4)
	matplotlib.pyplot.xticks(numElements, dateliste,rotation=psc_overview_tickrota)
	matplotlib.pyplot.title('PSC')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Date')
	axes.set_ylabel('PSC')
	axes.axhspan(minus_psc, plus_psc, alpha=0.5, color='green')
	ymin = 0
	ymax = max(psc[-int(number_of_shown_values):]) + 1.5
	axes.set_ylim([ymin,ymax])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='PSC range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=psc_overview_fontsize)
	matplotlib.pyplot.savefig('psc')

	#PSG
	matplotlib.pyplot.figure(figsize=(psg_overview_width,psg_overview_height))
	matplotlib.pyplot.plot(numElements, psg_signal_image, 'bo',markersize=4)
	matplotlib.pyplot.xticks(numElements, dateliste,rotation=psg_overview_tickrota)
	matplotlib.pyplot.title('PSG Signal Image')
	axes = matplotlib.pyplot.gca()
	axes.set_xlim([-0.5,float(number_of_shown_values)+0.5])
	axes.set_xlabel('Date')
	axes.set_ylabel('PSG Signal Image')
	axes.axhspan(minus_psg, plus_psg, alpha=0.5, color='green')
	ymin = 0
	ymax = max(psg_signal_image[-int(number_of_shown_values):]) + 0.25
	axes.set_ylim([ymin,ymax])
	axes.yaxis.grid()
	matplotlib.pyplot.tight_layout()
	green_patch = matplotlib.patches.Patch(color='green', label='PSC range value')
	matplotlib.pyplot.legend(handles=[green_patch], fontsize=psg_overview_fontsize)
	matplotlib.pyplot.savefig('psg_signal_image')


	outlier = []
	for i in range(0,len(date_list)):
		if snr[i] < minus_snr or snr[i]> plus_snr:
			outlier.append(date_list[i].replace('-','_'))
		if sfnr[i] < minus_sfnr or snr[i]> plus_sfnr:
			outlier.append(date_list[i].replace('-','_'))
		if drift[i] < minus_drift or drift[i]> plus_drift:
			outlier.append(date_list[i].replace('-','_'))
		if fluctuation[i] < minus_fluct or fluctuation[i]> plus_fluct:
			outlier.append(date_list[i].replace('-','_'))
		if psc[i] < minus_psc or psc[i]> plus_psc:
			outlier.append(date_list[i].replace('-','_'))
		if psg_signal_image[i] < minus_psg or psg_signal_image[i]> plus_psg:
			outlier.append(date_list[i].replace('-','_'))


	 	
	return outlier
	
	# HTML
def generate_html(resultpath,outlier):
	result_file = open(resultpath+'overview.html','w')
	result_file.writelines(menu_html)
	result_file.write('\t\t<h1 style="margin-top:80px;">Gel-Overview</h1>\n')
	result_file.write('\t\t<h2>SNR</h2>\n\t\t<p><img src="snr.png" alt="snr"></p>\n')
	result_file.write('\t\t<h2>SFNR</h2>\n\t\t<p><img src="sfnr.png" alt="sfnr"></p>\n')
	result_file.write('\t\t<h2>Fluctuation</h2>\n\t\t<p><img src="fluctuation.png" alt="fluctuation"></p>\n')
	result_file.write('\t\t<h2>Drift</h2>\n\t\t<p><img src="drift.png" alt="drift"></p>\n')
	result_file.write('\t\t<h2>PSC</h2>\n\t\t<p><img src="psc.png" alt="psc"></p>\n')
	result_file.write('\t\t<h2>PSG</h2>\n\t\t<p><img src="psg_signal_image.png" alt="psc"></p>\n')

	result_file.write('\t\t<h1>Results</h1>\n')
	result_file.write('\t\t<ul>\n')
	
	result_list = os.listdir(resultpath)
	result_list.sort(reverse=True)
	for i in result_list:
		if os.path.isdir(resultpath+i):
			result_file.write('\t\t\t<li>'+i+'</li>\n')
			result_file.write('\t\t\t<li>\n\t\t\t\t<ul>\n')
			temp = os.listdir(resultpath+i)
			for j in temp:
				if os.path.isdir(resultpath+i):
					if j in outlier:
						result_file.write('\t\t\t\t\t<li><img src="/warning.png"><a href="'+i+'/'+j+'/results.html">'+j+'</a></li>\n')
					else:
						result_file.write('\t\t\t\t\t<li><a href="'+i+'/'+j+'/results.html">'+j+'</a></li>\n')
			result_file.write('\t\t\t\t</ul>\n\t\t\t</li>\n')
	result_file.write('\t\t</ul>\n')	
	result_file.write('\t</body>\n</html>')
	
def main(overview_logfile,matlab_path,resultpath,number_of_shown_values):
	os.chdir('/home/brain/qa/html/results/gel/')
	outlier = generate_graph(overview_logfile,matlab_path,resultpath,number_of_shown_values)
	generate_html(resultpath, outlier)

