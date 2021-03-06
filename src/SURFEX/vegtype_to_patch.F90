!SFX_LIC Copyright 1994-2014 CNRS, Meteo-France and Universite Paul Sabatier
!SFX_LIC This is part of the SURFEX software governed by the CeCILL-C licence
!SFX_LIC version 1. See LICENSE, CeCILL-C_V1-en.txt and CeCILL-C_V1-fr.txt  
!SFX_LIC for details. version 1.
!#### ########################################################
SUBROUTINE VEGTYPE_TO_PATCH(IVEGTYPE,INPATCH,IPATCH_NB,OECOSG,IPATCH_NAME)
!#############################################################
!
!!****  *VEGTYPE_TO_PATCH* - routine to attribute patch numbre (and name) with the nvegtype
!!
!!    PURPOSE
!!    -------
!
!  Calculation of patch indices coresponding to different  vegtype
!          according to the  number of patch  (NPATCH).
!             
!!**  METHOD
!!    ------
!!
!!    EXTERNAL
!!    --------
!!    none
!!
!!    IMPLICIT ARGUMENTS
!!    ------------------
!!      
!!    none
!!
!!    REFERENCE
!!    ---------
!!
!!      
!!    AUTHOR
!!    ------
!    F.Solmon/V.Masson 06/00 
!
!!    MODIFICATIONS
!!    -------------
!    R. Alkama       05/2012 : new vegtypes (19 rather than 12)
!    S. Faroux ?     01/2018 : new vegtypes (20 rather than 19 in ECOCLIMAP-SG)
!    A. DRUEL        10/2018 : - new organisation: 20, 19, 12, 9, 3 & 1 maintained, other (11,10,8,7,6,5,4,2) removed
!                                                13, 10 and 7 add with new logical (physic)
!                              - change function into routine
!                              - add the optionnal name of patch and vegtype into output
!-------------------------------------------------------------------------------
!
!*       0.     DECLARATIONS
!               ------------
!
USE MODD_DATA_COVER_PAR, ONLY : NVT_NO, NVT_ROCK, NVT_SNOW, NVT_TEBD,    & 
                                 NVT_BONE, NVT_TRBE, NVT_C3, NVT_C4,     &
                                 NVT_IRR, NVT_GRAS, NVT_TROG,NVT_PARK,   &
                                 NVT_TRBD, NVT_TEBE, NVT_TENE, NVT_BOBD, &
                                 NVT_BOND, NVT_BOGR, NVT_SHRB, NVT_C3W,  &
                                 NVT_C3S, NVT_FLTR, NVT_FLGR, NVEGTYPE
!
USE YOMHOOK   ,ONLY : LHOOK,   DR_HOOK
USE PARKIND1  ,ONLY : JPRB
!
USE MODI_ABOR1_SFX
!
IMPLICIT NONE
!
!*      0.1    declarations of arguments
!
INTEGER, INTENT(IN)  :: IVEGTYPE    ! indices of vegetation type           
INTEGER, INTENT(IN)  :: INPATCH     ! total number of PATCHES used 
!
INTEGER, INTENT(OUT) :: IPATCH_NB   ! PATCH index corresponding to the vegtype IVEGTYPE
LOGICAL,           OPTIONAL, INTENT(IN)  :: OECOSG
CHARACTER(LEN=34), OPTIONAL, INTENT(OUT) :: IPATCH_NAME ! Name of patch (dim 1: patch name, dim 2: vegtype inside)
!
CHARACTER(LEN=2) :: YVEGTYPE
CHARACTER(LEN=4), DIMENSION(NVEGTYPE) :: CVEG
REAL(KIND=JPRB) :: ZHOOK_HANDLE
!
!*      0.2    declarations of local variables
!
!-----------------------------------------------------------------
!
IF (LHOOK) CALL DR_HOOK('VEGTYPE_TO_PATCH',0,ZHOOK_HANDLE)
!
IF  ( .NOT.(PRESENT(IPATCH_NAME).EQV.PRESENT(OECOSG)) ) &
        CALL ABOR1_SFX('VEGTYPE_TO_PATCH: THE TWO OPTION ARE LINK AND HAVE TO BE PRESENT TOGETHER!')
