!This is the main driver to invoke different test functions
! more comments here.....
      program check_omp_v2_main
      implicit none
	integer LOOPCOUNT 
      integer failed, success
      integer N
      integer num_tests,crosschecked, crossfailed, j
	integer temp,temp1

	integer omp_check_num_threads,omp_crosscheck_num_threads
	integer omp_check_time,omp_crosscheck_time
	integer omp_check_ticks_time
	integer omp_crosscheck_ticks_time
	integer check_single_copyprivate
	integer crosscheck_single_copyprivate
	character*20 logfilename/"test2.log"/
	integer result 
	integer unit/1/

	integer i/0/,failed/0/,success/0/
	integer crosscheck/0/,N/20/
	integer j/0/,result/1/,crossfailed/0/
	LOOPCOUNT = 10000

	open (unit, FILE = Logfilename)
 
	write (*,*) "######## OpenMP Validation Suite V 0.93 ######"
	write (*,*) "## Repetitions: ",N,"                      ####"
 	write (*,*) "## Loop Count : ",
     &   LOOPCOUNT,"                   ####"
	write (*,*) 
     &   "##############################################"

	crossfailed=0;
	result=1;
	write (unit,*) "--------------------------------------------------"
	write (unit,*) "omp_check_num_threads"
	write (unit,*) "--------------------------------------------------"
	
	do j = 1, N
		write (unit,*) "# Check: "
		 
		temp =  omp_check_num_threads(unit)
		if (temp .EQ. 1) then
			write (unit,*) "No errors occured during the", j+1, ". test."
			temp1 = omp_crosscheck_num_threads(unit)
			if (temp1 .NE. 1) then
				write (unit,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (unit,*) "# Crosscheck: Verified result"
			endif
		else
			write(unit,*) 
     &                  "--> Erroros occured during the",j+1, ". test."
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
		
		write (unit,*) "Result for omp_check_num_threads:"
	
	if (result .EQ. 1) then
		write (unit,*) "Directiv worked without errors."
		write (unit,*) "Crosschecks verified this result with", 
     &            100.0*crossfailed/N,"certainty."
		write (*,"(A40,f5.2,A12)")
     &    "omp_check_num_threads... verified with", 
     &    100.0*crossfailed/N,"% certainty" 
	else
		write (unit,*) "Directive failed the tests!"
		write (*,*) "omp_check_num_threads... FAILED."
	endif


        num_tests = 0
        crosschecked = 0
	crossfailed = 0
	result = 1
        N=20
        failed = 0
	LOOPCOUNT = 10000

	write (unit,*) "--------------------------------------------------"
	write (unit,*) "omp_check_time"
	write (unit,*) "--------------------------------------------------"

	do j = 1, N
		write (unit,*) "# Check: "
		 
		temp =  omp_check_time(unit)
		if (temp .EQ. 1) then
			write (unit,*) "No errors occured during the", j+1, ". test."
			temp1 = omp_crosscheck_time(unit)
			if (temp1 .NE. 1) then
				write (unit,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (unit,*) "# Crosscheck: Verified result"
			endif
		else
			write (unit,*) "--> Erroros occured during the",j+1, ". test."
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
		
		write (unit,*) "Result for omp_get_wtime:"
	
	if (result .EQ. 1) then
		write (unit,*) "Directiv worked without errors."
		write (unit,*) 
     &  "Crosschecks verified this result with", 100.0*crossfailed/N,
     &  "certainty."
		write (*,*) "omp_get_wtime... " ,
     &  "verified with", 100.0*crossfailed/N ,"certainty."
	else
		write (unit,*) "Directive failed the tests!"
		write (*,*) "omp_get_wtime... FAILED."
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
	write (unit,*) "--------------------------------------------------"
	write (unit,*) "omp_check_ticks_time"
	write (unit,*) "--------------------------------------------------"

	do j = 1, N
		write (unit,*) "# Check: "
		 
		temp =  omp_check_ticks_time(unit)
		if (temp .EQ. 1) then
			write (unit,*) "No errors occured during the", j+1, ". test."
			temp1 = omp_crosscheck_ticks_time(unit)
			if (temp1 .NE. 1) then
				write (unit,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (unit,*) "# Crosscheck: Verified result"
			endif
		else
			write (unit,*) "--> Erroros occured during the",j+1, ". test."
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
		
		write (unit,*) "Result for omp_get_wticks:"
	
	if (result .EQ. 1) then
		write (unit,*) "Directiv worked without errors."
		write (unit,*) 
     & "Crosschecks verified this result with", 100.0*crossfailed/N,
     & "certainty."
		write (*,*) "omp_get_wticks... verified with", 
     & 100.0*crossfailed/N ,"certainty."
	else
		write (unit,*) "Directive failed the tests!"
		write (*,*) "omp_get_wticks... FAILED."
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
	write (unit,*) "--------------------------------------------------"
	write (unit,*) "check_single_copyprivate"
	write (unit,*) "--------------------------------------------------"

	do j = 1, N
		write (unit,*) "# Check: "
		 
		temp =  check_single_copyprivate(unit)
		if (temp .EQ. 1) then
			write (unit,*) "No errors occured during the", j+1, ". test."
			temp1 = crosscheck_single_copyprivate(unit)
			if (temp1 .NE. 1) then
				write (unit,*) "# Crosscheck: Verified result"		
				crossfailed = crossfailed + 1
			else
				write (unit,*) "# Crosscheck: Verified result"
			endif
		else
			write (unit,*) "--> Erroros occured during the",j+1, ". test."
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
		
		write (unit,*) "Result for check_single_copyprivate:"
	
	if (result .EQ. 1) then
		write (unit,*) "Directiv worked without errors."
		write (unit,*) 
     & "Crosschecks verified this result with", 100.0*crossfailed/N,
     & "certainty."
		write (*,*) "check_single_copyprivate... verified with", 
     &  100.0*crossfailed/N ,"certainty."
	else
		write (unit,*) "Directive failed the tests!"
		write (*,*) "check_single_copyprivate... FAILED."
	endif

	end
