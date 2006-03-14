<ompts:test>
<ompts:testdescription>Test if the compiler support nested parallelism.</ompts:testdescription>
<ompts:version>2.5</ompts:version>
<ompts:directive>nestedtest</ompts:directive>
<ompts:dependences>omp critical</ompts:dependences>
<ompts:testcode>
        INTEGER FUNCTION <ompts:testcode:functionname>omp_nested</ompts:testcode:functionname>()
!        USE OMP_LIB
        IMPLICIT NONE
        INTEGER counter
        INCLUDE "omp_testsuite.f"

        counter =0
        
		<ompts:check>
!$      CALL OMP_SET_NESTED(.TRUE.)
!#ifdef _OPENMP
!       CALL OMP_SET_NESTED(.TRUE.) 
!#endif
		</ompts:check>
		<ompts:crosscheck>
!$      CALL OMP_SET_NESTED(.FALSE.)
!#ifdef _OPENMP
!       CALL OMP_SET_NESTED(.FALSE.)
!#endif
		</ompts:crosscheck>

!$omp parallel
!$omp critical
        counter = counter + 1
!$omp end critical

!$omp parallel
!$omp critical
          counter = counter - 1
!$omp end critical
!$omp end parallel

!$omp end parallel
        
        IF (counter .EQ. 0 ) THEN
           <testfunctionname></testfunctionname> = 0
        ELSE
           <testfunctionname></testfunctionname> = 1
        END IF 
      END FUNCTION
</ompts:testcode>
</ompts:test>

!********************************************************************
! Functions: crschk_omp_nested
!********************************************************************
        integer function crschk_omp_nested()
!        USE OMP_LIB
        implicit none
        integer counter
        include "omp_testsuite.f"

        counter =0

!$      CALL OMP_SET_NESTED(.FALSE.)
!#ifdef _OPENMP
!       CALL OMP_SET_NESTED(.FALSE.)
!#endif

!$omp parallel
!$omp critical
        counter = counter + 1
!$omp end critical

!$omp parallel
!$omp critical
        counter = counter - 1
!$omp end critical
!$omp end parallel

!$omp end parallel

        if (counter .eq.0 ) then
           crschk_omp_nested = 0
        else
           crschk_omp_nested = 1
        end if
        end

