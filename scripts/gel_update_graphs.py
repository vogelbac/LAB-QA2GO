#!/usr/bin/python
import os,sys
import cgi
import cgitb; cgitb.enable()
import parse_ini_file
import gel_collect_results
import gel_make_html_report
import gel_make_overview_html
import time


# set HOME environment variable to a directory the httpd server can write to
os.environ[ 'HOME' ] = '/tmp/'
 
os.chdir('/home/brain/qa/html/results/gel/')	
import matplotlib
# chose a non-GUI backend
matplotlib.use( 'Agg' )

import pylab
 
#Deals with inputing data into python from the html form
form = cgi.FieldStorage()

gel_result_directory = '/home/brain/qa/html/results/gel/'
gel_matlab_path = '/home/brain/qa/scripts/gel/matlab/'
config_file = '/home/brain/qa/html/configuration/config.ini'
gel_view_settings = parse_ini_file.parse_ini_file('phantom_settings')
gel_collect_results.main(gel_result_directory)
gel_make_html_report.main(gel_result_directory)



overview_logfile = gel_result_directory+'overview.txt'
matlab_path = gel_matlab_path
resultpath = gel_result_directory
number_of_shown_values = gel_view_settings[12]

#remove old files

for file in os.listdir(gel_result_directory ):
    if file.endswith(".png"):
        os.remove(os.path.join(gel_result_directory, file))


gel_make_overview_html.main(overview_logfile,matlab_path,resultpath,number_of_shown_values)



