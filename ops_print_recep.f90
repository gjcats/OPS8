!-------------------------------------------------------------------------------------------------------------------------------
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <http://www.gnu.org/licenses/>.
!
!                       Copyright (C) 2002 by
!   National Institute of Public Health and Environment
!           Laboratory for Air Research (RIVM/LLO)
!                      The Netherlands
!
! SUBROUTINE
! NAME                : %M%
! SCCS (SOURCE)       : %P%
! RELEASE - LEVEL     : %R% - %L%
! BRANCH - SEQUENCE   : %B% - %S%
! DATE - TIME         : %E% - %U%
! WHAT                : %W%:%E%
! AUTHOR              : Chris Twenh"ofel (Cap Gemini)
! FIRM/INSTITUTE      : RIVM/LLO
! LANGUAGE            : FORTRAN-77/90
! DESCRIPTION         : Print output for non-gridded receptors
! EXIT CODES          :
! REFERENCE           :
! FILES I/O DEVICES   :
! SYSTEM DEPENDENCIES : HP-Fortran
! CALLED FUNCTIONS    : ops_print_kop, ops_scalefac
! UPDATE HISTORY      :
!-------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE ops_print_recep (project, gasv, idep, isec, igrid, verb, namco, namsec, namse3, coneh, depeh, conc_cf, amol21,      &
        &  ugmoldep, nrrcp, namrcp, xm, ym, precip, cpri, csec, drydep, ddepri, wetdep, rno2_nox_sum, lu_rcp_dom_all, z0_rcp_all,     &
        &  gemcpri, gemcsec, ccr, gemddep, gemddpri, gemddsec, ddrpri, ddrsec, gemwdep, gemwdpri, gemwdsec, wdrpri,            &
        &  wdrsec, gemprec, gemtdep, icm, cseccor, gemcseccor, namseccor, totdep, scale_con, scale_sec,                        &
        &  scale_sec_cor, scale_dep, error)

USE ops_print_table
USE m_error
USE m_utils
USE m_commonconst

IMPLICIT NONE

! CONSTANTS
CHARACTER*512                                    :: ROUTINENAAM                ! 
PARAMETER    (ROUTINENAAM = 'ops_print_recep')

