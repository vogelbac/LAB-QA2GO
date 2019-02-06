#!/bin/bash
# JS - 2010-07-10
# update 2010-10-21 - added spectro and some error corrections for recognition of split datasets
# update 2010-12-03 - added links for easy retrival of users datasets
# update 2010-12-13 - check for split datasets (written in two consecutive time-folders, e.g. /2010/12/13/09/xxx/yyy and /2010/12/13/10/xxx/yyy
# update 2010-12-15 - changed the way years, month, days and hours are checked - in this version every month, day and hour is checked (not based on real directory contents)
#                   - added a new commandline parameter for different modes (all - convert all, today - convert today)
# update 2011-12-16 - added dicom tag for phase encoding in logfile
# update 2012-01-16 - added 'what' option 'date' 
# update 2012-04-08 - added additional free diffusion sequence to the diffusion tag
# update 2012-11-27 - added 'acquisition time','serie description' and Siemens Tags in logfiles (Dicom Tags 0008:0032, 0008:103E, 0051:10xx )
# update 2017-01-04 - updated mricron-Version 20161007
# script for automatic conversion from DICOM to Analyze or Nifti-Format
# the input directory structure should be
# yyyy/mm/dd/hh/subject/series/dicomfiles
# with
# yyyy = year of receiving
# mm = month
# dd = day
# hh = hour
# subject = subject number might spread across time (and day?) (does not match the subject name)
# series = series number of measurement (does not match the series number of the mr-system)
# 
# Parameters - the section where they parameters are checked is marked with 'PARAMETERS'
function USAGE()
{
  echo "_______________________________________________________________________________________________________________________"
  echo "USAGE:   $0   idir  odir  logfile  what [yyyy mm dd]"
  echo "         idir - inputdirectory including the path"
  echo "         odir - outputdirectory including the path - an additional directory is required with the name 'odir_realnames'"
  echo "         logfile - the logfile is written to:                 'workingdirectory/logfile'                    log_full"
  echo "                 - additional logfile for split datasets:     'workingdirectory/_log_double.txt'            log_double"
  echo "                 - additional logfile for unknown protocols:  'workingdirectory/_log_unknown_protocol.txt'  log_unknown"
  echo "         what - all / year / month / yesterday / today / date"
  echo "                 - if this parameter is not specified the default value is 'today'"
  echo "                 - in case of 'date' the parameters yyyy mm dd have to be specified" - these parameters are not used with the other 'what' options
  echo "_______________________________________________________________________________________________________________________"
}


# NEUROLOGIE Daten muessen nicht ins NIFTI-Format gewandelt werden ---> ueberspringen, wenn in (0008,1030) etwas aus ${NEURO} steht
AGB=""
NEURO="-e NEUROLOGIE -e AG_MedPhy -e Klinische -e RAD"

# separator in pathnames
sep="/"

#

# define programs to be executed
#program="/usr/local/mricron/current/dcm2nii"
#programnew="/usr/local/mricron/mricron20160527/dcm2nii"
# JS - 20170104
programnew="/usr/bin/dcm2nii"
dicom2="/home/brain/qa/dicom2/dicom2"


# define the comments that shall be included in the protocol file
dicomcomments="-e \(0008,0020\) -e \(0008,0030\) -e \(0008,0023\) -e \(0008,0032\) -e \(0008,0033\) -e \(0008,1030\) -e \(0008,103E\) -e \(0010,0010\) -e \(0010,0020\) -e \(0010,0030\) -e \(0010,0040\) -e \(0010,1010\) -e \(0010,4000\) -e \(0018,0023\) -e \(0018,0024\)  -e \(0018,0050\) -e \(0018,0080\) -e \(0018,0081\) -e \(0018,0082\) -e \(0018,0083\) -e \(0018,0084\) -e \(0018,0088\) -e \(0018,0095\) -e \(0018,1020\) -e \(0018,1030\) -e \(0018,1310\) -e \(0018,1312\) -e \(0018,1314\) -e \(0018,5100\) -e \(0028,0100\) -e \(0028,0101\) -e \(0028,0102\) -e \(0051,100A\) -e \(0051,100B\)  -e \(0051,100C\) -e \(0051,100D\) -e \(0051,100E\) -e \(0051,100F\) -e \(0051,1017\) "

