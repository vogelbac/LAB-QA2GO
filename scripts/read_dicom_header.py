import pydicom
import os

def test_header(in_file, in_type):

	dicom_file1 = '/home/brain/qa/html/configuration/'+ in_type + '.dcm'
	ds = pydicom.dcmread(dicom_file1)

	dicom_file2 = in_file
	ds2 = pydicom.dcmread(dicom_file2,force=True)

	return_array = []
	
	try:
		if ds.SpecificCharacterSet !=  ds2.SpecificCharacterSet:
			return_array.append(['SpecificCharacterSet',ds.SpecificCharacterSet,ds2.SpecificCharacterSet])	

	except:	
		pass
	try:

		if ds.ImageType !=  ds2.ImageType:
			return_array.append(['ImageType',ds.ImageType,ds2.ImageType])

	except:	
		pass
	try:
		if ds.SOPClassUID !=  ds2.SOPClassUID:
			return_array.append(['SOPClassUID',ds.SOPClassUID,ds2.SOPClassUID])

	except:	
		pass
	try:
		if ds.AccessionNumber !=  ds2.AccessionNumber:
			return_array.append(['AccessionNumber',ds.AccessionNumber,ds2.AccessionNumber])

	except:	
		pass
	try:
		if ds.Modality !=  ds2.Modality:
			return_array.append(['Modality',ds.Modality,ds2.Modality])

	except:	
		pass
	try:
		if ds.Manufacturer !=  ds2.Manufacturer:
			return_array.append(['Manufacturer',ds.Manufacturer,ds2.Manufacturer])

	except:
		pass	
	try:
		if ds.InstitutionName !=  ds2.InstitutionName:
			return_array.append(['InstitutionName',ds.InstitutionName,ds2.InstitutionName])

	except:	
		pass
	try:
		if ds.InstitutionAddress !=  ds2.InstitutionAddress:
			return_array.append(['InstitutionAddress',ds.InstitutionAddress,ds2.InstitutionAddress])

	except:	
		pass
	try:
		if ds.ReferringPhysicianName  !=  ds2.ReferringPhysicianName:
			return_array.append(['ReferringPhysicianName',ds.ReferringPhysicianName,ds2.ReferringPhysicianName])

	except:	
		pass
	try:
		if ds.StationName !=  ds2.StationName:
			return_array.append(['StationName',ds.StationName,ds2.StationName])

	except:	
		pass
	try:
		if ds.StudyDescription !=  ds2.StudyDescription:
			return_array.append(['StudyDescription',ds.StudyDescription,ds2.StudyDescription])

	except:	
		pass
	try:
		if ds.SeriesDescription !=  ds2.SeriesDescription:
			return_array.append(['SeriesDescription',ds.SeriesDescription,ds2.SeriesDescription])

	except:	
		pass
	try:		
		if ds.InstitutionalDepartmentName  !=  ds2.InstitutionalDepartmentName :
			return_array.append(['InstitutionalDepartmentName',ds.InstitutionalDepartmentName,ds2.InstitutionalDepartmentName])

	except:	
		pass
	try:
		if ds.PerformingPhysicianName !=  ds2.PerformingPhysicianName:
			return_array.append(['PerformingPhysicianName',ds.PerformingPhysicianName,ds2.PerformingPhysicianName])

	except:	
		pass
	try:
		if ds.OperatorsName  !=  ds2.OperatorsName:
			return_array.append(['OperatorsName',ds.OperatorsName,ds2.OperatorsName])

	except:	
		pass
	try:
		if ds.ManufacturerModelName !=  ds2.ManufacturerModelName:
			return_array.append(['ManufacturerModelName',ds.ManufacturerModelName,ds2.ManufacturerModelName])

	except:	
		pass
	try:
		if ds.PatientBirthDate !=  ds2.PatientBirthDate:
			return_array.append(['PatientBirthDate',ds.PatientBirthDate,ds2.PatientBirthDate])

	except:	
		pass
	try:
		if ds.PatientSex  !=  ds2.PatientSex:
			return_array.append(['PatientSex',ds.PatientSex,ds2.PatientSex])

	except:	
		pass
	try:
		if ds.PatientAge !=  ds2.PatientAge:
			return_array.append(['PatientAge',ds.PatientAge,ds2.PatientAge])

	except:
		pass	
	try:
		if ds.PatientSize  !=  ds2.PatientSize:
			return_array.append(['PatientSize',ds.PatientSize,ds2.PatientSize])

	except:	
		pass
	try:
		if ds.PatientWeight !=  ds2.PatientWeight:
			return_array.append(['PatientWeight',ds.PatientWeight,ds2.PatientWeight])

	except:	
		pass
	try:
		if ds.BodyPartExamined  !=  ds2.BodyPartExamined :
			return_array.append(['BodyPartExamined',ds.BodyPartExamined,ds2.BodyPartExamined])

	except:	
		pass
	try:
		if ds.ScanningSequence !=  ds2.ScanningSequence:
			return_array.append(['ScanningSequence',ds.ScanningSequence,ds2.ScanningSequence])

	except:	
		pass
	try:
		if ds.SequenceVariant !=  ds2.SequenceVariant:
			return_array.append(['SequenceVariant',ds.SequenceVariant,ds2.SequenceVariant])

	except:	
		pass
	try:	
		if ds.ScanOptions  !=  ds2.ScanOptions :
			return_array.append(['ScanOptions',ds.ScanOptions,ds2.ScanOptions])

	except:	
		pass
	try:
		if ds.MRAcquisitionType  !=  ds2.MRAcquisitionType :
			return_array.append(['MRAcquisitionType',ds.MRAcquisitionType,ds2.MRAcquisitionType])

	except:	
		pass
	try:
		if ds.SequenceName  !=  ds2.SequenceName :
			return_array.append(['SequenceName',ds.SequenceName,ds2.SequenceName])

	except:	
		pass
	try:
		if ds.AngioFlag !=  ds2.AngioFlag:
			return_array.append(['AngioFlag',ds.AngioFlag,ds2.AngioFlag])

	except:	
		pass
	try:
		if ds.SliceThickness !=  ds2.SliceThickness:
			return_array.append(['SliceThickness',ds.SliceThickness,ds2.SliceThickness])

	except:	
		pass
	try:
		if ds.RepetitionTime  !=  ds2.RepetitionTime :
			return_array.append(['RepetitionTime',ds.RepetitionTime,ds2.RepetitionTime])

	except:	
		pass
	try:
		if ds.EchoTime !=  ds2.EchoTime:
			return_array.append(['EchoTime',ds.EchoTime,ds2.EchoTime])

	except:	
		pass
	try:
		if ds.NumberOfAverages !=  ds2.NumberOfAverages:
			return_array.append(['NumberOfAverages',ds.NumberOfAverages,ds2.NumberOfAverages])

	except:	
		pass
	try:
		if ds.ImagingFrequency  !=  ds2.ImagingFrequency :
			return_array.append(['ImagingFrequency',ds.ImagingFrequency,ds2.ImagingFrequency])

	except:	
		pass
	try:
		if ds.ImagedNucleus   !=  ds2.ImagedNucleus  :
			return_array.append(['ImagedNucleus',ds.ImagedNucleus,ds2.ImagedNucleus])

	except:	
		pass
	try:
		if ds.EchoNumbers !=  ds2.EchoNumbers:
			return_array.append(['EchoNumbers',ds.EchoNumbers,ds2.EchoNumbers])

	except:	
		pass
	try:
		if ds.MagneticFieldStrength !=  ds2.MagneticFieldStrength:
			return_array.append(['MagneticFieldStrength',ds.MagneticFieldStrength,ds2.MagneticFieldStrength])

	except:	
		pass
	try:
		if ds.SpacingBetweenSlices !=  ds2.SpacingBetweenSlices:
			return_array.append(['SpacingBetweenSlices',ds.SpacingBetweenSlices,ds2.SpacingBetweenSlices])

	except:	
		pass
	try:
		if ds.NumberOfPhaseEncodingSteps  !=  ds2.NumberOfPhaseEncodingSteps :
			return_array.append(['NumberOfPhaseEncodingSteps',ds.NumberOfPhaseEncodingSteps,ds2.NumberOfPhaseEncodingSteps])

	except:	
		pass
	try:	
		if ds.EchoTrainLength  !=  ds2.EchoTrainLength :
			return_array.append(['EchoTrainLength',ds.EchoTrainLength,ds2.EchoTrainLength])

	except:	
		pass
	try:
		if ds.PercentSampling !=  ds2.PercentSampling:
			return_array.append(['PercentSampling',ds.PercentSampling,ds2.PercentSampling])

	except:	
		pass
	try:
		if ds.PercentPhaseFieldOfView !=  ds2.PercentPhaseFieldOfView:
			return_array.append(['PercentPhaseFieldOfView',ds.PercentPhaseFieldOfView,ds2.PercentPhaseFieldOfView])

	except:	
		pass
	try:
		if ds.PixelBandwidth  !=  ds2.PixelBandwidth :
			return_array.append(['PixelBandwidth',ds.PixelBandwidth,ds2.PixelBandwidth])

	except:	
		pass
	try:
		if ds.DeviceSerialNumber  !=  ds2.DeviceSerialNumber :
			return_array.append(['DeviceSerialNumber',ds.DeviceSerialNumber,ds2.DeviceSerialNumber])

	except:	
		pass
	try:
		if ds.SoftwareVersions !=  ds2.SoftwareVersions:
			return_array.append(['SoftwareVersions',ds.SoftwareVersions,ds2.SoftwareVersions])

	except:	
		pass
	try:
		if ds.ProtocolName  !=  ds2.ProtocolName :
			return_array.append(['ProtocolName',ds.ProtocolName,ds2.ProtocolName])

	except:	
		pass
	try:
		if ds.DateOfLastCalibration !=  ds2.DateOfLastCalibration:
			return_array.append(['DateOfLastCalibration',ds.DateOfLastCalibration,ds2.DateOfLastCalibration])

	except:	
		pass
	try:
		if ds.TimeOfLastCalibration !=  ds2.TimeOfLastCalibration:
			return_array.append(['TimeOfLastCalibration',ds.TimeOfLastCalibration,ds2.TimeOfLastCalibration])

	except:	
		pass
	try:
		if ds.TransmitCoilName !=  ds2.TransmitCoilName:
			return_array.append(['TransmitCoilName',ds.TransmitCoilName,ds2.TransmitCoilName])

	except:	
		pass
	try:
		if ds.AcquisitionMatrix  !=  ds2.AcquisitionMatrix :
			return_array.append(['AcquisitionMatrix',ds.AcquisitionMatrix,ds2.AcquisitionMatrix])

	except:	
		pass
	try:
		if ds.InPlanePhaseEncodingDirection !=  ds2.InPlanePhaseEncodingDirection:
			return_array.append(['InPlanePhaseEncodingDirection',ds.InPlanePhaseEncodingDirection,ds2.InPlanePhaseEncodingDirection])

	except:	
		pass
	try:
		if ds.FlipAngle !=  ds2.FlipAngle:
			return_array.append(['FlipAngle',ds.FlipAngle,ds2.FlipAngle])

	except:	
		pass
	try:
		if ds.VariableFlipAngleFlag !=  ds2.VariableFlipAngleFlag:
			return_array.append(['VariableFlipAngleFlag',ds.VariableFlipAngleFlag,ds2.VariableFlipAngleFlag])

	except:	
		pass
	try:
		if ds.SAR !=  ds2.SAR:
			return_array.append(['SAR',ds.SAR,ds2.SAR])

	except:	
		pass
	try:
		if ds.PatientPosition !=  ds2.PatientPosition:
			return_array.append(['PatientPosition',ds.PatientPosition,ds2.PatientPosition])		

	except:	
		pass
	try:
		if ds.ImagePositionPatient !=  ds2.ImagePositionPatient:
			return_array.append(['ImagePositionPatient',ds.ImagePositionPatient,ds2.ImagePositionPatient])

	except:	
		pass
	try:
		if ds.ImageOrientationPatient  !=  ds2.ImageOrientationPatient:
			return_array.append(['ImageOrientationPatient',ds.ImageOrientationPatient,ds2.ImageOrientationPatient])

	except:	
		pass
	try:
		if ds.Laterality !=  ds2.Laterality:
			return_array.append(['Laterality',ds.Laterality,ds2.Laterality])

	except:	
		pass
	try:
		if ds.PositionReferenceIndicator !=  ds2.PositionReferenceIndicator:
			return_array.append(['PositionReferenceIndicator',ds.PositionReferenceIndicator,ds2.PositionReferenceIndicator])

	except:	
		pass
	try:
		if ds.SliceLocation  !=  ds2.SliceLocation :
			return_array.append(['SliceLocation',ds.SliceLocation,ds2.SliceLocation])

	except:	
		pass
	try:
		if ds.SamplesPerPixel !=  ds2.SamplesPerPixel:
			return_array.append(['SamplesPerPixel',ds.SamplesPerPixel,ds2.SamplesPerPixel])

	except:	
		pass
	try:
		if ds.PhotometricInterpretation !=  ds2.PhotometricInterpretation:
			return_array.append(['PhotometricInterpretation',ds.PhotometricInterpretation,ds2.PhotometricInterpretation])

	except:	
		pass
	try:
		if ds.Rows !=  ds2.Rows:
			return_array.append(['Rows',ds.Rows,ds2.Rows])

	except:	
		pass
	try:
		if ds.Columns !=  ds2.Columns:
			return_array.append(['Columns',ds.Columns,ds2.Columns])		

	except:	
		pass
	try:
		if ds.PixelSpacing  !=  ds2.PixelSpacing :
			return_array.append(['PixelSpacing',ds.PixelSpacing,ds2.PixelSpacing])

	except:	
		pass
	try:
		if ds.BitsAllocated !=  ds2.BitsAllocated:
			return_array.append(['BitsAllocated',ds.BitsAllocated,ds2.BitsAllocated])

	except:	
		pass
	try:
		if ds.BitsStored    !=  ds2.BitsStored   :
			return_array.append(['BitsStored',ds.BitsStored,ds2.BitsStored])

	except:	
		pass
	try:
		if ds.HighBit !=  ds2.HighBit:
			return_array.append(['HighBit',ds.HighBit,ds2.HighBit])

	except:	
		pass
	try:
		if ds.PixelRepresentation !=  ds2.PixelRepresentation:
			return_array.append(['PixelRepresentation',ds.PixelRepresentation,ds2.PixelRepresentation])

	except:	
		pass

	return return_array

