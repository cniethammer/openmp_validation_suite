!This is the main driver to invoke different test functions
! more comments here.....
      program check_omp_v1_main
      implicit none
	integer LOOPCOUNT 
      integer failed, success
      integer N
      integer num_tests,crosschecked, crossfailed, j
	integer temp,temp1

	integer check_has_openmp, crosscheck_has_openmp
	integer chk_omp_get_num_threads, crosschk_omp_get_num_threads
	integer chk_omp_in_parallel, crosschk_omp_in_parallel
	integer check_do_ordered, crosscheck_do_ordered
	integer check_do_reduction, crosscheck_do_reduction
	integer check_do_private,crosscheck_do_private
	integer chk_do_firstprivate, crosschk_do_firstprivate
	integer chk_do_lastprivate, crosschk_do_lastprivate
	integer chk_section_reduction,crosschk_section_reduction
	integer check_single,crosscheck_single
	integer check_single_private,crosscheck_single_private
	integer check_single_nowait,crosscheck_single_nowait
	integer chk_par_do_ordered,crosschk_par_do_ordered
	integer chk_par_do_reduction,crosschk_par_do_reduction
	integer chk_par_do_private,crosschk_par_do_private
	integer chk_par_do_firstprivate,crosschk_par_do_firstprivate
	integer chk_par_do_lastprivate,crosschk_par_do_lastprivate
	integer check_section_private,crosscheck_section_private
	integer chk_section_firstprivate,crosschk_section_firstprivate
	integer chk_section_lastprivate,crosschk_section_lastprivate
	integer chk_omp_master_thd,crosschk_omp_master_thd
	integer check_omp_critical,crosscheck_omp_critical
	integer check_omp_atomic,crosscheck_omp_atomic
	integer check_omp_barrier,crosscheck_omp_barrier
	integer check_omp_flush,crosscheck_omp_flush
	integer check_omp_threadprivate,crosscheck_omp_threadprivate
	integer check_omp_copyin,crosscheck_omp_copyin
	integer check_omp_lock,crosscheck_omp_lock
	integer check_omp_testlock,crosscheck_omp_testlock
	integer check_omp_nest_lock,crosscheck_omp_nest_lock
	integer check_omp_nest_testlock,crosscheck_omp_nest_testlock


	character*20 logfilename
	integer result 

      num_tests = 0
      crosschecked = 0
	crossfailed = 0
	result = 1
      N=20
      failed = 0
	LOOPCOUNT = 10000

	write (*,*) "Enter logFilename:" 
	read  (*,*) logfilename

	open (1, FILE = Logfilename)
 
	write (*,*) "######## OpenMP Validation Suite V 0.93 ######"
	write (*,*) "## Repetitions:", N ,"                       ####"
 	write (*,*) "## Loop Count :", LOOPCOUNT, "                    ####"
	write (*,*) "##############################################"

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "check_has_openmp"
	write (1,*) "--------------------------------------------------"
	
	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_has_openmp()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_has_openmp()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_has_openmp:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_has_openmp ... verified with", 
     &           100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "check_has_openmp ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "check_omp_get_num_threads"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_omp_get_num_threads()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_omp_get_num_threads()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_get_num_threads:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_get_num_threads ... verified",
     &           " with",100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "check_omp_get_num_threads ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "check_omp_in_parallel"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_omp_in_parallel()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_omp_in_parallel()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_in_parallel ... ",
     &          "verified with", 100.0*crossfailed/N , "% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "check_omp_in_parallel ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "do ORDERED"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_do_ordered()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_do_ordered()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "for ORDERED ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "for ORDERED ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "do REDUCTION"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_do_reduction()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_do_reduction()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "for reduction ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "for reduction ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "do firstprivate"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_do_private()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_do_private()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "for private ... ",
     &  "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "for private ... FAILED."
	endif
	

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "for FIRSTPRIVATE"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_do_firstprivate()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_do_firstprivate()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "for firstprivate ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "for firstprivate ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "for LASTPRIVATE"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_do_lastprivate()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_do_lastprivate()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 
     &          100.0*crossfailed/N
		write (*,*) "for lastprivate ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "for lastprivate ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "section REDUCTION"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_section_reduction()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_section_reduction()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "for section reduction ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "for section reduction ... FAILED."
	endif
	
        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "SINGLE"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_single()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_single()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "single ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "single ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "single PRIVATE"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_single_private()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_single_private()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "single private... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "single private... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "SINGLE NOWAIT"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_single_nowait()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_single_nowait()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "SINGLE NOWAIT... ",
     &           "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "SINGLE NOWAIT ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "parallel for ORDERED"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_par_do_ordered()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_par_do_ordered()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "parallel do ORDERED... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "parallel do ORDERED ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "parallel do REDUCTION"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_par_do_reduction()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_par_do_reduction()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "parallel do reduction... ",
     &           "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "parallel do reduction ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "parallel do private"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_par_do_private()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_par_do_private()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "parallel do private... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "parallel do private ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "parallel do firstprivate"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_par_do_firstprivate()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_par_do_firstprivate()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "parallel do firstprivate... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "parallel do firstprivate ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000
	
	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "parallel do lastprivate"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_par_do_lastprivate()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_par_do_lastprivate()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "parallel do lastprivate... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "parallel do lastprivate ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "parallel section reduction"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_section_reduction()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_section_reduction()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "parallel section reduction... ",
     &           "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "parallel section reduction ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "parallel section PRIVATE"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_section_private()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_section_private()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "parallel section private ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "parallel section private ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "parallel section FIRSTPRIVATE"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_section_firstprivate()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_section_firstprivate()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "parallel section firstprivate ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "parallel section firstprivate ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "parallel section LASTPRIVATE"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_section_lastprivate()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_section_lastprivate()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "parallel section lastprivate ... ",
     &           "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "parallel section lastprivate ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp MASTER"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  chk_omp_master_thd()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosschk_omp_master_thd()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_master_thread ... ",
     &           "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_master_thread ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp CRITICAL"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_omp_critical()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_omp_critical()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_critical ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_critical ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp ATOMIC"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_omp_atomic()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_omp_atomic()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_atomic ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_atomic ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp BARRIER"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_omp_barrier()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_omp_barrier()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_barrier ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_barrier ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp FLUSH"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_omp_flush()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_omp_flush()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_flush ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_flush ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp THREADPRIVATE"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_omp_threadprivate()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_omp_threadprivate()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_threadprivate ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_threadprivate ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp omp COPYIN"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_omp_copyin()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_omp_copyin()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_copyin ... ",
     &         "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_copuin ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp LOCK"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_omp_lock()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_omp_lock()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_lock ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_lock ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp TESTLOCK"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_omp_testlock()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_omp_testlock()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_in_parallel:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_testlock ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_testlock ... FAILED."
	endif

        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp NEST_LOCK"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_omp_nest_lock()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_omp_nest_lock()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_nest_lock:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_nest_lock ... ",
     &          "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_nest_lock ... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	crossfailed=0;
	result=1;
	write (1,*) "--------------------------------------------------"
	write (1,*) "omp NEST_TESTLOCK"
	write (1,*) "--------------------------------------------------"

	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  check_omp_nest_testlock()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_omp_nest_testlock()
			if (temp1 .NE. 1) then
				write (1,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (1,*) "# Crosscheck: Verified result"
			endif
		else
			write (1,*) "--> Erroros occured during the",j+1, ". test."
			result = 0
		endif
	end do

	if (result .EQ. 0 )then
		failed = failed + 1
	else
		success = success + 1
	endif
	
	if (crossfailed .LT. 0) then
		crosschecked = crosschecked + 1
	endif 
		
		write (1,*) "Result for check_omp_nest_testlog:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_omp_nest_testlock ... ",
     &             "verified with", 100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "crosscheck_omp_nest_testlock ... FAILED."
	endif
      end program 
