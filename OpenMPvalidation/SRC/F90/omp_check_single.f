!********************************************************************
! Functions: check_single
!********************************************************************

	integer function check_single()
        implicit none
	integer nr_threads_in_single, result, nr_iterations,i
	include "omp_testsuite.f"
	nr_threads_in_single=0
	result=0	
	nr_iterations=0
!$omp parallel
	do i=0, LOOPCOUNT-1
!$omp single
!$omp flush
	  nr_threads_in_single = nr_threads_in_single + 1
!$omp flush
	  nr_iterations = nr_iterations + 1
	  nr_threads_in_single = nr_threads_in_single - 1
	  result = result + nr_threads_in_single
!$omp end single
	end do
!$omp end parallel
	if ( result .eq. 0 .and. nr_iterations .eq. LOOPCOUNT ) then
	   check_single = 1
	else
	   check_single = 0
	end if
	end

	integer function crosscheck_single()
        implicit none
        integer nr_threads_in_single, result, nr_iterations,i
        include "omp_testsuite.f"
        nr_threads_in_single=0
        result=0
        nr_iterations=0
!$omp parallel
        do i=0, LOOPCOUNT-1
!$omp single
!$omp flush
	  nr_threads_in_single = nr_threads_in_single + 1
!$omp flush
	  nr_iterations = nr_iterations + 1
	  nr_threads_in_single = nr_threads_in_single + 1
	  result = result + nr_threads_in_single
!$omp end single
	end do
!$omp end parallel
	if ( result .eq. 0 .and. nr_iterations .eq. LOOPCOUNT ) then
	  crosscheck_single = 1
	else
	  crosscheck_single = 0
	end if
	end

!********************************************************************
! Functions: check_single_private
!********************************************************************

	integer function check_single_private()
        implicit none
	integer nr_threads_in_single, result, myresult, myit
	integer nr_iterations, i
	include "omp_testsuite.f"
	nr_threads_in_single=0
	result=0
	myresult=0
	myit=0
	nr_iterations=0
!$omp parallel private(i, myresult, myit)
	myresult = 0
	myit = 0
	do i=0, LOOPCOUNT -1

!$omp single private(nr_threads_in_single)
	  nr_threads_in_single = 0
!$omp flush
	  nr_threads_in_single = nr_threads_in_single + 1
!$omp flush
	  myit = myit + 1
	  nr_threads_in_single = nr_threads_in_single - 1
	  myresult = myresult + nr_threads_in_single
!$omp end single nowait
	end do
!$omp critical
	result = result + myresult
	nr_iterations = nr_iterations + myit
!$omp end critical
!$omp end parallel
	if ( result .eq. 0 .and. nr_iterations .eq. LOOPCOUNT) then
 	   check_single_private = 1	
	else
	   check_single_private = 0
	end if
	end

	integer function crosscheck_single_private()
        implicit none
	integer nr_threads_in_single, result, myresult, myit
	integer nr_iterations, i
	include "omp_testsuite.f"
	nr_threads_in_single =0 
	result=0
	myresult=0
	myit=0
	nr_iterations=0
!$omp parallel private(i,myresult, myit)
	myresult = 0
	myit = 0
	do i = 0, LOOPCOUNT -1
!$omp single
	  nr_threads_in_single = 0
!$omp flush
	  nr_threads_in_single = nr_threads_in_single + 1
!$omp flush
	  myit = myit + 1
	  nr_threads_in_single = nr_threads_in_single - 1
	  myresult = myresult + nr_threads_in_single
!$omp end single nowait
	end do
!$omp critical 
	result = result + myresult
	nr_iterations = nr_iterations + myit
!$omp end critical
!$omp end parallel
	if ( result .eq. 0 .and. nr_iterations .eq. LOOPCOUNT) then
	   crosscheck_single_private = 1
	else
	   crosscheck_single_private = 0
	endif
	end

