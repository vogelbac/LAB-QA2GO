#this function reads the parameters of the movements of a given file and
#creates graphs and histograms for the parametes

import os
import subprocess
import numpy
import matplotlib
import matplotlib.pyplot as plt

def make_graphs(script_path , in_file, name,measurement):
	os.chdir(script_path)

	rfile = open(in_file,'r')


	lines = rfile.readlines()


	rotx = []
	roty = []
	rotz = []
	transx = []
	transy = []
	transz = []

	for i in lines:
		entry = i.split(' ')
		#print (entry)
		rotx.append(float(entry[0].replace(',','.')))
		roty.append(float(entry[2].replace(',','.')))
		rotz.append(float(entry[4].replace(',','.')))
		transx.append(float(entry[6].replace(',','.')))
		transy.append(float(entry[8].replace(',','.')))
		transz.append(float(entry[10].replace(',','.')))
		
	rfile.close()	
	#change to matlab folder
	value_file = open('values.txt','w')
	#mean,min,max of every list
	value_file.write(str(measurement)+'\t')
	value_file.write(str(name)+'\t')
	value_file.write(str(numpy.mean(rotx))+'\t'+str(numpy.min(rotx))+'\t'+str(numpy.max(rotx))+'\t')
	value_file.write(str(numpy.mean(roty))+'\t'+str(numpy.min(roty))+'\t'+str(numpy.max(roty))+'\t')
	value_file.write(str(numpy.mean(rotz))+'\t'+str(numpy.min(rotz))+'\t'+str(numpy.max(rotz))+'\t')
	value_file.write(str(numpy.mean(transx))+'\t'+str(numpy.min(transx))+'\t'+str(numpy.max(transx))+'\t')
	value_file.write(str(numpy.mean(transy))+'\t'+str(numpy.min(transy))+'\t'+str(numpy.max(transy))+'\t')
	value_file.write(str(numpy.mean(transz))+'\t'+str(numpy.min(transz))+'\t'+str(numpy.max(transz))+'\n')
	value_file.close()

	numElements= range(1,len(rotx)+1)

	#Rotation
	plt.figure(figsize=(10,4))
	plt.plot(numElements, rotx, 'b-',label='ptich')
	plt.plot(numElements, roty, 'r-',label='roll')
	plt.plot(numElements, rotz, 'g-',label='yaw')
	plt.title('Rotation')
	plt.legend()
	axes = plt.gca()
	axes.set_xlabel('Volume')
	axes.set_ylabel('Rotation in rads')
	axes.set_xlim([0,len(rotx)])
	axes.set_ylim([min(min(rotx),min(roty),min(rotz))-0.01,max(max(rotx),max(roty),max(rotz))+0.03])
	matplotlib.pyplot.tight_layout()
	plt.savefig('Rotation_'+name)	
	
	#Translation
	plt.figure(figsize=(10,4))
	plt.plot(numElements, transx, 'b-',label='x')
	plt.plot(numElements, transy, 'r-',label='y')
	plt.plot(numElements, transz, 'g-',label='z')
	plt.title('Translation')
	plt.legend()
	axes = plt.gca()
	axes.set_xlabel('Volume')
	axes.set_ylabel('Movement in mm')
	axes.set_xlim([0,len(transx)])
	axes.set_ylim([min(min(transx),min(transy),min(transz))-0.1,max(max(transx),max(transy),max(transz))+0.5])
	matplotlib.pyplot.tight_layout()
	plt.savefig('Translation_'+name)	



	diff_rotx = []
	diff_roty = []
	diff_rotz = []
	diff_transx = []
	diff_transy = []
	diff_transz = []

	for i in range(0,len(rotx)-1):
		diff_rotx.append(abs(float(rotx[i])-float(rotx[i+1])))
		diff_roty.append(abs(float(roty[i])-float(roty[i+1])))
		diff_rotz.append(abs(float(rotz[i])-float(rotz[i+1])))
		diff_transx.append(abs(float(transx[i])-float(transx[i+1])))
		diff_transy.append(abs(float(transy[i])-float(transy[i+1])))
		diff_transz.append(abs(float(transz[i])-float(transz[i+1])))

	#Hist Rotation
	plt.figure(figsize=(10,4))
	plt.hist(diff_rotx, normed=0, facecolor='blue', alpha=0.75)
	plt.title('Pitch')
	axes = plt.gca()
	axes.set_xlabel('Rotation in rads')
	axes.set_ylabel('Frequency')
	axes.set_ylim([0,len(numElements)])
	plt.tight_layout()
	plt.savefig('Histogram_Pitch_'+name)
	
	#Hist Rotation
	plt.figure(figsize=(10,4))
	plt.hist(diff_roty, normed=0, facecolor='blue', alpha=0.75)
	plt.title('Roll')
	axes = plt.gca()
	axes.set_xlabel('Rotation  in rads')
	axes.set_ylabel('Frequency')
	axes.set_ylim([0,len(numElements)])
	plt.tight_layout()
	plt.savefig('Histogram_Roll_'+name)

	#Hist Rotation
	plt.figure(figsize=(10,4))
	plt.hist(diff_rotz, normed=0, facecolor='blue', alpha=0.75)
	plt.title('Yaw')
	axes = plt.gca()
	axes.set_xlabel('Rotation in rads')
	axes.set_ylabel('Frequency')
	axes.set_ylim([0,len(numElements)])
	plt.tight_layout()
	plt.savefig('Histogram_Yaw_'+name)

	#Hist Translation
	plt.figure(figsize=(10,4))
	plt.hist(diff_transx, normed=0, facecolor='blue', alpha=0.75)
	plt.title('Translation X')
	axes = plt.gca()
	axes.set_xlabel('Movement in mm')
	axes.set_ylabel('Frequency')
	axes.set_ylim([0,len(numElements)])
	plt.tight_layout()
	plt.savefig('Histogram_Translation_X_'+name)

	#Hist Translation
	plt.figure(figsize=(10,4))
	plt.hist(diff_transy, normed=0, facecolor='blue', alpha=0.75)
	plt.title('Translation y')
	axes = plt.gca()
	axes.set_xlabel('Movement in mm')
	axes.set_ylabel('Frequency')
	axes.set_ylim([0,len(numElements)])
	plt.tight_layout()
	plt.savefig('Histogram_Translation_Y_'+name)

	#Hist Translation
	plt.figure(figsize=(10,4))
	plt.hist(diff_transz, normed=0, facecolor='blue', alpha=0.75)
	plt.title('Translation z')
	axes = plt.gca()
	axes.set_xlabel('Movement in mm')
	axes.set_ylabel('Frequency')
	axes.set_ylim([0,len(numElements)])
	plt.tight_layout()
	plt.savefig('Histogram_Translation_Z_'+name)
	
	plt.close('all')