!
WRITE(YVEGTYPE,"(I2.2)") NVEGTYPE
!
! 1. Find the NPATCH NUMBER corresponding to NVEGTYPE (and NPATCH NAME if asked)
!
! No differentiation: all nevegtype are merged into 1.
IF (INPATCH==1) THEN
  IPATCH_NB = 1 ! default case
  IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'ALL VEGEGTYPE TOGETHER'
!
!differenciation between low-vegetation and high vegtation, (forest +shrubs)
ELSEIF (INPATCH==2) THEN
   IF (PRESENT(IPATCH_NAME)) WRITE(*,*) "CAUTION: YOU CHOSE THE PATCH NUMBER = 2 (WITHOUT IRRIGATION)."
   IF (PRESENT(IPATCH_NAME)) WRITE(*,*) "         FOR BIO-PHYSICAL ASPECT WE RECOMMAND TO USE NPATCH = 3!!"
   IF ( IVEGTYPE== NVT_TEBD .OR. IVEGTYPE== NVT_TRBD .OR. IVEGTYPE== NVT_TEBE .OR. &
        IVEGTYPE== NVT_BOBD .OR. IVEGTYPE== NVT_SHRB .OR. IVEGTYPE== NVT_BONE .OR. &
        IVEGTYPE== NVT_TENE .OR. IVEGTYPE== NVT_BOND .OR. IVEGTYPE== NVT_TRBE .OR. &
        IVEGTYPE== NVT_FLTR ) THEN
     IPATCH_NB = 2
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'HIGH VEGETATION (TREES & SHRUBS)'
   ELSE
     IPATCH_NB = 1
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'LOW VEGETATION (GRASSES & NO VEG)'
   ENDIF
!
!differenciation between no vegetation, forest (+shrubs) and low vegetation
ELSEIF (INPATCH==3) THEN
   IF (IVEGTYPE== NVT_NO   .OR. IVEGTYPE== NVT_ROCK .OR. IVEGTYPE== NVT_SNOW ) THEN 
     IPATCH_NB = 1
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'NO VEGETATION'
   ELSEIF (IVEGTYPE== NVT_TEBD .OR. IVEGTYPE== NVT_TRBD .OR. IVEGTYPE== NVT_TEBE .OR. &
           IVEGTYPE== NVT_BOBD .OR. IVEGTYPE== NVT_SHRB .OR. IVEGTYPE== NVT_BONE .OR. &
           IVEGTYPE== NVT_TENE .OR. IVEGTYPE== NVT_BOND .OR. IVEGTYPE== NVT_TRBE .OR. &
           IVEGTYPE== NVT_FLTR ) THEN
     IPATCH_NB = 2
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'TREES AND SHRUBS'
   ELSEIF (IVEGTYPE== NVT_GRAS .OR. IVEGTYPE== NVT_BOGR .OR. IVEGTYPE== NVT_TROG .OR. &
           IVEGTYPE== NVT_PARK .OR. IVEGTYPE== NVT_C3   .OR. IVEGTYPE== NVT_C3W  .OR. &
           IVEGTYPE== NVT_C3S  .OR. IVEGTYPE== NVT_C4   .OR. IVEGTYPE== NVT_IRR  .OR. &
           IVEGTYPE== NVT_FLGR ) THEN
     IPATCH_NB = 3
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'HERBACEOUS'
   ENDIF
