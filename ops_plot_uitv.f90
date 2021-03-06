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
!
! NAME               : %M%
! SCCS(SOURCE)       : %P%
! RELEASE - LEVEL    : %R% - %L%
! BRANCH -SEQUENCE   : %B% - %S%
! DATE - TIME        : %E% - %U%
! WHAT               : %W%:%E%
! AUTHOR             : HvJ/ Franka Loeve (Cap Volmac)
! FIRM/INSTITUTE     : RIVM LLO
! LANGUAGE           : FORTRAN-77/90
! DESCRIPTION        : Write results to plot-file (*.plt)
! EXIT CODES         :
! FILES AND OTHER    :
!    I/O DEVICES
! SYSTEM DEPENDENCIES: HP-Fortran
! CALLED FUNCTIONS   :
! UPDATE HISTORY :
!-------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE ops_plot_uitv(spgrid, isec, coneh, nrrcp, jump, xorg, yorg, nrcol, nrrow, grid, idep, namco, namse3, namsec,        &
                      &  depeh, namrcp, xm, ym, cpri, csec, drydep, wetdep, icm, cseccor, namseccor, error)

USE m_error
USE m_commonfile
USE m_fileutils
USE m_commonconst

IMPLICIT NONE

! SUBROUTINE ARGUMENTS - INPUT
INTEGER*4, INTENT(IN)                            :: spgrid                     ! 
LOGICAL,   INTENT(IN)                            :: isec                       ! 
CHARACTER*(*), INTENT(IN)                        :: coneh                      ! 
INTEGER*4, INTENT(IN)                            :: nrrcp                      ! 
INTEGER*4, INTENT(IN)                            :: jump(nrrcp+1)              ! distance between receptor points in grid units
real,    INTENT(IN)                            :: xorg                       ! 
real,    INTENT(IN)                            :: yorg                       ! 
INTEGER*4, INTENT(IN)                            :: nrcol                      ! number of columns in grid
INTEGER*4, INTENT(IN)                            :: nrrow                      ! number of row in grid
real,    INTENT(IN)                            :: grid                       ! 
LOGICAL,   INTENT(IN)                            :: idep                       ! 
CHARACTER*(*), INTENT(IN)                        :: namco                      ! 
CHARACTER*(*), INTENT(IN)                        :: namse3                     ! 
CHARACTER*(*), INTENT(IN)                        :: namsec                     ! 
CHARACTER*(*), INTENT(IN)                        :: depeh                      ! 
CHARACTER*(*), INTENT(IN)                        :: namrcp(nrrcp)              ! 
real,    INTENT(IN)                            :: xm(nrrcp)                  ! 
real,    INTENT(IN)                            :: ym(nrrcp)                  ! 
real,    INTENT(IN)                            :: cpri(nrrcp)                ! 
real,    INTENT(IN)                            :: csec(nrrcp)                ! 
real,    INTENT(IN)                            :: drydep(nrrcp)              ! 
real,    INTENT(IN)                            :: wetdep(nrrcp)              ! 
INTEGER*4, INTENT(IN)                            :: icm                        ! 
real,    INTENT(IN)                            :: cseccor(nrrcp)             ! 
CHARACTER*(*), INTENT(IN)                        :: namseccor                  ! 

! SUBROUTINE ARGUMENTS - OUTPUT
TYPE (TError), INTENT(OUT)                       :: error                      ! Error handling record

! LOCAL VARIABLES
INTEGER*4                                        :: ierr                       ! 
INTEGER*4                                        :: ls                         ! lengte textstring namse3
INTEGER*4                                        :: j                          ! 
real                                           :: xlb                        ! 
real                                           :: ylb                        ! 
real                                           :: totdep(nrrcp)              ! 

! CONSTANTS
CHARACTER*512                                    :: ROUTINENAAM                ! 
PARAMETER    (ROUTINENAAM = 'ops_plot_uitv')

! SCCS-ID VARIABLES
CHARACTER*81                                     :: sccsida                    ! 
sccsida = '%W%:%E%'//char(0)
!-------------------------------------------------------------------------------------------------------------------------------
!
! Open plot file
!
!IF (.NOT. sysopen(fu_plt, pltnam, 'w', 'plot file', error)) GOTO 9999