! SUBROUTINE ARGUMENTS - INPUT
CHARACTER*(*), INTENT(IN)                        :: project                    ! 
LOGICAL,   INTENT(IN)                            :: gasv                       ! 
LOGICAL,   INTENT(IN)                            :: isec                       ! 
LOGICAL,   INTENT(IN)                            :: verb                       ! 
CHARACTER*(*), INTENT(IN)                        :: namco                      ! 
CHARACTER*(*), INTENT(IN)                        :: namsec                     ! 
CHARACTER*(*), INTENT(IN)                        :: namse3                     ! 
CHARACTER*(*), INTENT(IN)                        :: coneh                      ! 
CHARACTER*(*), INTENT(IN)                        :: depeh                      ! 
real,    INTENT(IN)                            :: conc_cf                    ! 
real,    INTENT(IN)                            :: amol21                     ! 
real,    INTENT(IN)                            :: ugmoldep                   ! 
INTEGER*4, INTENT(IN)                            :: nrrcp                      ! number of receptor points
CHARACTER*(*), INTENT(IN)                        :: namrcp (nrrcp)             ! 
real,    INTENT(IN)                            :: xm(nrrcp)                  ! 
real,    INTENT(IN)                            :: ym(nrrcp)                  ! 
real,    INTENT(IN)                            :: precip(nrrcp)              ! calculated precipitation
real,    INTENT(IN)                            :: cpri(nrrcp)                ! primary concentration
real,    INTENT(IN)                            :: csec(nrrcp)                ! secondary concentration
real,    INTENT(IN)                            :: drydep(nrrcp)              ! dry deposition
real,    INTENT(IN)                            :: ddepri(nrrcp)              ! dry depo of primary comp.
real,    INTENT(IN)                            :: wetdep(nrrcp)              ! wet deposition
real,    INTENT(IN)                            :: rno2_nox_sum(nrrcp)        ! NO2/NOx ratio, weighed sum over classes
INTEGER*4, INTENT(IN)                            :: lu_rcp_dom_all(nrrcp)      ! 
real,    INTENT(IN)                            :: z0_rcp_all(nrrcp)          ! roughness lengths for all receptors; from z0-map or receptor file [m]
real,    INTENT(IN)                            :: gemcpri                    ! mean for prim. concentration
real,    INTENT(IN)                            :: gemcsec                    ! mean for sec. concentration
real,    INTENT(IN)                            :: ccr                        ! eff. chemical conversion rate
real,    INTENT(IN)                            :: gemddep                    ! mean for dry deposition
real,    INTENT(IN)                            :: gemddpri                   ! mean for dry deposition (pri)
real,    INTENT(IN)                            :: gemddsec                   ! mean for dry deposition (sec)
real,    INTENT(IN)                            :: ddrpri                     ! eff. dry deposition rate (prim)
real,    INTENT(IN)                            :: ddrsec                     ! eff. dry deposition rate (sec)
real,    INTENT(IN)                            :: gemwdep                    ! mean for wet deposition
real,    INTENT(IN)                            :: gemwdpri                   ! mean for wet deposition (pri)
real,    INTENT(IN)                            :: gemwdsec                   ! mean for wet deposition (sec)
real,    INTENT(IN)                            :: wdrpri                     ! eff. wet deposition rate (prim)
real,    INTENT(IN)                            :: wdrsec                     ! eff. wet deposition rate (sec)
real,    INTENT(IN)                            :: gemprec                    ! mean annual precpitation from meteo
real,    INTENT(IN)                            :: gemtdep                    ! mean for total deposition
INTEGER*4, INTENT(IN)                            :: icm                        ! number of component
real,    INTENT(IN)                            :: cseccor(nrrcp)             ! gaseous secondary concentration
real,    INTENT(IN)                            :: gemcseccor                 ! mean gaseous secondary concentration
CHARACTER*(*), INTENT(IN)                        :: namseccor                  ! 
real,    INTENT(IN)                            :: totdep(nrrcp)              ! total deposition
real,    INTENT(IN)                            :: scale_con                  ! 
real,    INTENT(IN)                            :: scale_sec                  ! 
real,    INTENT(IN)                            :: scale_sec_cor              ! 
real,    INTENT(IN)                            :: scale_dep                  ! 

! SUBROUTINE ARGUMENTS - I/O
LOGICAL,   INTENT(INOUT)                         :: idep                       ! 
LOGICAL,   INTENT(INOUT)                         :: igrid                      ! 

! SUBROUTINE ARGUMENTS - OUTPUT
TYPE (Terror), INTENT(OUT)                       :: error                      ! 

! LOCAL VARIABLES
INTEGER*4                                        :: i                          ! 
INTEGER*4                                        :: j                          ! 
real                                           :: scalec                     ! 
real                                           :: scaled                     ! 
real                                           :: scalen                     ! 
real                                           :: scalsc                     ! 
real                                           :: vdpri(nrrcp)               ! 
real                                           :: vdsec(nrrcp)               ! 
real                                           :: tmp(nrrcp)                 ! dry+wet deposition
CHARACTER*4                                      :: vdeh                       ! 
CHARACTER*4                                      :: z0eh                       ! 
CHARACTER*4                                      :: lueh                       ! 
CHARACTER*4                                      :: ppeh                       ! 
INTEGER*4                                        :: ircp

! SCCS-ID VARIABLES
CHARACTER*81                                     :: sccsida                    ! 
sccsida = '%W%:%E%'//char(0)
!-------------------------------------------------------------------------------------------------------------------------------
!
! FORMATS for possible header rows
!
1703 FORMAT (/,'  nr    name        x-coord   y-coord  pri.con')
2703 FORMAT (/,'  nr    name        x-coord   y-coord  pri.con', '       z0   lu_dom   precip')
3703 FORMAT (/,'  nr    name        x-coord   y-coord  pri.con', '  dry.dep  wet.dep  tot.dep')
4703 FORMAT (/,'  nr    name        x-coord   y-coord  pri.con', '  dry.dep  wet.dep  tot.dep',                                    &
            &  '    vdpri       z0   lu_dom   precip')
