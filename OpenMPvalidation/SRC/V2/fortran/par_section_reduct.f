<ompts:test>
<ompts:testdescription>Test which checks the omp parallel sections reduction directive with all its option.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp parallel sections reduction</ompts:directive>
<ompts:testcode>
      INTEGER FUNCTION <ompts:testcode:functionname>par_section_reduct</ompts:testcode:functionname>()
        IMPLICIT NONE
        INTEGER sum, sum2, known_sum, i, i2,diff
        INTEGER product,known_product,int_const
        INTEGER MAX_FACTOR
        DOUBLE PRECISION dsum,dknown_sum,dt,dpt
        DOUBLE PRECISION rounding_error, ddiff
        INTEGER DOUBLE_DIGITS
        LOGICAL logic_and, logic_or, logic_eqv,logic_neqv
        INTEGER bit_and, bit_or
        INTEGER exclusiv_bit_or
        INTEGER min_value, max_value
        DOUBLE PRECISION dmin, dmax
        INTEGER result
        INCLUDE "omp_testsuite.f"
        LOGICAL logics(1000)
        INTEGER int_array(1000)
        DOUBLE PRECISION d_array(1000)
        PARAMETER (int_const=10,known_product=3628800)
        PARAMETER (DOUBLE_DIGITS=20,MAX_FACTOR=10)
        PARAMETER (rounding_error=1.E-6)

        dt = 1./3.
        known_sum = (1000 * (1000 + 1)) / 2
        product = 1
        sum2 = 0
        sum = 0
        dsum = 0.
        result =0 
        logic_and = .TRUE.
        logic_or = .FALSE.
        bit_and = 1
        bit_or = 0
        exclusiv_bit_or = 0

!$omp parallel sections private(i) <ompts:check>reduction(+:sum)</ompts:check>
!$omp section
        DO i =1, 300
          sum = sum + i
        END DO
!$omp section
        DO i =301, 700
          sum = sum + i
        END DO
!$omp section
        DO i =701, 1000
          sum = sum + i
        END DO
!$omp end parallel sections

        IF (known_sum .NE. sum) THEN
          result = result + 1
          WRITE(1,*) "Error in sum with integers: Result was ",
     &       sum,"instead of ", known_sum
        END IF

        diff = (1000 * (1000 + 1)) / 2


!$omp parallel sections <ompts:check>reduction (-: diff)</ompts:check>
!$omp section
        DO i =1, 300
          diff = diff - i
        END DO
!$omp section
        DO i =301, 700
          diff = diff - i
        END DO
!$omp section
        DO i =701, 1000
          diff = diff - i
        END DO
!$omp end parallel sections
  
        IF ( diff .NE. 0 ) THEN
          result = result + 1
          WRITE(1,*) "Error in difference with integers: Result was ",
     &       sum,"instead of 0."
        END IF

!... Test for doubles
        dsum =0.
        dpt = 1

        DO i=1, DOUBLE_DIGITS
          dpt= dpt * dt
        END DO
        dknown_sum = (1-dpt)/(1-dt)
!$omp parallel sections <ompts:check>reduction(+:dsum)</ompts:check>
!$omp section
        DO i=0,6
           dsum = dsum + dt**i
        END DO
!$omp section
        DO i=7,12
           dsum = dsum + dt**i
        END DO
!$omp section
        DO i=13,DOUBLE_DIGITS-1
           dsum = dsum + dt**i
        END DO
