!********************************************************************
! Functions: check_parallel_do_ordered
!********************************************************************

	integer function check_i_islarger2(i)
        implicit none
        integer i
        common last_i
	integer last_i,islarger
        include "omp_testsuite.f"
!        print *, "last_i",last_i, "i", i
! last_i is a global variable
	if ( i .gt. last_i ) then
	  islarger = 1
	else
	  islarger = 0
	end if
	last_i = i
	check_i_islarger2 = islarger
	end

	integer function chk_par_do_ordered()
        implicit none
        common last_i
	integer sum, known_sum,i, is_larger,last_i
	integer check_i_islarger2
	
	sum=0
	is_larger=1
	last_i=0
!$omp parallel do schedule(static, 1) ordered
	do i=1, 99
!$omp ordered
	  if( check_i_islarger2(i) .eq. 1 .and. is_larger .eq. 1 ) then	  
	    is_larger = 1
	  else
	    is_larger = 0
	  end if
	  sum = sum + i
!$omp end ordered
	end do
!$omp end parallel do
	known_sum = (99*100)/2
!Yi Wen; Sun compiler will fail sometimes
!        print *, "sum", sum, "ks", known_sum, "la", is_larger
	if ( known_sum .eq. sum .and. is_larger .eq. 1 ) then
	   chk_par_do_ordered = 1
	else
	   chk_par_do_ordered = 0
	end if
	end

	integer function crosschk_par_do_ordered()
        implicit none
	integer sum,known_sum, i, is_larger, last_i
	integer check_i_islarger2
	common last_i
	sum=0
	is_larger=1
	last_i=0
!$omp parallel do schedule(static, 1) 
	do i=1, 99
	  if( check_i_islarger2(i) .eq. 1 .and. is_larger .eq. 1) then
            is_larger = 1
          else
            is_larger = 0
          end if
          sum = sum + i
	end do
!$omp end parallel do
	known_sum = (99*100)/2
	if ( known_sum .eq. sum .and. is_larger .eq. 1) then
	   crosschk_par_do_ordered = 1
	else
	   crosschk_par_do_ordered = 0
	end if
	end 

!********************************************************************
! Functions: check_parallel_do_reduction
!********************************************************************

	integer function chk_par_do_reduction()
        implicit none
	integer sum,known_sum,i
	include "omp_testsuite.f"
	sum = 0
!$omp parallel do schedule(dynamic,1) reduction(+:sum)
	do i=1, LOOPCOUNT
	  sum = sum + i
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum) then
	  chk_par_do_reduction = 1
	else
	  chk_par_do_reduction = 0
	end if
	end 

	integer function crosschk_par_do_reduction()
        implicit none
	integer sum, known_sum, i
	include "omp_testsuite.f"
	sum = 0
!$omp parallel do schedule(dynamic,1)
	do i=1, LOOPCOUNT
	  sum = sum + i
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum ) then
	  crosschk_par_do_reduction = 1
	else
	  crosschk_par_do_reduction = 0
	end if
	end

	subroutine do_some_work2()
        implicit none
	real i
	double precision sum
	intrinsic sqrt
	include "omp_testsuite.f"
	sum = 0.0
	do i=0, LOOPCOUNT,1.0
	   sum = sum + sqrt(i)
!	   sum = sum + exp(i)
!	   sum = sum + sin(i)
	end do
	end


!********************************************************************
! Functions: check_parallel_do_private
!********************************************************************

	integer function chk_par_do_private()
        implicit none
	integer sum,known_sum, i, i2, i3
        include "omp_testsuite.f"
	sum = 0
!$omp parallel do reduction(+:sum) private(i2) schedule(static,1)
	do i=1, LOOPCOUNT
	  i2 = i
!$omp flush
	  call do_some_work2()
!$omp flush
	  sum = sum + i2
	end do
!$omp end parallel do
 	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum ) then
	  chk_par_do_private = 1
	else
	  chk_par_do_private = 0
	end if
	end

	integer function crosschk_par_do_private()
        implicit none
	integer sum, known_sum, i, i2, i3
	include "omp_testsuite.f"
	sum = 0
!$omp parallel do reduction(+:sum) schedule(static,1)
	do i=1,LOOPCOUNT
	  i2 = i	
