[![GitHub issues](https://img.shields.io/github/issues/vogelbac/LAB-QA2GO.svg)](https://github.com/vogelbac/LAB-QA2GO/issues/)
[![GitHub pull-requests](https://img.shields.io/github/issues-pr/vogelbac/LAB-QA2GO.svg)](https://github.com/vogelbac/LAB-QA2GO/pulls/)
[![GitHub contributors](https://img.shields.io/github/contributors/vogelbac/LAB-QA2GO.svg)](https://GitHub.com/vogelbac/LAB-QA2GO/graphs/contributors/)
[![GitHub Commits](https://github-basic-badges.herokuapp.com/commits/vogelbac/LAB-QA2GO.svg)](https://github.com/vogelbac/LAB-QA2GO/commits/master)
[![GitHub size](https://github-size-badge.herokuapp.com/vogelbac/LAB-QA2GO.svg)](https://github.com/vogelbac/LAB-QA2GOs/archive/master.zip)
[![Docker Hub](https://img.shields.io/docker/pulls/vogelbac/LAB-QA2GO.svg?maxAge=2592000)](https://hub.docker.com/r/vogelbac/LAB-QA2GO/)
[![GitHub HitCount](http://hits.dwyl.io/vogelbac/LAB-QA2GO.svg)](http://hits.dwyl.io/vogelbac/LAB-QA2GO)


# LAB-QA2GO
LAB–QA2GO  - A free, easy-to-use toolbox for the  quality assessment of magnetic resonance imaging data

LAB–QA2GO is a light-weighted virtual machine which provides scripts for fully automated QA analyses of phantom and human datasets. This virtual machine is ready for analysis by starting it the first time. With minimal configuration in the guided web-interface the first analysis can start within 10 minutes, while adapting to local phantoms and needs is easily possible.

# Download
The LAB–QA2GO tool is a virtual machine based on [Virtual Box](https://www.virtualbox.org/ "Official Virtual Box Site"). The image can be downloaded [here](https://osf.io/vdqmp/download "LAB-QA2GO download page on OSF"). After downloading the tool, you have to integrate the virtual machine into your Virtual Box client.

# Quick Installation Guide
## Download
1.	Download LAB-QA2Go
2.	Be sure VirtualBox is installed on your system
3.	Open VirtualBox
4.	Import the LAB-QA2Go tool as a virtual machine
5.	(optional) open the configuration page of the tool and change the network settings if needed
6.	Start the tool
7.	Open the chromium browser of the virtual machine
8.	Visit the _localhost_ page (this is the main page of the tool).
9.	Click on _Configuration -> Network_ to get the IP address. Then you can access the tool of the host PC if the correct network setting of the virtual machine is used.

## Preparation for the analysis (important)
1.	Go the general configuration page _Configuration -> General_
2.	Enable or disable the structural/functional human data analysis
3.	Insert the identifiers in the corresponding fields to select the analysis pipeline. A description of the values is available at the LAB-QA2GO MediaWiki (_LABQA2GO-MediaWiki -> ConfigurationPageDescription_)
4.	After inserting all identifier click on _**Update Configuration**_ to save the changes.

## Starting a measurement (manual approach)
1.	Make the data available for the tool by using a shared folder with the host system, an USB stick or a CD-ROM.
2.	Go to _Start Calculation -> Start manual calculation_ 
3.	If the data is available as DICOM files then the full path to the data has to be inserted into the field for the DICOM analysis. By pressing _**Start DICOM calculation**_ the data of this folder is copied to the virtual machine and then converted into NIfTI format.
4.	If the data is present in NIfTI format the described folder structure has to be regard. Then the full path to the data has to be inserted into the field. . By pressing _**Start NIfTI calculation**_ the data of this folder is copied to the virtual machine.

## Starting a measurement (automated approach)
1.	To use this approach a PACS and the LAB-QA2GO tool has to be available in the same local network.
2.	Maybe a port forwarding has to be added in the configuration of the virtual machine in VirtualBox.
3.	The LAB-QA2GO tool has to be added as DICOM receiver in the PACS.
4.	Then the data can be sent from the PACS to the LAB-QA2GO tool. 
5.	Go to _Start Calculation -> Start automated calculation_ 
6.	By pressing _**Start Automated calculation**_ the received data will be converted from DICOM to NIfTI and the calculation will be started. 

# Sample Data
A set of sample data can be downloaded [here](http://www.online.uni-marburg.de/quamri/labqa2go/LABQA2GO_sample_data.zip "LAB-QA2GO sample data").  

# Versions
A list of all LAB-QA2GO versions is listed [here](https://osf.io/qpn47/files/ "LAB-QA2GO OSF").

## current version
The current version is 0.81.
### updates to version 0.8
- Runtime updates
### updates to version 0.7
- DICOM header comparision with a preuploaded DICOM reference file.
- For the overview graphs we added the option to define the ranges based on the data.

# Feedback
This is the first version of this tool. It is adapted to the data of our MRI lab at the University of Marburg. If you got a problem or questions just contact me, so that we can help you.

## Slack
You can contact us using slack. Our channel is available at https://lab-qa2go.slack.com/. Feel free to contact us to invite you to this channel. You can join the channel [here](https://join.slack.com/t/lab-qa2go/shared_invite/enQtNjUxMTQ4Njg4MTMxLTgyNjViN2MzZWQxYTkyNjlhZWJjOGUxZjI3MTcwMjQwOTllY2RlNjA1MjA5NjBjMzMyZWVkMDY4YTkyMWQ3NGY "LAB-QA2GO slack channel").


# License
LAB-QA2GO is licensed under the BSD license for phantom data analysis.

For human data analysis [FSL](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence "FSL Licence") routines are used in the current version. It is therefore not allowed to use LAB-QA2GO in commercial setup, when you are interested in human data analysis.

Furthermore LAB-QA2GO is not intended as a clinical tool. It does not replace maintenance by a trained / skilled professional.

# Preprint
LAB–QA2GO: A free, easy-to-use toolbox for the quality assessment of magnetic resonance imaging data
Christoph Vogelbacher, Miriam H. A. Bopp, Verena Schuster, Peer Herholz, Jens Sommer, Andreas Jansen
bioRxiv 546564; doi: https://doi.org/10.1101/546564

# Poster
Vogelbacher, Christoph; Bopp, Miriam; Schuster, Verena; Herholz, Peer; Jansen, Andreas; Sommer, Jens (2019): LAB–QA2GO: A free, easy-to-use toolbox for the quality assessment of magnetic resonance imaging data. figshare. Poster on OHBM 2019. https://doi.org/10.6084/m9.figshare.8305964.v2

# Acknowledgement
We would like to thank our collaborators [Bhalerao Gaurav Vivek](https://github.com/gvbhalerao591 "Bhalerao Gaurav Vivek Github page")  and [Pravesh Parekh](https://github.com/parekhpravesh "Pravesh Parekh Github page") from National Institute of Mental Health and Neurosciences (NIMHANS) Bengaluru, India. 

# Support
[Laboratory for Multimodal Neuroimaging | LMN](http://lmn-marburg.de/index.php/de/)

[Philipps-Universität Marburg](https://www.uni-marburg.de/en)

# Copyright
Copyright 2015-2019, Christoph Vogelbacher. Last updated on 2019-05-27.
