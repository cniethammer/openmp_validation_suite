<ompts:test>
<ompts:testdescription></ompts:testdescription>
<ompts:version>2.0</ompts:version>
<ompts:directive>omp do firstprivate</ompts:directive>
<ompts:dependences>omp parallel private, omp critical</ompts:dependences>
<ompts:testcode>
      integer function <ompts:testcode:functionname>do_firstprivate</ompts:testcode:functionname>()
      implicit none
      integer sum, known_sum
      integer numthreads
      integer omp_get_num_threads
<ompts:orphan:vars>
      integer sum0, sum1, i
      COMMON /orphvars/ sum0, sum1, i
</ompts:orphan:vars>

      include "omp_testsuite.f"
      sum = 0
      sum0 = 12345 ! bug 162, Liao
      sum1 = 0

!$omp parallel firstprivate(sum1)
!$omp single
      numthreads= omp_get_num_threads()
!$omp end single

<ompts:orphan>
!$omp do <ompts:check>firstprivate(sum0)</ompts:check><ompts:crosscheck>private (sum0)</ompts:crosscheck>
      do i=1,LOOPCOUNT
        sum0 = sum0 + i
        sum1 = sum0
      end do
!$omp end do
</ompts:orphan>

!$omp critical
      sum = sum + sum1
!$omp end critical
!$omp end parallel
      known_sum=12345*numthreads+ (LOOPCOUNT*(LOOPCOUNT+1))/2
      if ( known_sum .eq. sum ) then
         <testfunctionname></testfunctionname> = 1
      else
         <testfunctionname></testfunctionname>= 0
      end if
      end
</ompts:testcode>
</ompts:test>