!$omp flush
	  call do_some_work2()	
!$omp flush
	  sum = sum + i2
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum) then
	  crosschk_par_do_private = 1
	else
	  crosschk_par_do_private = 0
	end if
	end
!********************************************************************
! Functions: check_parallel_do_firstprivate
!********************************************************************

	integer function chk_par_do_firstprivate()
        implicit none
	integer sum,known_sum, i2, i
	include "omp_testsuite.f"
	sum =0
	i2 = 3
!$omp parallel do firstprivate(i2) reduction(+:sum)
	do i=1, LOOPCOUNT
	  sum = sum + ( i+ i2)
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2+3*LOOPCOUNT
	if ( known_sum .eq. sum ) then
	  chk_par_do_firstprivate = 1
	else
	  chk_par_do_firstprivate = 0
	end if
	end

	integer function crosschk_par_do_firstprivate()
        implicit none
	integer sum, known_sum, i2,i
	include "omp_testsuite.f"
	sum = 0
	i2 = 3
!$omp parallel do private(i2) reduction(+: sum)
	do i=1, LOOPCOUNT	
	  sum = sum + (i+ i2)
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2+3*999
	if ( known_sum .eq. sum ) then
	  crosschk_par_do_firstprivate = 1
	else
	  crosschk_par_do_firstprivate = 0
	end if
	end 


!********************************************************************
! Functions: check_parallel_do_lastprivate
!********************************************************************

	integer function chk_par_do_lastprivate()
        implicit none
	integer sum, known_sum, i , i0
	include "omp_testsuite.f"
	sum = 0
	i0 = -1
!$omp parallel do reduction(+:sum) schedule(static,7) lastprivate(i0)	
	do i=1, LOOPCOUNT
	  sum = sum + i
	  i0 = i
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum .and. i0 .eq. LOOPCOUNT ) then
	  chk_par_do_lastprivate = 1
	else
	  chk_par_do_lastprivate = 0
	end if
	end   

	integer function crosschk_par_do_lastprivate()
        implicit none
	integer sum, known_sum, i , i0
	include "omp_testsuite.f"
	sum = 0
	i0 = -1
!$omp parallel do reduction(+:sum) schedule(static,7) private(i0)	
	do i=1, LOOPCOUNT
	  sum = sum + i
	  i0 = i
	end do
!$omp end parallel do
	known_sum = (LOOPCOUNT*(LOOPCOUNT+1))/2
	if ( known_sum .eq. sum .and. i0 .eq. LOOPCOUNT ) then
	  crosschk_par_do_lastprivate = 1
	else
	  crosschk_par_do_lastprivate = 0
	end if
	end   

!***************************************************************************
! driver function
!***************************************************************************
      subroutine check_omp_parallel_do(N,failed,num_tests,crosschecked)
      implicit none
      integer, external::chk_par_do_ordered
      integer, external::crosschk_par_do_ordered
      integer, external::chk_par_do_reduction
      integer, external::crosschk_par_do_reduction
      integer, external::chk_par_do_private
      integer, external::crosschk_par_do_private
      integer, external::chk_par_do_firstprivate
      integer, external::crosschk_par_do_firstprivate
      integer, external::chk_par_do_lastprivate
      integer, external::crosschk_par_do_lastprivate
      character (len=30)::name
      integer failed
      integer N
      integer num_tests,crosschecked
      name="Parallel Do ORDERED"
      call do_test(chk_par_do_ordered,crosschk_par_do_ordered,
     x  name,N,failed,num_tests,crosschecked)
      name="Parallel Do REDUCTION"
      call do_test(chk_par_do_reduction,crosschk_par_do_reduction,
     x name,N,failed,num_tests,crosschecked)
      name="Parallel Do PRIVATE"
      call do_test(chk_par_do_private,crosschk_par_do_private,
     x name,N,failed,num_tests,crosschecked)
      name="Parallel Do FIRSTPRIVATE"
      call do_test(chk_par_do_firstprivate,
     x crosschk_par_do_firstprivate,name,N,failed,
     x num_tests,crosschecked)
      name="Parallel Do LASTPRIVATE"
      call do_test(chk_par_do_lastprivate,crosschk_par_do_lastprivate,
     x name,N,failed,num_tests,crosschecked)
      end
