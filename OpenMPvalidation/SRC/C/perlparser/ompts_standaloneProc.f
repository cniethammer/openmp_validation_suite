!This is the main driver to invoke different test functions
! more comments here.....
      program <testfunctionname></testfunctionname>_main
      implicit none
	integer LOOPCOUNT 
      integer failed, success
      integer N
      integer num_tests,crosschecked, crossfailed, j
	integer temp,temp1

	integer <testfunctionname></testfunctionname>


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
	write (1,*) "<directive></directive>"
	write (1,*) "--------------------------------------------------"
	
	do j = 1, N
		write (1,*) "# Check: "
		 
		temp =  <testfunctionname></testfunctionname>()
		if (temp .EQ. 1) then
			write (1,*) "No errors occured during the", j+1, ". test."
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
		
		write (1,*) "Result for <directive></directive>:"
	
	if (result .EQ. 1) then
		write (1,*) "Directiv worked without errors."
		write (1,*) "Crosschecks verified this result with", 100.0*crossfailed/N
		write (*,*) "check_has_openmp ... verified with", 
     &           100.0*crossfailed/N ,"% certainty."
	else
		write (1,*) "Directive failed the tests!"
		write (*,*) "check_has_openmp ... FAILED."
	endif
      end program 