!
!differenciation between - No vegetation 
!                        - High vegetation (Broadleafs forest, needleleafs forest and shrubs)
!                        - Crops (+irrigated if old version before ECOSG) and Grassland (+park if old version before ECOSG)
ELSEIF (INPATCH==5) THEN
   IF (IVEGTYPE== NVT_NO   .OR. IVEGTYPE== NVT_ROCK .OR. IVEGTYPE== NVT_SNOW ) THEN
     IPATCH_NB = 1
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'NO VEGETATION'
   ELSEIF (IVEGTYPE== NVT_TEBD .OR. IVEGTYPE== NVT_TRBD .OR. IVEGTYPE== NVT_TEBE .OR. &
           IVEGTYPE== NVT_BOBD .OR. IVEGTYPE== NVT_SHRB .OR. IVEGTYPE== NVT_BONE .OR. &
           IVEGTYPE== NVT_TENE .OR. IVEGTYPE== NVT_BOND .OR. IVEGTYPE== NVT_TRBE .OR. &
           IVEGTYPE== NVT_FLTR ) THEN
     IPATCH_NB = 2
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'TREES AND SHRUBS'
   ELSEIF (IVEGTYPE== NVT_C3  .OR. IVEGTYPE== NVT_C3W  .OR. &
           IVEGTYPE== NVT_C3S .OR. IVEGTYPE== NVT_C4 ) THEN
     IPATCH_NB = 3
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'CROPS'
   ELSEIF (IVEGTYPE== NVT_IRR  .OR. IVEGTYPE== NVT_PARK .OR. IVEGTYPE== NVT_FLGR ) THEN
     IPATCH_NB = 4
     IF (PRESENT(IPATCH_NAME)) THEN
       IF ( OECOSG ) THEN
         IPATCH_NAME = 'FLOODED TREES'
       ELSE
         IPATCH_NAME = 'C4 CROPS IRRIGATED & PARKS'
       ENDIF
     ENDIF
   ELSEIF (IVEGTYPE== NVT_GRAS .OR. IVEGTYPE== NVT_BOGR .OR. IVEGTYPE== NVT_TROG ) THEN
     IPATCH_NB = 5
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'GRASSLANDS'
   ENDIF
!
!differenciation between: - Bare fields and permanent snow
!  NEW DISTINCTION        - Broadleafs forest, needleleafs forest and shrubs
! (from INPATCH==3)       - Crops (+irrigated if old version before ECOSG) and Grassland (+park if old version before ECOSG)
ELSEIF (INPATCH==7) THEN
   IF (IVEGTYPE== NVT_NO   .OR. IVEGTYPE== NVT_ROCK ) THEN
     IPATCH_NB = 1
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BARE FIELD'
   ELSEIF (IVEGTYPE== NVT_SNOW ) THEN
     IPATCH_NB = 2
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'PERMANENT SNOW'
   ELSEIF (IVEGTYPE== NVT_BOBD .OR. IVEGTYPE== NVT_TEBD .OR. IVEGTYPE== NVT_TRBD .OR. &
           IVEGTYPE== NVT_TEBE .OR. IVEGTYPE== NVT_TRBE .OR. IVEGTYPE== NVT_FLTR ) THEN
     IPATCH_NB = 3
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BROADLEAF TREES'
   ELSEIF (IVEGTYPE== NVT_BONE .OR. IVEGTYPE== NVT_TENE .OR. IVEGTYPE== NVT_BOND ) THEN
     IPATCH_NB = 4
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'NEEDLELEAF TREES'
   ELSEIF (IVEGTYPE== NVT_SHRB ) THEN 
     IPATCH_NB = 5
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'SHRUBS'
   ELSEIF (IVEGTYPE==  NVT_C3  .OR. IVEGTYPE== NVT_C3W  .OR. IVEGTYPE== NVT_C3S  .OR. &
           IVEGTYPE== NVT_C4   .OR. IVEGTYPE== NVT_IRR  .OR. IVEGTYPE== NVT_PARK ) THEN
     IPATCH_NB = 6
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'CROPS'
   ELSEIF (IVEGTYPE== NVT_BOGR .OR. IVEGTYPE== NVT_GRAS .OR. IVEGTYPE== NVT_TROG .OR. &
           IVEGTYPE== NVT_FLGR ) THEN
     IPATCH_NB = 7 
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'GRASSLANDS'
   ENDIF
