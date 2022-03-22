#!/usr/bin/python
# vim : set fileencoding=utf-8 :

#import all the librairies
from pylab import *
import scipy
from scipy import io
from scipy.io import *
import matplotlib.pyplot as plt
import datetime

#######################
#plot soil temperature#
#############################################################
#choose the start and end date with this format : yyyymmddhh
start_date = '2008010100'
end_date = '2008123000'
#############################################################
#list every hours between start_date and end_date
ldate=[]
datetime_start_date = datetime.datetime(int(start_date[0:4]),int(start_date[4:6]),int(start_date[6:8]),int(start_date[8:10]))
datetime_end_date = datetime.datetime(int(end_date[0:4]),int(end_date[4:6]),int(end_date[6:8]),int(end_date[8:10]))
ldate.append(datetime_start_date)
while ldate[len(ldate)-1] != datetime_end_date :
   ldate.append(ldate[len(ldate)-1]+1*datetime.timedelta(hours=1))

#list of dates before start_date --> allow the convert start_date in hours
l_before = []
l_before.append(datetime.datetime(int(start_date[0:4]),1,1,0))
while l_before[len(l_before)-1] != ldate[0] :
   l_before.append(l_before[len(l_before)-1]+1*datetime.timedelta(hours=1))
start_hour = len(l_before)
end_hour = start_hour + len(ldate)

#######################
#open the source file
source = open("../Evaluation_data/SOIL_SNOW_DATA/MET0002/TS_SMP_MET0002_2008_2010.txt", "r")

#read the first line and find the place of "DATE TIME", "TS-5"
entete = source.readline().rstrip('\n\r').split(",")
date_and_time = entete.index("DATE TIME")
ts = entete.index("TS-5")

#read the unit line
unit_line = source.readline().rstrip('\n\r').split(",")
unit_time = unit_line.index("YYYY-MM-DD hh:mm:ss")
unit_ts = unit_line.index("C")
 
#useful variables
time=[]
soil_temp=[]
date = start_date[0:4]
#read every lines and collect the data for the willing period
while date[0:4] == start_date [0:4] or date[0:4] == end_date [0:4]:
  donnees = source.readline().rstrip('\n\r').split(",")
  date = donnees[date_and_time]
  datetime_date = datetime.datetime(int(date[0:4]),int(date[5:7]),int(date[8:10]),int(date[11:13]),int(date[14:16]))
  if datetime_start_date <= datetime_date and datetime_date <= datetime_end_date :
    soil_temp.append(float(donnees[ts]))
    time.append(datetime_date)#pick the time which correspond to the data

#close the file
source.close()

#######################
#do the same for the 2 differents setups

datadir ='../'
ncfile=array([ 'ISBA_PROGNOSTIC.OUT.nc'])

sourcefile = datadir + '/' + ncfile[0]
data=netcdf_file(sourcefile)
variables=data.variables
varname=variables['TG2P1']
varnamebis=variables['TG3P1']
clf()
#useful variables
TG2 = []
TG3 = []
TG_5cm = []
#collect the data for each hour of each day
for hours in range (start_hour,end_hour):
 TG2.append(varname.data[hours,0,0]-(273.15))
 TG3.append(varnamebis.data[hours,0,0]-(273.15))
#calculate the 5cm depth = average temperature of layer 2 and 3
for i  in range (len(TG2)):
  TG_5cm.append((TG2[i]+TG3[i])/2)

#######################

#datadir2 ='../no_explicit_canopy'
#ncfile2=array([ 'ISBA_PROGNOSTIC.OUT.nc'])
#
#sourcefile2 = datadir2 + '/' + ncfile2[0]
#data2=netcdf_file(sourcefile2)
#variables2=data2.variables
#varname2=variables2['TG2P2']
#varname2bis=variables['TG3P2']
#clf()
##useful variables
#TG2_no = []
#TG3_no = []
#TG_5cm_no = []
##collect the data for each hour of each day
#for hours in range (start_hour,end_hour):
# TG2_no.append(varname2.data[hours,0,0]-(273.15))
# TG3_no.append(varname2bis.data[hours,0,0]-(273.15))
##calculate the 5cm depth = average temperature of layer 2 and 3
#for i  in range (len(TG2)):
#  TG_5cm_no.append((TG2_no[i]+TG3_no[i])/2)

#######################

plt.ion()
plt.plot(ldate,TG_5cm,label="explicit_canopy")
#plt.plot(ldate,TG_5cm_no,label="no_explicit_canopy")
plt.plot(time,soil_temp,label="observations")
plt.legend()
plt.xticks(rotation=50)
plt.ylabel('temperature C')
plt.suptitle('STATION MET0002')
plt.title("TG 5cm depth - 2008")
plt.show()
raw_input()
#plt.savefig('TG5cm_depth_2008')