IF (spgrid .EQ. 2) THEN

!-------------------------------------------------------
! Tabulated output for non-gridded receptors
!-------------------------------------------------------

  IF (isec) THEN
!
!   Acidifying components
!

    IF (icm == 2) THEN
!
!     NOx
!
      WRITE (fu_plt, '(a4,8x,a10,a10,6a12)', IOSTAT = ierr) 'name', 'x-coord', 'y-coord', 'conc.', 'dry dep.', 'wet dep.',       &
          &  'tot.dep.', 'conc.', 'conc.'
      IF (ierr .GT. 0) GOTO 4200

      ls = LEN_TRIM(namse3)
      WRITE (fu_plt, '(32x,6a12)', IOSTAT = ierr) namco(:LEN_TRIM(namco)), namse3(:ls), namse3(:ls), namse3(:ls),              &
            &  namsec(:LEN_TRIM(namsec)), namseccor(:LEN_TRIM(namseccor))
      IF (ierr .GT. 0) GOTO 4200

      WRITE (fu_plt, '(12x,a10,a10,6a12)', IOSTAT = ierr) 'm', 'm', coneh, depeh, depeh, depeh, 'ug/m3', 'ug/m3'
      IF (ierr .GT. 0) GOTO 4200

      DO j = 1, nrrcp
        WRITE (fu_plt, '(a12,2F10.2,6e12.4)', IOSTAT = ierr) namrcp(j), xm(j), ym(j), cpri(j), drydep(j),             &
                  &  wetdep(j), drydep(j) + wetdep(j), csec(j), cseccor(j)
        IF (ierr .GT. 0) GOTO 4200
      ENDDO

    ELSE
!
!     other than NOx
!
      WRITE (fu_plt, '(a4,8x,a10,a10,5a12)', IOSTAT = ierr) 'name', 'x-coord', 'y-coord', 'conc.', 'dry dep.', 'wet dep.',       &
          &  'tot.dep.', 'conc.'
      IF (ierr .GT. 0) GOTO 4200

      ls = LEN_TRIM(namse3)
      WRITE (fu_plt, '(32x,5a12)', IOSTAT = ierr) namco(:LEN_TRIM(namco)), namse3(:ls), namse3(:ls), namse3(:ls),              &
            &  namsec(:LEN_TRIM(namsec))
      IF (ierr .GT. 0) GOTO 4200

      WRITE (fu_plt, '(12x,a10,a10,5a12)', IOSTAT = ierr) 'm', 'm', coneh, depeh, depeh, depeh, 'ug/m3'
      IF (ierr .GT. 0) GOTO 4200

      DO j = 1, nrrcp
        WRITE (fu_plt, '(a12,2F10.2,5e12.4)', IOSTAT = ierr) namrcp(j), xm(j), ym(j), cpri(j), drydep(j),             &
                  &  wetdep(j), drydep(j) + wetdep(j), csec(j)
        IF (ierr .GT. 0) GOTO 4200
      ENDDO
    ENDIF
  
  ELSE IF (idep) THEN
!
!   Depositions
!  
    WRITE (fu_plt, '(a4,8x,a8,a8,5a12)', IOSTAT = ierr) 'name', 'x-coord', 'y-coord', 'conc.', 'dry dep.', 'wet dep.',         &
          &  'tot.dep.'
    IF (ierr .GT. 0) GOTO 4200

    WRITE (fu_plt, '(28x,5a12)', IOSTAT = ierr) namco(:5), namse3(:5), namse3(:5), namse3(:5)
    IF (ierr .GT. 0) GOTO 4200

    WRITE (fu_plt, '(12x,a8,a8,5a12)', IOSTAT = ierr) 'm', 'm', coneh, depeh, depeh, depeh
    IF (ierr .GT. 0) GOTO 4200

    DO j = 1, nrrcp
      WRITE (fu_plt, '(a12,2i8,5e12.4)', IOSTAT = ierr) namrcp(j), NINT(xm(j)), NINT(ym(j)), cpri(j), drydep(j), wetdep(j),    &
                  &  drydep(j) + wetdep(j)
      IF (ierr .GT. 0) GOTO 4200
    ENDDO

  ELSE