5703 FORMAT (/,'  nr    name        x-coord   y-coord  pri.con', '  dry.dep  wet.dep  tot.dep  sec.con')
6703 FORMAT (/,'  nr    name        x-coord   y-coord  pri.con', '  dry.dep  wet.dep  tot.dep  sec.con'                            &
            &  '    vdpri    vdsec       z0   lu_dom   precip')
7703 FORMAT (/,'  nr    name        x-coord   y-coord  pri.con', '  dry.dep  wet.dep  tot.dep  sec.con  sec.cor')
8703 FORMAT (/,'  nr    name        x-coord   y-coord  pri.con', '  dry.dep  wet.dep  tot.dep  sec.con  sec.cor'                   &
            &  '    vdpri    vdsec       z0   lu_dom   precip')

704 FORMAT (37x,5(6x,a3:),(6x,a4:))                                            ! component name (for isec=1)
705 FORMAT (24x,'(m)       (m)',11(a9:))                                         ! unit
!
! Definition of units for deposition velocity vd, roughness length z0, land use
!
vdeh = 'cm/s'
z0eh = '   m'
lueh = '   -'
ppeh = 'mm/y'
!
! To avoid unlogical combinations
!
IF (verb) igrid = .TRUE.
IF (isec) idep  = .TRUE.
!
! PRINTOUT
!
CALL ops_print_kop (project,namco)

IF (igrid) THEN

  IF (.NOT.idep) THEN

    IF (.NOT.verb) THEN
!
!     print primary concentration in table
!
      CALL print_conc_names(namco)
      CALL print_depo_names()
      WRITE (fu_prt,1703)
      WRITE (fu_prt,705) coneh ! unit for concentration

      CALL print_values(nrrcp, namrcp, xm, ym, error, cpri, scale_con)
    ELSE
!
!     print primary concentration, z0, lu, precipitation in tables
!
      CALL print_conc_names(namco)
      CALL print_depo_names()
      WRITE (fu_prt,2703)
      WRITE (fu_prt,705) coneh, z0eh, lueh, ppeh
      CALL print_values(nrrcp, namrcp, xm, ym, error, cpri, scale_con, z0_rcp_all, 1.E3, REAL(lu_rcp_dom_all), 1., precip, 1.)
    ENDIF

  ELSE

    IF (.NOT.isec) THEN

      !----------------------------
      ! only primary species 
      !----------------------------

      IF (.NOT.verb) THEN
!        
!       print primary concentration, drydep, wetdep, totdep in tables
!
        CALL print_conc_names(namco)
        CALL print_depo_names()
        WRITE (fu_prt,3703)
        WRITE (fu_prt,705) coneh,depeh,depeh,depeh

        CALL print_values(nrrcp, namrcp, xm, ym, error, cpri, scale_con, drydep, scale_dep, wetdep, scale_dep, totdep,         &
                       &  scale_dep)

      ELSE
!        
!       print primary concentration, drydep, wetdep, totdep, vdpri, z0, lu, precip in table
!
        CALL print_conc_names(namco)
        CALL print_depo_names()
        WRITE (fu_prt,4703)
        WRITE (fu_prt,705) coneh,depeh,depeh,depeh,z0eh,lueh, ppeh

        DO j = 1, nrrcp
           vdpri(j) = ddepri(j)/ugmoldep*1.0e2/(cpri(j)/ conc_cf*3600.)/amol21
        ENDDO
        CALL print_values(nrrcp, namrcp, xm, ym, error, cpri, scale_con, drydep, scale_dep, wetdep, scale_dep, totdep,         &
                       &  scale_dep, vdpri, 1.E3, z0_rcp_all, 1.E3, REAL(lu_rcp_dom_all), 1., precip, 1.)
      ENDIF

    ELSE
      !----------------------------
      ! primary + secondary species 
      !----------------------------

      IF (icm == 2) THEN
        
        ! NOx
        
        IF (.NOT.verb) THEN
