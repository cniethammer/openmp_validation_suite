!This is the main driver to invoke different test functions
! more comments here.....
      program check_omp_v2_main
      implicit none
      integer failed
      integer N
      integer num_tests,crosschecked
      num_tests=0
      N=20
      failed=0
      crosschecked=0
!Below we start to invoke driver functions for each test.
!A driver function manages several test functions residing in one file

!check omp_get_num_threads
      call check_num_threads(N,failed,num_tests,crosschecked)
!check omp time functions
      call check_omp_times(N,failed,num_tests,crosschecked)
!check single copyprivate
      call check_copyprivate(N,failed,num_tests,crosschecked)
!final message:
      write (*,"(A,I1,A,I1,A,I1,A,I1,A)") "Performed a total of ", 
     x num_tests," tests, ", failed, " failed and ",num_tests-failed,
     x " successful with ", crosschecked, " cross checked."
      end program 