!
!   Non-acidifying substances AND no depositions (.not.idep .and. .not. isec)
!
    WRITE (fu_plt, '(a4,8x,a8,a8,a12)', IOSTAT = ierr) 'name', 'x-coord', 'y-coord', 'conc.'
    IF (ierr .GT. 0) GOTO 4200

    WRITE (fu_plt, '(28x,a12)', IOSTAT = ierr) namco(:5)
    IF (ierr .GT. 0) GOTO 4200

     WRITE (fu_plt, '(12x,a8,a8,a12)', IOSTAT = ierr) 'm', 'm', coneh
    IF (ierr .GT. 0) GOTO 4200

     DO j = 1, nrrcp
       WRITE (fu_plt, '(a12,2i8,e12.4)', IOSTAT = ierr) namrcp(j), NINT(xm(j)), NINT(ym(j)), cpri(j)
       IF (ierr .GT. 0) GOTO 4200
    ENDDO
  ENDIF
  WRITE (fu_plt, '(a1)', IOSTAT = ierr) ' '
ELSE
  
!-------------------------------------------------------
! Grid output (APS format) for gridded receptors
!-------------------------------------------------------

!
! Set (xlb,ylb) = coordinates of left-upper corner of grid
! note: (xorg,yorg) is the centre of the left-upper grid cell
!
  xlb = (xorg - grid/2.)/1000.
  ylb = (yorg + grid/2.)/1000.
!
! Primary concentration
!
  CALL plot_mat(fu_plt, cpri, nrrcp, jump, nrcol, nrrow, 'concentration         ', namco, coneh, grid, xlb, ylb, error)
  IF (error%haserror) GOTO 9000
!
! Depositions (dry, wet, total)
!
  IF (idep) THEN
    CALL plot_mat(fu_plt, drydep, nrrcp, jump, nrcol, nrrow, 'dry deposition        ', namse3, depeh, grid, xlb, ylb, error)
    IF (error%haserror) GOTO 9000

    CALL plot_mat(fu_plt, wetdep, nrrcp, jump, nrcol, nrrow, 'wet deposition        ', namse3, depeh, grid, xlb, ylb, error)
    IF (error%haserror) GOTO 9000

    totdep(:nrrcp) = drydep(:) + wetdep(:)
    CALL plot_mat(fu_plt, totdep, nrrcp, jump, nrcol, nrrow, 'total deposition      ', namse3, depeh, grid, xlb, ylb, error)
    IF (error%haserror) GOTO 9000
  ENDIF
!
! Secondary concentration
!
  IF (isec) THEN
    CALL plot_mat(fu_plt, csec, nrrcp, jump, nrcol, nrrow, 'conctr. sec. component', namsec, 'ug/m3', grid, xlb, ylb, error)
    IF (error%haserror) GOTO 9000
  ENDIF
!
! Second secondary concentration (NOx only, icm = 2)
!
  IF (icm == 2) THEN
    CALL plot_mat(fu_plt, cseccor, nrrcp, jump, nrcol, nrrow, 'NO3 concentration     ', namseccor, 'ug/m3', grid, xlb, ylb,    &
                     &  error)
    IF (error%haserror) GOTO 9000
  ENDIF

ENDIF
!
! Close plot file
!
!CALL sysclose(fu_plt, pltnam,  error)

RETURN

4200 CALL SetError('Error writing plot output', error)
CALL ErrorParam('ierr', ierr, error)

9000 CALL ErrorParam('spgrid', spgrid, error)
CALL ErrorParam('isec', isec, error)
CALL ErrorParam('idep', idep, error)

9999 CALL ErrorCall(ROUTINENAAM, error)
CALL sysclose(fu_plt, pltnam,  error)
RETURN

CONTAINS

!-------------------------------------------------------------------------------------------------------------------------------
! SUBROUTINE : plot_mat
! DESCRIPTION: plotting of matrix
!-------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE plot_mat(lun, value, nrrcp, jump, nrcol, nrrow, descco, compname, compunit, grid, xlb, ylb, error)

USE m_commonconst
USE m_utils

! CONSTANTS
CHARACTER*512                                    :: ROUTINENAAM                ! 
PARAMETER    (ROUTINENAAM = 'plot_mat')

