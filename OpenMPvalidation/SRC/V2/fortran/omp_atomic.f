<ompts:test>
<ompts:testdescription>Test which checks the omp atomic directive by counting up a variable in a parallelized loop with an atomic directive.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp atomic</ompts:directive>
<ompts:testcode>
!********************************************************************
! Functions: chk_omp_atomic
! change "character*20" into "character (LEN=20)::"
! get rid of the "tab" key by Zhenying Liu, on Oct. 16, 2005.
!********************************************************************
      INTEGER FUNCTION <ompts:testcode:functionname>omp_atomic</ompts:testcode:functionname>()
        IMPLICIT NONE
        INTEGER sum, sum2, known_sum, i, i2,diff
        INTEGER product,known_product,int_const
        INTEGER MAX_FACTOR
        DOUBLE PRECISION dsum,dknown_sum,dt,dpt
        DOUBLE PRECISION rounding_error, ddiff
        INTEGER double_DIGITS
        LOGICAL logic_and, logic_or, logic_eqv,logic_neqv
        INTEGER bit_and, bit_or
        INTEGER exclusiv_bit_or
        INTEGER min_value, max_value
        DOUBLE PRECISION dmin, dmax
        INTEGER result
        INCLUDE "omp_testsuite.f"
        LOGICAL logics(LOOPCOUNT)
        INTEGER int_array(LOOPCOUNT)
        DOUBLE PRECISION d_array(LOOPCOUNT)
        PARAMETER (int_const=10,known_product=3628800)
        PARAMETER (double_DIGITS=20,MAX_FACTOR=10)
        PARAMETER (rounding_error=1.E-2)
        dt = 1./3.
        known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2
        product = 1
        sum2 = 0
        sum = 0
        dsum = 0.
        result =0 
        logic_and = .true.
        logic_or = .false.
        bit_and = 1
        bit_or = 0
        exclusiv_bit_or = 0
!$omp parallel
!$omp do 
        DO i =1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
          sum = sum + i
        END DO
!$omp end do
!$omp end parallel

        IF (known_sum .NE. sum) THEN
             result = result + 1
        WRITE(1,*) "Error in sum with integers: Result was ",
     &   sum,"instead of ", known_sum
        END If

        diff = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2


!$omp parallel
!$omp do 
        DO i =1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
          diff = diff - i
        END DO
!$omp end do
!$omp end parallel
  
        IF ( diff .NE. 0 ) THEN
          result = result + 1
        WRITE(1,*) "Error in difference with integers: Result was ",
     &   diff,"instead of 0."
        END IF

!... Test for doubles
        dsum = 0.
        dpt = 1

        DO i=1, DOUBLE_DIGITS
          dpt= dpt * dt
        END DO
        dknown_sum = (1-dpt)/(1-dt)
!$omp parallel
!$omp do 
        DO i=0,DOUBLE_DIGITS-1
<ompts:check>
!$omp atomic
</ompts:check>
              dsum = dsum + dt**i
        END DO
!$omp end do
!$omp end parallel

 
        IF (dsum .NE. dknown_sum .AND. 
     &     ABS(dsum - dknown_sum) .GT. rounding_error ) THEN
           result = result + 1
           WRITE(1,*) "Error in sum with doubles: Result was ",
     &       dsum,"instead of ",dknown_sum,"(Difference: ",
     &       dsum - dknown_sum,")"
        END IF
        dpt = 1

      
        DO i=1, DOUBLE_DIGITS
           dpt = dpt*dt
        END DO

        ddiff = ( 1-dpt)/(1-dt)
!$omp parallel
!$omp do 
        DO i=0, DOUBLE_DIGITS-1
<ompts:check>
!$omp atomic
</ompts:check>
          ddiff = ddiff - dt**i
        END DO
!$omp end do
!$omp end parallel

        IF ( ABS(ddiff) .GT. rounding_error ) THEN
           result = result + 1
           WRITE(1,*) "Error in Difference with doubles: Result was ",
     &       ddiff,"instead of 0.0"
        END IF

