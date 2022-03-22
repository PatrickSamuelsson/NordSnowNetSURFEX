#!/usr/bin/python
# vim : set fileencoding=utf-8 :

#import all the librairies
from __future__ import division
from pylab import *
import scipy
from scipy import io
from scipy.io import *
import matplotlib.pyplot as plt
import datetime

#########################################################
#plot average soil&snow profile temperature, for january#
#########################################################
#open the source file
source = open("../Evaluation_data/SOIL_SNOW_DATA/MET0002/TS_SMP_MET0002_2008_2010.txt", "r")
source_2 = open("../Evaluation_data/SOIL_SNOW_DATA/MET0002/TSNOW_MET0002_2008_2010.txt", "r")

#read the first line and find the place of "DATE TIME", "TS-5","TSNOW+10"...
entete = source.readline().rstrip('\n\r').split(",")
date_and_time = entete.index("DATE TIME")
ts_5 = entete.index("TS-5")
ts_10 = entete.index("TS-10")
ts_20 = entete.index("TS-20")
ts_30 = entete.index("TS-30")
ts_50 = entete.index("TS-50")

entete_2 = source_2.readline().rstrip('\n\r').split(",")
date_and_time_2 = entete_2.index("DATE TIME")
ts_snow_10 = entete_2.index("TSNOW+10")
ts_snow_20 = entete_2.index("TSNOW+20")
ts_snow_30 = entete_2.index("TSNOW+30")
ts_snow_40 = entete_2.index("TSNOW+40")
ts_snow_50 = entete_2.index("TSNOW+50")
ts_snow_60 = entete_2.index("TSNOW+60")
ts_snow_70 = entete_2.index("TSNOW+70")
ts_snow_80 = entete_2.index("TSNOW+80")
ts_snow_90 = entete_2.index("TSNOW+90")
ts_snow_100 = entete_2.index("TSNOW+100")
ts_snow_110 = entete_2.index("TSNOW+110")
donnees_2 = source_2.readline().rstrip('\n\r').split(",")

#read the unit line
unit_line = source.readline().rstrip('\n\r').split(",")
unit_time = unit_line.index("YYYY-MM-DD hh:mm:ss")
unit_ts = unit_line.index("C")

#useful variables
T_profile=[]
depth = [110,100,90,80,70,60,50,40,30,20,10,-5,-10,-20,-30,-50]
date='2008'
month='01'
month_2='01'
temp = [[] for i in range (16)] #five lists corresponding to the 11 layers of snow and the 5 layers of soil
#read every lines and collect the data for january
while int(month_2) == 01:
  donnees_2 = source_2.readline().rstrip('\n\r').split(",")
  date_2 = donnees_2[date_and_time_2]
  month_2 = date_2[5:7]
  temp[0].append(float(donnees_2[ts_snow_110]))
  temp[1].append(float(donnees_2[ts_snow_100]))
  temp[2].append(float(donnees_2[ts_snow_90]))
  temp[3].append(float(donnees_2[ts_snow_80]))
  temp[4].append(float(donnees_2[ts_snow_70]))
  temp[5].append(float(donnees_2[ts_snow_60]))
  temp[6].append(float(donnees_2[ts_snow_50]))
  temp[7].append(float(donnees_2[ts_snow_40]))
  temp[8].append(float(donnees_2[ts_snow_30]))
  temp[9].append(float(donnees_2[ts_snow_20]))
  temp[10].append(float(donnees_2[ts_snow_10]))
while int(month) == 01:
  donnees = source.readline().rstrip('\n\r').split(",")
  date = donnees[date_and_time]
  month = date[5:7]
  temp[11].append(float(donnees[ts_5]))
  temp[12].append(float(donnees[ts_10]))
  temp[13].append(float(donnees[ts_20]))
  temp[14].append(float(donnees[ts_30]))
  temp[15].append(float(donnees[ts_50]))