! SUBROUTINE ARGUMENTS - INPUT
INTEGER,   INTENT(IN)                            :: lun                        ! number of unit to which values are written
REAL,      INTENT(IN)                            :: value(nrrcp)               ! values to be displayed in each receptor point
INTEGER,   INTENT(IN)                            :: nrrcp                      ! number of receptor points
INTEGER*4, INTENT(IN)                            :: jump(nrrcp+1)              ! distance between receptor points in grid units
INTEGER,   INTENT(IN)                            :: nrcol                      ! number of elements displayed on row
INTEGER,   INTENT(IN)                            :: nrrow                      ! number of rows in grid
CHARACTER*(*), INTENT(IN)                        :: descco                     ! description of component
CHARACTER*(*), INTENT(IN)                        :: compname                   ! name of component
CHARACTER*(*), INTENT(IN)                        :: compunit                   ! component unit
REAL,      INTENT(IN)                            :: grid                       ! grid size in km
real,    INTENT(IN)                            :: xlb                        ! aps-formatted x-origin (?)
real,    INTENT(IN)                            :: ylb                        ! aps-formatted y-origin (?)

! SUBROUTINE ARGUMENTS - OUTPUT
TYPE (TError), INTENT(OUT)                       :: error                      ! Error handling record

! Local variables
INTEGER                                          :: j                          ! receptor counter
INTEGER                                          :: m                          ! do loop counter
INTEGER                                          :: ierr                       ! error number
INTEGER                                          :: pointto                    ! current receptor point index on line
real                                           :: line(nrcol)                ! value from each row
CHARACTER*80                                     :: formatstring               ! format string in writing
CHARACTER*10                                     :: OPSVERSIE                  ! format string in writing
! ---
450 FORMAT (4i3, 3(1x, a10), 1x, a22, 1x, a6, 1x, i2, 2(1x, f8.3), 2i3, 2(1x, f8.3))
460 FORMAT (4i3, 3(1x, a10), 1x, a22, 1x, a6, 1x, i2, 2(1x, f8.3), 2i4, 2(1x, f8.3))

#ifndef UNIX
  OPSVERSIE(1:2) = 'W-'
#else
  OPSVERSIE(1:2) = 'L-'
#endif
OPSVERSIE(3:10) = MODVERSIE(1:8)

IF (nrcol .LE. 999 .AND. nrrow .LE. 999) THEN
  WRITE (lun, 450, IOSTAT = ierr) 0, 0, 0, 0, compname, compunit, OPSVERSIE, descco, 'e12.4 ', 1, xlb, ylb, nrcol, nrrow,        &
               &  grid/1000, grid/1000
ELSE
  WRITE (lun, 460, IOSTAT = ierr) 0, 0, 0, 0, compname, compunit, OPSVERSIE, descco, 'e12.4 ', 1, xlb, ylb, nrcol, nrrow,        &
               &  grid/1000, grid/1000
ENDIF

IF (ierr .GT. 0) GOTO 1000
!
! Make format string for writing rows of nrcol columns
!
CALL startformat(formatstring, error)
! CALL appendformat(nrcol, 'es11.3', formatstring, error)
CALL appendformat(nrcol, 'e12.4', formatstring, error)
IF (error%haserror) GOTO 9999

pointto = 0
line(:) = -1.E+38                                                                 ! default value
DO j = 1, nrrcp + 1
   pointto = pointto + jump(j)
   DO WHILE (pointto > nrcol)
!
!     This line is written and then reset to defaults. Also adjust pointto
!
      WRITE (lun, formatstring, IOSTAT = ierr) (line(m), m = 1, nrcol)
      IF (ierr .NE. 0) GOTO 1000

      line(:) = -1.E+38                                                            ! reset to default value
      pointto = pointto - nrcol
   ENDDO
!
!  The next receptor point value from matr is inserted into the line.
!
   IF ( j /= nrrcp + 1 ) THEN
      line(pointto) = value(j)
   ENDIF
ENDDO

RETURN

1000 CALL SetError('Error writing matrix to plot file', error)
CALL ErrorParam('ierr', ierr, error)

9999 CALL ErrorParam('Writing parameter', descco, error)
CALL ErrorCall(ROUTINENAAM, error)
RETURN

END SUBROUTINE plot_mat

END SUBROUTINE ops_plot_uitv