!$omp parallel
!$omp do 
        DO i=1,MAX_FACTOR
<ompts:check>
!$omp atomic
</ompts:check>
           product = product * i
        END DO
!$omp end do
!$omp end parallel

        IF (known_product .NE. product) THEN
           result = result + 1
           WRITE(1,*) "Error in Product with integers: Result was ",
     &       product," instead of",known_product 
        END IF

        DO i=1,LOOPCOUNT
          logics(i) = .TRUE.
        END DO

!$omp parallel
!$omp do 
        DO i=1,LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
          logic_and = logic_and .AND. logics(i)
        END DO
!$omp end do
!$omp end parallel

        IF (.NOT. logic_and) THEN
          result = result + 1
          WRITE(1,*) "Error in logic AND part 1"
        END IF


        logic_and = .TRUE.
        logics(LOOPCOUNT/2) = .FALSE.

!$omp parallel
!$omp do
        DO i=1,LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
          logic_and = logic_and .AND. logics(i)
        END DO
!$omp end do
!$omp end parallel

        IF (logic_and) THEN
           result = result + 1
           WRITE(1,*) "Error in logic AND pass 2"
        END IF

        DO i=1, LOOPCOUNT
         logics(i) = .FALSE.
        END DO

!$omp parallel
!$omp do 
        DO i = 1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
           logic_or = logic_or .OR. logics(i)
        END DO
!$omp end do
!$omp end parallel

        IF (logic_or) THEN
          result = result + 1
          WRITE(1,*) "Error in logic OR part 1"
        END IF

        logic_or = .FALSE.
        logics(LOOPCOUNT/2) = .TRUE.

!$omp parallel
!$omp do 
        DO i=1,LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
           logic_or = logic_or .OR. logics(i)
        END DO
!$omp end do
!$omp end parallel

        IF ( .NOT. logic_or ) THEN
          result = result + 1
          WRITE(1,*) "Error in logic OR part 2"
        END IF

!... Test logic EQV, unique in Fortran
        DO i=1, LOOPCOUNT
         logics(i) = .TRUE.
        END DO

        logic_eqv = .TRUE.

!$omp parallel
!$omp do 
        DO i = 1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
           logic_eqv = logic_eqv .EQV. logics(i)
        END DO
!$omp end do
!$omp end parallel

        IF (.NOT. logic_eqv) THEN
          result = result + 1
          WRITE(1,*) "Error in logic EQV part 1"
        END IF

        logic_eqv = .TRUE.
        logics(LOOPCOUNT/2) = .FALSE.

!$omp parallel
!$omp do 
        DO i=1,LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
           logic_eqv = logic_eqv .EQV. logics(i)
        END DO
!$omp end do
!$omp end parallel

        IF ( logic_eqv ) THEN
          result = result + 1
          WRITE(1,*) "Error in logic EQV part 2"
        END IF

!... Test logic NEQV, which is unique in Fortran
        DO i=1, LOOPCOUNT
         logics(i) = .FALSE.
        END DO

        logic_neqv = .FALSE.

!$omp parallel
!$omp do 
        DO i = 1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
           logic_neqv = logic_neqv .OR. logics(i)
        END DO
!$omp end do
!$omp end parallel

        IF (logic_neqv) THEN
          result = result + 1
          WRITE(1,*) "Error in logic NEQV part 1"
        END IF

        logic_neqv = .FALSE.
        logics(LOOPCOUNT/2) = .TRUE.

!$omp parallel
!$omp do 
        DO i=1,LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
           logic_neqv = logic_neqv .OR. logics(i)
        END DO
!$omp end do
!$omp end parallel

        IF ( .NOT. logic_neqv ) THEN
          result = result + 1
          WRITE(1,*) "Error in logic NEQV part 2"
        END IF

        DO i=1, LOOPCOUNT
          int_array(i) = 1
        END DO
!$omp parallel
!$omp do 
        DO i=1, LOOPCOUNT
