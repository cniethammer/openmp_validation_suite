	program main
	character*20 logFileName 
  	integer i/1/
  	integer failed/0/
  	integer success/0/
  	integer crosschecked/0/
  	integer N/20/
  	integer j/0/
  	integer result/1/
  	integer crossfailed/0/
	integer check_for_schedule_static
	integer crosscheck_for_schedule_static
	integer check_for_schedule_dynamic
	integer crosscheck_for_schedule_dynamic
	integer check_for_schedule_guided
	integer crosscheck_for_schedule_guided
	type testcall
	  character*31 :: name
	  integer ::  pass
	  integer :: fail
	end type testcall
	type(testcall):: alltests(4)
	include "omp_testsuite.f"
	logFileName= "check_schedule.log"

	open(1, FILE=logFileName)
  	write(*,*) 
     &  "######## OpenMP Validation Suite V 0.93 ######"
  	write(*,*) "## Repetitions: ",N,
     &  "                       ####"
  	write(*,*) "## Loop Count : ",LOOPCOUNT,
     &  "                    ####"
  	write(*,*) 
     &  "##############################################"
  
	alltests(1)%name = "check_for_schedule_static"
	alltests(2)%name = "check_for_schedule_dynamic"
	alltests(3)%name = "check_for_schedule_guided"
	alltests(4)%name = "end"

	alltests(1)%pass = 1
	alltests(2)%pass = 1
	alltests(3)%pass = 1
	alltests(4)%pass =0 
 
  	do while( alltests(i)%pass .ge. 1)
    	   crossfailed=0
    	   result=1
           write(1,*) 
     &     "--------------------------------------------------"
           write (1,*) alltests(i)%name
	   write (1,*) 
     &     "--------------------------------------------------"
    	   do j=1,N
    	    write (1,*) "# Check: "

	    select case (i)
	     case(1)
               alltests(1)%pass=check_for_schedule_static(logFileName)
	     case(2)
	       alltests(2)%pass=check_for_schedule_dynamic(logFileName)
	     case(3)
	       alltests(3)%pass=check_for_schedule_guided(logFileName)
	     case(4)
	       alltests(4)%pass=0
	    end select
	
            if ( alltests(i)%pass.ge.1 ) then
	     write (1,*) "No errors occured during the ",
     &                   j, ". test."
	     select case (i)
             case(1)
               alltests(1)%fail=
     &          crosscheck_for_schedule_static(logFileName)
             case(2)
               alltests(2)%fail=
     &          crosscheck_for_schedule_dynamic(logFileName)
             case(3)
               alltests(3)%fail=
     &          crosscheck_for_schedule_guided(logFileName)
             case(4)
               alltests(4)%fail=0
            end select
 
      	     if ( (alltests(i)%fail).ge.1 ) then
	       write (1,*) "# Crosscheck: Verified result"
	       crossfailed = crossfailed + 1
      	     else 
	       write (1,*) "# Crosscheck: Coudn't verify result."
	     end if
	    else
	     write (1,*) "--> Errors occured during the ",
     &         j,". test."
	     result=0
	    end if
	   end do
	   if ( result .eq. 0) then
	    failed = failed + 1
           else 
            success = success + 1
	   end if
    	   if(crossfailed .gt. 0) then
             crosschecked = crosscheck + 1
	   end if
    	   write(1,*) "Result for ",alltests(i)%name
    	   if(result.ge.1) then
      	     write(1,*) "Directive worked without errors."
	     write(1,*) "Crosschecks verified this result with "
	     write(1,"(f5.2,A16)") 
     &         dble(100.0*crossfailed)/dble(N),"%% certainty."

	     write(*,"(A26,A31,f5.2,A16)") alltests(i)%name,
     &        " ... verified with ",100.0*crossfailed/N,"% certainty"
	   else
	     write(1,*) "Directive failed the tests!"
     	     write(*,*) alltests(i)%name," ... FAILED"
	   end if

    	   i = i + 1
	end do
	write(*,*)
	write(*,*)
  	write(*,*) " Performed a total of ",i-1,"tests, ",
     &  failed," failed and ",success," successful with ",
     &  crosschecked,"cross checked"
	write(*,*) 
     &  "For detailled inforamtion on the tests see the logfile ",
     &  logFileName

        write(1,*)
        write(1,*)
        write(1,*) " Performed a total of ",i,"tests, ",
     &  failed," failed and ",success," successful with ",
     &  crosschecked,"cross checked"
        write(1,*) 
     &  "For detailled inforamtion on the tests see the logfile ",
     &  logFileName

  	
	close(1)
c	return failed
	end

