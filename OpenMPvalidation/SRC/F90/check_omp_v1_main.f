!This is the main driver to invoke different test functions
! more comments here.....
      program check_omp_v1_main
      implicit none
      integer failed 
      integer N
      integer num_tests,crosschecked
      num_tests=0
      crosschecked=0
      N=20
      failed=0
!Below we start to invoke driver functions for each test.
!A driver function manages several test functions residing in one file
!check omp libs
      call check_omp_libs(N,failed,num_tests,crosschecked)
!check does
      call check_omp_do(N,failed,num_tests,crosschecked)
!check sections
      call check_omp_section(N,failed,num_tests,crosschecked)
!check singles
      call check_omp_single(N,failed,num_tests,crosschecked)
!check parallel do
      call check_omp_parallel_do(N,failed,num_tests,crosschecked)
!check parallel section
      call check_omp_par_sect(N,failed,num_tests,crosschecked)
!check master
      call check_omp_master(N,failed,num_tests,crosschecked)
!check threadprivate and copyin
      call omp_check_threadprivate(N,failed,num_tests,crosschecked)
 
!check locks		
      call check_omp_locks(N,failed,num_tests,crosschecked)
!check critical and automic		
      call check_omp_critical_automics(N,failed,num_tests,crosschecked)
!final message:
      write (*,"(A,I2,A,I2,A,I2,A,I2,A)") "Performed a total of ", 
     x num_tests," tests, ", failed, " failed and ",num_tests-failed,
     x " successful with ", crosschecked, " cross checked."
      end program 