!... iand(I,J): Returns value resulting from boolean AND of 
!... pair of bits in each of I and J. 
<ompts:check>
!$omp atomic
</ompts:check>
          bit_and = IAND(bit_and,int_array(i))
        END DO
!$omp end do
!$omp end parallel

        IF ( bit_and .LT. 1 ) THEN
          result = result + 1
          WRITE(1,*) "Error in IAND part 1"
        END If

        bit_and = 1
        int_array(LOOPCOUNT/2) = 0

!$omp parallel
!$omp do 
        DO i=1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
          bit_and = IAND ( bit_and, int_array(i) )
        END DO
!$omp end do
!$omp end parallel

        IF( bit_and .GE. 1) THEN
          result = result + 1
          WRITE(1,*) "Error in IAND part 2"
        END IF

        DO i=1, LOOPCOUNT
          int_array(i) = 0
        END DO


!$omp parallel
!$omp do 
        DO i=1, LOOPCOUNT
!... Ior(I,J): Returns value resulting from boolean OR of 
!... pair of bits in each of I and J. 
<ompts:check>
!$omp atomic
</ompts:check>
          bit_or = Ior(bit_or, int_array(i) )
        END DO
!$omp end do
!$omp end parallel

        IF ( bit_or .GE. 1) THEN
          result = result + 1
          WRITE(1,*) "Error in Ior part 1"
        END IF


        bit_or = 0
        int_array(LOOPCOUNT/2) = 1
!$omp parallel
!$omp do 
        DO i=1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
          bit_or = IOR(bit_or, int_array(i) )
        END DO
!$omp end do
!$omp end parallel

        IF ( bit_or .le. 0) THEN
          result = result + 1
          WRITE(1,*) "Error in Ior part 2"
        END IF

        DO i=1, LOOPCOUNT
          int_array(i) = 0
        END DO

!$omp parallel
!$omp do 
        DO i = 1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
            exclusiv_bit_or = IEOR(exclusiv_bit_or, int_array(i))
        END DO
!$omp end do
!$omp end parallel

        IF ( exclusiv_bit_or .GE. 1) THEN
           result = result + 1
           WRITE(1,*) "Error in Ieor part 1"
        END IF

        exclusiv_bit_or = 0
        int_array(LOOPCOUNT/2) = 1

!$omp parallel
!$omp do 
        DO i = 1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp end do
!$omp end parallel

        IF ( exclusiv_bit_or .LE. 0) THEN
          result = result + 1
          WRITE(1,*) "Error in Ieor part 2"
        END IF

        DO i=1,LOOPCOUNT
           int_array(i) = 10 - i
        END DO

        min_value = 65535

!$omp parallel
!$omp do 
        DO i = 1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
            min_value = min(min_value,int_array(i) )
        END DO
!$omp end do
!$omp end parallel

        IF ( min_value .GT. (10-LOOPCOUNT) )THEN
          result = result + 1
          WRITE(1,*) "Error in integer MIN"
        END IF


        DO i=1,LOOPCOUNT
           int_array(i) = i
        END DO

        max_value = -32768

!$omp parallel
!$omp do 
        DO i = 1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
            max_value = max(max_value,int_array(i) )
        END DO
!$omp end do
!$omp end parallel

        IF ( max_value .LT. LOOPCOUNT )THEN
          result = result + 1
          WRITE(1,*) "Error in integer MAX"
        END IF

!... test double min, max
        DO i=1,LOOPCOUNT
           d_array(i) = 10 - i*dt
        END DO

        dmin = 2**10
        dt = 0.5

!$omp parallel
!$omp do 
        DO i = 1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
            dmin= MIN(dmin,d_array(i) )
        END DO
!$omp end do
!$omp end parallel

        IF ( dmin .GT. (10-dt) )THEN
          result = result + 1
          WRITE(1,*) "Error in double MIN"
        END IF


        DO i=1,LOOPCOUNT
          d_array(i) = i * dt
        END DO

        dmax= - (2**10)

!$omp parallel
!$omp do 
        DO i = 1, LOOPCOUNT