def main(in_file, in_type, in_resultpath):
	
	if os.path.exists('/home/brain/qa/html/configuration/'+ in_type + '.dcm'):
		temp_data = test_header(in_file, in_type)

		if in_type == 'GEL' or in_type == 'ACR':
			write_file = open(in_resultpath + 'header.txt','w')
			for i in temp_data:
				temp_line= str(i)
				temp_line=temp_line.replace('], [',';')
				temp_line=temp_line.replace('\', [',';')
				temp_line=temp_line.replace(', u\'',';\'')
				temp_line=temp_line.replace(', \"',';')
				temp_line=temp_line.replace('\'','')
				temp_line=temp_line.replace('\"','')
				temp_line=temp_line.replace('[','')
				temp_line=temp_line.replace(']','')				
				write_file.writelines(temp_line+'\n')
			write_file.close()
		else:
			return temp_data
	else:
		if in_type == 'GEL' or in_type == 'ACR':
			write_file = open(in_resultpath + 'header.txt','w')
			write_file.close()
		else:
			return []

#asd = main('/home/brain/qa/dicom/converted/izie244_MRT_20151215/1.3.12.2.1107.5.2.32.35213.201512151633134265923715.0.0.0/1.3.12.2.1107.5.2.32.35213.2015121516331481312624322.dcm','ACR','')

