!***************************************************************************
!   omp_check_locks.f: an implementation for checking if compilers      
!   implement OMP lock functions correctly
!***************************************************************************
!***************************************************************************
! check set_lock functions
!***************************************************************************
      integer function check_omp_lock()
      USE omp_lib
		implicit none
		integer result
!lock variable
      INTEGER (KIND=OMP_LOCK_KIND) :: lck
!      INTEGER lck
      integer nr_threads_in_single
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      call omp_init_lock(lck)
      nr_iterations=0
      nr_threads_in_single=0
      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
           call omp_set_lock(lck)
!$omp flush
	   nr_threads_in_single=nr_threads_in_single+1
!$omp flush
	   nr_iterations=nr_iterations+1
	   nr_threads_in_single=nr_threads_in_single-1
	   result=result+nr_threads_in_single
	   call omp_unset_lock(lck)
      enddo
!$omp end do       
!$omp end parallel
      call omp_destroy_lock(lck)
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
            check_omp_lock=1
      else
            check_omp_lock=0
      endif    
      end
      
      integer function crosscheck_omp_lock()
      USE omp_lib
		implicit none
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_threads_in_single
		integer result
      INTEGER (KIND=OMP_LOCK_KIND) :: lck
!      INTEGER lck
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      nr_iterations=0
      nr_threads_in_single=0
      call omp_init_lock(lck)
  
      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
!$omp flush
      nr_threads_in_single=nr_threads_in_single+1
!$omp flush           
      nr_iterations=nr_iterations+1
      nr_threads_in_single=nr_threads_in_single-1
      result=result+nr_threads_in_single
      enddo
!$omp end do 
!$omp end parallel  
      call omp_destroy_lock(lck)
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
!		      print *, "cross ckeck : 1"
            crosscheck_omp_lock=1
      else
!		      print *, "cross ckeck : 0"
            crosscheck_omp_lock=0
      endif    
      end

!***************************************************************************
! check testlock functions
!***************************************************************************
      integer function check_omp_testlock()
      USE OMP_LIB
		implicit none
		integer result
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_threads_in_single
      INTEGER (KIND=OMP_LOCK_KIND) :: lck
!      INTEGER  lck
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      nr_iterations=0
      nr_threads_in_single=0
      call omp_init_lock(lck)
  
      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
      DO WHILE (.NOT. OMP_TEST_LOCK(LCK))
      end do
!$omp flush
      nr_threads_in_single=nr_threads_in_single+1
!$omp flush           
      nr_iterations=nr_iterations+1
      nr_threads_in_single=nr_threads_in_single-1
      result=result+nr_threads_in_single
      call omp_unset_lock(lck)
      enddo
!$omp end do 
!$omp end parallel  
      call omp_destroy_lock(lck)
!		print *, result, nr_iterations
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
            check_omp_testlock=1
      else
            check_omp_testlock=0
      endif    
      end

      integer function crosscheck_omp_testlock()
      USE omp_lib
		implicit none
		integer result
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_threads_in_single
      INTEGER (KIND=OMP_LOCK_KIND) :: lck
!      INTEGER lck
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      nr_iterations=0
      nr_threads_in_single=0
      call omp_init_lock(lck)
  
      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
!$omp flush
      nr_threads_in_single=nr_threads_in_single+1
!$omp flush           
      nr_iterations=nr_iterations+1
      nr_threads_in_single=nr_threads_in_single-1
      result=result+nr_threads_in_single
      enddo
!$omp end do 
!$omp end parallel  
      call omp_destroy_lock(lck)
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
            crosscheck_omp_testlock=1
      else
            crosscheck_omp_testlock=0
      endif    
      end

!***************************************************************************
! check nest_lock functions
!***************************************************************************

      integer function check_omp_nest_lock()
      USE OMP_LIB
		implicit none
		integer result
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_threads_in_single
      INTEGER (KIND=OMP_NEST_LOCK_KIND) :: lck
!      INTEGER  lck
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      nr_iterations=0
      nr_threads_in_single=0
      call omp_init_nest_lock(lck)
  
      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
      call OMP_SET_NEST_LOCK(LCK)
!$omp flush
      nr_threads_in_single=nr_threads_in_single+1
!$omp flush           
      nr_iterations=nr_iterations+1
      nr_threads_in_single=nr_threads_in_single-1
      result=result+nr_threads_in_single
      call omp_unset_nest_lock(lck)
      enddo
!$omp end do 
!$omp end parallel  
      call omp_destroy_nest_lock(lck)