<ompts:check>
!$omp atomic
</ompts:check>
          dmax= max(dmax,d_array(i) )
        END DO
!$omp end do
!$omp end parallel

        IF ( dmax .LT. LOOPCOUNT*dt )THEN
          result = result + 1
          WRITE(1,*) "Error in double MAX"
        END IF

        IF ( result .EQ. 0 ) THEN
          <testfunctionname></testfunctionname>=  1
        ELSE
          <testfunctionname></testfunctionname>=  0
        END IF

      END FUNCTION
</ompts:testcode>
</ompts:test>


        integer function crschk_omp_atomic()
        implicit none
        integer sum, sum2, known_sum, i, i2,diff
        integer product,known_product,int_const
        integer MAX_FACTOR
        double precision dsum,dknown_sum,dt,dpt
        double precision rounding_error, ddiff
        integer double_DIGITS
        logical logic_and, logic_or, logic_eqv,logic_neqv
        integer bit_and, bit_or
        integer exclusiv_bit_or
        integer min_value, max_value
        double precision dmin, dmax
        integer result
        include "omp_testsuite.f"
        logical logics(LOOPCOUNT)
        integer int_array(LOOPCOUNT)
        double precision d_array(LOOPCOUNT)
        parameter (int_const=10,known_product=3628800)
        parameter (DOUBLE_DIGITS=20,MAX_FACTOR=10)
        parameter (rounding_error=1.E-2)
        dt = 1./3.
        known_sum = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2
        product = 1
        sum2 = 0
        sum = 0
        dsum = 0.
        result =0 
        logic_and = .true.
        logic_or = .false.
        bit_and = 1
        bit_or = 0
        exclusiv_bit_or = 0
!$omp parallel
!$omp do 
        do i =1, LOOPCOUNT
!$omp atomic
          sum = sum + i
        end do
!$omp end do
!$omp end parallel

       if (known_sum .ne. sum) then
             result = result + 1
        end if

        diff = (LOOPCOUNT * (LOOPCOUNT + 1)) / 2



!$omp parallel
!$omp do 
        do i =1, LOOPCOUNT
!$omp atomic
          diff = diff - i
        end do
!$omp end do
!$omp end parallel
  
        if ( diff .NE. 0 ) then
          result = result + 1
!        write(1,*) "Error in difference with integers: Result was ",
!     &   sum,"instead of 0."
        end if

!... Test for doubles
       dsum =0.
        dpt = 1

       do i=1, DOUBLE_DIGITS
          dpt= dpt * dt
       end do
        dknown_sum = (1-dpt)/(1-dt)
!$omp parallel
!$omp do 
        do i=0,DOUBLE_DIGITS-1
!$omp atomic
              dsum = dsum + dt**i
        end do
!$omp end do
!$omp end parallel

 
         if(dsum .ne. dknown_sum .or. 
     &     abs(dsum - dknown_sum) .gt. rounding_error ) then
           result = result + 1
!           write(1,*) "Error in sum with doubles: Result was ",
!     &       dsum,"instead of ",dknown_sum,"(Difference: ",
!     &       dsum - dknown_sum,")"
         end if
        dpt = 1


      
        do i=1, DOUBLE_DIGITS
           dpt = dpt*dt
        end do
        ddiff = ( 1-dpt)/(1-dt)
!$omp parallel
!$omp do 
        do i=0, DOUBLE_DIGITS-1
!$omp atomic
          ddiff = ddiff - dt**i
        end do
!$omp end do
!$omp end parallel

        if ( ddiff .GT. rounding_error .or.
     &       ddiff .GT. (-rounding_error) ) then
           result = result + 1
!           write(1,*) "Error in Difference with doubles: Result was ",
!     &       ddiff,"instead of 0.0"
        end if

!$omp parallel
!$omp do 
        do i=1,MAX_FACTOR
!$omp atomic
           product = product * i
        end do
!$omp end do
!$omp end parallel

        if (known_product .NE. product) then
           result = result + 1