!	integer function check_single_copyprivate()
!	integer nr_threads_in_single, result, result2
!	integer nr_iterations, i,j
!	include "omp_testsuite.f"
!	nr_threads_in_single=0
!	result=0
!	result2=0
!	nr_iterations=0
!!$omp parallel private(i,j)
!	do i=0, LOOPCOUNT-1
!!$omp single copyprivate(j)
!!$omp flush
!	  nr_threads_in_single = nr_threads_in_single + 1
!!$omp flush
!	  nr_iterations = nr_iterations + 1
!	  nr_threads_in_single = nr_threads_in_single - 1
!	  result = result + nr_threads_in_single
!	  j = result
!! not sure where to end single here
!!$omp end single
!	end do
!!$omp end parallel
!	if ( j .eq. 0 .and. nr_iterations .eq. LOOPCOUNT )then
!	   check_single_copyprivate = 1
!	else
!	   check_single_copyprivate = 0
!	end if
!	end

!********************************************************************
! Functions: check_single_nowait
!********************************************************************

	integer function check_single_nowait()
        implicit none
	integer result, nr_iterations, total_iterations, my_iterations,i
	include "omp_testsuite.f"
	result=0
	nr_iterations=0
	total_iterations=0
	my_iterations=0
!$omp parallel private(i)
	do i=0, LOOPCOUNT -1
!$omp single 
!$omp atomic
	  nr_iterations = nr_iterations + 1
!$omp end single nowait
	end do
!$omp end parallel
!$omp parallel private(i,my_iterations)
	my_iterations = 0
	do i=0, LOOPCOUNT -1
!$omp single 
	  my_iterations = my_iterations + 1
!$omp end single nowait
	end do
!$omp critical
	total_iterations = total_iterations + my_iterations
!$omp end critical
!$omp end parallel
	if ( nr_iterations .eq. LOOPCOUNT .and.
     &     total_iterations .eq. LOOPCOUNT ) then
	    check_single_nowait = 1
	else
	    check_single_nowait = 0
	end if
	end		

	integer function crosscheck_single_nowait()
	integer result, nr_iterations, total_iterations,my_iterations,i
	include "omp_testsuite.f"
	result=0
	nr_iterations=0
	total_iterations=0
	my_iterations=0
!$omp parallel private(i)
	do i = 0, LOOPCOUNT -1
C!$omp single  
!$omp atomic
	  nr_iterations = nr_iterations + 1
C!omp end single
	end do
!$omp end parallel
!$omp parallel private(i,my_iterations)
	my_iterations = 0
	do i=0, LOOPCOUNT -1
C!$omp single
	  my_iterations = my_iterations + 1
C!$omp end single
	end do
!$omp critical
	total_iterations = total_iterations + my_iterations
!$omp end critical
!$omp end parallel
	if ( nr_iterations .eq. LOOPCOUNT .and.
     &       total_iterations .eq. LOOPCOUNT ) then
	   crosscheck_single_nowait = 1
	else
	   crosscheck_single_nowait = 0
	end if
	end


!***************************************************************************
! driver function
!***************************************************************************
      subroutine check_omp_single(N,failed,num_tests,crosschecked)
      implicit none
      integer, external::check_single
      integer, external::crosscheck_single
      integer, external::check_single_private
      integer, external::crosscheck_single_private
      integer, external::check_single_nowait
      integer, external::crosscheck_single_nowait
      character (len=20)::name
      integer failed
      integer N
      integer num_tests,crosschecked
      name="SINGLE"
      call do_test(check_single,crosscheck_single,name,
     x N,failed,num_tests,crosschecked)
      name="Single PRIVATE"
      call do_test(check_single_private,crosscheck_single_private,
     x name,N,failed,num_tests,crosschecked)
      name="Single NOWAIT"
      call do_test(check_single_nowait,crosscheck_single_nowait,
     x name,N,failed,num_tests,crosschecked)
      end