!
!         print primary concentration, drydep, wetdep, totdep, secondary concentration, second secondary concentration in tables
!
          CALL print_conc_names(namco, namsec, namseccor)
          CALL print_depo_names(namsec)
          WRITE (fu_prt,7703)
          WRITE (fu_prt,704) namco(:LEN_TRIM(namco)), (namse3(:LEN_TRIM(namse3)), i=1, 3), namsec(:LEN_TRIM(namsec)),          &
                          &  namseccor(:LEN_TRIM(namseccor))
          WRITE (fu_prt,705) coneh, depeh, depeh, depeh, 'ug/m3', 'ug/m3'

          CALL print_values(nrrcp, namrcp, xm, ym, error, cpri, scale_con, drydep, scale_dep, wetdep, scale_dep, totdep,         &
                       &  scale_dep, csec, scale_sec, cseccor, scale_sec_cor)

        ELSE
!      
!         print primary concentration, drydep, wetdep, totdep, secondary conc, second secondary concentration, vdpri, vdsec, z0, lu and precip in table
!
          CALL print_conc_names(namco, namsec, namseccor)
          CALL print_depo_names(namsec)
          WRITE (fu_prt,8703)
          WRITE (fu_prt,704) namco(:LEN_TRIM(namco)), (namse3(:LEN_TRIM(namse3)), i=1, 3), namsec(:LEN_TRIM(namsec)),          &
                          &  namseccor(:LEN_TRIM(namseccor))
          WRITE (fu_prt,705) coneh, depeh, depeh, depeh, 'ug/m3', 'ug/m3', vdeh, vdeh, z0eh, lueh, ppeh

          DO j = 1, nrrcp
             vdpri(j) = ddepri(j)/ugmoldep*1.0e2/(cpri(j)/ conc_cf*3600.)/amol21
             vdsec(j) = (drydep(j) - ddepri(j))/ugmoldep*1.0e2/ (csec(j)*3600.)
          ENDDO

          CALL print_values(nrrcp, namrcp, xm, ym, error, cpri, scale_con, drydep, scale_dep, wetdep, scale_dep, totdep,       &
                         &  scale_dep, csec, scale_sec, cseccor, scale_sec_cor, vdpri, 1.E3, vdsec, 1.E3, z0_rcp_all, 1.E3,           &
                         &  REAL(lu_rcp_dom_all), 1., precip, 1.)

        ENDIF
      ELSE
      
        ! no NOx 
        
        IF (.NOT.verb) THEN
!          
!         print primary concentration, drydep, wetdep, totdep, secondary concentration in tables
!
          CALL print_conc_names(namco, namsec)
          CALL print_depo_names(namsec)
          WRITE (fu_prt,5703)
          WRITE (fu_prt,704) namco(:3),(namse3(:3),i=1,3), namsec(:3)
          WRITE (fu_prt,705) coneh, depeh, depeh, depeh, 'ug/m3'

          CALL print_values(nrrcp, namrcp, xm, ym, error, cpri, scale_con, drydep, scale_dep, wetdep, scale_dep, totdep,       &
                         &  scale_dep, csec, scale_sec)

        ELSE