!           write(1,*) "Error in Product with integers: Result was ",
!     &       product," instead of",known_product 
        end if

        do i=1,LOOPCOUNT
          logics(i) = .true.
        end do

!$omp parallel
!$omp do
        do i=1,LOOPCOUNT
!$omp atomic
          logic_and = logic_and .and. logics(i)
        end do
!$omp end do
!$omp end parallel

        if (.not. logic_and) then
          result = result + 1
!          write(1,*) "Error in logic AND part 1"
        end if


        logic_and = .true.
        logics(LOOPCOUNT/2) = .false.

!$omp parallel
!$omp do 
        do i=1,LOOPCOUNT
!$omp atomic
          logic_and = logic_and .and. logics(i)
        end do
!$omp end do
!$omp end parallel

        if (logic_and) then
           result = result + 1
!           write(1,*) "Error in logic AND pass 2"
        end if




        do i=1, LOOPCOUNT
         logics(i) = .false.
        end do

!$omp parallel
!$omp do 
        do i = 1, LOOPCOUNT
!$omp atomic
           logic_or = logic_or .or. logics(i)
        end do
!$omp end do
!$omp end parallel

        if (logic_or) then
          result = result + 1
!	  write(1,*) "Error in logic OR part 1"
        end if

        logic_or = .false.
        logics(LOOPCOUNT/2) = .true.

!$omp parallel
!$omp do 
        do i=1,LOOPCOUNT
!$omp atomic
           logic_or = logic_or .or. logics(i)
        end do
!$omp end do
!$omp end parallel

        if ( .not. logic_or ) then
          result = result + 1
!          write(1,*) "Error in logic OR part 2"
        end if

!... Test logic EQV, unique in Fortran
        do i=1, LOOPCOUNT
         logics(i) = .true.
        end do

        logic_eqv = .true.

!$omp parallel
!$omp do 
        do i = 1, LOOPCOUNT
!$omp atomic
           logic_eqv = logic_eqv .eqv. logics(i)
        end do
!$omp end do
!$omp end parallel

        if (.not. logic_eqv) then
          result = result + 1
!	  write(1,*) "Error in logic EQV part 1"
        end if

        logic_eqv = .true.
        logics(LOOPCOUNT/2) = .false.

!$omp parallel
!$omp do 
        do i=1,LOOPCOUNT
!$omp atomic
           logic_eqv = logic_eqv .eqv. logics(i)
        end do
!$omp end do
!$omp end parallel

        if ( logic_eqv ) then
          result = result + 1
!          write(1,*) "Error in logic EQV part 2"
        end if

!... Test logic NEQV, which is unique in Fortran
        do i=1, LOOPCOUNT
         logics(i) = .false.
        end do

        logic_neqv = .false.

!$omp parallel
!$omp do 
        do i = 1, LOOPCOUNT
!$omp atomic
           logic_neqv = logic_neqv .or. logics(i)
        end do
!$omp end do
!$omp end parallel

        if (logic_neqv) then
          result = result + 1
!	  write(1,*) "Error in logic NEQV part 1"
        end if

        logic_neqv = .false.
        logics(LOOPCOUNT/2) = .true.

!$omp parallel
!$omp do 
        do i=1,LOOPCOUNT
!$omp atomic
           logic_neqv = logic_neqv .or. logics(i)
        end do
!$omp end do
!$omp end parallel

        if ( .not. logic_neqv ) then
          result = result + 1
!          write(1,*) "Error in logic NEQV part 2"
        end if


        do i=1, LOOPCOUNT
           int_array(i) = 1
        end do
!$omp parallel
!$omp do 
        do i=1, LOOPCOUNT
!... iand(I,J): Returns value resulting from boolean AND of 
!... pair of bits in each of I and J. 
!$omp atomic
         bit_and = iand(bit_and,int_array(i))
        end do
!$omp end do
!$omp end parallel

        if ( bit_and .lt. 1 ) then
          result = result + 1
!          write(1,*) "Error in IAND part 1"
        end if

        bit_and = 1
        int_array(LOOPCOUNT/2) = 0

