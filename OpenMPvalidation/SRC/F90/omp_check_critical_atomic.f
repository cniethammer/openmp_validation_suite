!********************************************************************
! Functions: check_omp_critical
!********************************************************************

	integer function check_omp_critical()
        implicit none
	integer i, sum, known_sum
	sum = 0
!$omp parallel
!$omp do
	do i =0, 999
!$omp critical
	   sum = sum + i
!$omp end critical
	end do
!$opm end do
!$omp end parallel
	known_sum = 999*1000/2
	if ( known_sum .eq. sum ) then
	  check_omp_critical = 1
	else
	  check_omp_critical = 0
	end if
	end
	
	integer function crosscheck_omp_critical()
        implicit none
	integer i, sum, known_sum
	sum = 0
!$omp parallel
!$omp do
	do i=0, 999
	 sum = sum + i
	end do
!$omp end do
!$omp end parallel
	known_sum = 999 * 1000/2
	if ( known_sum .eq. sum ) then
	   crosscheck_omp_critical = 1
	else
	   crosscheck_omp_critical = 0
	end if
	end

!********************************************************************
! Functions: check_omp_atomic
!********************************************************************

	integer function check_omp_atomic()
        implicit none
	integer i, sum, known_sum
	sum = 0
!$omp parallel
!$omp do
	do i=0, 999
!$omp atomic
	  sum = sum + i
	end do
!$omp end parallel
	known_sum = 999*1000/2
	if ( known_sum .eq. sum ) then
	  check_omp_atomic = 1
	else
	  check_omp_atomic = 0
	end if
	end	

	integer function crosscheck_omp_atomic()
        implicit none
	integer i, sum, known_sum
	sum = 0
!$omp parallel
!$omp do
	do i=0, 999
	  sum = sum + i
	end do
!$omp end do
!$omp end parallel
	known_sum = 999*1000/2
	if ( known_sum .eq. sum) then
	   crosscheck_omp_atomic = 1
	else
	   crosscheck_omp_atomic = 0
	end if
	end 

        subroutine do_some_work3()
        real i
! Yi Wen modified here		  
        intrinsic sqrt
        double precision sum
        include "omp_testsuite.f"
        sum = 0.0
        do i=0.0, 1000000-1, 1.0
          sum = sum + sqrt(i)
        end do
        end

!********************************************************************
! Functions: check_omp_barrier
!********************************************************************

	integer function check_omp_barrier()
!        use omp_lib
        implicit none
        integer omp_get_thread_num
	integer result1, result2, rank
	result1 = 0
	result2 = 0
!Yi modified here 05042004: privatize rank by sementics
!$omp parallel private(rank)
	rank = omp_get_thread_num()
!        print *, "rank", rank
    	if ( rank .eq. 1 ) then
!Yi modified here 05042004
	  call sleep(2)
	  result2 = 3
	end if	
!$omp barrier
	if ( rank .eq. 0 ) then
	  result1 = result2
	end if
!$omp end parallel
	if ( result1 .eq. 3 ) then
	   check_omp_barrier = 1
	else
	   check_omp_barrier = 0
	end if
	end

	integer function crosscheck_omp_barrier()
!        use omp_lib 
        implicit none
	integer result1, result2, rank
        integer omp_get_thread_num
	result1 = 0
	result2 = 0
!Yi at 05042004 made the same modification as in check_omp_barrier
!$omp parallel private(rank)
	rank = omp_get_thread_num()
	if ( rank .eq. 1 ) then
	  call sleep(2)
	  result2 = 3
	end if
	if ( rank. eq. 0 ) then
	  result1 = result2 
	end if
!$omp end parallel
	if ( result1 .eq. 3 ) then
	   crosscheck_omp_barrier = 1
	else
	   crosscheck_omp_barrier = 0
	end if
	end

!********************************************************************
! Functions: check_omp_flush
!********************************************************************

	integer function check_omp_flush()
!        use omp_lib
        implicit none
	integer result1, result2, dummy, rank
        integer omp_get_thread_num
!Yi modefied at 05042004
        result1=0
        result2=0
!$omp parallel private(rank)
	rank = omp_get_thread_num()
!$omp barrier
	if ( rank .eq. 1 ) then
	  result2 = 3
!$omp flush(result2)
	  dummy = result2
	end if
	if ( rank .eq. 0 ) then
	  call sleep(1)
!$omp flush(result2)
	  result1 = result2
	end if
!$omp end parallel
c        print *,"1:", result1, "2:", result2, "dummy", dummy
    	if ( result1 .eq. result2 .and. result2 .eq. dummy .and.
     &       result2 .eq. 3 ) then
	   check_omp_flush = 1
	else
	   check_omp_flush = 0
	end if
	end

	integer function crosscheck_omp_flush()
!        use omp_lib
        implicit none
	integer result1, result2, dummy, rank
	integer  omp_get_thread_num
	result1 = 0
	result2 = 0
!Yi modified at 05042004
!$omp parallel private(rank)
	rank = omp_get_thread_num()
!	print *, "rank", rank
!$omp barrier
	if ( rank .eq. 1 ) then
	  result2 = 3
	  dummy = result2
	end if
	if ( rank .eq. 0) then
	  call sleep(1)
	  result1 = result2
	end if
!$omp end parallel
	if ( result1 .eq. result2 .and. result2 .eq. dummy .and.
     &       result2 .eq. 3 ) then
	    crosscheck_omp_flush = 1
	else
	     crosscheck_omp_flush = 0
	end if
	end


!***************************************************************************
! driver function
!***************************************************************************

      subroutine check_omp_critical_automics(N,failed,num_tests,
     x  crosschecked)
		implicit none
		integer, external::check_omp_critical
		integer, external::crosscheck_omp_critical
                integer, external::check_omp_atomic
		integer, external::crosscheck_omp_atomic
		integer, external::check_omp_barrier
		integer, external::crosscheck_omp_barrier
		integer, external::check_omp_flush
		integer, external::crosscheck_omp_flush
		character (len=20)::name
		integer failed
		integer N,num_tests,crosschecked
		name="OMP CRITICAL"
		call do_test(check_omp_critical,crosscheck_omp_critical,
     x  name,N,failed,num_tests,crosschecked)
                name="OMP ATOMIC"
	call do_test(check_omp_atomic,crosscheck_omp_atomic,
     x  name,N,failed,num_tests,crosschecked)
                name="OMP BARRIER"
		call do_test(check_omp_barrier,crosscheck_omp_barrier,
     x  name,N,failed,num_tests,crosschecked)
!           name="OMP FLUSH"
!		call do_test(check_omp_flush,crosscheck_omp_flush,
!     x  name,N,failed,num_tests,crosschecked)

		end
