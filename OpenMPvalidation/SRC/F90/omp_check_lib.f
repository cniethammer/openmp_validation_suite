!*********************************************************************
! Functions: check_has_omp
!*********************************************************************
!Yi Wen at 05032004: Do we want to write two versions of has_omp?
!both C23456789 and #ifdef formats are supposed to work.
!At least Sun's compiler cannot deal with the second format (#ifdef)
        integer function check_has_OpenMP()
         check_has_OpenMP=0
C23456789 
!$       check_has_OpenMP=1
!      #ifdef _OPENMP
!        check_has_OpenMP=1
!      #endif
	end

        integer function crosscheck_has_OpenMP()
        integer check_has_OpenMP
        crosscheck_has_OpenMP=0
!C23456789 
!!$      crosscheck_has_OpenMP=1
!#ifdef _OPENMP
!        crosscheck_has_OpenMP=1
!#endif
	end

!*********************************************************************
! Functions: check_omp_get_num_threads()
!*********************************************************************

        integer function chk_omp_get_num_threads()
        integer  nthreads, nthreads_lib 
        integer omp_get_num_threads
        nthreads=0
        nthreads_lib=-1
!$omp parallel 
!shared(nthreads,nthreads_lib)
!$omp critical
        nthreads = nthreads + 1
!$omp end critical
!$omp single
        nthreads_lib=omp_get_num_threads()
!$omp end single
!$omp end parallel
        if(nthreads .eq. nthreads_lib) then
          chk_omp_get_num_threads = 1
        else
          chk_omp_get_num_threads = 0
        end if
        end 


        integer function crosschk_omp_get_num_threads()
        integer  nthreads, nthreads_lib 
        nthreads=0
        nthreads_lib=-1
!$omp parallel 
!shared(nthreads,nthreads_lib)
!$omp critical
        nthreads = nthreads + 1
!$omp end critical
!!$omp single
!        nthreads_lib=omp_get_num_threads()
!!$omp end single
!$omp end parallel
        if(nthreads .eq. nthreads_lib) then
          crosschk_omp_get_num_threads = 1
        else
          crosschk_omp_get_num_threads = 0
        end if
        end 


!*********************************************************************
! Functions: chk_omp_in_parallel()
!*********************************************************************

        integer function chk_omp_in_parallel()
C   checks that false is returned when called from serial region
C     and true is returned when called within parallel region 
	logical serial, parallel, omp_in_parallel
        serial=.TRUE.
        parallel=.FALSE.
  	serial=omp_in_parallel()
!$omp parallel
!$omp single
      parallel=omp_in_parallel();
!$omp end single
!$omp end parallel
      if( .not. serial .and. parallel ) then
       chk_omp_in_parallel=1
      else
       chk_omp_in_parallel=0
      end if
      end


      integer function crosschk_omp_in_parallel()

	logical serial, parallel, omp_in_parallel
        serial=.TRUE.
        parallel=.FALSE.
!  	serial=omp_in_parallel()
!$omp parallel
!$omp single
!      parallel=omp_in_parallel();
!$omp end single
!$omp end parallel
      if( .not. serial .and. parallel ) then
       crosschk_omp_in_parallel=1
      else
       crosschk_omp_in_parallel=0
      end if
      end



!Modified by Yi Wen on 05032004
        subroutine check_omp_libs(N, failed,num_tests,crosschecked)
        integer, external::chk_omp_get_num_threads
        integer, external::crosschk_omp_get_num_threads
        integer, external::chk_omp_in_parallel
        integer, external::crosschk_omp_in_parallel
     
        integer, external::check_has_openmp
        integer, external::crosscheck_has_openmp
        integer num_tests,crosschecked
        character (len=20)::name
	integer failed
	integer N
        name="HAS OMP"
        call do_test(check_has_openmp,
     x   crosscheck_has_openmp,name,N,failed,num_tests,crosschecked)
        name="Get THREAD NUM"
        call do_test(chk_omp_get_num_threads,
     x    crosschk_omp_get_num_threads,name,N,failed,
     x    num_tests,crosschecked)
        name="OMP IN PARALLEL"
        call do_test(chk_omp_in_parallel,
     x    crosschk_omp_in_parallel,name,N,failed,num_tests,crosschecked)
        end 
