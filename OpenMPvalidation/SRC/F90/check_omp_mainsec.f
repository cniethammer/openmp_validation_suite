	program main
	include "omp_testsuite_include.f"
	print *, ' Has openMP macro ...'
	if ( check_has_openmp() .eq. 1 ) then
	   print *, ' passed'
	else
	   print *, ' failed'
	end if

	print *, ' omp_get_num_threads ...'
	if ( check_omp_get_num_threads() .eq. 1 ) then
	   print *, ' passed'
	else
	   print *, ' failed'
        end if
	
	print *, ' omp_in_parallel...'
        if ( check_omp_in_parallel() .eq. 1 ) then
           print *, ' passed'
        else
           print *, ' failed'
        end if
	
	end
