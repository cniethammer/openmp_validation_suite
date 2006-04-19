<ompts:test>
<ompts:testdescription>Test which checks the omp single copyprivate directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp single copyprivate</ompts:directive>
<ompts:dependences>omp parllel,omp critical</ompts:dependences>
<ompts:testcode>
      INTEGER FUNCTION <ompts:testcode:functionname>single_copyprivate</ompts:testcode:functionname>()
        IMPLICIT NONE
        INTEGER result
        INTEGER nr_iterations
        INTEGER i
        INTEGER j,thread
        INTEGER omp_get_thread_num
        INCLUDE "omp_testsuite.f"

        result=0
        nr_iterations=0

!$omp parallel private(i,j,thread)
        DO i=0,LOOPCOUNT-1
          thread=OMP_GET_THREAD_NUM()
!$omp single 
          nr_iterations=nr_iterations+1
          j=i
!$omp end single <ompts:check>copyprivate(j)</ompts:check>
!$omp critical
          result=result+j-i;
!$omp end critical
        END DO
!$omp end parallel
        IF(result .EQ. 0 .AND. 
     &     nr_iterations .EQ. LOOPCOUNT) THEN
          <testfunctionname></testfunctionname>=1
        ELSE
          <testfunctionname></testfunctionname>=0
        END IF
      END FUNCTION
</ompts:testcode>
</ompts:test>


      integer function crschk_single_copyprivate(fileunit)
      implicit none
      integer result
      integer nr_iterations
      integer fileunit
      integer i
      integer j,thread
      integer omp_get_thread_num
      include "omp_testsuite.f"
      result=0
      nr_iterations=0
!$omp parallel private(i,j,thread)
      do i=0,LOOPCOUNT-1
	thread=omp_get_thread_num()
!$omp single 
	nr_iterations=nr_iterations+1
	j=i
!$omp end single
!$omp critical
       result=result+j-i;
!$omp end critical

       end do
!$omp end parallel
       if(result .eq. 0 .AND. 
     x  nr_iterations .eq. LOOPCOUNT) then
          crschk_single_copyprivate=1
       else
          crschk_single_copyprivate=0
       endif
       end