#einbinden des folgenden Ausdruckes in den awk-Aufruf hat nicht funktioniert, daher direkt in den Aufruf eingetragen (s.u. bei protocolname)
#dicomtagProtocolName="\(0018,1030\)"


parameterbasedir="/home/brain/qa/scrips"

# use DOC conversion for the following protocols
dtagdoc=Document
doc=doc
parameterdoc=""

# use default conversion for the following protocols
dtaglocalizer=localizer
dtagaahscout=AAHScout
dtagt2se=t2_se_
dtagt2tse=t2_tse_
dtagt2tirm=t2_tirm_
dtagt2spc=t2_spc_
dtagt2fl2d=t2_fl2d_
dtagt2fl3d=t2_fl3d_
dtagt2haste=t2_haste3d_
dtagt2me2d=t2_me2d_
dtagt2swi3d=t2_swi3d_ #
dtagt2blade=t2_blade_ #
dtagflair=flair_ #
dtagt1se=t1_se_
dtagt1tse=t1_tse_
dtagt1vibe=t1_vibe_
dtagt1fl2d=t1_fl2d_
dtagt1tirm=t1_tirm_
dtagt1tir=t1_tir_
dtagtof2d=TOF_2D_ #
dtagtof3d=TOF_3D_
dtagpc2d=PC_2D_
dtagpdtse=pd_tse_
dtagmprage=t1_mpr_
dtagmprage_2=MPRAGE #
dtagspcir=spc_ir_ #
dtagtsegross=TSE # attention - protocolname is very short -
dtaggrefield=gre_field_mapping
dtagflair=flair_
dtagflair2=FLAIR_
dtagmultiecho=se_mc
dtagspgr=SPGR2_

dtagDEFAULT="-e ${dtaglocalizer} -e ${dtagaahscout} -e ${dtagt2se} -e ${dtagt2tse} -e ${dtagt2tirm} -e ${dtagt2spc} -e ${dtagt2fl2d} -e ${dtagt2fl3d} -e ${dtagt2haste} -e ${dtagt2me2d}"
dtagDEFAULT="${dtagDEFAULT} -e ${dtagt2swi3d} -e ${dtagt2blade} -e ${dtagflair} -e ${dtagflair2} -e ${dtagt1se} -e ${dtagt1tse} -e ${dtagt1vibe} -e ${dtagt1fl2d} -e ${dtagt1tirm} -e ${dtagt1tir}"
dtagDEFAULT="${dtagDEFAULT} -e ${dtagtof2d} -e ${dtagtof3d} -e ${dtagpc2d} -e ${dtagpdtse} -e ${dtagmprage} -e ${dtagmprage_2} -e ${dtagspcir} -e ${dtagtsegross} -e ${dtaggrefield} -e ${dtagmultiecho} -e ${dtagspgr}"
# echo "----------------DTAGDEF=" ${dtagDEFAULT}
DEFAULT=DEFAULT
parameterDEFAULT="-b ${parameterbasedir}${sep}dcm2nii_mprage_20100720.ini"

# spectroscopy
dtagcsise=csi_se_ #
dtagcsi3d=csi3d_se_ #
dtagcsi3d_2=csi3D_se_ #
dtagsvs=svs_se_ #
dtagSPECTRO="-e ${dtagcsise} -e ${dtagcsi3d} -e ${dtagcsi3d_2} -e ${dtagsvs}"
# echo "----------------DTAGSPECTRO=" ${dtagSPECTRO}
SPECTRO=SPECTROSCOPY
parameterSPECTRO=""

# use SPM5 conversion for the following protocols
dtagfmri1=ep2d_bold
dtagfmri2=ep2d_tra
dtagfmri3=ep2d_pace
dtagfmri4=ep2d_fid
dtagfmri5=ep2d_eegtime
dtagFMRI="-e ${dtagfmri1} -e ${dtagfmri2} -e ${dtagfmri3} -e ${dtagfmri4} -e ${dtagfmri5}"
# echo "----------------DTAGFMRI=" ${dtagFMRI}
FMRI=epi_fMRI
parameterFMRI="-b ${parameterbasedir}${sep}dcm2nii_spm5_20100720.ini"

