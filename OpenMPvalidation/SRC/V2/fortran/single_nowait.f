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
<ompts:check>!$omp single</ompts:check>
!$omp atomic
          nr_iterations = nr_iterations + 1
<ompts:check>!$omp end single nowait</ompts:check>
        END DO
!$omp end parallel
!$omp parallel private(i,my_iterations)
        my_iterations = 0
        DO i=0, LOOPCOUNT -1
<ompts:check>!$omp single</ompts:check>
          my_iterations = my_iterations + 1
<ompts:check>!$omp end single nowait</ompts:check>
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
