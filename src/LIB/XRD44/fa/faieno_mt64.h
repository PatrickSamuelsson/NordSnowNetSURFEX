INTERFACE

SUBROUTINE FAIENO_FORT                                           &
&                     (FA, KREP, KNUMER, CDPREF, KNIVAU, CDSUFF, &
&                      PCHAMP, LDCOSP, LDUNDF, PUNDF)
USE FA_MOD, ONLY : FA_COM
USE LFI_PRECISION
IMPLICIT NONE
TYPE(FA_COM)           FA
INTEGER (KIND=JPLIKB)  KREP                                   !   OUT
INTEGER (KIND=JPLIKB)  KNUMER                                 ! IN   
CHARACTER (LEN=*)      CDPREF                                 ! IN   
INTEGER (KIND=JPLIKB)  KNIVAU                                 ! IN   
CHARACTER (LEN=*)      CDSUFF                                 ! IN   
REAL (KIND=JPDBLR)     PCHAMP     (*)                         ! IN   
LOGICAL                LDCOSP                                 ! IN   
LOGICAL,               OPTIONAL :: LDUNDF                     ! IN
REAL (KIND=JPDBLR),    OPTIONAL :: PUNDF                      ! IN
END SUBROUTINE

END INTERFACE