!$omp parallel
!$omp do 
        do i=1, LOOPCOUNT
!$omp atomic
          bit_and = Iand ( bit_and, int_array(i) )
        end do
!$omp end do
!$omp end parallel

        if( bit_and .ge. 1) then
           result = result + 1
!          write(1,*) "Error in IAND part 2"
        end if

      do i=1, LOOPCOUNT
        int_array(i) = 0
      end do


!$omp parallel
!$omp do 
        do i=1, LOOPCOUNT
!... Ior(I,J): Returns value resulting from boolean OR of 
!... pair of bits in each of I and J. 
!$omp atomic
          bit_or = Ior(bit_or, int_array(i) )
        end do
!$omp end do
!$omp end parallel

        if ( bit_or .ge. 1) then
           result = result + 1
!          write(1,*) "Error in Ior part 1"
        end if


        bit_or = 0
        int_array(LOOPCOUNT/2) = 1
!$omp parallel
!$omp do 
        do i=1, LOOPCOUNT
!$omp atomic
          bit_or = Ior(bit_or, int_array(i) )
        end do
!$omp end do
!$omp end parallel

        if ( bit_or .le. 0) then
           result = result + 1
!          write(1,*) "Error in Ior part 2"
        end if

        do i=1, LOOPCOUNT
          int_array(i) = 0
        end do

!$omp parallel
!$omp do 
        do i = 1, LOOPCOUNT
!$omp atomic
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        end do
!$omp end do
!$omp end parallel

        if ( exclusiv_bit_or .ge. 1) then
           result = result + 1
!           write(1,*) "Error in Ieor part 1"
        end if

        exclusiv_bit_or = 0
        int_array(LOOPCOUNT/2) = 1

!$omp parallel
!$omp do
        do i = 1, LOOPCOUNT
!$omp atomic
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        end do
!$omp end do
!$omp end parallel

        if ( exclusiv_bit_or .le. 0) then
          result = result + 1
!          write(1,*) "Error in Ieor part 2"
        end if

        do i=1,LOOPCOUNT
           int_array(i) = 10 - i
        end do

        min_value = 65535

!$omp parallel
!$omp do 
        do i = 1, LOOPCOUNT
!$omp atomic
            min_value = min(min_value,int_array(i) )
        end do
!$omp end do
!$omp end parallel


        if ( min_value .gt. (10-LOOPCOUNT) )then
          result = result + 1
!          write(1,*) "Error in integer MIN"
        end if

        do i=1,LOOPCOUNT
           int_array(i) = i
        end do

        max_value = -32768

!$omp parallel
!$omp do 
        do i = 1, LOOPCOUNT
!$omp atomic
            max_value = max(max_value,int_array(i) )
        end do
!$omp end do
!$omp end parallel

        if ( max_value .lt. LOOPCOUNT )then
          result = result + 1
!          write(1,*) "Error in integer MAX"
        end if

!... test double min, max
        do i=1,LOOPCOUNT
           d_array(i) = 10 - i*dt
        end do

        dmin = 2**10
        dt = 0.5

!$omp parallel
!$omp do 
        do i = 1, LOOPCOUNT
!$omp atomic
            dmin= min(dmin,d_array(i) )
        end do
!$omp end do
!$omp end parallel

        if ( dmin .gt. (10-dt) )then
          result = result + 1
!          write(1,*) "Error in double MIN"
        end if


        do i=1,LOOPCOUNT
           d_array(i) = i * dt
        end do

        dmax= - (2**10)

!$omp parallel
!$omp do 
        do i = 1, LOOPCOUNT
!$omp atomic
            dmax= max(dmax,d_array(i) )
        end do
!$omp end do
!$omp end parallel

        if ( dmax .lt. LOOPCOUNT*dt )then
          result = result + 1
!          write(1,*) "Error in double MAX"
        end if

        if ( result .eq. 0 ) then
         crschk_omp_atomic =  1
        else
           crschk_omp_atomic =  0
        end if

        close(2)

       end

