
c$$$      subroutine my_sleep(double sleeptime)
c$$$  struct timeval tv;
c$$$  struct timezone tzp;
c$$$  double start;
c$$$  double real;
c$$$  if(gettimeofday(&tv,&tzp)!=0) {
c$$$    perror("get_time: ");
c$$$    exit(-1);
c$$$  }
c$$$  start = (double)tv.tv_sec + ((double)tv.tv_usec/1000000.0);
c$$$  real=start;
c$$$  while( (real-start)<sleeptime){
c$$$    if(gettimeofday(&tv,&tzp)!=0) {
c$$$      perror("get_time: ");
c$$$      exit(-1);
c$$$    }
c$$$    real = (double)tv.tv_sec + ((double)tv.tv_usec/1000000.0);
c$$$  }
c$$$}
c$$$      end

!********************************************************************
! Functions: omp_check_time
!********************************************************************

      integer function omp_check_time()
      implicit none
      double precision start
      double precision endtime
      double precision omp_get_wtime
      integer wait_time
      double precision measured_time
      wait_time=1
      start=omp_get_wtime()
      call sleep(wait_time)
      endtime=omp_get_wtime()
      measured_time=endtime-start
!      print *, "measureed time", measured_time
      if(measured_time.gt.0.99*wait_time .AND. 
     x measured_time .lt. 1.01*wait_time) then
              omp_check_time=1              
      else
              omp_check_time=0
      endif
      end

      integer function omp_crosscheck_time()
      implicit none
      double precision start
      double precision endtime
!      double precision omp_get_wtime
      integer wait_time
      double precision measured_time
      wait_time=1
      start=0
      endtime=0
      call sleep(wait_time)
     
      measured_time=endtime-start
  
      if(measured_time.gt.0.99*wait_time .AND. 
     x measured_time .lt. 1.01*wait_time) then
              omp_crosscheck_time=1
      else
              omp_crosscheck_time=0
      endif
      end

!********************************************************************
! Functions: omp_check_ticks
!********************************************************************


      integer function omp_check_ticks()
      implicit none
      double precision tick
      double precision omp_get_wtick
      tick=omp_get_wtick()
      if(tick .gt. 0 .AND. tick .lt. 0.01) then
              omp_check_ticks=1
      else
              omp_check_ticks=0
      endif
      end

      integer function omp_crosscheck_ticks()
      implicit none
      double precision tick
      tick=0.0
!      tick=omp_get_wtick()
      if(tick .gt. 0 .AND. tick .lt. 0.01) then
              omp_crosscheck_ticks=1
      else
              omp_crosscheck_ticks=0
      endif
      end

 
!***************************************************************************
! driver function
!***************************************************************************
      subroutine check_omp_times(N,failed,num_tests,crosschecked)
      implicit none
      integer, external::omp_check_time
      integer, external::omp_crosscheck_time
      integer, external::omp_check_ticks
      integer, external::omp_crosscheck_ticks

      character (len=20)::name
      integer failed
      integer N
      integer num_tests,crosschecked
      name="omp_get_wtime"
      call do_test(omp_check_time,omp_crosscheck_time,name,
     x N,failed,num_tests,crosschecked)
      name="omp_get_wtick"
      call do_test(omp_check_ticks,omp_crosscheck_ticks,
     x name,N,failed,num_tests,crosschecked)
      end
