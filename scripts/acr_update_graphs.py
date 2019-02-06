#script to update the acr graphs based on the configuration page entry

#!/usr/bin/python
import os,sys
import cgi
import cgitb; cgitb.enable()
import parse_ini_file
import acr_generate_overview_measurement
import acr_generate_html_report
import acr_make_overview
import acr_generate_overview_overall
import time


# set HOME environment variable to a directory the httpd server can write to
os.environ[ 'HOME' ] = '/tmp/'
 
os.chdir('/home/brain/qa/html/results/acr/')	
import matplotlib
# chose a non-GUI backend
matplotlib.use( 'Agg' )

import pylab
 
#Deals with inputing data into python from the html form
form = cgi.FieldStorage()

acr_result_directory = '/home/brain/qa/html/results/acr/'
acr_matlab_path = '/home/brain/qa/scripts/acr/matlab/'
config_file = '/home/brain/qa/html/configuration/config.ini'
acr_view_settings = parse_ini_file.parse_ini_file('acr_settings')
acr_generate_overview_measurement.main(acr_result_directory)
acr_generate_html_report.read_logfile(acr_result_directory)
acr_make_overview.main(acr_result_directory)



overview_logfile = acr_result_directory+'overview.txt'
matlab_path = acr_matlab_path
resultpath = acr_result_directory
number_of_shown_values = acr_view_settings[0]

#remove old files

for file in os.listdir(acr_result_directory ):
    if file.endswith(".png"):
        os.remove(os.path.join(acr_result_directory, file))


acr_generate_overview_overall.main(overview_logfile,matlab_path,resultpath,number_of_shown_values)






