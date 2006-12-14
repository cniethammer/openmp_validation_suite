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


      CHARACTER*50 logfilename
      INTEGER result 

      num_tests = 0
      crosschecked = 0
      crossfailed = 0
      result = 1
      N=20
      failed = 0
      LOOPCOUNT = 10000

      logfilename = "f<testfunctionname></testfunctionname>.log"
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
      WRITE (1,*) "Testting <directive></directive>"
      WRITE (1,*) "--------------------------------------------------"
      WRITE (1,*) 
      WRITE (1,*) "testname: <testfunctionname></testfunctionname>"
      WRITE (1,*) "(Crosstests should fail)"
      WRITE (1,*)
      
      DO j = 1, N
        temp =  <testfunctionname></testfunctionname>()
        IF (temp .EQ. 1) THEN
          WRITE (1,*)  j, ". test successfull."
          success = success + 1
        ELSE
          WRITE (1,*) "Error: ",j, ". test failed."
          failed = failed + 1
        ENDIF
      END DO

      
      IF (failed .EQ. 0) THEN
        WRITE (1,*) "Directiv worked without errors."
        result = 0
      ELSE
        WRITE (1,*) "Directive failed the test ", failed, " times."
        result = failed * 100 / N
      ENDIF
      CALL EXIT (result)
      END PROGRAM 
