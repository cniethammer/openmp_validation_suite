	program main
        implicit none
        integer temp
        integer check_has_openmp
        integer chk_omp_get_num_threads
        integer check_do_schedule
!	include "omp_testsuite_include.f"
	print *, ' Has OpenMP macro ...'
	if (check_has_openmp().eq. 1) then
	  print *, ' passed'	
	else
	  print *, ' failed'
	end if

	print *, ' omp_get_num_threads ...'
        if (chk_omp_get_num_threads().eq. 1) then
          print *, ' passed'
        else
          print *, ' failed'
        end if

	print *, ' omp in schedule...'
        if ( check_do_schedule().eq. 1) then
          print *, ' passed'
        else
          print *, ' failed'
        end if
	end
