!Yi Wen at 05032004: all functions are added with "implicit none"
!********************************************************************
! Functions: chk_section_reduction
!********************************************************************

	integer function chk_section_reduction()
        implicit none
	integer sum, known_sum, i
	sum = 7
!$omp parallel
!$omp sections reduction(+:sum) private(i)
!$omp section
	do i=1, 399
	  sum = sum + i
	end do
!$omp section
	do i=400, 699
	  sum = sum + i
	end do
!$omp section
	do i=700, 999
	  sum = sum + i
	end do
!$omp end sections
!$omp end parallel
	known_sum = (999*1000)/2+7
	if ( known_sum .eq. sum) then
	  chk_section_reduction = 1
	else
	  chk_section_reduction = 0
	end if
	end

	integer function crosschk_section_reduction()
        implicit none
	integer sum, known_sum, i
	sum = 7
!$omp parallel
!$omp sections private(i)
!$omp section
	do i=1, 399
	  sum = sum + i
	end do
!$omp section
	do i=400, 699
	  sum = sum + i
	end do
!$omp section
        do i=700, 999
          sum = sum + i
        end do
!$omp end sections
!$omp end parallel
	known_sum=(999*1000)/2+7
	if (known_sum .eq. sum) then
	   crosschk_section_reduction = 1
	else
	   crosschk_section_reduction = 0
	end if
	end

!********************************************************************
! Functions: check_section_private
!********************************************************************

	integer function check_section_private()
        implicit none
 	integer sum, sum0, known_sum, i
	sum = 7
	sum0 = 0
!$omp parallel
!$omp sections private(sum0,i)
!$omp section
	sum0 = 0
	do i=1, 399
	  sum0 = sum0 + i
	end do
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=400, 699
          sum0 = sum0 + i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=700, 999
          sum0 = sum0 + i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end sections
!$omp end parallel
	known_sum = (999*1000)/2+7
	if ( known_sum .eq. sum) then
	  check_section_private = 1
	else
	  check_section_private = 0
	end if
	end

	integer function crosscheck_section_private()
        implicit none
	integer sum, sum0, known_sum, i
	sum = 7
	sum0 = 0
!$omp parallel
!$omp sections private(i)
!$omp section
	sum0 =0
	do i=1, 399
	  sum0 = sum0 + i
	end do
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp section
        sum0 =0
        do i=400, 699
          sum0 = sum0 + i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
        sum0 =0
        do i=700, 999
          sum0 = sum0 + i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end sections
!$omp end parallel
	known_sum=(999*1000)/2+7
	if ( known_sum .eq. sum ) then
	   crosscheck_section_private = 1
	else
	   crosscheck_section_private = 0
 	end if
	end 

!********************************************************************
! Functions: chk_section_firstprivate
!********************************************************************
	integer function chk_section_firstprivate()
        implicit none
	integer sum, sum0, known_sum
	sum = 7
	sum0 = 11
!$omp parallel	
!$omp sections firstprivate(sum0)
!$omp section
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp section
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end sections
!$omp end parallel	
	known_sum = 11*3+7
	if ( known_sum .eq. sum) then
	  chk_section_firstprivate = 1
	else
	  chk_section_firstprivate = 0
	end if
	end 

	integer function crosschk_section_firstprivate()
        implicit none
	integer sum, sum0, known_sum
	sum = 7
	sum0 = 11
!$omp parallel
!$omp sections private(sum0)
!$omp section
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp section
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end sections
!$omp end parallel
	known_sum=11*3+7
	if ( known_sum .eq. sum) then
	  crosschk_section_firstprivate = 1
	else
	  crosschk_section_firstprivate = 0
	end if
	end 


!********************************************************************
! Functions: chk_section_lastprivate
!********************************************************************


	integer function chk_section_lastprivate()
	integer sum, sum0, known_sum, i, i0
	sum = 0
	sum0 = 0
	i0 = -1
!$omp parallel
!$omp sections lastprivate(i0) private(i,sum0)
!$omp section
	sum0 = 0
	do i=1, 399
	  sum0 = sum0 + i
	  i0 = i
	end do
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=400, 699
          sum0 = sum0 + i
          i0 = i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=700, 999
          sum0 = sum0 + i
          i0 = i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end sections
!$omp end parallel
	known_sum=(999*1000)/2
	if ( known_sum .eq. sum .and. i0 .eq. 999 ) then
	   chk_section_lastprivate = 1
	else
	   chk_section_lastprivate = 0
	end if
	end


	integer function crosschk_section_lastprivate()
	integer sum, sum0, known_sum, i, i0
	sum = 0
	sum0 = 0
	i0 = -1
!$omp parallel
!$omp sections private(i0) private(i,sum0)
!$omp section
	sum0 = 0
	do i=1, 399
	  sum0 = sum0 + i
	  i0 = i
	end do
!$omp critical
	sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=400, 699
          sum0 = sum0 + i
          i0 = i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=700, 999
          sum0 = sum0 + i
          i0 = i
        end do
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end sections
!$omp end parallel
	known_sum = (999*1000)/2
	if ( known_sum .eq. sum .and. i0 .eq. 999 ) then
	   crosschk_section_lastprivate = 1
	else
	   crosschk_section_lastprivate = 0
	end if
	end


!***************************************************************************
! driver function
!***************************************************************************
      subroutine check_omp_section(N,failed,num_tests,crosschecked)
      implicit none
      integer, external::crosschk_section_reduction
      integer, external::chk_section_reduction
      integer, external::check_section_private
      integer, external::crosscheck_section_private
      integer, external::chk_section_firstprivate
      integer, external::crosschk_section_firstprivate
      integer, external::chk_section_lastprivate
      integer, external::crosschk_section_lastprivate
      character (len=20)::name
      integer num_tests,crosschecked
      integer failed
      integer N
      name="Section REDEUCTION"
      call do_test(chk_section_reduction,crosschk_section_reduction,
     x name,N,failed,num_tests,crosschecked)
      name="Section PRIVATE"
      call do_test(check_section_private,crosscheck_section_private,
     x name,N,failed,num_tests,crosschecked)
      name="Section FIRSTPRIVATE"
      call do_test(chk_section_firstprivate,
     x crosschk_section_firstprivate,name,N,failed,
     x num_tests,crosschecked)
      name="Section LASTPRIVATE"
      call do_test(chk_section_lastprivate,crosschk_section_lastprivate,
     x name,N,failed,num_tests,crosschecked)
      end
