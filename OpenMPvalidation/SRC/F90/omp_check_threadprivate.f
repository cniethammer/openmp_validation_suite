!********************************************************************
! Functions: check_omp_threadprivate
!********************************************************************
!Yi Wen modified this function from his own understanding of the semantics
!of C version at 05042004
!The undeestanding is that sum0 and myvalue can be local static variables
!of the check_omp_threadprivate function. There is no need to use common
!block
        integer function check_omp_threadprivate()
        implicit none
	integer sum, known_sum, i , iter, rank,size, failed
!Yi Wen modified at 05042004 : add "save"
	integer,save:: sum0
        real, save::myvalue
	integer omp_get_num_threads, omp_get_thread_num
        real my_random
	real, allocatable:: data(:)
        integer random_size
	intrinsic random_number
        intrinsic random_seed
        external omp_set_dynamic
!Yi Wen commented two common blocks
!	common/csum0/ sum0
!	common/cmyvalue/ myvalue
!!!!!!!!!!$omp threadprivate(/csum0/,/cmyvalue/)
!$omp threadprivate(sum0,myvalue)
	include "omp_testsuite.f"
	sum = 0
	failed = 0
        sum0=0
        myvalue=0
        random_size=45
        call omp_set_dynamic(0)
!$omp parallel
	sum0 = 0
!$omp do
	do i=1, LOOPCOUNT
	  sum0 = sum0 + i
	end do
!$omp end do
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp end parallel
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .ne. sum ) then
	  print *, ' known_sum =', known_sum, ', sum =',sum
	end if

	call omp_set_dynamic(0)
	
!$omp parallel
!$omp master
	size = omp_get_num_threads()
	allocate ( data(size) )
!$omp end master
!$omp end parallel
        call random_seed(SIZE=random_size)
	do iter = 0, 99
	  call random_number(harvest=my_random)
!$omp parallel private(rank)
	  rank = omp_get_thread_num()
	  myvalue = my_random + rank
	  data(rank) = myvalue
!$omp end parallel
!$omp parallel private(rank)
	  rank = omp_get_thread_num()
	  if ( myvalue .ne. data(rank) ) then
	   failed = failed + 1
	   print *, ' myvalue =',myvalue,' data(rank)=', data(rank)
	  end if
!$omp end parallel
	end do
	deallocate( data)
	if ( known_sum .eq. sum .and. failed .ne. 1) then
	  check_omp_threadprivate = 1
	else
	  check_omp_threadprivate = 0 
	end if
	end

	integer function crosscheck_omp_threadprivate()
        implicit none
	integer sum, known_sum, i, iter, rank, size, failed
	integer sum1
        real my_random
        integer, save::crosssum0
        real, save::crossmyvalue
        integer omp_get_num_threads,omp_get_thread_num
        integer random_size
	intrinsic random_number
        intrinsic random_seed
        external omp_set_dynamic
	real, allocatable :: data(:)
!	common sum0, myvalue, crossmyvalue
!Yi Wen commented comm block below at 05042004
!	common/csum1/sum1
!!!!!!!!!$omp threadprivate(/csum1/)
        include "omp_testsuite.f"
	sum1 = 789
        sum = 0
	failed = 0
        random_size=45
	call omp_set_dynamic(0)
!$omp parallel
	crosssum0 = 0
!$omp do 
	do i=1, LOOPCOUNT
	   crosssum0 = crosssum0 + i
	end do
!$omp end do
!$omp critical
	sum = sum + crosssum0
!$omp end critical
!$omp end parallel
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
!$omp parallel
!$omp master
	size = omp_get_num_threads()
	allocate ( data(size) )
!$omp end master
!$omp end parallel
        call random_seed(SIZE=random_size)
	do iter = 0, 99
	   call random_number(harvest=my_random)
!$omp parallel private(rank)
	   rank = omp_get_thread_num()
	   crossmyvalue = my_random + rank
	   data(rank) = crossmyvalue
!$omp end parallel
!$omp parallel reduction(+:failed) private(rank)
	   rank = omp_get_thread_num()
	   if ( crossmyvalue .ne. data(rank) ) then
	     failed = failed + 1
 	   end if
!$omp end parallel
	end do
	deallocate(data)
	if ( known_sum .eq. sum .and. failed .ne. 1) then
	  crosscheck_omp_threadprivate = 1
	else
	  crosscheck_omp_threadprivate = 0
	end if
	end