!
!differenciation between: - Bare fields and permanent snow
!  OLD DISTINCTION        - Broadleafs(+shrubs), needleleafs and flooded tree cover
! (from INPATCH==3)       - C3 crops, C4 crops(irrigated if old version), Grassland and wetlands 
ELSEIF (INPATCH==9) THEN
   IF (IVEGTYPE== NVT_NO   .OR. IVEGTYPE== NVT_ROCK ) THEN
     IPATCH_NB = 1
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BARE FIELD'
   ELSEIF (IVEGTYPE== NVT_SNOW) THEN
     IPATCH_NB = 2
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'PERMANENT SNOW'
   ELSEIF (IVEGTYPE== NVT_TEBD .OR. IVEGTYPE== NVT_TRBD .OR. IVEGTYPE== NVT_TEBE .OR. &
           IVEGTYPE== NVT_BOBD .OR. IVEGTYPE== NVT_SHRB .OR. IVEGTYPE== NVT_TRBE ) THEN
     IPATCH_NB = 3
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BROADLEAF TREES & SHRUBS'
   ELSEIF (IVEGTYPE== NVT_BONE .OR. IVEGTYPE== NVT_TENE .OR. IVEGTYPE== NVT_BOND ) THEN
     IPATCH_NB = 4
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'NEEDLELEAF TREES'
   ELSEIF (IVEGTYPE== NVT_C3   .OR. IVEGTYPE== NVT_C3W  .OR. IVEGTYPE== NVT_C3S )  THEN
     IPATCH_NB = 5
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C3 CROPS'
   ELSEIF (IVEGTYPE== NVT_C4  ) THEN
     IPATCH_NB = 6
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C4 CROPS'
   ELSEIF (IVEGTYPE== NVT_IRR  .OR. IVEGTYPE== NVT_FLTR) THEN
     IPATCH_NB = 7
     IF (PRESENT(IPATCH_NAME)) THEN
       IF ( OECOSG ) THEN
         IPATCH_NAME = 'FLOODED TREES'
       ELSE
         IPATCH_NAME = 'C4 CROPS IRRIGATED'
       ENDIF
     ENDIF
   ELSEIF (IVEGTYPE== NVT_GRAS .OR. IVEGTYPE== NVT_BOGR .OR. IVEGTYPE== NVT_TROG)  THEN
     IPATCH_NB = 8
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'GRASSLANDS'
   ELSEIF (IVEGTYPE== NVT_PARK .OR. IVEGTYPE== NVT_FLGR) THEN
     IPATCH_NB = 9
     IF (PRESENT(IPATCH_NAME)) THEN
       IF ( OECOSG ) THEN
          IPATCH_NAME = 'FLOODED GRASSES'
       ELSE
         IPATCH_NAME = 'IRRIGATED PARKS GARDEN & PEAT BOGS'
       ENDIF
     ENDIF
   ENDIF
!
!differenciation between: - Bare soil and bare rock
!  NEW DISTINCTION        - Crops C3 and C4 (+irrigated if old version before ECOSG)
! (from INPATCH==7)       - Grassland C3 and C4 (+park if old version before ECOSG)
ELSEIF (INPATCH==10) THEN
   IF (IVEGTYPE==  NVT_NO   ) THEN
     IPATCH_NB = 1
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BARE SOIL'
   ELSEIF (IVEGTYPE==  NVT_ROCK ) THEN
     IPATCH_NB = 2
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BARE ROCK'
   ELSEIF (IVEGTYPE==  NVT_SNOW ) THEN
     IPATCH_NB = 3
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'PERMANENT SNOW'
   ELSEIF (IVEGTYPE== NVT_BOBD .OR. IVEGTYPE== NVT_TEBD .OR. IVEGTYPE== NVT_TRBD .OR. &
           IVEGTYPE== NVT_TEBE .OR. IVEGTYPE== NVT_TRBE .OR. IVEGTYPE== NVT_FLTR ) THEN
     IPATCH_NB = 4
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BROADLEAF TREES'
   ELSEIF (IVEGTYPE== NVT_BONE .OR. IVEGTYPE== NVT_TENE .OR. IVEGTYPE== NVT_BOND ) THEN
     IPATCH_NB = 5
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'NEEDLELEAF TREES'
   ELSEIF (IVEGTYPE== NVT_SHRB ) THEN
     IPATCH_NB = 6
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'SHRUBS'
   ELSEIF (IVEGTYPE== NVT_C3   .OR. IVEGTYPE== NVT_C3W .OR. IVEGTYPE== NVT_C3S  ) THEN
     IPATCH_NB = 7
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C3 CROPS'
   ELSEIF (IVEGTYPE== NVT_C4   .OR. IVEGTYPE== NVT_IRR .OR. IVEGTYPE== NVT_PARK ) THEN
     IPATCH_NB = 8
     IF (PRESENT(IPATCH_NAME)) THEN
       IF ( OECOSG ) THEN
         IPATCH_NAME = 'C4 CROPS'
       ELSE
         IPATCH_NAME = 'C4 CROPS & PARKS (IRRIG. OR NOT)'
       ENDIF
     ENDIF
   ELSEIF (IVEGTYPE== NVT_BOGR .OR. IVEGTYPE== NVT_GRAS .OR. IVEGTYPE== NVT_FLGR ) THEN
     IPATCH_NB = 9
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C3 GRASSLANDS'
   ELSEIF (IVEGTYPE== NVT_TROG ) THEN
     IPATCH_NB = 10
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C4 GRASSLANDS'
   ENDIF
