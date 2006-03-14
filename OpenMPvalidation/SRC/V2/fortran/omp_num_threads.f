<ompts:test>
<ompts:testdescription>Test which checks that the omp_get_num_threads returns the correct number of threads. Therefor it counts up a variable in a parallelized section and compars this value with the result of the omp_get_num_threads function.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp_get_num_threads</ompts:directive>
<ompts:testcode>
      INTEGER FUNCTION <ompts:testcode:functionname>omp_num_threads</ompts:testcode:functionname>()
        IMPLICIT NONE
        INTEGER failed, i, max_threads, threads, nthreads
        INTEGER omp_get_num_threads
        failed = 0
        max_threads = 0
         
!$omp parallel
!$omp master
        max_threads = OMP_GET_NUM_THREADS()       
!$omp end master
!$omp end parallel
!         print *, "max threads:",max_threads
!Yi Wen added omp_Set_dynamics here to make sure num_threads clause work
        CALL OMP_SET_DYNAMIC(.TRUE.)
        DO threads = 1, max_threads
          nthreads = 0
!$omp parallel num_threads(threads) reduction(+:failed)
!          print *, threads, omp_get_num_threads()
          IF ( threads .NE. OMP_GET_NUM_THREADS() ) THEN
            failed = failed + 1
          END IF
!$omp atomic
          nthreads = nthreads + 1
!$omp end parallel
!            print *, threads, nthreads
          <ompts:check>IF ( nthreads .NE. threads ) THEN</ompts:check>
          <ompts:crosscheck>IF ( nthreads .EQ. threads ) THEN</ompts:crosscheck>
            failed = failed + 1
          END IF
        END DO

        IF(failed .NE. 0) THEN
          <testfunctionname></testfunctionname> = 0
        ELSE
          <testfunctionname></testfunctionname> = 1
        END IF
      END FUNCTION
</ompts:testcode>
</ompts:test>

	integer function crschk_omp_num_threads()
        implicit none
	integer failed, i, max_threads, threads, nthreads
	integer omp_get_num_threads
	failed = 0
	max_threads = 0
!$omp parallel
!$omp master
	max_threads = omp_get_num_threads()
!$omp end master
!$omp end parallel

        do threads=1, max_threads
	  nthreads = 0
!$omp parallel reduction(+:failed)
	  if (threads .ne. omp_get_num_threads() ) then
 	    failed = failed + 1
	  end if
!$omp atomic
	    nthreads = nthreads + 1
!$omp end parallel
	if ( nthreads .eq. threads ) then
 	  failed = failed + 1
 	end if
  	end do
!Yi Wen at 05062004 modified here: return value should only be 0 or 1
        if(failed .ne. 0) then
	    crschk_omp_num_threads = 0
        else
            crschk_omp_num_threads = 1
        endif
	end	

