#!/usr/bin/python
# vim : set fileencoding=utf-8 :

#import all the librairies
from pylab import *
import scipy
from scipy import io
from scipy.io import *
import matplotlib.pyplot as plt
import datetime

###############################
#plot snow depth, for one year#
###############################
#open the source file
source = open("../Evaluation_data/SOIL_SNOW_DATA/MET0002/SD_MET0002_2008_2010.txt", "r")

#read the first line and find the place of "DATE TIME", "SD"
entete = source.readline().rstrip('\n\r').split(",")
station = entete.index("STATION")
date_and_time = entete.index("DATE TIME")
sd = entete.index("SD")

#read the unit line
unit_line = source.readline().rstrip('\n\r').split(",")
unit_time = unit_line.index("YYYY-MM-DD hh:mm:ss")
unit_sd = unit_line.index("cm")
 
#useful variables
time=[]
snow_depth=[]
date='2008'
#read every lines and collect the data for one year
while int(date[0:4]) == 2008:
  donnees = source.readline().rstrip('\n\r').split(",")
  snow_depth.append(float(donnees[sd]))
  date = donnees[date_and_time]
  time.append(datetime.datetime(int(date[0:4]),int(date[5:7]),int(date[8:10]),int(date[11:13]),int(date[14:16])))#pick the date which correspond to the data

snow_depth.pop()
time.pop()

#close the file
source.close()

###############################
#do the same for the 3 differents setups

datadir ='../'
ncfile=array([ 'ISBA_PROGNOSTIC.OUT.nc'])

#364*24 hours list
ldate=[]
for i in range(8741):
#for i in range(17543):
   ldate.append(datetime.datetime(2008,1,1,0)+i*datetime.timedelta(hours=1))

sourcefile = datadir + '/' + ncfile[0]
data=netcdf_file(sourcefile)
variables=data.variables
varname=variables['DSN_T_ISBA']
variable='DSN_T_ISBA'
clf()

###############################
#
#datadir2 ='../xx'
#ncfile2=array([ 'ISBA_PROGNOSTIC.OUT.nc'])
#
#sourcefile2 = datadir2 + '/' + ncfile2[0]
#data2=netcdf_file(sourcefile2)
#variables2=data2.variables
#varname2=variables2['DSN_T_ISBA']
#variable2='DSN_T_ISBA'
#clf()
#
#######################################
#
#datadir3 ='../xx'
#ncfile3=array([ 'ISBA_PROGNOSTIC.OUT.nc'])
#
#sourcefile3 = datadir3 + '/' + ncfile3[0]
#data3=netcdf_file(sourcefile3)
#variables3=data3.variables
#varname3=variables3['DSN_T_ISBA']
#variable3='DSN_T_ISBA'
#clf()
#
#######################################

plt.ion()
plt.plot(ldate,varname.data[:,0,0]*100,label="explicit_canopy")
#plt.plot(ldate,varname2.data[:,0,0]*100,label="no_explicit_canopy")
#plt.plot(ldate,varname3.data[:,0,0]*100,label="force_restore")
plt.plot(time,snow_depth,label="observations")
plt.legend()
plt.xticks(rotation=50)
plt.ylabel('snow depth (cm)')
plt.suptitle('STATION MET0002')
plt.title("Snow depth - 2008")
plt.show()
raw_input()
#plt.savefig('snow_depth')

