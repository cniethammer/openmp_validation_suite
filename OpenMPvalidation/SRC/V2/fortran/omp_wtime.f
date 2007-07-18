<ompts:test>
<ompts:testdescription>Test which checks the omp_get_wtime function. It compares the time with which is called a sleep function with the time it took by messuring the difference between the call of the sleep function and its end.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp_get_wtime</ompts:directive>
<ompts:testcode>
      INTEGER FUNCTION <ompts:testcode:functionname>omp_wtime</ompts:testcode:functionname>(fileunit)
        USE omp_lib
        IMPLICIT NONE
        <ompts:orphan:vars>
        DOUBLE PRECISION start
        DOUBLE PRECISION endtime
        COMMON start, endtime
        </ompts:orphan:vars>
        INTEGER wait_time
        DOUBLE PRECISION measured_time
        INTEGER fileunit
        wait_time=1

        start = 0;
        endtime = 0;

                <ompts:orphan>
                <ompts:check>
        start=omp_get_wtime()
                </ompts:check>
                </ompts:orphan>
        CALL sleep(wait_time)
                <ompts:orphan>
                <ompts:check>
        endtime=omp_get_wtime()
                </ompts:check>
                </ompts:orphan>
        measured_time=endtime-start
        WRITE(1,*) "work took",measured_time,"sec. time."
        IF(measured_time.GT.0.99*wait_time .AND.
     & measured_time .LT. 1.01*wait_time) THEN
              <testfunctionname></testfunctionname>=1
        ELSE
              <testfunctionname></testfunctionname>=0
        END IF
      END
</ompts:testcode>
</ompts:test>

!*****************************************************
      integer function crschk_omp_time(fileunit)
      implicit none
      double precision start
      double precision endtime
!      double precision omp_get_wtime
      integer wait_time
      double precision measured_time
      integer fileunit
      wait_time=1
      start=0
      endtime=0
      call sleep(wait_time)

      measured_time=endtime-start
      write(1,*) "work took",measured_time,"sec. time."

      if(measured_time.gt.0.9*wait_time .AND.
     x measured_time .lt. 1.1*wait_time) then
              crschk_omp_time=1
      else
              crschk_omp_time=0
      endif
      end

