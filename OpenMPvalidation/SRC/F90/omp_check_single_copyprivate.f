!********************************************************************
! Functions: check_single_copyprivate
!********************************************************************

      integer function check_single_copyprivate(fileunit)
      implicit none
      integer result
      integer fileunit
      integer nr_iterations
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
!$omp end single copyprivate(j)
!$omp critical
       result=result+j-i;
!$omp end critical

       end do
!$omp end parallel
       if(result .eq. 0 .AND. 
     x  nr_iterations .eq. LOOPCOUNT) then
          check_single_copyprivate=1
       else
          check_single_copyprivate=0
       endif
       end


      integer function crosscheck_single_copyprivate(fileunit)
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
!$omp single private(j)
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
          crosscheck_single_copyprivate=1
       else
          crosscheck_single_copyprivate=0
       endif
       end



!***************************************************************************
! driver function
!***************************************************************************
      subroutine check_copyprivate(N,failed,num_tests,crosschecked)
      implicit none
      integer, external::check_single_copyprivate
      integer, external::crosscheck_single_copyprivate

      character (len=20)::name
      integer failed
      integer N
      integer num_tests,crosschecked
      name="single COPYPRIVATE"
      call do_test(check_single_copyprivate,
     & crosscheck_single_copyprivate,
     x name,N,failed,num_tests,crosschecked)
      end

