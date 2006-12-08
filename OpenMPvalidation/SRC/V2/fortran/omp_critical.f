<ompts:test>
<ompts:testdescription>Test which checks the omp critical directive by counting up a variable in a parallelized loop within a critical section.

</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp critical</ompts:directive>
<ompts:testcode>
! We use sleep in one thread to ensure the execution order of two threads
! which is not a good practice in OpenMP programming. Need to be fixed
! in future release.
! Functions: check_omp_critical
!********************************************************************

      INTEGER FUNCTION <ompts:testcode:functionname>omp_critical</ompts:testcode:functionname>()
        IMPLICIT NONE
        INTEGER known_sum
        <ompts:orphan:vars>
        INTEGER i, sum
        COMMON /orphvars/ sum, i
        </ompts:orphan:vars>
        sum = 0
!$omp parallel
!$omp do
        DO i = 0 , 999
                <ompts:orphan>
                <ompts:check>
!$omp critical
                </ompts:check>
           sum = sum + i
                <ompts:check>
!$omp end critical
                </ompts:check>
                </ompts:orphan>
        END DO
!$omp end do
!$omp end parallel
        known_sum = 999*1000/2
        IF ( known_sum .EQ. sum ) THEN
          <testfunctionname></testfunctionname> = 1
        ELSE
          WRITE (1,*) "Found sum was", sum, "instead", known_sum
          <testfunctionname></testfunctionname> = 0
        END IF
      END
</ompts:testcode>
</ompts:test>
