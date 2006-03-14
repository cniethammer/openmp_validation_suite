<ompts:test>
<ompts:testdescription></ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp single nowait</ompts:directive>
<ompts:dependences>omp critical,omp atomic</ompts:dependences>
<ompts:testcode>
      INTEGER FUNCTION <ompts:testcode:functionname>single_nowait</ompts:testcode:functionname>()
        IMPLICIT NONE
        INTEGER result, nr_iterations, total_iterations, my_iterations,i
        INCLUDE "omp_testsuite.f"

        result=0
        nr_iterations=0
        total_iterations=0
        my_iterations=0

!$omp parallel private(i)
        DO i=0, LOOPCOUNT -1
!$omp single
!$omp atomic
          nr_iterations = nr_iterations + 1
!$omp end single nowait
        END DO
!$omp end parallel
!$omp parallel private(i,my_iterations)
        my_iterations = 0
        DO i=0, LOOPCOUNT -1
!$omp single
          my_iterations = my_iterations + 1
!$omp end single <ompts:check>nowait</ompts:check>
        END DO
!$omp critical
        total_iterations = total_iterations + my_iterations
!$omp end critical
!$omp end parallel
        IF ( nr_iterations .EQ. LOOPCOUNT .AND.
     &     total_iterations .EQ. LOOPCOUNT ) THEN
            <testfunctionname></testfunctionname> = 1
        ELSE
            <testfunctionname></testfunctionname> = 0
        END IF
      END FUNCTION
</ompts:testcode>
</ompts:test>

        integer function crschk_single_nowait()
        integer result, nr_iterations, total_iterations,my_iterations,i
        include "omp_testsuite.f"
        result=0
        nr_iterations=0
        total_iterations=0
        my_iterations=0
!$omp parallel private(i)
        do i = 0, LOOPCOUNT -1
C!$omp single
!$omp atomic
          nr_iterations = nr_iterations + 1
C!omp end single
        end do
!$omp end parallel
!$omp parallel private(i,my_iterations)
        my_iterations = 0
        do i=0, LOOPCOUNT -1
C!$omp single
          my_iterations = my_iterations + 1
C!$omp end single
        end do
!$omp critical
        total_iterations = total_iterations + my_iterations
!$omp end critical
!$omp end parallel
        if ( nr_iterations .eq. LOOPCOUNT .and.
     &       total_iterations .eq. LOOPCOUNT ) then
           crschk_single_nowait = 1
        else
           crschk_single_nowait = 0
        end if
        end