!********************************************************************
! Functions: check_omp_copyin
!********************************************************************

	integer function check_omp_copyin()
        implicit none
	integer sum, known_sum, i
!Yi Wen at 05042004 modified to add "save" for sum1 and
!commented the below common block
        integer, save::sum1
!	common/csum1/ sum1
!!!!!!!$omp threadprivate(/csum1/)
!$omp threadprivate(sum1)
	sum = 0
	sum1 = 0
!$omp parallel copyin(sum1)
!        print *,"sum1",sum1
!$omp do
	do i=1, 999
	  sum1 = sum1 + i
	end do
!$omp critical
	sum = sum + sum1
!$omp end critical
!$omp end parallel
	known_sum = 999*1000/2
	if ( known_sum .eq. sum ) then
	   check_omp_copyin = 1
	else
	   check_omp_copyin = 0
	end if
	end

	integer function crosscheck_omp_copyin()
        implicit none
	integer sum, known_sum, i
!Yi Wen at 05042004, same modification
        integer, save::crosssum1
!	common/ccrosssum1/ crosssum1
!!!!!!!!$omp threadprivate(/ccrosssum1/)
!$omp threadprivate(crosssum1)
	sum = 0
	crosssum1 = 789
!$omp parallel
!	print *,"cs",crosssum1
!$omp do
	do i=1, 999
	  crosssum1 = crosssum1 + i
	end do
!$omp end do
!$omp critical
	sum = sum + crosssum1
!$omp end critical
!$omp end parallel
	known_sum = 999*1000/2
	if ( known_sum .eq. sum ) then
	    crosscheck_omp_copyin = 1
	else
	    crosscheck_omp_copyin = 0
	end if
	end

!********************************************************************
! Functions: check_omp_copyprivate
!********************************************************************

	integer function check_omp_copyprivate()
        implicit none
	integer sum, known_sum, i, sum0
	common /csum0/ sum0
!$omp threadprivate(/csum0/)
	sum = 0
!$omp parallel
	do i=1, 999
!$omp single 
	  sum0 = sum0 + i
!$omp end single copyprivate(/csum0/)
!$omp critical
	  sum = sum + sum0
!$omp end critical
	end do
!$omp end parallel
	known_sum = 999* 1000/2
	if ( known_sum .eq. sum ) then
	   check_omp_copyprivate = 1
	else
	   check_omp_copyprivate = 0
	end if
	end

	integer function crosscheck_spmd_threadprivate()
!        implicit none
	integer iter, rank, size, failed 
        real myvalue2
        real my_random
        integer random_size
	intrinsic random_number
        intrinsic random_seed
	real, allocatable:: data(:)
	integer omp_get_num_threads, omp_get_thread_num
	failed = 0
	myvalue2 = 2
        random_size=45
!$omp parallel
!$omp master
	size = omp_get_num_threads()
	allocate( data(size) )
!$omp end master
!$omp end parallel
	do iter=0, 999
!$omp parallel private(rank)
	   rank = omp_get_thread_num()
           call random_seed(SIZE=random_size)
	   call random_number(harvest=my_random)
	   myvalue2 = my_random + rank
!$omp end parallel
!$omp parallel reduction(+:failed) private(rank)
	   rank = omp_get_thread_num()
	   if ( myvalue2 .ne. data(rank) ) then
	     failed = failed + 1
	   end if
!$omp end parallel
	end do
	deallocate ( data )
	if ( failed .ne. 1) then
	   crosscheck_spmd_threadprivate = 1
	else
	   crosscheck_spmd_threadprivate = 0
	end if
	end


!***************************************************************************
! driver function
!***************************************************************************

      subroutine omp_check_threadprivate(N,failed,num_tests,
     x  crosschecked)
		implicit none
		integer, external::check_omp_threadprivate
		integer, external::crosscheck_omp_threadprivate
                integer, external::check_omp_copyin
                integer, external::crosscheck_omp_copyin
		character (len=30)::name
		integer failed
		integer N,num_tests,crosschecked
		name="OMP THREADPRIVATE"
		call do_test(check_omp_threadprivate,
     x      crosscheck_omp_threadprivate,name,N,failed,
     x      num_tests,crosschecked)
                name="OMP COPYIN"
	call do_test(check_omp_copyin,crosscheck_omp_copyin,
     x  name,N,failed,num_tests,crosschecked)
		end
