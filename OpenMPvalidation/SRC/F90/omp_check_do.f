!********************************************************************
! Functions: check_do_ordered
!********************************************************************

	integer function check_i_islarger(i)
        implicit none
	integer i, islarger, last_i
	integer common last_i
	if ( i .gt. last_i) then
	  islarger = 1
	else
	  islarger = 0
	end if
	last_i = i
	check_i_islarger = islarger
	end

	integer function check_do_ordered()
        implicit none
	integer sum, known_sum, i, my_islarger,is_larger,last_i
	integer check_i_islarger
	integer common last_i
	sum = 0
	is_larger = 1
	last_i = 0
!$omp parallel private(my_islarger)
	my_islarger = 1
!$omp do schedule(static,1) ordered
	do i=1, 99
!$omp ordered
	  if ( check_i_islarger(i) .eq. 1 .and. my_islarger .eq. 1) then	
	    my_islarger = 1
	  else
	    my_islarger = 0
	  end if
	  sum = sum + i
!$omp end ordered
	end do
!$omp end do
!$omp critical
	if (is_larger .eq. 1 .and. my_islarger .eq. 1 ) then
	  is_larger = 1
	else
	  is_larger = 0
	end if
!$omp end critical
!$omp end parallel
	known_sum = (99*100)/2
	if ( known_sum .eq. sum .and. is_larger .eq. 1) then
	  check_do_ordered = 1
	else
	  check_do_ordered = 0
	end if
	end 

	integer function crosscheck_do_ordered()
        implicit none
	integer sum, known_sum, i , my_islarger, is_larger, last_i
	integer check_i_islarger
	integer common last_i
	sum = 0
	is_larger = 1
	last_i = 0
!$omp parallel private(my_islarger) 
	my_islarger = 1
!$omp do schedule(static, 1)
	do i=1, 99
	  if ( check_i_islarger(i) .eq. 1 .and. my_islarger .eq. 1 ) then
	    my_islarger = 1
	  else
	    my_islarger = 0 
	  end if
	end do
!$omp end do
!$omp critical
	if ( is_larger .eq. 1 .and. my_islarger .eq. 1 ) then
	  is_larger = 1
	else
	  is_larger = 0
	end if
!$omp end critical
!$omp end parallel 
	known_sum = (99*100)/2
	if ( known_sum .eq. sum .and. is_larger .eq. 1 ) then
	  crosscheck_do_ordered = 1
	else
	  crosscheck_do_ordered = 0 	
	end if
	end

!********************************************************************
! Functions: check_do_reduction
!********************************************************************

	integer function check_do_reduction()
        implicit none
	integer sum, sum2, known_sum, i, i2
	include "omp_testsuite.f"
	sum = 0	
	sum2 = 0
!$omp parallel 
!$omp do schedule(dynamic, 1) reduction(+:sum)
	do i =1, LOOPCOUNT
	  sum = sum + i
	end do
!$omp end do
!$omp end parallel 

!$omp parallel
!$omp do schedule(static, 1) reduction (+: sum2)
	do i2=1, LOOPCOUNT
	  sum2 = sum2 + i2
	end do
!$omp end do
!$omp end parallel
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum .and. known_sum .eq. sum2 ) then
	  check_do_reduction = 1
	else
	  check_do_reduction = 0
	end if
	end

	integer function crosscheck_do_reduction()
        implicit none
	integer sum, sum2, known_sum, i, i2
        include "omp_testsuite.f"
	sum  = 0
	sum2 = 0
!$omp parallel
!$omp do schedule(dynamic, 1)
	do i=1, LOOPCOUNT
  	  sum = sum + i
	end do
!$omp end do
!$omp end parallel	

!$omp parallel
!$omp do schedule(static, 1)
	do i2=1, LOOPCOUNT
	  sum2 = sum2 + i2
	end do
!$omp end do
!$omp end parallel
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum .and. known_sum .eq. sum2 ) then
	  crosscheck_do_reduction = 1
	else
	  crosscheck_do_reduction = 0
	end if
	end

!********************************************************************
! Functions: check_do_private
!********************************************************************

      integer function check_do_private()
      implicit none
      integer sum, sum0, sum1, known_sum, i
      include "omp_testsuite.f"
      sum = 0
      sum0 = 0
      sum1 = 0
!$omp parallel private(sum1)
      sum0 = 0
      sum1 = 0
!$omp do private(sum0) schedule(static,1)
!Yi Wen modified: 05032004
      do i=1, LOOPCOUNT
         sum0=sum1
!$omp flush
        sum0 = sum0 + i
        call do_some_work()
!$omp flush
!        print *, sum0
        sum1 = sum0
      end do
!$omp end do
!$omp critical
      sum = sum + sum1
!$omp end critical
!$omp end parallel
  
      known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
!	 print *, "sum:", sum, "known_sum", known_sum
      if ( known_sum .eq. sum) then
        check_do_private = 1
      else
        check_do_private = 0
      end if
      end

      integer function crosscheck_do_private()
      implicit none
      integer sum, sum0, sum1, known_sum, i
      include "omp_testsuite.f"
      sum = 0
      sum0 = 0
      sum1 = 0
