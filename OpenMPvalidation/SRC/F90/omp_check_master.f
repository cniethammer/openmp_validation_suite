!********************************************************************
! Functions: check_parallel_do_ordered
!********************************************************************

	integer function chk_omp_master_thd()
        implicit none
	integer nthreads, executing_thread
        integer omp_get_thread_num
        nthreads=0
	executing_thread=-1
!$omp parallel
!$omp master
!$omp critical
        nthreads = nthreads + 1
!$omp end critical
	executing_thread=omp_get_thread_num()
!$omp end master
	if ( nthreads .eq. 1 .and. executing_thread .eq. 0) then
 	  chk_omp_master_thd = 1
        else
	  chk_omp_master_thd = 0
	end if
!$omp end parallel
	end

	integer function crosschk_omp_master_thd()
        implicit none
	integer nthreads, executing_thread
	integer omp_get_thread_num
        nthreads=0
        executing_thread=-1
!$omp parallel
!$omp critical
	nthreads = nthreads + 1
!$omp end critical
	executing_thread=omp_get_thread_num()
	if ( nthreads .eq. 1 .and. executing_thread .eq. 0) then
          crosschk_omp_master_thd = 1
        else
          crosschk_omp_master_thd = 0
        end if
!$omp end parallel     	
        end

!***************************************************************************
! driver function
!***************************************************************************
      subroutine check_omp_master(N,failed,num_tests,crosschecked)
      implicit none
      integer, external::chk_omp_master_thd
      integer, external::crosschk_omp_master_thd
      character (len=30)::name
      integer failed
      integer N,num_tests,crosschecked
      
      name="omp MASTER"
      call do_test(chk_omp_master_thd,crosschk_omp_master_thd,
     x  name,N,failed,num_tests,crosschecked)
   
      end