!
!differenciation between: - Bare soil and bare rock
!  OLD DISTINCTION        - Grassland (temperate+boreal) and trpical one
! (from INPATCH==9)       - Broadleafs(+shrubs) and tropical broadleafs evergreen
ELSEIF (INPATCH==12) THEN
   IF (IVEGTYPE==  NVT_NO ) THEN
     IPATCH_NB = 1
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BARE SOIL'
   ELSEIF (IVEGTYPE==  NVT_ROCK ) THEN
     IPATCH_NB = 2
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BARE ROCK'
   ELSEIF (IVEGTYPE==  NVT_SNOW ) THEN
     IPATCH_NB = 3
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'PERMANENT SNOW'
   ELSEIF (IVEGTYPE== NVT_TEBD .OR. IVEGTYPE== NVT_TRBD .OR. IVEGTYPE== NVT_TEBE .OR. &
           IVEGTYPE== NVT_BOBD .OR. IVEGTYPE== NVT_SHRB) THEN
     IPATCH_NB = 4
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BROADLEAF TREES & SHRUBS (-TRBE)'
   ELSEIF (IVEGTYPE== NVT_BONE .OR. IVEGTYPE== NVT_TENE .OR. IVEGTYPE== NVT_BOND) THEN
     IPATCH_NB = 5
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'NEEDLELEAF TREES'
   ELSEIF (IVEGTYPE== NVT_TRBE ) THEN
     IPATCH_NB = 6
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'TROPICAL BROADLEAF EVERG. TREES'
   ELSEIF (IVEGTYPE== NVT_C3   .OR. IVEGTYPE== NVT_C3W  .OR. IVEGTYPE== NVT_C3S ) THEN
     IPATCH_NB = 7
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C3 CROPS'
   ELSEIF (IVEGTYPE== NVT_C4   ) THEN
     IPATCH_NB = 8
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C4 CROPS'
   ELSEIF (IVEGTYPE== NVT_IRR  .OR. IVEGTYPE== NVT_FLTR) THEN
     IPATCH_NB = 9
     IF (PRESENT(IPATCH_NAME)) THEN
       IF ( OECOSG ) THEN
         IPATCH_NAME = 'FLOODED TREES'
       ELSE
         IPATCH_NAME = 'C4 CROPS IRRIGATED'
       ENDIF
     ENDIF
   ELSEIF (IVEGTYPE== NVT_GRAS .OR. IVEGTYPE== NVT_BOGR) THEN
     IPATCH_NB = 10
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C3 GRASSLANDS'
   ELSEIF (IVEGTYPE== NVT_TROG ) THEN
     IPATCH_NB = 11
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C4 GRASSLANDS'
   ELSEIF (IVEGTYPE== NVT_PARK .OR. IVEGTYPE== NVT_FLGR) THEN
     IPATCH_NB = 12
     IF (PRESENT(IPATCH_NAME)) THEN
       IF ( OECOSG ) THEN
          IPATCH_NAME = 'FLOODED GRASSES'
       ELSE
         IPATCH_NAME = 'IRRIGATED PARKS GARDEN & PEAT BOGS'
       ENDIF
     ENDIF
   ENDIF
