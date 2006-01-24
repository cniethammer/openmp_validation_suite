!This is the main driver to invoke different test functions
! more comments here.....
      PROGRAM <testfunctionname></testfunctionname>_main
      IMPLICIT NONE
      INTEGER LOOPCOUNT 
      INTEGER failed, success
      INTEGER N
      INTEGER num_tests,crosschecked, crossfailed, j
      INTEGER temp,temp1

      INTEGER <testfunctionname></testfunctionname>


      CHARACTER*20 logfilename
      INTEGER result 

      num_tests = 0
      crosschecked = 0
      crossfailed = 0
      result = 1
      N=20
      failed = 0
      LOOPCOUNT = 10000

      logfilename = "f<ompts:crosscheck>cross</ompts:crosscheck><testfunctionname></testfunctionname>.log"
!      WRITE (*,*) "Enter logFilename:" 
!      READ  (*,*) logfilename

      OPEN (1, FILE = logfilename)
 
      WRITE (*,*) "######## OpenMP Validation Suite V 0.93 ######"
      WRITE (*,*) "## Repetitions:", N 
      WRITE (*,*) "## Loop Count :", LOOPCOUNT
      WRITE (*,*) "##############################################"

      crossfailed=0
      result=1
      WRITE (1,*) "--------------------------------------------------"
      WRITE (1,*) "<directive></directive>"
      WRITE (1,*) "--------------------------------------------------"
      
      DO j = 1, N
        WRITE (1,*) "# Check: "
            
        temp =  <testfunctionname></testfunctionname>()
        IF (temp .EQ. 1) THEN
          WRITE (1,*) "No errors occured during the", j, ". test."
        ELSE
          WRITE (1,*) "--> Erroros occured during the",j, ". test."
          result = 0
        ENDIF
      END DO

      IF (result .EQ. 0 ) THEN
            failed = failed + 1
      ELSE
            success = success + 1
      ENDIF
      
      IF (crossfailed .LT. 0) THEN
            crosschecked = crosschecked + 1
      ENDIF 
            
      WRITE (1,*) "Result for <directive></directive>:"
      
      IF (result .EQ. 1) THEN
        WRITE (1,*) "Directiv worked without errors."
        WRITE (1,*) "Crosschecks verified this result with", 100.0*
     &crossfailed/N
        WRITE (*,*) "<testfunctionname></testfunctionname>... verified 
     &with", 100.0*crossfailed/N ,"% certainty."
      ELSE
        WRITE (1,*) "Directive failed the tests!"
        WRITE (*,*) "check_has_openmp ... FAILED."
      ENDIF
      END PROGRAM 
