!********************************************************************
! Functions: chk_omp_workshare
! 
! by Chunhua Liao, University of Houston
! Oct. 2005 - First version
! 
! The idea for the test is that if WORKSHARE is not present,
! the array assignment in PARALLEL region will be executed by each 
! thread and then wrongfully repeated several times.
!
! TODO:Do we need test for WHERE and FORALL?
!********************************************************************
        integer function chk_omp_workshare()
        implicit none
        integer scalar0,scalar1,scalar2,scalar3,result
        integer scalar02,scalar12,scalar22,scalar32
        integer, DIMENSION(1000)::AA,BB

        result=0
        scalar0=0
        scalar02=0
        scalar1=0
        scalar12=0
        scalar2=0
        scalar22=0
        scalar3=0
        scalar32=0

        AA=0
        BB=0

!$OMP PARALLEL
!$OMP   WORKSHARE

! test if work is divided or not for array assignment
        AA=AA+1

! test if scalar assignment is treated as a single unit of work
        scalar0=scalar0+1 

! test if atomic is treated as a single unit of work
!$OMP ATOMIC
        scalar1=scalar1+1 
! test if critical is treated as a single unit of work
!$OMP CRITICAL
        scalar2=scalar2+1
!$OMP END CRITICAL

! test if PARALLEL is treated as a single unit of work
!$OMP PARALLEL
        scalar3=scalar3+1
!$OMP END PARALLEL

!$OMP   END WORKSHARE
!$OMP END PARALLEL

!sequential equivalent statements for comparison 
       BB=BB+1
       scalar02=scalar02+1
       scalar12=scalar12+1
       scalar22=scalar22+1
       scalar32=scalar32+1

!      write (1,*) "ck:sum of AA is",SUM(AA)," sum of BB is ",sum(BB)
       if (SUM(AA)/=SUM(BB)) then
            write(1,*) "Array assignment has some problem"
            result=result +1
       endif
       if (scalar0/=scalar02) then
          write(1,*) "Scalar assignment has some problem"
          result = result +1
       endif
       if (scalar1/=scalar12) then
          write(1,*) "Atomic inside WORKSHARE has some problem"
         result = result +1
       endif
       if (scalar2/=scalar22) then
          write(1,*) "CRITICAL inside WORKSHARE has some problem"
         result = result +1
       endif
       if (scalar3/=scalar32) then
           write(1,*) "PARALLEL inside WORKSHARE has some problem"
           result = result +1
       endif

!if anything is wrong, set result to 0
       if (result==0) then
         chk_omp_workshare = 1
       else
          chk_omp_workshare =0
       end if
       end

!********************************************************************
! Functions: crschk_omp_workshare
!
! Simply removing WORKSHARE to get a crosscheck
!********************************************************************

        integer function crschk_omp_workshare()
        implicit none
        integer scalar0,scalar1,scalar2,scalar3,result
        integer scalar02,scalar12,scalar22,scalar32
        integer, DIMENSION(1000)::AA,BB

        result=0
        scalar0=0
        scalar02=0
        scalar1=0
        scalar12=0
        scalar2=0
        scalar22=0
        scalar3=0
        scalar32=0

        AA=0
        BB=0

!$OMP PARALLEL
!!$OMP   WORKSHARE

! test if work is divided or not for array assignment
        AA=AA+1

! test if scalar assignment is treated as a single unit of work
        scalar0=scalar0+1

! test if atomic is treated as a single unit of work
!$OMP ATOMIC
        scalar1=scalar1+1
! test if critical is treated as a single unit of work
!$OMP CRITICAL
        scalar2=scalar2+1
!$OMP END CRITICAL

! test if PARALLEL is treated as a single unit of work
!$OMP PARALLEL
        scalar3=scalar3+1
!$OMP END PARALLEL

!!$OMP   WORKSHARE
!$OMP END PARALLEL

!sequential equivalent statements for comparison
       BB=BB+1
       scalar02=scalar02+1
       scalar12=scalar12+1
       scalar22=scalar22+1
       scalar32=scalar32+1

!      write (1,*) "ck:sum of AA is",SUM(AA)," sum of BB is ",sum(BB)
       if (SUM(AA)/=SUM(BB)) then
            write(1,*) "Array assignment has some problem"
            result=result +1
       endif
       if (scalar0/=scalar02) then
          write(1,*) "Scalar assignment has some problem"
          result = result +1
       endif
       if (scalar1/=scalar12) then
          write(1,*) "Atomic inside WORKSHARE has some problem"
         result = result +1
       endif
       if (scalar2/=scalar22) then
          write(1,*) "CRITICAL inside WORKSHARE has some problem"
         result = result +1
       endif
       if (scalar3/=scalar32) then
           write(1,*) "PARALLEL inside WORKSHARE has some problem"
           result = result +1
       endif

!if anything is wrong, set result to 0
       if (result==0) then
         crschk_omp_workshare = 1
       else
          crschk_omp_workshare =0
       end if

       end

