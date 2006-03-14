<ompts:test>
<ompts:testdescription>Test which checks the omp parallel copyin directive.</   ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp parallel copyin</ompts:directive>
<ompts:dependences>omp critical,omp threadprivate</ompts:dependences>
<ompts:testcode>
      INTEGER FUNCTION <ompts:testcode:functionname>omp_copyin</ompts:testcode:functionname>()
        IMPLICIT NONE
        INTEGER known_sum
		<ompts:orphan:vars>
! Edit c. Niethammer: removed save statement from variable sum1 because of problems with
! the common block used for the orphaned test.
!        INTEGER, SAVE::sum1
        INTEGER sum1
        INTEGER sum, i
        COMMON /orphvars/ sum1, sum, i
		</ompts:orphan:vars>
!       common/csum1/ sum1
!!!!!!!$omp threadprivate(/csum1/)
!$omp threadprivate(sum1)
        sum = 0
        sum1 = 0
		<ompts:orphan>
!$omp parallel <ompts:check>copyin(sum1)</ompts:check>
!        print *,"sum1",sum1
!$omp do
        DO i=1, 999
          sum1 = sum1 + i
        END DO
!$omp critical
        sum = sum + sum1
!$omp end critical
!$omp end parallel
		</ompts:orphan>
        known_sum = 999*1000/2
        IF ( known_sum .EQ. sum ) THEN
           <testfunctionname></testfunctionname> = 1
        ELSE
           <testfunctionname></testfunctionname> = 0
        END IF
      END
</ompts:testcode>
</ompts:test>
