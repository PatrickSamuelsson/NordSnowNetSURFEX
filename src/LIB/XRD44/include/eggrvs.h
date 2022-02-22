INTERFACE
SUBROUTINE EGGRVS (PRPI, PRA, PDELX, PDELY, KPROF,&
 & KBEG, KEND, KULOUT, PGELAM, PGELAT, PGM, PGNORX, PGNORY)  
!---------------------------------------------------------------------
USE PARKIND1  ,ONLY : JPIM     ,JPRB
!-------------------------------------------------------------------
IMPLICIT NONE
INTEGER(KIND=JPIM),INTENT(IN)    :: KPROF 
REAL(KIND=JPRB)   ,INTENT(IN)    :: PRPI 
REAL(KIND=JPRB)   ,INTENT(IN)    :: PRA 
REAL(KIND=JPRB)   ,INTENT(IN)    :: PDELX 
REAL(KIND=JPRB)   ,INTENT(IN)    :: PDELY 
INTEGER(KIND=JPIM),INTENT(IN)    :: KBEG 
INTEGER(KIND=JPIM),INTENT(IN)    :: KEND 
INTEGER(KIND=JPIM),INTENT(IN)    :: KULOUT 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PGELAM(KPROF) 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PGELAT(KPROF) 
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PGM(KPROF) 
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PGNORX(KPROF) 
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PGNORY(KPROF) 
!-------------------------------------------------------------------
END SUBROUTINE EGGRVS
END INTERFACE