!
!differenciation between: - Broadleaf decidus and broadleaf evergreen forest 
!  NEW DISTINCTION        - Needleleaf decidus and needleleaf evergreen forest
! (from INPATCH==7)       - Winter C3 crops and summer C3 crops (C3 crops go in summer C3 in old versions)
ELSEIF (INPATCH==13) THEN
   IF (IVEGTYPE==  NVT_NO ) THEN
     IPATCH_NB = 1
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BARE SOIL'
   ELSEIF (IVEGTYPE== NVT_ROCK ) THEN
     IPATCH_NB = 2
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BARE ROCK'
   ELSEIF (IVEGTYPE== NVT_SNOW ) THEN
     IPATCH_NB = 3
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'PERMANENT SNOW'
   ELSEIF (IVEGTYPE== NVT_BOBD .OR. IVEGTYPE== NVT_TEBD .OR. IVEGTYPE== NVT_TRBD .OR. &
           IVEGTYPE== NVT_FLTR ) THEN
     IPATCH_NB = 4
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BROADLEAF DECIDUOUS TREES'
   ELSEIF (IVEGTYPE== NVT_TEBE .OR. IVEGTYPE== NVT_TRBE ) THEN
     IPATCH_NB = 5
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'BROADLEAF EVERGREEN TREES'
   ELSEIF (IVEGTYPE== NVT_BOND ) THEN
     IPATCH_NB = 6
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'NEEDLELEAF BOREAL DECIDUOUS TREES'
   ELSEIF (IVEGTYPE== NVT_BONE .OR. IVEGTYPE== NVT_TENE ) THEN
     IPATCH_NB = 7
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'NEEDLELEAF EVERGREEN TREES'
   ELSEIF (IVEGTYPE== NVT_SHRB ) THEN
     IPATCH_NB = 8
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'SHRUBS'
   ELSEIF (IVEGTYPE== NVT_C3   .OR. IVEGTYPE== NVT_C3S  ) THEN
     IPATCH_NB = 9
     IF (PRESENT(IPATCH_NAME)) THEN
       IF ( OECOSG ) THEN
         IPATCH_NAME = 'SUMMER C3 CROPS'
       ELSE
         IPATCH_NAME = 'C3 CROPS'
       ENDIF
     ENDIF
   ELSEIF (IVEGTYPE== NVT_C3W .OR. IVEGTYPE== NVT_IRR .OR. IVEGTYPE== NVT_PARK )  THEN
     IPATCH_NB = 10
     IF (PRESENT(IPATCH_NAME)) THEN
       IF ( OECOSG ) THEN
         IPATCH_NAME = 'WINTER C3 CROPS'
       ELSE
         IPATCH_NAME = 'IRRIGATED C4 CROPS, PARKS & GARDEN'
       ENDIF
     ENDIF
   ELSEIF (IVEGTYPE== NVT_C4 ) THEN
     IPATCH_NB = 11
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C4 CROPS'
   ELSEIF (IVEGTYPE== NVT_BOGR .OR. IVEGTYPE== NVT_GRAS .OR. IVEGTYPE== NVT_FLGR ) THEN
     IPATCH_NB = 12
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C3 GRASSLANDS'
   ELSEIF (IVEGTYPE== NVT_TROG ) THEN
     IPATCH_NB = 13
     IF (PRESENT(IPATCH_NAME)) IPATCH_NAME = 'C4 GRASSLANDS'
   ENDIF
