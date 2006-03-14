<ompts:test>
<ompts:testdescription>Test which checks the omp_get_wtick function.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp_get_wtick</ompts:directive>
<ompts:testcode>
      INTEGER FUNCTION <ompts:testcode:functionname>omp_get_wticks</ompts:testcode:functionname>()
        USE omp_lib
        IMPLICIT NONE
        DOUBLE PRECISION tick
!        DOUBLE PRECISION omp_get_wtick
        tick = 1
		<ompts:check>
        tick=omp_get_wticK()
		</ompts:check>
        WRITE(1,*) "work took",tick,"sec. time."
        IF(tick .GT. 0. .AND. tick .LT. 0.01) THEN
          <testfunctionname></testfunctionname>=1
        ELSE
          <testfunctionname></testfunctionname>=0
        END IF
      END FUNCTION
</ompts:testcode>
</ompts:test>

      integer function crschk_omp_ticks_time()
        implicit none
        double precision tick
        tick=0.0
!        tick=omp_get_wtick()
        if(tick .gt. 0 .AND. tick .lt. 0.01) then
                crschk_omp_ticks_time=1
        else
                crschk_omp_ticks_time=0
        endif
      end