!
!         print primary concentration, drydep, wetdep, totdep, secondary concentration, vdpri, vdsec, z0, lu, precip in tables
!
          CALL print_conc_names(namco, namsec)
          CALL print_depo_names(namsec)
          WRITE (fu_prt,6703)
        WRITE (fu_prt,704) namco(:3),(namse3(:3),i=1,3),namsec(:3)
          WRITE (fu_prt,705) coneh, depeh, depeh, depeh, 'ug/m3', vdeh, vdeh, z0eh, lueh, ppeh

          DO j = 1, nrrcp
             vdpri(j) = ddepri(j)/ugmoldep*1.0e2/(cpri(j)/ conc_cf*3600.)/amol21
             vdsec(j)  = (drydep(j) - ddepri(j))/ugmoldep*1.0e2/ (csec(j)*3600.)
          ENDDO

          CALL print_values(nrrcp, namrcp, xm, ym, error, cpri, scale_con, drydep, scale_dep, wetdep, scale_dep, totdep,       &
                         &  scale_dep, csec, scale_sec, vdpri, 1.E3, vdsec, 1.E3, z0_rcp_all, 1.E3, REAL(lu_rcp_dom_all), 1., precip, 1.)
        ENDIF
      ENDIF

    ENDIF

  ENDIF

ENDIF

IF (error%haserror) GOTO 9000
!
! Output of summary statistics
!
IF (igrid) THEN
  WRITE (fu_prt, '(a)') char(12)
  CALL ops_print_kop (project,namco)
ENDIF

WRITE(fu_prt,'(/)')

WRITE(fu_prt,'('' Summary statistics for '',a)') namco(:LEN_TRIM(namco))

IF (.NOT.gasv) THEN
  WRITE (fu_prt, '(/,1x,a,'' considered as aerosol'')') namco(1:LEN_TRIM(namco))
ELSE
  WRITE (fu_prt, '(/,1x,a,'' considered as gaseous'')') namco(1:LEN_TRIM(namco))
  IF (.NOT.idep) THEN
    WRITE (fu_prt,'('' No conversion and deposition assumed'')')
  ELSE
    IF (.NOT.isec) THEN
      WRITE (fu_prt,'('' Dispersion and deposition of secundary'', '' component '', a, '' not included'')')                    &
          &  namsec(1:LEN_TRIM(namsec))
    ELSE
      WRITE (fu_prt,'('' Dispersion and deposition of secundary'', '' component '', a, '' included'')')                        &
          &  namsec(1:LEN_TRIM(namsec))
    ENDIF
  ENDIF
ENDIF

WRITE(fu_prt,'(1x,80a)') ('-',i=1,79)

! concentration of primary component always written to output

WRITE (fu_prt, '(/,'' average '',a,'' concentration'', T50, '': '', e9.3, a6)') namco(:LEN_TRIM(namco)), gemcpri, coneh

IF (idep)THEN

  IF (.NOT.isec) THEN

!   chemical conversion rate

    WRITE (fu_prt,'('' eff. chem. conv. rate'', T50, '': '', f9.3, '' %/h'')') ccr

!   average dry deposition, eff. dry deposition velocity

    WRITE (fu_prt, '(/,'' average dry deposition'', T50, '': '', e9.3, a10)') gemddep, depeh

    WRITE (fu_prt, '('' effective dry deposition velocity'', T50, '': '', f9.3, '' cm/s'')') ddrpri

!   average wet deposition, eff. wet deposition rate, annual precipitation amount

    WRITE (fu_prt, '(/,'' average wet deposition'', T50, '': '', e9.3, a10)') gemwdep, depeh

    WRITE (fu_prt, '('' effective wet deposition rate'', T50, '': '', f9.3, '' %/h'')') wdrpri

    WRITE (fu_prt, '('' annual precipitation amount'', T50, '': '', i9, '' mm'')') NINT(gemprec)

!   average  deposition (dry+wet)

    WRITE (fu_prt, '(/,'' average deposition'', T50, '': '', e9.3, a10)') gemtdep, depeh

  ELSE

!   concentration of secondary component, chemical conversion rate

    WRITE (fu_prt, '(/,'' average '',a,'' concentration'', T50, '': '', e9.3, a6)') namsec(:LEN_TRIM(namsec)), gemcsec,        &
        &  'ug/m3'

    WRITE (fu_prt,'('' eff. '',a,'' > '',a,'' chem. conv. rate'', T50, '': '', f9.3, '' %/h'')') namco(:LEN_TRIM(namco)),      &
        &  namsec(:LEN_TRIM(namsec)), ccr

    IF (icm == 2) THEN