#use DTI conversion for the following protocols
dtagdti1=ep2d_diff_
dtagdti2=_diff_mddw_
dtagdtiMGH=DIFFUSION_MGH
dtagdtiGATED=DTI_gated
dtagdtifree=_diff_free
dtagDTI="-e ${dtagdti1} -e ${dtagdti2} -e ${dtagdtiMGH} -e ${dtagdtiGATED} -e ${dtagdtifree}"
# echo "----------------DTAGDTI=" ${dtagDTI}
DTI=epi_dti
parameterDTI="-b ${parameterbasedir}${sep}dcm2nii_dti_20100825.ini"
odirparm="-o"


# ------------------------------------------------------------------------------------------------------------------------------------
# check PARAMETERS and create LOGFILES
# ------------------------------------------------------------------------------------------------------------------------------------
# set directory-names for input and output
# input directory (where to find the directories with
# dicom images)
idirbase="${1}"

# output directory (where to build the directory structure
# and create the analyze and/or nifti files
odirbase="${2}"
linkdirbase="/home/brain/qa/nifti_realnames/new"

actualpath=`pwd`
cd "${idirbase}"

# directory used to combine data from one measurement that was stored in two consecutive time folders (e.g. at 12 and at 13 o'clock)
linkdir="${actualpath}${sep}convDicom_tempLinks"
if [ -d "${linkdir}" ]
then
	a=1
else
	mkdir "${linkdir}"
fi

# -----------------------------------------------------------------------------------------------------
# write protocol to
log_full="${actualpath}${sep}${3}"
echo "====================================================================================================" >> "${log_full}"
/bin/date >> "${log_full}"

# log_short is the name of the logfile in the output folder. log_s includes the pathname log_s=$path$sep$log_short
log_short="_logfile.txt"
log_s=""

# log_unknown contains a list of unknown protocolnames found while this script run
log_unknown="${actualpath}${sep}_log_unknown_protocol.txt"
echo "====================================================================================================" >> "${log_unknown}"
/bin/date >> "${log_unknown}"
echo "DEFAULT=" ${dtagDEFAULT} >> "${log_unknown}"
echo  >> "${log_unknown}"
echo "FMRI=" ${dtagFMRI}  >> "${log_unknown}"
echo  >> "${log_unknown}"
echo "DTI=" ${dtagDTI}  >> "${log_unknown}"
echo >> "${log_unknown}"


# log_double is a logfile of subject-directories found twice (at different hours)
log_double="${actualpath}${sep}_log_double.txt"
echo "====================================================================================================" >> "${log_double}"
/bin/date >> "${log_double}"




# echo "YEARS: ${startyear} - ${endyear}" 
# echo "MONTH: ${startmonth} - ${endmonth}"
# echo "DAYS:  ${startday}  - ${endday}"
#exit 1


# ------------------------------------------------------------------------------------------------------------------------------------
# END check PARAMETERS and create LOGFILES
# ------------------------------------------------------------------------------------------------------------------------------------




listdir="ls -w1"
sortcommand="sort -n"
#sortcommand="cat" # just repeat, no sort


path=""

# remember values of the last loop
# for the first loop initialize the variables
subjects_old=""
sequences_old=""


subject_old=""
sequence_old=""

# initialize flag for subject and sequence (if a measurement exceeds the hour limit we will find data for this subject in both folders hh and hh+1)
subject_flag=""
sequence_flag=""



idir="${idirbase}${sep}${path}"
subjects=(`${listdir} "${idir}" | ${sortcommand}`)
for subject in ${subjects[@]}
do
	path="${subject}"
	idir="${idirbase}${sep}${path}"
	odir="${odirbase}${sep}${path}"
	cd "${idir}"
#						echo "cd------${idir}"

	if [ -d "${odir}" ]
	then
#							echo "exists_no_change------${odir}"
		a=1
	else
