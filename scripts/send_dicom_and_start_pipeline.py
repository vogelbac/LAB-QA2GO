#!/usr/bin/python

import sys
import os
import shutil
import subprocess
import qa_pipeline


#define variables
dcm_send = '/home/brain/qa/dcmtk/bin/dcmsend'
dcm_send_values = '-v +sd +r -aec CONQUESTSRV1 127.0.0.1 5678'

input_list = os.listdir(sys.argv[1])

#copy data from input to custom_new_directory

os.environ["DCMDICTPATH"] = '/home/brain/qa/dcmtk/share/dcmtk/dicom.dic'
subprocess.call (dcm_send + ' ' + dcm_send_values + ' ' + sys.argv[1], shell=True)

#start automated QA pipeline
os.system("python /home/brain/qa/scripts/qa_pipeline.py dicom")