!$omp end parallel sections

 
        IF(dsum .NE. dknown_sum .AND. 
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
!$omp parallel sections <ompts:check>reduction(-:ddiff)</ompts:check>
!$omp section
        DO i=0, 6
          ddiff = ddiff - dt**i
        END DO
!$omp section
        DO i=7, 12
          ddiff = ddiff - dt**i
        END DO
!$omp section
        DO i=13, DOUBLE_DIGITS-1
          ddiff = ddiff - dt**i
        END DO
!$omp end parallel sections

        IF ( ABS(ddiff) .GT. rounding_error ) THEN
           result = result + 1
           WRITE(1,*) "Error in Difference with doubles: Result was ",
     &       ddiff,"instead of 0.0"
        END IF

!$omp parallel sections <ompts:check>reduction(*:product)</ompts:check>
!$omp section
        DO i=1,3
           product = product * i
        END DO
!$omp section
        DO i=4,6
           product = product * i
        END DO
!$omp section
        DO i=7,10
           product = product * i
        END DO
!$omp end parallel sections

        IF (known_product .NE. product) THEN
           result = result + 1
           WRITE(1,*) "Error in Product with integers: Result was ",
     &       product," instead of",known_product 
         END IF

        DO i=1,1000
          logics(i) = .TRUE.
        END DO

!$omp parallel sections <ompts:check>reduction(.AND.:logic_and)</ompts:check>
!$omp section
        DO i=1,300
          logic_and = logic_and .AND. logics(i)
        END DO
!$omp section
        DO i=301,700
          logic_and = logic_and .AND. logics(i)
        END DO
!$omp section
        DO i=701,1000
          logic_and = logic_and .AND. logics(i)
        END DO
!$omp end parallel sections

        if (.not. logic_and) then
          result = result + 1
          write(1,*) "Error in logic AND part 1"
        end if


        logic_and = .TRUE.
        logics(1000/2) = .FALSE.

!$omp parallel sections <ompts:check>reduction(.AND.:logic_and)</ompts:check>
!$omp section
        DO i=1,300
          logic_and = logic_and .AND. logics(i)
        END DO
!$omp section
        DO i=301,700
          logic_and = logic_and .AND. logics(i)
        END DO
!$omp section
        DO i=701,1000
          logic_and = logic_and .AND. logics(i)
        END DO
!$omp end parallel sections

        IF (logic_and) THEN
          result = result + 1
          WRITE(1,*) "Error in logic AND pass 2"
        END IF

        DO i=1, 1000
          logics(i) = .FALSE.
        END DO

!$omp parallel sections <ompts:check>reduction(.OR.:logic_or)</ompts:check>
!$omp section
        DO i = 1, 300
          logic_or = logic_or .OR. logics(i)
        END DO
!$omp section
        DO i = 301, 700
          logic_or = logic_or .OR. logics(i)
        END DO
!$omp section
        DO i = 701, 1000
          logic_or = logic_or .OR. logics(i)
        END DO
!$omp end parallel sections

        IF (logic_or) THEN
          result = result + 1
          WRITE(1,*) "Error in logic OR part 1"
        END IF

        logic_or = .FALSE.
        logics(1000/2) = .TRUE.

!$omp parallel sections <ompts:check>reduction(.OR.:logic_or)</ompts:check>
!$omp section
        DO i=1,300
          logic_or = logic_or .OR. logics(i)
        END DO
!$omp section
        DO i=301,700
          logic_or = logic_or .OR. logics(i)
        END DO
!$omp section
        DO i=701,1000
          logic_or = logic_or .OR. logics(i)
        END DO
!$omp end parallel sections

        IF ( .NOT. logic_or ) THEN
          result = result + 1
          WRITE(1,*) "Error in logic OR part 2"
        END IF

!... Test logic EQV, unique in Fortran
        DO i=1, 1000
          logics(i) = .TRUE.
        END DO

        logic_eqv = .TRUE.

!$omp parallel sections <ompts:check>reduction(.EQV.:logic_eqv)</ompts:check>
!$omp section
        DO i = 1, 300
           logic_eqv = logic_eqv .EQV. logics(i)
        END DO
!$omp section
        DO i = 301, 700
           logic_eqv = logic_eqv .EQV. logics(i)
        END DO
!$omp section
        DO i = 701, 1000
           logic_eqv = logic_eqv .EQV. logics(i)
        END DO
!$omp end parallel sections

        IF (.NOT. logic_eqv) THEN
          result = result + 1
          WRITE(1,*) "Error in logic EQV part 1"
        END IF

        logic_eqv = .TRUE.
        logics(1000/2) = .FALSE.

!$omp parallel sections <ompts:check>reduction(.EQV.:logic_eqv)</ompts:check>
!$omp section
        DO i=1,300
           logic_eqv = logic_eqv .EQV. logics(i)
        END DO
!$omp section
        DO i=301,700
           logic_eqv = logic_eqv .EQV. logics(i)
        END DO
!$omp section
        DO i=701,1000
           logic_eqv = logic_eqv .EQV. logics(i)
        END DO
!$omp end parallel sections

        IF ( logic_eqv ) THEN
          result = result + 1
          WRITE(1,*) "Error in logic EQV part 2"
        END IF

!... Test logic NEQV, which is unique in Fortran
        DO i=1, 1000
          logics(i) = .FALSE.
        END DO

        logic_neqv = .FALSE.

!$omp parallel sections <ompts:check>reduction(.NEQV.:logic_neqv)</ompts:check>
!$omp section
        DO i = 1, 300
          logic_neqv = logic_neqv .NEQV. logics(i)
        END DO
!$omp section
        DO i = 301, 700
          logic_neqv = logic_neqv .NEQV. logics(i)
        END DO
!$omp section
        DO i = 701, 1000
          logic_neqv = logic_neqv .NEQV. logics(i)
        END DO
!$omp end parallel sections

        IF (logic_neqv) THEN
          result = result + 1
          WRITE(1,*) "Error in logic NEQV part 1"
        END IF

        logic_neqv = .FALSE.
        logics(1000/2) = .TRUE.

!$omp parallel sections <ompts:check>reduction(.NEQV.:logic_neqv)</ompts:check>
!$omp section
        DO i=1,300
           logic_neqv = logic_neqv .NEQV. logics(i)
        END DO
!$omp section
        DO i=301,700
           logic_neqv = logic_neqv .NEQV. logics(i)
        END DO
!$omp section
        DO i=701,1000
           logic_neqv = logic_neqv .NEQV. logics(i)
        END DO
!$omp end parallel sections

        IF ( .NOT. logic_neqv ) THEN
          result = result + 1
          WRITE(1,*) "Error in logic NEQV part 2"
        END IF

        DO i=1, 1000
          int_array(i) = 1
        END DO
!$omp parallel sections <ompts:check>reduction(IAND:bit_and)</ompts:check>
!... iand(I,J): Returns value resulting from boolean AND of
!... pair of bits in each of I and J.
!$omp section
        DO i=1, 300
          bit_and = IAND(bit_and,int_array(i))
        END DO
!$omp section
        DO i=301, 700
          bit_and = IAND(bit_and,int_array(i))
        END DO
!$omp section
        DO i=701, 1000
          bit_and = IAND(bit_and,int_array(i))
        END DO
!$omp end parallel sections

        IF ( bit_and .LT. 1 ) THEN
          result = result + 1
          WRITE(1,*) "Error in IAND part 1"
        END IF

        bit_and = 1
        int_array(1000/2) = 0

!$omp parallel sections <ompts:check>reduction(IAND:bit_and)</ompts:check>
!$omp section
        DO i=1, 300
          bit_and = IAND ( bit_and, int_array(i) )
        END DO
!$omp section
        DO i=301, 700
          bit_and = IAND ( bit_and, int_array(i) )
        END DO
!$omp section
        DO i=701, 1000
          bit_and = IAND ( bit_and, int_array(i) )
        END DO
!$omp end parallel sections

        IF( bit_and .GE. 1) THEN
          result = result + 1
          WRITE(1,*) "Error in IAND part 2"
        END IF

        DO i=1, 1000
          int_array(i) = 0
        END DO


!$omp parallel sections <ompts:check>reduction(IOR:bit_or)</ompts:check>
!... Ior(I,J): Returns value resulting from boolean OR of
!... pair of bits in each of I and J.
!$omp section
        DO i=1, 300
          bit_or = IOR(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=301, 700
          bit_or = IOR(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=701, 1000
          bit_or = IOR(bit_or, int_array(i) )
        END DO
!$omp end parallel sections

        IF ( bit_or .GE. 1) THEN
          result = result + 1
          WRITE(1,*) "Error in Ior part 1"
        END IF


        bit_or = 0
        int_array(1000/2) = 1
!$omp parallel sections <ompts:check>reduction(IOR:bit_or)</ompts:check>
!$omp section
        DO i=1, 300
          bit_or = IOR(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=301, 700
          bit_or = IOR(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=701, 1000
          bit_or = IOR(bit_or, int_array(i) )
        END DO
!$omp end parallel sections

        IF ( bit_or .LE. 0) THEN
          result = result + 1
          WRITE(1,*) "Error in Ior part 2"
        END IF

        DO i=1, 1000
          int_array(i) = 0
        END DO

!$omp parallel sections <ompts:check>reduction(IEOR:exclusiv_bit_or)</ompts:check>
!$omp section
        DO i = 1, 300
          exclusiv_bit_or = IEOR(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 301, 700
          exclusiv_bit_or = IEOR(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 701, 1000
          exclusiv_bit_or = IEOR(exclusiv_bit_or, int_array(i))
        END DO
!$omp end parallel sections

        IF ( exclusiv_bit_or .GE. 1) THEN
          result = result + 1
          WRITE(1,*) "Error in Ieor part 1"
        END IF

        exclusiv_bit_or = 0
        int_array(1000/2) = 1

!$omp parallel sections <ompts:check>reduction(IEOR:exclusiv_bit_or)</ompts:check>
!$omp section
        DO i = 1, 300
          exclusiv_bit_or = IEOR(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 301, 700
          exclusiv_bit_or = IEOR(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 701, 1000
          exclusiv_bit_or = IEOR(exclusiv_bit_or, int_array(i))
        END DO
!$omp end parallel sections

        IF ( exclusiv_bit_or .LE. 0) THEN
          result = result + 1
          WRITE(1,*) "Error in Ieor part 2"
        END IF

        DO i=1,1000
          int_array(i) = 10 - i
        END DO

        min_value = 65535

!$omp parallel sections <ompts:check>reduction(MIN:min_value)</ompts:check>
!$omp section
        DO i = 1, 300
          min_value = MIN(min_value,int_array(i) )
        END DO
!$omp section
        DO i = 301, 700
          min_value = MIN(min_value,int_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
          min_value = MIN(min_value,int_array(i) )
        END DO
!$omp end parallel sections

        IF ( min_value .GT. (10-1000) )THEN
          result = result + 1
          WRITE(1,*) "Error in integer MIN"
        END IF


        DO i=1,1000
          int_array(i) = i
        END DO

        max_value = -32768

!$omp parallel sections <ompts:check>reduction(MAX:max_value)</ompts:check>
!$omp section
        DO i = 1, 300
          max_value = MAX(max_value,int_array(i) )
        END DO
!$omp section
        DO i = 301, 700
          max_value = MAX(max_value,int_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
          max_value = MAX(max_value,int_array(i) )
        END DO
!$omp end parallel sections

        IF ( max_value .LT. 1000 )THEN
          result = result + 1
          WRITE(1,*) "Error in integer MAX"
        END IF

!... test double min, max
        DO i=1,1000
          d_array(i) = 10 - i*dt
        END DO

        dmin = 2**10
        dt = 0.5

!$omp parallel sections <ompts:check>reduction(MIN:dmin)</ompts:check>
!$omp section
        DO i = 1, 300
          dmin= MIN(dmin,d_array(i) )
        END DO
!$omp section
        DO i = 301, 700
          dmin= MIN(dmin,d_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
          dmin= MIN(dmin,d_array(i) )
        END DO
!$omp end parallel sections

        IF ( dmin .GT. (10-dt) )THEN
          result = result + 1
          WRITE(1,*) "Error in double MIN"
        END IF


        DO i=1,1000
          d_array(i) = i * dt
        END DO

        dmax= - (2**10)

!$omp parallel sections <ompts:check>reduction(MAX:dmax)</ompts:check>
!$omp section
        DO i = 1, 300
          dmax= MAX(dmax,d_array(i) )
        END DO
!$omp section
        DO i = 301, 700
          dmax= MAX(dmax,d_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
          dmax= MAX(dmax,d_array(i) )
        END DO
!$omp end parallel sections

        IF ( dmax .lt. 1000*dt )THEN
          result = result + 1
          write(1,*) "Error in double MAX"
        END IF

        IF ( result .EQ. 0 ) THEN
          <testfunctionname></testfunctionname> =  1
        ELSE
          <testfunctionname></testfunctionname> =  0
        END IF

        CLOSE(2)

      END FUNCTION
</ompts:testcode>
</ompts:test>
