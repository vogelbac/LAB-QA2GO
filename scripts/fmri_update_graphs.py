#script to update the overview graphs based on the value given of the config file (configuration page)

#!/usr/bin/python
import os,sys
import cgi
import cgitb; cgitb.enable()
import parse_ini_file
import fmri_generate_overview_graphs
import fmri_make_html_report


# set HOME environment variable to a directory the httpd server can write to
os.environ[ 'HOME' ] = '/tmp/'
 
os.chdir('/home/brain/qa/html/results/functional/')	
import matplotlib
# chose a non-GUI backend
matplotlib.use( 'Agg' )

import pylab
 
#Deals with inputing data into python from the html form
form = cgi.FieldStorage()

functional_result_directory = '/home/brain/qa/html/results/functional/'
fmri_view_settings = parse_ini_file.parse_ini_file('fmri_settings')

number_of_shown_values = fmri_view_settings[2]
fmri_generate_overview_graphs.read_values_file(functional_result_directory, number_of_shown_values)
fmri_make_html_report.generate_overview_html(functional_result_directory)