#							echo "mkdir------${odir}"
		mkdir "${odir}"
	fi

	# subject_flag will be empty if the subjectnumber is not part of the subjects of the last hour.
	subject_flag=`echo ${subjects_old[@]} | awk '/'${subject}'/ {print index($0,'${subject}')}' `
	if [ -n "${subject_flag}" ]
	then
		echo "__doppelt________________"${idir} >> "${log_double}"
		echo "__doppelt________________subjectflag="${subject_flag}"--subject="${subject}"==========--subjects_old="${subjects_old[@]} >> "${log_double}"
fi
	sequences=(`${listdir} "${idir}" | ${sortcommand}`)
	for series in ${sequences[@]}
	do
		path="${subject}${sep}${series}"
		idir="${idirbase}${sep}${path}"
		odir="${odirbase}${sep}${path}"

		if [ -d "${odir}" ]
		then
#								echo "__ss__exists_no_change-------${odir}"
			a=1
		else
#							echo "mkdir-------${odir}"
			mkdir "${odir}"
			log_s="${odir}${sep}${log_short}"


			# sequence_flag will be empty if the sequencenumber is not part of the series of the last hour.
			sequence_flag=`echo ${sequences_old[@]} | awk '/'${series}'/ {print $0 "===" '${series}' "===" index($0,'${series}')}' `

#								sequence_flag=`echo ${sequences_old[@]} | awk '/'${series}'/ {print $0 "===" '${series}' "===" index($0,'${series}')} {print $0 "===" '${series}'}' `
			if [ -n "${sequence_flag}" ]
			then
				echo "__doppelt________________subjectflag="${subject_flag}"--subject="${subject}"____sequenceflag="${sequence_flag}"--series="${series} >> "${log_double}"

#---testweise_aktiviert
				echo "Linkdir====>"${linkdir} >> "${log_double}"
#20160830-JS									rm "${linkdir}${sep}*"
#20160830-JS									ln -s "${idir}${sep}" "${linkdir}"
				if [ -n "${subject_old}" ]
				then
#20160830-JS										ln -s "${idirbase}${sep}${yyyy}${sep}${mm}${sep}${dd}${sep}${hour_old}${sep}${subject_old}${sep}${series_old}${sep}*" "${linkdir}"
#---bis_hier_testweise_aktiviert
					#echo "year/month/day/hour/subject/series/=${yyyy} ${sep} ${mm} ${sep} ${dd} ${sep} ${hh} ${sep} ${subject} ${sep} ${series}----------hour_old/subject_old/series_old=${hour_old} ${sep} ${subject_old} ${sep} ${series_old}" >> "${log_double}"
					echo "hallo"
				fi
			else
				echo "_________________________subjectflag="${subject_flag}"--subject="${subject}"____sequenceflag="${sequence_flag}"--series="${series} >> "${log_double}"

			fi

			firstfile=`(ls -St -w1 ${idir} | egrep "*" | sed -n -e '1,1p')`
			echo "File to determine protocol: ${idir}${sep}${firstfile}" > "${log_s}"
			if [ -f "${idir}${sep}${firstfile}" ]
			then
				AGB=`${dicom2} -t1  ${idir}${sep}${firstfile} 2>&1 | awk '/(\(0008,1030\))/ {res=gsub(/[\[\]]/,"",$NF); print $NF}' | grep ${NEURO}`
				if [ -z ${AGB}"" ]
				then
#=============================================================================== NEUROLOGIE-Daten nicht ins NIFTI-Format umwandeln

	                 	protocolname=`${dicom2} -t1 ${idir}${sep}${firstfile} 2>&1 | awk '/(\(0018,1030\))/ {res=gsub(/[\[\]]/,"",$NF); print $NF}'`

				if [ -z ${protocolname}"" ]
				then
					echo "ERROR: Protocol Name Tag (0018,1030) not found --> NO_DICOM_FILE" >> "${log_s}"
				else
					${dicom2} -t1 ${idir}${sep}${firstfile} | grep ${dicomcomments} > "${log_s}"
			        	result=unknown
					res=`echo "${protocolname}" | grep ${dtagDTI}`
					if [ -n ${res}"" ]
					then
						result="${DTI}"
						parameter="${parameterDTI}"
					fi

        	                        res=`echo "${protocolname}" | grep ${dtagSPECTRO}`
					if [ -n ${res}"" ]
					then
						result="${SPECTRO}"
						parameter="${parameterSPECTRO}"
					fi

                                        res=`echo "${protocolname}" | grep ${dtagFMRI}`
					if [ -n ${res}"" ]
					then
						result="${FMRI}"
						parameter="${parameterFMRI}"
					fi

                                        res=`echo "${protocolname}" | grep ${dtagDEFAULT}`
					if [ -n ${res}"" ]
					then
						result="${DEFAULT}"
						parameter="${parameterDEFAULT}"
					fi

                                        res=`echo "${protocolname}" | grep -e ${dtagdoc}`
					if [ -n ${res}"" ]
					then
						result="${doc}"
						parameter=""
					fi
