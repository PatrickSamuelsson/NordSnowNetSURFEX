#!/bin/bash

#set -xv

#####################################
# Which OPTIONS file to use:

# No use of ECOCLIMAP parameters, all values needed specified in the namelist:
# This is an open land case
cp OPTIONS.nam.no_ECOCLIMAP_OpenLand OPTIONS.nam

# No use of ECOCLIMAP parameters, all values needed specified in the namelist:
# This is a forest setup without MEB
#cp OPTIONS.nam.no_ECOCLIMAP_forest_noMEB OPTIONS.nam

# Use of ECOCLIMAP parameter file, but some values specified in the namelist:
# Please note that this option requires links to physiography below.
#cp OPTIONS.nam.ECOCLIMAP OPTIONS.nam
#####################################

#####################################
# Paths on your file system to be specified:

# Location of binaries, i.e. PGD, PREP, OFFLINE
binpath="/home/a000793/NordSnowNet/SURFEX_V9_DEV/src/dir_obj-LXgfortran-SFX-V8-1-1-NOMPI-OMP-O2-X0/MASTER"

# Location of physiography *.hdr and *.dir files.
# Please download needed files from http://www.umr-cnrm.fr/surfex/spip.php?rubrique14
#physiography_path="/nobackup/smhid13/sm_uandr/HARMONIE/data/climate/PGD"
#####################################

curdir=$PWD

export OMP_NUM_THREADS=1

#############
# Link to ECOCLIMAP parameter files and physiography data
if [ ! -s $curdir/ecoclimapI_covers_param.bin ]; then
  ln -sf /home/a000793/NordSnowNet/SURFEX_V9_DEV/MY_RUN/ECOCLIMAP/*.bin .

# Link to soil carbon files soc_sub.dir, soc_sub.hdr, soc_top.dir, soc_top.hdr
#  ln -sf $physiography_path/soc_* .
fi
#############


#############
# PGD physiography step
if [ ! -s "PGD.txt" ]; then
  $binpath/PGD
fi
#############

#############
# PREP initial condition step
if [ ! -s "PREP.txt" ]; then
  $binpath/PREP
fi
#############

#############
# OFFLINE running the physical time step model
#if [ ! -s "PREP.txt" ]; then
  $binpath/OFFLINE
#fi
#############