#for each layer, calculate the average soil temperature
for i in range (len(temp)):
  temp[i].pop()
  monthly_sum = sum(temp[i])
  mean =  monthly_sum/len(temp[i])
  T_profile.append(mean)

#close the file
source.close()
source_2.close()

#########################################################################################
ldepth=[-0.5,-3,-10,-25,-55,-105,-175,-265] #depth of the 8 top soil layers

datadir ='../'
ncfile=array([ 'ISBA_PROGNOSTIC.OUT.nc','ISBA_DIAGNOSTICS.OUT.nc'])

sourcefile = datadir + '/' + ncfile[0]
data=netcdf_file(sourcefile)
variable=data.variables
varname_1=variable['TG1P1']
varname_2=variable['TG2P1']
varname_3=variable['TG3P1']
varname_4=variable['TG4P1']
varname_5=variable['TG5P1']
varname_6=variable['TG6P1']
varname_7=variable['TG7P1']
varname_8=variable['TG8P1']
clf()
temp_1=[[] for i in range (8)]
t_pro=[]
months = [0,31,29,31,30,31,30,31,31,30,31,30,31]
hours_in_january = [months[0]*24,months[1]*24]
#collect the data and calculate the average temperature of the month for each layer
for hours in range (hours_in_january[0],hours_in_january[1]):
 temp_1[0].append(varname_1.data[hours,0,0]-(273.15))
 temp_1[1].append(varname_2.data[hours,0,0]-(273.15))
 temp_1[2].append(varname_3.data[hours,0,0]-(273.15))
 temp_1[3].append(varname_4.data[hours,0,0]-(273.15))
 temp_1[4].append(varname_5.data[hours,0,0]-(273.15))
 temp_1[5].append(varname_6.data[hours,0,0]-(273.15))
 temp_1[6].append(varname_7.data[hours,0,0]-(273.15))
 temp_1[7].append(varname_8.data[hours,0,0]-(273.15))
for i in range (len(temp_1)):
  m_sum = sum(temp_1[i])
  mean =  m_sum/len(temp_1[i])
  t_pro.append(mean)
#do the same for the 12 layers of snow
sourcefile_2 = datadir + '/' + ncfile[0]
data=netcdf_file(sourcefile_2)
variable_2=data.variables
varname_2_1=variable_2['SNOWDZP1']
varname_2_2=variable_2['SNOWTEMPP1']
thickness =[[] for i in range (12)]
snow_temp_all=[[] for i in range (12)]
#collect temperature and thickness data of the 12 layers
for hours in range (hours_in_january[0],hours_in_january[1]):
 for i in range (12):
   thickness[i].append(varname_2_1.data[hours,i,0])
   snow_temp_all[i].append(varname_2_2.data[hours,i,0]-(273.15))
previous_thickness=0
snow_depth =[]
#calculate the average thickness of each layer (for the willing period)
for i in reversed(range (len(thickness))):
  st_sum = sum(thickness[i])
  mean =  st_sum/len(thickness[i])
  thick = mean+previous_thickness
  snow_depth.append(thick*100)
  previous_thickness= thick
snow_temps_mean =[]
#calculate the average temperture of each layer (for the willing period)
for i in reversed(range (len(snow_temp_all))):
  snowT_sum = sum(snow_temp_all[i])
  mean =  snowT_sum/len(snow_temp_all[i])
  snow_temps_mean.append(mean)
#put the temperature and the depth in the right order
snow_depth.reverse()
snow_temps_mean.reverse()
depth_profile = snow_depth + ldepth
snow_t_profile = snow_temps_mean + t_pro

