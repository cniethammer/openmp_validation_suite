!********************************************************************
! Functions: check_parallel_section_reduction
!********************************************************************

	integer function chk_par_sect_reduction()
        implicit none
	integer sum, known_sum, i
	sum = 7
!$omp parallel sections reduction(+:sum) private(i)
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
!$omp end parallel sections
	known_sum = (999*1000)/2+7
	if ( known_sum .eq. sum) then
	  chk_par_sect_reduction = 1
	else
	  chk_par_sect_reduction = 0
	end if
	end

	integer function crosschk_par_sect_reduction()
        implicit none
	integer sum, known_sum, i
!$omp parallel sections private(i)
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
!$omp end parallel sections
	known_sum=(999*1000)/2+7
	if (known_sum .eq. sum ) then
	   crosschk_par_sect_reduction = 1
	else
	   crosschk_par_sect_reduction = 0
	end if
	end

!********************************************************************
! Functions: check_parallel_section_private
!********************************************************************

	integer function chk_par_sect_private()
        implicit none
	integer sum, sum0, known_sum, i
	sum = 7
	sum0 = 0
!$omp parallel sections private(sum0,i)
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
!$omp end parallel sections
	known_sum = (999*1000)/2+7
	if ( known_sum .eq. sum ) then
	   chk_par_sect_private = 1
	else
	   chk_par_sect_private = 0
	end if
	end 

	integer function crosschk_par_sect_private()
        implicit none
	integer sum, sum0, known_sum, i
	sum = 7
	sum0 = 0
!$omp parallel sections private(i)
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
!$omp end parallel sections
	known_sum = (999*1000)/2+7
	if ( known_sum .eq. sum ) then
	  crosschk_par_sect_private = 1
	else
	  crosschk_par_sect_private = 0
	end if
	end

!********************************************************************
! Functions: check_parallel_section_firstprivate
!********************************************************************

	integer function chk_par_sect_fprivate()
        implicit none
	integer sum, sum0, known_sum
	sum = 7
	sum0 = 11
!$omp parallel sections firstprivate(sum0)
!$omp section
!$omp critical 
	sum = sum + sum0
!$omp end critical
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp critical
        sum = sum + sum0
!$omp end critical
!$omp end parallel sections
	known_sum = 11*3 + 7
	if ( known_sum .eq. sum ) then
	  chk_par_sect_fprivate = 1
	else
	  chk_par_sect_fprivate = 0
	end if
	end 

	integer function crosschk_par_sect_fprivate()
        implicit none
	integer sum, sum0, known_sum
	sum = 7
	sum0 = 11
!$omp parallel sections private(sum0)
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
!$omp end parallel sections
	known_sum = 11*3 + 7
	if ( known_sum .eq. sum ) then
	  crosschk_par_sect_fprivate = 1
	else
	  crosschk_par_sect_fprivate = 0
	end if
	end

!********************************************************************
! Functions: check_parallel_section_lastprivate
!********************************************************************

	integer function chk_par_sect_lprivate()
        implicit none
	integer sum, sum0, known_sum, i ,i0
	sum =0
	sum0 = 0
	i0 = -1
!$omp parallel sections lastprivate(i0) private(i,sum0)
!$omp section
	sum0 = 0
	do i=1, 399
	  sum0 = sum0 + i
          i0=i
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
!$omp end parallel sections
	known_sum = (999*1000)/2
!        print *, "sum", sum, "ks", known_sum, i0
	if ( known_sum .eq. sum .and. i0 .eq. 999 ) then
	  chk_par_sect_lprivate = 1
	else
	  chk_par_sect_lprivate = 0
	end if
	end

	integer function crosschk_par_sect_lprivate()
        implicit none
	integer sum, sum0, known_sum, i ,i0
	sum =0
	sum0 = 0
	i0 = -1
!$omp parallel sections private(i0) private(i,sum0)
!$omp section
	sum0 = 0
	do i=1, 399
	  sum0 = sum0 + i
	end do
	i0 = i
!$omp critical
	sum0 = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=400, 699
          sum0 = sum0 + i
	end do
        i0 = i
!$omp critical
        sum0 = sum + sum0
!$omp end critical
!$omp section
        sum0 = 0
        do i=700, 999
          sum0 = sum0 + i
	end do
        i0 = i
!$omp critical
        sum0 = sum + sum0
!$omp end critical
!$omp end parallel sections
	known_sum = (999*1000)/2
	if ( known_sum .eq. sum .and. i0 .eq. 999 ) then
	  crosschk_par_sect_lprivate = 1
	else
	  crosschk_par_sect_lprivate = 0
	end if
	end

!***************************************************************************
! driver function
!***************************************************************************
      subroutine check_omp_par_sect(N,failed,num_tests,crosschecked)
      implicit none
      integer, external::chk_par_sect_reduction
      integer, external::crosschk_par_sect_reduction
      integer, external::chk_par_sect_private
      integer, external::crosschk_par_sect_private
      integer, external::chk_par_sect_fprivate
      integer, external::crosschk_par_sect_fprivate
      integer, external::chk_par_sect_lprivate
      integer, external::crosschk_par_sect_lprivate
      character (len=35)::name
      integer failed
      integer N
      integer num_tests,crosschecked
      name="Parallel Section REDUCTION"
      call do_test(chk_par_sect_reduction,crosschk_par_sect_reduction,
     x name,N,failed,num_tests,crosschecked)
      name="Parallel Section PRIVATE"
      call do_test(chk_par_sect_private,crosschk_par_sect_private,
     x name,N,failed,num_tests,crosschecked)
      name="Parallel Section FIRSTPRIVATE"
      call do_test(chk_par_sect_fprivate,
     x crosschk_par_sect_fprivate,name,N,failed,num_tests,crosschecked)
      name="Parallel Section LASTPRIVATE"
      call do_test(chk_par_sect_lprivate,crosschk_par_sect_lprivate,
     x name,N,failed,num_tests,crosschecked)
      end