!$omp parallel private(sum1)
      sum0 = 0
      sum1 = 0
!$omp do schedule(static,1)
      do i=1,LOOPCOUNT
        sum0 = sum1
!$omp flush
        sum0 = sum0 + i
        call do_some_work()
!$omp flush
        sum1 = sum0
      end do
!$omp end do
!$omp critical
      sum = sum + sum1
!$omp end critical
!$omp end parallel
      known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
      if ( known_sum .eq. sum ) then
        crosscheck_do_private = 1
      else
        crosscheck_do_private = 0
      endif
      end

	subroutine do_some_work()
	implicit none
	real i
!Yi Wen modified here, f90
	intrinsic sqrt
	double precision sum
	include "omp_testsuite.f"
	sum = 0.0
	do i=0.0, LOOPCOUNT-1,1.0
	  sum = sum + sqrt(i) 
	end do
	end

!********************************************************************
! Functions: check_do_firstprivate
!********************************************************************
      integer function chk_do_firstprivate()
      implicit none
      integer sum, sum0, sum1, known_sum, i
      include "omp_testsuite.f"
      sum = 0
      sum0 = 0
      sum1 = 0
!$omp parallel firstprivate(sum1)
!$omp do firstprivate(sum0)
      do i=1,LOOPCOUNT
        sum0 = sum0 + i
        sum1 = sum0
      end do
!$omp end do
!$omp critical
      sum = sum + sum1
!$omp end critical
!$omp end parallel
      known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
      if ( known_sum .eq. sum ) then
         chk_do_firstprivate = 1
      else
         chk_do_firstprivate = 0
      end if
      end

	integer function crosschk_do_firstprivate()
        implicit none
	integer sum, sum0, sum1, known_sum, i
        include "omp_testsuite.f"
	sum = 0
	sum0 = 0
	sum1 = 0
	
!$omp parallel firstprivate(sum1)
!$omp do
	do i=1,LOOPCOUNT
	  sum0 = sum0 + i
	  sum1 = sum0
	end do
!$omp end do
!$omp critical
	sum = sum + sum1
!$omp end critical
!$omp end parallel
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum ) then
	  crosschk_do_firstprivate = 1
	else
	  crosschk_do_firstprivate = 0
	end if
	end
!********************************************************************
! Functions: check_do_lastprivate
!*******************************************************************

	integer function chk_do_lastprivate()
        implicit none
	integer sum, sum0, known_sum, i, i0
	include "omp_testsuite.f"
	sum = 0
	sum0 = 0
	i0 = -1
!$omp parallel firstprivate(sum0)
!$omp do schedule(static,7) lastprivate(i0)
	do i=1, LOOPCOUNT	
	  sum0 = sum0 + i
   	  i0 = i
	end do
!$omp end do
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp end parallel
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum .and. i0 .eq. LOOPCOUNT ) then
	   chk_do_lastprivate = 1
	else
	   chk_do_lastprivate = 0
	end if
	end 

	integer function crosschk_do_lastprivate()
        implicit none
	integer sum, sum0, known_sum, i, i0
	include "omp_testsuite.f"
	sum = 0
	sum0 = 0
	i0 = -1
!$omp parallel firstprivate(sum0)
!$omp do schedule(static, 7)
	do i=1, LOOPCOUNT
	   sum0 = sum0 + i
	   i0 = i
	end do
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp end parallel
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum .and. i0 .eq. LOOPCOUNT ) then
	  crosschk_do_lastprivate = 1
	else
	  crosschk_do_lastprivate = 0
	end if
	end

!***************************************************************************
! driver function
!***************************************************************************
      subroutine check_omp_do(N,failed,num_tests,crosschecked)
      implicit none
      integer, external::check_do_ordered
      integer, external::crosscheck_do_ordered
      integer, external::check_do_reduction
      integer, external::crosscheck_do_reduction
      integer, external::check_do_private
      integer, external::crosscheck_do_private
      integer, external::chk_do_firstprivate
      integer, external::crosschk_do_firstprivate
      integer, external::chk_do_lastprivate
      integer, external::crosschk_do_lastprivate
      character (len=20)::name
      integer num_tests,crosschecked
      integer failed
      integer N
      name="Do ORDERED"
      call do_test(check_do_ordered,crosscheck_do_ordered,name,
     x N,failed,num_tests,crosschecked)
      name="Do REDUCTION"
      call do_test(check_do_reduction,crosscheck_do_reduction,
     x name,N,failed,num_tests,crosschecked)
      name="Do PRIVATE"
      call do_test(check_do_private,crosscheck_do_private,
     x name,N,failed,num_tests,crosschecked)
      name="Do FIRSTPRIVATE"
      call do_test(chk_do_firstprivate,crosschk_do_firstprivate,
     x name,N,failed,num_tests,crosschecked)
      name="Do LASTPRIVATE"
      call do_test(chk_do_lastprivate,crosschk_do_lastprivate,
     x name,N,failed,num_tests,crosschecked)
      end