!
! if INPATCH=NVEGTYPE: no patch merging, each vegetation is computed
ELSEIF (INPATCH==NVEGTYPE) THEN
  IPATCH_NB = IVEGTYPE
  IF (PRESENT(IPATCH_NAME)) THEN
    IF ( NVEGTYPE == 19 ) THEN
      CVEG(1) =  "NO  "      ! no vegetation (smooth)
      CVEG(2) =  "ROCK"      ! no vegetation (rocks)
      CVEG(3) =  "SNOW"      ! permanent snow and ice
      CVEG(4) =  "TEBD"      ! temperate broadleaf deciduous trees
      CVEG(5) =  "BONE"      ! boreal needleleaf evergreen trees 
      CVEG(6) =  "TRBE"      ! tropical broadleaf evergreen trees
      CVEG(7) =  "C3  "      ! C3 cultures types
      CVEG(8) =  "C4  "      ! C4 cultures types
      CVEG(9) =  "IRR "      ! irrigated crops
      CVEG(10)=  "GRAS"      ! temperate grassland C3
      CVEG(11)=  "TROG"      ! tropical  grassland C4
      CVEG(12)=  "PARK"      ! peat bogs, parks and gardens (irrigated grass)
      CVEG(13)=  "TRBD"      ! tropical  broadleaf  deciduous trees
      CVEG(14)=  "TEBE"      ! temperate broadleaf  evergreen trees
      CVEG(15)=  "TENE"      ! temperate needleleaf evergreen trees
      CVEG(16)=  "BOBD"      ! boreal    broadleaf  deciduous trees
      CVEG(17)=  "BOND"      ! boreal    needleleaf deciduous trees
      CVEG(18)=  "BOGR"      ! boreal grassland C3
      CVEG(19)=  "SHRB"      ! broadleaf shrub
    !
    ELSEIF ( NVEGTYPE == 20 ) THEN
      CVEG(1) =  "NO  "      ! no vegetation (smooth)
      CVEG(2) =  "ROCK"      ! no vegetation (rocks)
      CVEG(3) =  "SNOW"      ! permanent snow and ice
      CVEG(4) =  "BOBD"      ! boreal    broadleaf  deciduous trees
      CVEG(5) =  "TEBD"      ! temperate broadleaf deciduous trees
      CVEG(6) =  "TRBD"      ! tropical  broadleaf  deciduous trees
      CVEG(7) =  "TEBE"      ! temperate broadleaf  evergreen trees
      CVEG(8) =  "TRBE"      ! tropical broadleaf evergreen trees
      CVEG(9) =  "BONE"      ! boreal needleleaf evergreen trees 
      CVEG(10)=  "TENE"      ! temperate needleleaf evergreen trees
      CVEG(11)=  "BOND"      ! boreal    needleleaf deciduous trees
      CVEG(12)=  "SHRB"      ! broadleaf shrub
      CVEG(13)=  "BOGR"      ! boreal grassland C3
      CVEG(14)=  "GRAS"      ! temperate grassland C3
      CVEG(15)=  "TROG"      ! tropical  grassland C4
      CVEG(16)=  "C3W "      ! winter C3 cultures types
      CVEG(17)=  "C3S "      ! summer C3 cultures types
      CVEG(18)=  "C4  "      ! C4 cultures types
      CVEG(19)=  "FLTR"      ! flooded trees
      CVEG(20)=  "FLGR"      ! flooded grassland
    ELSE
      CALL ABOR1_SFX('VEGTYPE_TO_PATCH: NO NAME CORRESPONDANCE FOR NVEGTYPE/=20 or 19. PLEASE UPDATE. NVEGTYPE = '//YVEGTYPE)
    ENDIF
    !
    IPATCH_NAME = 'NVT_'//CVEG(IVEGTYPE)//' (PATCHS = VEGTYPES)'
    !
  ENDIF
!
ELSE
  CALL ABOR1_SFX('VEGTYPE_TO_PATCH: NPATCH (OR NPATCH_TREE OR EQ.) MUST BE 1, 2, 3, 5, 7, 9, 10, 12, 13 OR EQUAL TO NVEGTYPE =' &
                 //YVEGTYPE)
ENDIF
!
IF (LHOOK) CALL DR_HOOK('VEGTYPE_TO_PATCH',1,ZHOOK_HANDLE)
!
END SUBROUTINE VEGTYPE_TO_PATCH