#########################################################################################
#ldepth=[-0.5,-3,-10,-25,-55,-105,-175,-265] #depth of the 8 top soil layers
#
#datadir_2 ='../no_explicit'
#sourcefile = datadir_2 + '/' + ncfile[0]
#data=netcdf_file(sourcefile)
#variable=data.variables
#varname_1=variable['TG1P1']
#varname_2=variable['TG2P1']
#varname_3=variable['TG3P1']
#varname_4=variable['TG4P1']
#varname_5=variable['TG5P1']
#varname_6=variable['TG6P1']
#varname_7=variable['TG7P1']
#varname_8=variable['TG8P1']
#clf()
#temp_1=[[] for i in range (8)]
#t_pro=[]
#months = [0,31,29,31,30,31,30,31,31,30,31,30,31]
#hours_in_january = [months[0]*24,months[1]*24]
##collect the data and calculate the average temperature of the month for each layer
#for hours in range (hours_in_january[0],hours_in_january[1]):
# temp_1[0].append(varname_1.data[hours,0,0]-(273.15))
# temp_1[1].append(varname_2.data[hours,0,0]-(273.15))
# temp_1[2].append(varname_3.data[hours,0,0]-(273.15))
# temp_1[3].append(varname_4.data[hours,0,0]-(273.15))
# temp_1[4].append(varname_5.data[hours,0,0]-(273.15))
# temp_1[5].append(varname_6.data[hours,0,0]-(273.15))
# temp_1[6].append(varname_7.data[hours,0,0]-(273.15))
# temp_1[7].append(varname_8.data[hours,0,0]-(273.15))
#for i in range (len(temp_1)):
#  m_sum = sum(temp_1[i])
#  mean =  m_sum/len(temp_1[i])
#  t_pro.append(mean)
##do the same for the 12 layers of snow
#sourcefile_2 = datadir + '/' + ncfile[1]
#data=netcdf_file(sourcefile_2)
#variable_2=data.variables
#varname_2_1=variable_2['SNOWDZP2']
#varname_2_2=variable_2['SNOWTEMPP2']
#thickness =[[] for i in range (12)]
#snow_temp_all=[[] for i in range (12)]
##collect temperature and thickness data of the 12 layers
#for hours in range (hours_in_january[0],hours_in_january[1]):
# for i in range (12):
#   thickness[i].append(varname_2_1.data[hours,i,0])
#   snow_temp_all[i].append(varname_2_2.data[hours,i,0]-(273.15))
#previous_thickness=0
#snow_depth =[]
##calculate the average thickness of each layer (for the willing period)
#for i in range (len(thickness)):
#  st_sum = sum(thickness[i])
#  mean =  st_sum/len(thickness[i])
#  thick = mean+previous_thickness
#  snow_depth.append(thick*100)
#  previous_thickness= thick
#snow_temps_mean =[]
##calculate the average temperture of each layer (for the willing period)
#for i in range (len(snow_temp_all)):
#  snowT_sum = sum(snow_temp_all[i])
#  mean =  snowT_sum/len(snow_temp_all[i])
#  snow_temps_mean.append(mean)
##put the temperature and the depth in the right order
#snow_depth.reverse()
##snow_temps_mean.reverse()
#depth_profile_no = snow_depth + ldepth
#snow_t_profile_no = snow_temps_mean + t_pro

#########################################################################################


X= array([-12])
Y= array([-110])
Y2 = array([140])

plt.ion()
plt.bar(X,Y,facecolor='saddlebrown',label='soil')
plt.bar(X,Y2,facecolor='lightgrey',label='snow')
plt.plot(snow_t_profile,depth_profile,label="explicit_canopy",marker="*")
plt.plot(snow_t_profile_no,depth_profile_no,label="no_explicit_canopy",marker="*")
plt.plot(T_profile,depth,label="observations",marker="*")
plt.legend()
#plt.xticks(rotation=50)
plt.xlabel('Temperature - C')
plt.ylabel('Depth - cm')
plt.suptitle('Station MET0002')
plt.title("Temperature Profile Jan. 2008")
plt.grid(True)
plt.show()
raw_input()
#plt.savefig('Temperature_Profile_01_2008')