!		print *, result, nr_iterations
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
            check_omp_nest_lock=1
      else
            check_omp_nest_lock=0
      endif    
      end

      integer function crosscheck_omp_nest_lock()
      USE omp_lib
		implicit none
		integer result
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_threads_in_single
      INTEGER (KIND=OMP_NEST_LOCK_KIND) :: lck
!      INTEGER lck
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      nr_iterations=0
      nr_threads_in_single=0
      call omp_init_nest_lock(lck)
  
      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
!$omp flush
      nr_threads_in_single=nr_threads_in_single+1
!$omp flush           
      nr_iterations=nr_iterations+1
      nr_threads_in_single=nr_threads_in_single-1
      result=result+nr_threads_in_single
      enddo
!$omp end do 
!$omp end parallel  
      call omp_destroy_nest_lock(lck)
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
            crosscheck_omp_nest_lock=1
      else
            crosscheck_omp_nest_lock=0
      endif    
      end


!***************************************************************************
! check nest_testlock functions
!***************************************************************************

      integer function check_omp_nest_testlock()
      USE OMP_LIB
		implicit none
		integer result
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_threads_in_single
      INTEGER (KIND=OMP_NEST_LOCK_KIND) :: lck
!      INTEGER  lck
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      nr_iterations=0
      nr_threads_in_single=0
      call omp_init_nest_lock(lck)
  
      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
      DO while(OMP_TEST_NEST_LOCK(LCK) .NE. 0)
		end do
!$omp flush
      nr_threads_in_single=nr_threads_in_single+1
!$omp flush           
      nr_iterations=nr_iterations+1
      nr_threads_in_single=nr_threads_in_single-1
      result=result+nr_threads_in_single
      call omp_unset_nest_lock(lck)
      enddo
!$omp end do 
!$omp end parallel  
      call omp_destroy_nest_lock(lck)
!		print *, result, nr_iterations
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
            check_omp_nest_testlock=1
      else
            check_omp_nest_testlock=0
      endif    
      end

      integer function crosscheck_omp_nest_testlock()
      USE omp_lib
		implicit none
		integer result
!result is:
!      0 -- if the test fails
!      1 -- if the test succeeds
      integer nr_threads_in_single
      INTEGER (KIND=OMP_NEST_LOCK_KIND) :: lck
!      INTEGER lck
      integer nr_iterations
      integer i
      include "omp_testsuite.f"
      nr_iterations=0
      nr_threads_in_single=0
      call omp_init_nest_lock(lck)
  
      result=0
!$omp parallel shared(lck,nr_threads_in_single,nr_iterations,result)
!$omp do
      do i=1,LOOPCOUNT
!$omp flush
      nr_threads_in_single=nr_threads_in_single+1
!$omp flush           
      nr_iterations=nr_iterations+1
      nr_threads_in_single=nr_threads_in_single-1
      result=result+nr_threads_in_single
      enddo
!$omp end do 
!$omp end parallel  
      call omp_destroy_nest_lock(lck)
      if(result.eq.0 .and. nr_iterations .eq. LOOPCOUNT) then
            crosscheck_omp_nest_testlock=1
      else
            crosscheck_omp_nest_testlock=0
      endif    
      end

!***************************************************************************
! driver function
!***************************************************************************
      subroutine check_omp_locks(N,failed,num_tests,crosschecked)
		implicit none
		integer, external::check_omp_lock
		integer, external::crosscheck_omp_lock
		integer, external::check_omp_testlock
		integer, external::crosscheck_omp_testlock
		integer, external::check_omp_nest_lock
		integer, external::crosscheck_omp_nest_lock
		integer, external::check_omp_nest_testlock
		integer, external::crosscheck_omp_nest_testlock
		character (len=20)::name
		integer failed
		integer N,num_tests,crosschecked
		name="OMP LOCK"
		call do_test(check_omp_lock,crosscheck_omp_lock,name,N,
     x failed,num_tests,crosschecked)
		name="OMP TEST LOCK"
		call do_test(check_omp_testlock,crosscheck_omp_testlock,
     x name,N,failed,num_tests,crosschecked)
!		name="OMP NEST LOCK"
!		call do_test(check_omp_nest_lock,crosscheck_omp_nest_lock,
!     x  name,N,failed,num_tests,crosschecked)
!		name="OMP NEST TEST LOCK"
!		call do_test(check_omp_nest_testlock,
!     x  crosscheck_omp_nest_testlock,
!     x  name,N,failed,num_tests,crosschecked)
		end

