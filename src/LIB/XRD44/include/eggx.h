INTERFACE
SUBROUTINE EGGX (PRPI, PRA, KROTEQ, PLONR, PLATR, PBETA,&
 & PLON1, PLAT1, PLON2, PLAT2, PLON0, PLAT0, PRPK, KULOUT,&
 & KSOTRP, KGIV0,&
 & PGELAM, PGELAT, PGM, PGNORX, PGNORY,&
 & KDLSA, KDLSUR, KDGSA, KDGEN, KDLUN, KDLUX, KDGUN, KDGUX,&
 & PDELX, PDELY)  
!----------------------------------------------------------------------
USE PARKIND1  ,ONLY : JPIM     ,JPRB
!---------------------------------------------------------------------
IMPLICIT NONE
INTEGER(KIND=JPIM),INTENT(IN)    :: KDLSA 
INTEGER(KIND=JPIM),INTENT(IN)    :: KDLSUR 
INTEGER(KIND=JPIM),INTENT(IN)    :: KDGSA 
INTEGER(KIND=JPIM),INTENT(IN)    :: KDGEN 
REAL(KIND=JPRB)   ,INTENT(IN)    :: PRPI
REAL(KIND=JPRB)   ,INTENT(IN)    :: PRA
INTEGER(KIND=JPIM),INTENT(IN)    :: KROTEQ 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PLONR 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PLATR 
REAL(KIND=JPRB)   ,INTENT(IN)    :: PBETA 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PLON1 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PLAT1 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PLON2 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PLAT2 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PLON0 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PLAT0 
REAL(KIND=JPRB)   ,INTENT(INOUT) :: PRPK
INTEGER(KIND=JPIM),INTENT(IN)    :: KULOUT
INTEGER(KIND=JPIM),INTENT(INOUT) :: KSOTRP
INTEGER(KIND=JPIM),INTENT(IN)    :: KGIV0 
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PGELAM(KDLSA:KDLSUR,KDGSA:KDGEN)
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PGELAT(KDLSA:KDLSUR,KDGSA:KDGEN)
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PGM(KDLSA:KDLSUR,KDGSA:KDGEN)
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PGNORX(KDLSA:KDLSUR,KDGSA:KDGEN)
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PGNORY(KDLSA:KDLSUR,KDGSA:KDGEN)
INTEGER(KIND=JPIM),INTENT(IN)    :: KDLUN
INTEGER(KIND=JPIM),INTENT(IN)    :: KDLUX
INTEGER(KIND=JPIM),INTENT(IN)    :: KDGUN
INTEGER(KIND=JPIM),INTENT(IN)    :: KDGUX
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PDELX
REAL(KIND=JPRB)   ,INTENT(OUT)   :: PDELY
!---------------------------------------------------------------------
END SUBROUTINE EGGX
END INTERFACE