!   concentration of second secondary component

      WRITE (fu_prt, '(/,'' average '',a,'' concentration'', T50, '': '', e9.3, a6)') namseccor(:LEN_TRIM(namseccor)),         &
          &  gemcseccor, 'ug/m3'

    ENDIF

!   mean dry deposition (total), mean dry deposition (primary), mean dry deposition (secondary)

    WRITE (fu_prt, '(/, '' average dry '',a,'' deposition'', '' (as '', a, '')'', T50, '': '', e9.3, a10)')                    &
        &  namse3(:LEN_TRIM(namse3)), namsec(:LEN_TRIM(namsec)), gemddep, depeh

    WRITE (fu_prt,'('' average dry '',a,'' deposition'', '' (as '', a, '')'', T50, '': '', e9.3, a10)')                        &
        &  namco(:LEN_TRIM(namco)), namsec(:LEN_TRIM(namsec)), gemddpri, depeh

    WRITE (fu_prt,'('' average dry '',a,'' deposition '', ''(as '', a, '')'', T50, '': '', e9.3, a10)')                        &
        &  namsec(:LEN_TRIM(namsec)), namsec(:LEN_TRIM(namsec)), gemddsec, depeh

!   effective dry deposition velocity (primary), effective dry deposition velocity (secondary)

    WRITE (fu_prt, '('' effective dry deposition velocity '',a, T50, '': '', f9.3, '' cm/s'')') namco(:LEN_TRIM(namco)),       &
        &  ddrpri

    WRITE (fu_prt, '('' effective dry deposition velocity '',a, T50, '': '', f9.3, '' cm/s'')') namsec(:LEN_TRIM(namsec)),     &
        &  ddrsec

!   mean wet deposition (total), mean wet deposition (primary),mean wet deposition (secondary)

    WRITE (fu_prt, '(/,'' average wet '',a,'' deposition'', '' (as '', a, '')'', T50, '': '', e9.3, a10)')                     &
        &  namse3(:LEN_TRIM(namse3)), namsec(:LEN_TRIM(namsec)), gemwdep, depeh

    WRITE (fu_prt, '('' average wet '',a,'' deposition'', '' (as '', a, '')'', T50, '': '', e9.3, a10)')                       &
        &  namco(:LEN_TRIM(namco)), namsec(:LEN_TRIM(namsec)), gemwdpri, depeh

    WRITE (fu_prt, '('' average wet '',a,'' deposition'', '' (as '', a, '')'', T50, '': '', e9.3, a10)')                       &
        &  namsec(:LEN_TRIM(namsec)), namsec(:LEN_TRIM(namsec)), gemwdsec, depeh

!   effective wet deposition velocity (primary), effective wet deposition velocity (secondary)

    WRITE (fu_prt,'('' effective wet deposition rate '',a, T50, '': '', f9.3, '' %/h'')') namco(:LEN_TRIM(namco)), wdrpri

    WRITE (fu_prt,'('' effective wet deposition rate '',a, T50, '': '', f9.3, '' %/h'')') namsec(:LEN_TRIM(namsec)), wdrsec

!   annual precipitation amount (Region or interpolated)

    WRITE (fu_prt, '('' annual precipitation amount'', T50, '': '', i9, '' mm'')') NINT(gemprec)

!   average deposition (dry + wet)

    WRITE (fu_prt, '(/, '' average '',a,'' deposition'', '' (as '', a, '')'', T50, '': '', e9.3, a10)')                        &
        &  namse3(:LEN_TRIM(namse3)), namsec(:LEN_TRIM(namsec)), gemtdep, depeh

  ENDIF

ENDIF

WRITE(fu_prt,'(1x,80a)') ('-',i=1,79)

RETURN

9000 CALL ErrorCall(ROUTINENAAM, error)

END SUBROUTINE ops_print_recep
