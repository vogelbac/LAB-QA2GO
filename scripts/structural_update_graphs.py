#!/usr/bin/python
import os,sys
import cgi
import cgitb; cgitb.enable()
import parse_ini_file
import structural_make_overview
import structural_make_html_report

# set HOME environment variable to a directory the httpd server can write to
os.environ[ 'HOME' ] = '/tmp/'
 
os.chdir('/home/brain/qa/html/results/structural/')	
import matplotlib
# chose a non-GUI backend
matplotlib.use( 'Agg' )

import pylab
 
#Deals with inputing data into python from the html form
form = cgi.FieldStorage()

structural_result_directory = '/home/brain/qa/html/results/structural/'
human_structural_settings = parse_ini_file.parse_ini_file('human_structural_settings')

structural_make_html_report.generate_overview_html(structural_result_directory,human_structural_settings)
structural_make_overview.run(structural_result_directory)