#										echo "Result="${result}"  res="${res}"  ProtocolName="${protocolname}

					case ${result} in
						${DTI} )
							echo "${programnew} ${parameter} ${odirparm} ${odir} ${idir}" >> "${log_s}"
							${programnew} ${parameter} ${odirparm} ${odir} ${idir} >> "${log_s}"
							;;										
						${FMRI} | ${DEFAULT} )
#20170104												echo "${program} ${parameter} ${odirparm} ${odir} ${idir}" >> "${log_s}"
#												${program} ${parameter} ${odirparm} ${odir} ${idir} >> "${log_s}"
                                                        echo "${programnew} ${parameter} ${odirparm} ${odir} ${idir}" >> "${log_s}"
                                                        ${programnew} ${parameter} ${odirparm} ${odir} ${idir} >> "${log_s}"

							;;
						${SPECTRO} )
						        echo "Convert spectroscopy to ..." >> "${log_s}"
						        # here we need the relevant routine ;)
						        ;;
						${doc} )
							echo "Convert Dicom-Documents to PDF" >> "${log_s}"
							# here we need the relevant routine ;)
							;;
						* )
							echo "ERROR: unknown protocol" >> "${log_s}"
                                                        echo "${idir}${sep}${firstfile}" >> "${log_s}"
                                                        echo "RESULT= ${result}" >> "${log_s}"
							echo "${protocolname} --- ${idir} -- ${firstfile} --- " >> "${log_unknown}"
					esac
		                        # -----------------------------
                			# create link to this directory
                                        studydescription=`${dicom2} -t1 ${idir}${sep}${firstfile} 2>&1 | awk '/(\(0008,1030\))/ {res=gsub(/[\[\]]/,"",$NF); print $NF}'`
                                        patientname=`${dicom2} -t1 ${idir}${sep}${firstfile} 2>&1 | awk '/(\(0010,0010\))/ {res=gsub(/[\[\]]/,"",$NF); print $NF}'`
					# reformat number from series to 3 digits with leading 0	
	                                dummynumber=`${dicom2} -t1 ${idir}${sep}${firstfile} 2>&1 | awk '/(\(0020,0011\))/ {res=gsub(/[\[\]]/,"",$NF); print $NF}'`
					seriesnumber=`printf "%03d\n" ${dummynumber}`
                	                if [ ! -d "${linkdirbase}${sep}${studydescription}" ]
					then
                                		mkdir "${linkdirbase}${sep}${studydescription}"
                                	fi
                                	if [ ! -d "${linkdirbase}${sep}${studydescription}${sep}${patientname}" ]
					then
                                   		mkdir "${linkdirbase}${sep}${studydescription}${sep}${patientname}"
                                	fi
					# if linkname already exists add an underscore at the front
					while [ -e "${linkdirbase}${sep}${studydescription}${sep}${patientname}${sep}${seriesnumber}__${protocolname}" ]
					do
						seriesnumber="_${seriesnumber}"
					done
                			ln -s ${odir} "${linkdirbase}${sep}${studydescription}${sep}${patientname}${sep}${seriesnumber}__${protocolname}"

                                	# ----------------------------- end create link
					cat "${log_s}" >> "${log_full}"
				fi
#=========================================================================================
				fi # Neurologie-Daten nicht nach NIFTI wandeln
			fi
		fi
		series_old="${series}" # remember sequence for next turn
	done #series
	sequences_old="${sequences[@]}"
	subject_old=${subject} # remember subject for next turn
done #subject
subjects_old="${subjects[@]}"
				
					

/bin/date >> "${log_full}"
cd "${actualpath}"
