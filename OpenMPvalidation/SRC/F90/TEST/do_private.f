<ompts:test>
<ompts:testdescription></ompts:testdescription>
<ompts:version>2.0</ompts:version>
<ompts:directive>omp do private</ompts:directive>
<ompts:dependences>omp parallel private, omp flush, omp critical</ompts:dependences>
<ompts:testcode>
      subroutine do_some_work()
        implicit none
        real i
        intrinsic sqrt
        double precision sum
        include "omp_testsuite.f"
        sum = 0.0
        do i=0.0, LOOPCOUNT-1,1.0
          sum = sum + sqrt(i)
        end do
      end

      integer function <ompts:testcode:functionname>do_private</ompts:testcode:functionname>()
        implicit none
        integer sum, known_sum
<ompts:orphan:vars>
        integer sum0, sum1, i
        COMMON /orphvars/ sum0, sum1, i
</ompts:orphan:vars>        

        include "omp_testsuite.f"
        sum = 0
        sum0 = 0
        sum1 = 0
!$omp parallel private(sum1)
        sum0 = 0
        sum1 = 0
<ompts:orphan>
!$omp do <ompts:check>private(sum0)</ompts:check> schedule(static,1)
        do i=1, LOOPCOUNT
           sum0 = sum1
!$omp flush
          sum0 = sum0 + i
          call do_some_work()
!$omp flush
!          print *, sum0
          sum1 = sum0
        end do
!$omp end do
</ompts:orphan>
!$omp critical
        sum = sum + sum1
!$omp end critical
!$omp end parallel

        known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
!        print *, "sum:", sum, "known_sum", known_sum
        if ( known_sum .eq. sum) then
           <testfunctionname></testfunctionname> = 1
        else
           <testfunctionname></testfunctionname> = 0
        end if
      end
</ompts:testcode>
</ompts:test>
