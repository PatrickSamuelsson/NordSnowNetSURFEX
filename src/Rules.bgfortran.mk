###
#  arch file for DragonFly BSD with gfortran5(gcc5) openmpi 3.1.3 & openmp
###
##########################################################
#                                                        #
# Compiler Options                                       #
#                                                        #
##########################################################
#
#RJ: few extra features
#DO_ASM = YES
DO_ASM = NO
USE_SPLR = YES
#USE_SPLR = NO
#USE_SPLR_WRAP = YES
USE_SPLR_WRAP = NO
#AVOID_CPP = NO
AVOID_CPP = YES
#
#OBJDIR_PATH=/home/escj/azertyuiopqsdfghjklm/wxcvbn/azertyuiopqsdfghjklmwxcvbn
#
##OPT_BASE  = -fdefault-real-8 -fdefault-double-8 -g -fno-second-underscore -fpic -fbacktrace -fconvert=swap -Wimplicit-interface -Wimplicit-procedure -Wall -Wextra -Waliasing -Wampersand -Warray-temporaries -Wcharacter-truncation -Wconversion-extra -Wsurprising -Wunderflow -Wno-compare-reals
#OPT_BASE  = -fdefault-real-8 -fdefault-double-8 -g -fno-second-underscore -fpic -fbacktrace -fconvert=swap -Wimplicit-interface -Wimplicit-procedure -Wall -Wextra -Waliasing -Wampersand -Wcharacter-truncation -Wconversion-extra -Wsurprising -Wunderflow -Wno-compare-reals
#OPT_BASE  = -fdefault-real-8 -fdefault-double-8 -g -fno-second-underscore -fpic -fbacktrace -fconvert=swap
OPT_BASE  = -fdefault-real-8 -fdefault-double-8 -g -fno-second-underscore -fpic -fbacktrace -fconvert=swap 
OPT_BASE += -ffpe-trap=overflow,zero,invalid
OPT_BASE += -Wimplicit-interface -Wimplicit-procedure -Waliasing -Wampersand -Wsurprising
#
OPT_PERF0 = -O0
OPT_PERF2 = -O2
OPT_CHECK = -fcheck=bounds,do,mem,pointer,recursion -finit-real=nan -ffpe-trap=overflow,zero,invalid
OPT_I8    = -fdefault-integer-8
#
#
# Integer 4/8 option
#
#MNH_INT   ?=I4
#RJ LFI_RECL  ?=512
#
ifeq "$(MNH_INT)" "I8"
OPT_BASE         += $(OPT_I8)
#RJ LFI_INT           ?=8
MNH_MPI_RANK_KIND ?=8
else
MNH_MPI_RANK_KIND ?=4
#RJ LFI_INT           ?=4
endif
#
#
OPT       = $(OPT_BASE) $(OPT_PERF2)
OPT0      = $(OPT_BASE) $(OPT_PERF0)
OPT_NOCB  = $(OPT_BASE) $(OPT_PERF2)
#
ifeq "$(OPTLEVEL)" "DEBUG"
OPT       = $(OPT_BASE) $(OPT_PERF0) $(OPT_CHECK)
OPT0      = $(OPT_BASE) $(OPT_PERF0) $(OPT_CHECK)
OPT_NOCB  = $(OPT_BASE) $(OPT_PERF0)
endif
#
ifneq "$(OPTLEVEL)" "DEBUG"
OBJSD += spll_teb_garden.o
$(OBJSD) : OPT = $(OPT_BASE) $(OPT_PERF0)
endif
#
ifeq "$(VER_MPI)" "NOMPI"
F90= gfortran5r
F77= gfortran5r
else
F90= mpifort
F77= mpifort
endif
#
REALFC=gfortran5r
#
FCFLAGS_OMP= -fopenmp
CFLAGS_OMP= -fopenmp
ifeq "$(VER_OMP)" "NOOMP"
FCFLAGS_OMP=
CFLAGS_OMP=
endif
#
F90FLAGS      = $(OPT) $(FCFLAGS_OMP) -ffree-form -ffree-line-length-none -fimplicit-none
F77FLAGS      = $(OPT) $(FCFLAGS_OMP) -ffixed-form
FX90          = $(F77)
FX90FLAGS     = $(OPT) $(FCFLAGS_OMP) -ffixed-form
#
CC            = gcc5r
CFLAGS        = $(CFLAGS_OMP)
#
#LDFLAGS   = -fbacktrace -fuse-ld=bfd -Wl,-warn-once
#zRJ: on DragonFly BSD libc doesn't have bactrace_symbols_fd(), unlike g(arbage)libc
#zRJ: bactrace functions can be used from devel/libexecinfo port library libexecinfo.so
LDFLAGS   =  $(FCFLAGS_OMP) -Wl,-warn-once -fbacktrace -L/usr/local/lib -lexecinfo
#
# NetCDF external
#
ifeq "$(VER_CDF)" "CDFEXT"
NETCDF = /opt/gcc5/netcdf_413
NETCDF_INC = $(NETCDF)/include
NETCDF_LIB = $(NETCDF)/lib
INC_NETCDF = -I$(NETCDF_INC)
LIB_NETCDF = -L$(NETCDF_LIB) -lnetcdff -lnetcdf
endif
#
# GRIBAPI external
#
ifeq "$(VER_GRIBAPI)" "GRIBAPI_EXT"
GRIB_API = /opt/gcc5/grib_api_113
GRIB_API_INC = $(GRIB_API)/include
GRIB_API_LIB = $(GRIB_API)/lib
INC_GRIBAPI = -I$(GRIB_API_INC)
LIB_GRIBAPI = -L$(GRIB_API_LIB) -lgrib_api_f90 -lgrib_api -lopenjpeg
endif
#
# preprocessing flags
#
CPP = cpp -P -traditional -Wcomment
#
VER_XRD=XRD40
##VER_XRD=NONE
#
FPPFLAGS_SURFEX    =
#RJ FPPFLAGS_SURCOUCHE = -DMNH_MPI_DOUBLE_PRECISION -DMNH_LINUX -DMNH_MPI_BSEND -DDEV_NULL  -DMNH_MPI_RANK_KIND=$(MNH_MPI_RANK_KIND)
#RJ FPPFLAGS_RAD       =
#RJ FPPFLAGS_NEWLFI    = -DSWAPIO -DLINUX -DLFI_INT=${LFI_INT} -DLFI_RECL=${LFI_RECL}
#RJ FPPFLAGS_MNH       = -DMNH -DAINT=INT -DAMOD=MOD
#
# Gribex flags
#
TARGET_GRIBEX=linux
CNAME_GRIBEX=_gfortran
##########################################################
#                                                        #
# Source of MESONH PACKAGE  Distribution                 #
#                                                        #
##########################################################
#
include Makefile.SURFEX.mk
#
##########################################################
#                                                        #
# extra VPATH, Compilation flag modification             #
#         systeme module , etc ...                       #
#         external precompiled module librairie          #
#         etc ...                                        #
#                                                        #
##########################################################

#RJ: force lfi output binary reproducibility (avoid use of unix timestamps inside)
FUNDEFS  += -ULFI_BFB
FPPFLAGS += -DLFI_BFB

#RJ: changes to allow successful serial runtime
FUNDEFS  += -URJ_OFIX
FPPFLAGS += -DRJ_OFIX

#RJ ifneq "$(findstring 8,$(LFI_INT))" ""
#RJ OBJS_I8=spll_NEWLFI_ALL.o
#RJ $(OBJS_I8) : OPT = $(OPT_BASE) $(OPT_PERF2) $(OPT_I8)
#RJ endif
