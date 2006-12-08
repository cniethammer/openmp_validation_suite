<ompts:test>
<ompts:testdescription>Test which checks the omp sections reduction directive with all its options.</ompts:testdescription>
<ompts:ompversion>2.0</ompts:ompversion>
<ompts:directive>omp sections reduction</ompts:directive>
<ompts:testcode>
      INTEGER FUNCTION <ompts:testcode:functionname>section_reduction</ompts:testcode:functionname>()
        IMPLICIT NONE
        INTEGER sum2, known_sum, i2
        INTEGER known_product,int_const
        INTEGER MAX_FACTOR
        DOUBLE PRECISION dknown_sum,dpt
        INTEGER result
        INCLUDE "omp_testsuite.f"
        PARAMETER (int_const=10,known_product=3628800)

        <ompts:orphan:vars>
        INTEGER i,dummy
        INTEGER sum, dIFf
        DOUBLE PRECISION dt
        DOUBLE PRECISION dsum, ddIFf
        INTEGER product
        LOGICAL logics(1000)
        INTEGER int_array(1000)
        LOGICAL logic_and, logic_or, logic_eqv,logic_neqv
        INTEGER bit_and, bit_or
        INTEGER exclusiv_bit_or
        INTEGER min_value, max_value
        DOUBLE PRECISION d_array(1000)
        DOUBLE PRECISION dmin, dmax

        INTEGER DOUBLE_DIGITS
        PARAMETER (DOUBLE_DIGITS=20,MAX_FACTOR=10)
        DOUBLE PRECISION rounding_error
        PARAMETER (rounding_error=1.E-6)

        COMMON /orphvars/ i,sum,dIFf,product,dt,dsum,ddIFf,logic_and,
     &    logic_or,logic_eqv,logic_neqv,logics,int_array,bit_and,bit_or,
     &    exclusiv_bit_or,min_value,dmin,dmax,d_array,max_value
        </ompts:orphan:vars>

        dt = 1./3.
        known_sum = (1000 * (1000 + 1)) / 2
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
<ompts:orphan>
!$omp sections private(i) <ompts:check>reduction(+:sum)</ompts:check>
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
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF (known_sum .NE. sum) THEN
          result = result + 1
        WRITE(1,*) "Error in sum with integers: Result was ",
     &    sum,"instead of ", known_sum
        END IF

        dIFf = known_sum



!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction (-: dIFf)</ompts:check>
!$omp section
        DO i =1, 300
          dIFf = dIFf - i
        END DO
!$omp section
        DO i =301, 700
          dIFf = dIFf - i
        END DO
!$omp section
        DO i =701, 1000
          dIFf = dIFf - i
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel
  
        IF ( dIFf .NE. 0 ) THEN
          result = result + 1
        WRITE(1,*) "Error in dIFference with integers: Result was ",
     &    sum,"instead of 0."
        END IF

!**********************************************************************!
!   Test for DOubles
!**********************************************************************!
        dsum = 0.
        dpt = 1

        DO i=1, DOUBLE_DIGITS
          dpt= dpt * dt
        END DO
        dknown_sum = (1-dpt)/(1-dt)

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(+:dsum)</ompts:check>
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
!$omp END sections
</ompts:orphan>
!$omp END parallel

 
        IF (dsum .NE. dknown_sum .AND. 
     &    abs(dsum - dknown_sum) .GT. rounding_error ) THEN
          result = result + 1
          WRITE(1,*) "Error in sum with DOubles: Result was ",
     &      dsum,"instead of ",dknown_sum,"(DIFference: ",
     &      dsum - dknown_sum,")"
        END IF

        dpt = 1
        DO i=1, DOUBLE_DIGITS
          dpt = dpt*dt
        END DO

        ddIFf = ( 1-dpt)/(1-dt)
!$omp parallel
!$omp sections <ompts:check>reduction(-:ddIFf)</ompts:check>
!$omp section
        DO i=0, 6
          ddIFf = ddIFf - dt**i
        END DO
!$omp section
        DO i=7, 12
          ddIFf = ddIFf - dt**i
        END DO
!$omp section
        DO i=13, DOUBLE_DIGITS-1
          ddIFf = ddIFf - dt**i
        END DO
!$omp END sections
!$omp END parallel

        IF ( abs(ddIFf) .GT. rounding_error ) THEN
          result = result + 1
          WRITE(1,*) "Error in DIFference with DOubles: Result was ",
     &      ddIFf,"instead of 0.0"
        END IF

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(*:product)</ompts:check>
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
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF (known_product .NE. product) THEN
          result = result + 1
          WRITE(1,*) "Error in Product with integers: Result was ",
     &      product," instead of",known_product 
        END IF

        DO i=1,1000
          logics(i) = .TRUE.
        END DO

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(.and.:logic_and)</ompts:check>
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
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF (.NOT. logic_and) THEN
          result = result + 1
          WRITE(1,*) "Error in logic AND part 1"
        END IF


        logic_and = .TRUE.
        logics(1000/2) = .FALSE.

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(.and.:logic_and)</ompts:check>
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
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF (logic_and) THEN
           result = result + 1
           WRITE(1,*) "Error in logic AND pass 2"
        END IF

        DO i=1, 1000
         logics(i) = .FALSE.
        END DO

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(.or.:logic_or)</ompts:check>
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
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF (logic_or) THEN
          result = result + 1
          WRITE(1,*) "Error in logic OR part 1"
        END IF

        logic_or = .FALSE.
        logics(1000/2) = .TRUE.

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(.or.:logic_or)</ompts:check>
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
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( .NOT. logic_or ) THEN
          result = result + 1
          WRITE(1,*) "Error in logic OR part 2"
        END IF

!... Test logic EQV, unique in Fortran
        DO i=1, 1000
         logics(i) = .TRUE.
        END DO

        logic_eqv = .TRUE.

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(.eqv.:logic_eqv)</ompts:check>
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
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF (.NOT. logic_eqv) THEN
          result = result + 1
          WRITE(1,*) "Error in logic EQV part 1"
        END IF

        logic_eqv = .TRUE.
        logics(1000/2) = .FALSE.

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(.eqv.:logic_eqv)</ompts:check>
!$omp section
        DO i=1,300
           logic_eqv = logic_eqv .EQV. logics(i)
        END DO
!$omp section
        DO i=301,700
           logic_eqv = logic_eqv .eqv. logics(i)
        END DO
!$omp section
        DO i=701,1000
           logic_eqv = logic_eqv .eqv. logics(i)
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( logic_eqv ) THEN
          result = result + 1
          WRITE(1,*) "Error in logic EQV part 2"
        END IF

!... Test logic NEQV, which is unique in Fortran
        DO i=1, 1000
         logics(i) = .false.
        END DO

        logic_neqv = .false.

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(.neqv.:logic_neqv)</ompts:check>
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
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF (logic_neqv) THEN
          result = result + 1
          WRITE(1,*) "Error in logic NEQV part 1"
        END IF

        logic_neqv = .FALSE.
        logics(1000/2) = .TRUE.

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(.neqv.:logic_neqv)</ompts:check>
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
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( .NOT. logic_neqv ) THEN
          result = result + 1
          write(1,*) "Error in logic NEQV part 2"
        END IF

        DO i=1, 1000
           int_array(i) = 1
        END DO

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(iand:bit_and)</ompts:check>
!... iand(I,J): Returns value resulting from boolean AND of
!... pair of bits in each of I and J.
!$omp section
        DO i=1, 300
         bit_and = iand(bit_and,int_array(i))
        END DO
!$omp section
        DO i=301, 700
         bit_and = iand(bit_and,int_array(i))
        END DO
!$omp section
        DO i=701, 1000
         bit_and = iand(bit_and,int_array(i))
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( bit_and .lt. 1 ) THEN
          result = result + 1
          write(1,*) "Error in IAND part 1"
        END IF

        bit_and = 1
        int_array(1000/2) = 0

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(iand:bit_and)</ompts:check>
!$omp section
        DO i=1, 300
          bit_and = iand ( bit_and, int_array(i) )
        END DO
!$omp section
        DO i=301, 700
          bit_and = iand ( bit_and, int_array(i) )
        END DO
!$omp section
        DO i=701, 1000
          bit_and = iand ( bit_and, int_array(i) )
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF( bit_and .GE. 1) THEN
           result = result + 1
          WRITE(1,*) "Error in IAND part 2"
        END IF

        DO i=1, 1000
          int_array(i) = 0
        END DO


!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(ior:bit_or)</ompts:check>
!... Ior(I,J): Returns value resulting from boolean OR of
!... pair of bits in each of I and J.
!$omp section
        DO i=1, 300
          bit_or = ior(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=301, 700
          bit_or = ior(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=701, 1000
          bit_or = ior(bit_or, int_array(i) )
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( bit_or .GE. 1) THEN
           result = result + 1
          WRITE(1,*) "Error in Ior part 1"
        END IF


        bit_or = 0
        int_array(1000/2) = 1
!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(ior:bit_or)</ompts:check>
!$omp section
        DO i=1, 300
          bit_or = Ior(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=301, 700
          bit_or = Ior(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=701, 1000
          bit_or = Ior(bit_or, int_array(i) )
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( bit_or .LE. 0) THEN
           result = result + 1
          WRITE(1,*) "Error in Ior part 2"
        END IF

        DO i=1, 1000
          int_array(i) = 0
        END DO

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(ieor:exclusiv_bit_or)</ompts:check>
!$omp section
        DO i = 1, 300
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 301, 700
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 701, 1000
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( exclusiv_bit_or .GE. 1) THEN
           result = result + 1
           WRITE(1,*) "Error in Ieor part 1"
        END IF

        exclusiv_bit_or = 0
        int_array(1000/2) = 1

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(ieor:exclusiv_bit_or)</ompts:check>
!$omp section
        DO i = 1, 300
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 301, 700
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 701, 1000
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( exclusiv_bit_or .LE. 0) THEN
          result = result + 1
          WRITE(1,*) "Error in Ieor part 2"
        END IF

        DO i=1,1000
           int_array(i) = 10 - i
        END DO

        min_value = 65535

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(min:min_value)</ompts:check>
!$omp section
        DO i = 1, 300
            min_value = min(min_value,int_array(i) )
        END DO
!$omp section
        DO i = 301, 700
            min_value = min(min_value,int_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
            min_value = min(min_value,int_array(i) )
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( min_value .GT. (10-1000) ) THEN
          result = result + 1
          WRITE(1,*) "Error in integer MIN"
        END IF


        DO i=1,1000
           int_array(i) = i
        END DO

        max_value = -32768

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(max:max_value)</ompts:check>
!$omp section
        DO i = 1, 300
            max_value = max(max_value,int_array(i) )
        END DO
!$omp section
        DO i = 301, 700
            max_value = max(max_value,int_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
            max_value = max(max_value,int_array(i) )
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( max_value .LT. 1000 ) THEN
          result = result + 1
          WRITE(1,*) "Error in integer MAX"
        END IF

!... test DOuble min, max
        DO i=1,1000
           d_array(i) = 10 - i*dt
        END DO

        dmin = 2**10
        dt = 0.5

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(min:dmin)</ompts:check>
!$omp section
        DO i = 1, 300
            dmin= min(dmin,d_array(i) )
        END DO
!$omp section
        DO i = 301, 700
            dmin= min(dmin,d_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
            dmin= min(dmin,d_array(i) )
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( dmin .GT. (10-dt) ) THEN
          result = result + 1
          WRITE(1,*) "Error in DOuble MIN"
        END IF


        DO i=1,1000
           d_array(i) = i * dt
        END DO

        dmax= - (2**10)

!$omp parallel
<ompts:orphan>
!$omp sections <ompts:check>reduction(max:dmax)</ompts:check>
!$omp section
        DO i = 1, 300
            dmax= max(dmax,d_array(i) )
        END DO
!$omp section
        DO i = 301, 700
            dmax= max(dmax,d_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
            dmax= max(dmax,d_array(i) )
        END DO
!$omp END sections
</ompts:orphan>
!$omp END parallel

        IF ( dmax .LT. 1000*dt ) THEN
          result = result + 1
          WRITE(1,*) "Error in DOuble MAX"
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

        integer function crschk_section_reduction()
        implicit none
        integer sum, sum2, known_sum, i, i2,dIFf
        integer product,known_product,int_const
        integer MAX_FACTOR
        DOuble precision dsum,dknown_sum,dt,dpt
        DOuble precision rounding_error, ddIFf
        integer DOUBLE_DIGITS
        logical logic_and, logic_or, logic_eqv,logic_neqv
        integer bit_and, bit_or
        integer exclusiv_bit_or
        integer min_value, max_value
        DOuble precision dmin, dmax
        integer result
        include "omp_testsuite.f"
        logical logics(1000)
        integer int_array(1000)
        DOuble precision d_array(1000)
        parameter (int_const=10,known_product=3628800)
        parameter (DOUBLE_DIGITS=20,MAX_FACTOR=10)
        parameter (rounding_error=1.E-6)
        dt = 1./3.
        known_sum = (1000 * (1000 + 1)) / 2
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
!$omp sections 
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
!$omp END sections
!$omp END parallel

       IF (known_sum .ne. sum) THEN
             result = result + 1
        END IF

        dIFf = (1000 * (1000 + 1)) / 2



!$omp parallel
!$omp sections
!$omp section
        DO i =1, 300
          dIFf = dIFf - i
        END DO
!$omp section
        DO i =301, 700
          dIFf = dIFf - i
        END DO
!$omp section
        DO i =701, 1000
          dIFf = dIFf - i
        END DO
!$omp END sections
!$omp END parallel
  
        IF ( dIFf .NE. 0 ) THEN
          result = result + 1
!        write(1,*) "Error in dIFference with integers: Result was ",
!     &   sum,"instead of 0."
        END IF

!... Test for DOubles
        dsum =0.
        dpt = 1

        DO i=1, DOUBLE_DIGITS
          dpt= dpt * dt
        END DO
        dknown_sum = (1-dpt)/(1-dt)
!$omp parallel
!$omp sections
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
!$omp END sections
!$omp END parallel

 
         IF(dsum .ne. dknown_sum .or. 
     &     abs(dsum - dknown_sum) .gt. rounding_error ) THEN
           result = result + 1
!           write(1,*) "Error in sum with DOubles: Result was ",
!     &       dsum,"instead of ",dknown_sum,"(DIFference: ",
!     &       dsum - dknown_sum,")"
        END IF
        dpt = 1


      
        DO i=1, DOUBLE_DIGITS
           dpt = dpt*dt
        END DO
        ddIFf = ( 1-dpt)/(1-dt)
!$omp parallel
!$omp sections
!$omp section
        DO i=0, 6
          ddIFf = ddIFf - dt**i
        END DO
!$omp section
        DO i=7, 12
          ddIFf = ddIFf - dt**i
        END DO
!$omp section
        DO i=13, DOUBLE_DIGITS-1
          ddIFf = ddIFf - dt**i
        END DO
!$omp END sections
!$omp END parallel

        IF ( ddIFf .GT. rounding_error .or.
     &       ddIFf .GT. (-rounding_error) ) THEN
           result = result + 1
!           write(1,*) "Error in DIFference with DOubles: Result was ",
!     &       ddIFf,"instead of 0.0"
        END IF

!$omp parallel
!$omp sections
!$omp section
        DO i=1,3
           product = product * i
        END DO
!$omp section
        DO i=4,7
           product = product * i
        END DO
!$omp section
        DO i=8,MAX_FACTOR
           product = product * i
        END DO
!$omp END sections
!$omp END parallel

        IF (known_product .NE. product) THEN
           result = result + 1
!           write(1,*) "Error in Product with integers: Result was ",
!     &       product," instead of",known_product 
        END IF

        DO i=1,1000
          logics(i) = .true.
        END DO

!$omp parallel
!$omp sections
!$omp section
        DO i=1,300
          logic_and = logic_and .and. logics(i)
        END DO
!$omp section
        DO i=301,700
          logic_and = logic_and .and. logics(i)
        END DO
!$omp section
        DO i=701,1000
          logic_and = logic_and .and. logics(i)
        END DO
!$omp END sections
!$omp END parallel

        IF (.not. logic_and) THEN
          result = result + 1
!          write(1,*) "Error in logic AND part 1"
        END IF


        logic_and = .true.
        logics(1000/2) = .false.

!$omp parallel
!$omp sections
!$omp section
        DO i=1,300
          logic_and = logic_and .and. logics(i)
        END DO
!$omp section
        DO i=301,700
          logic_and = logic_and .and. logics(i)
        END DO
!$omp section
        DO i=701,1000
          logic_and = logic_and .and. logics(i)
        END DO
!$omp END sections
!$omp END parallel

        IF (logic_and) THEN
           result = result + 1
!           write(1,*) "Error in logic AND pass 2"
        END IF




        DO i=1, 1000
         logics(i) = .false.
        END DO

!$omp parallel
!$omp sections
!$omp section
        DO i = 1, 300
           logic_or = logic_or .or. logics(i)
        END DO
!$omp section
        DO i = 301, 700
           logic_or = logic_or .or. logics(i)
        END DO
!$omp section
        DO i = 701, 1000
           logic_or = logic_or .or. logics(i)
        END DO
!$omp END sections
!$omp END parallel

        IF (logic_or) THEN
          result = result + 1
!         write(1,*) "Error in logic OR part 1"
        END IF

        logic_or = .false.
        logics(1000/2) = .true.

!$omp parallel
!$omp sections
!$omp section
        DO i=1,300
           logic_or = logic_or .or. logics(i)
        END DO
!$omp section
        DO i=301,700
           logic_or = logic_or .or. logics(i)
        END DO
!$omp section
        DO i=701,1000
           logic_or = logic_or .or. logics(i)
        END DO
!$omp END sections
!$omp END parallel

        IF ( .not. logic_or ) THEN
          result = result + 1
!          write(1,*) "Error in logic OR part 2"
        END IF

!... Test logic EQV, unique in Fortran
        DO i=1, 1000
         logics(i) = .true.
        END DO

        logic_eqv = .true.

!$omp parallel
!$omp sections
!$omp section
        DO i = 1, 300
           logic_eqv = logic_eqv .eqv. logics(i)
        END DO
!$omp section
        DO i = 301, 700
           logic_eqv = logic_eqv .eqv. logics(i)
        END DO
!$omp section
        DO i = 701, 1000
           logic_eqv = logic_eqv .eqv. logics(i)
        END DO
!$omp END sections
!$omp END parallel

        IF (.not. logic_eqv) THEN
          result = result + 1
!         write(1,*) "Error in logic EQV part 1"
        END IF

        logic_eqv = .true.
        logics(1000/2) = .false.

!$omp parallel
!$omp sections
!$omp section
        DO i=1,300
           logic_eqv = logic_eqv .eqv. logics(i)
        END DO
!$omp section
        DO i=301,700
           logic_eqv = logic_eqv .eqv. logics(i)
        END DO
!$omp section
        DO i=701,1000
           logic_eqv = logic_eqv .eqv. logics(i)
        END DO
!$omp END sections
!$omp END parallel

        IF ( logic_eqv ) THEN
          result = result + 1
!          write(1,*) "Error in logic EQV part 2"
        END IF

!... Test logic NEQV, which is unique in Fortran
        DO i=1, 1000
         logics(i) = .false.
        END DO

        logic_neqv = .false.

!$omp parallel
!$omp sections
!$omp section
        DO i = 1, 300
           logic_neqv = logic_neqv .neqv. logics(i)
        END DO
!$omp section
        DO i = 301, 700
           logic_neqv = logic_neqv .neqv. logics(i)
        END DO
!$omp section
        DO i = 701, 1000
           logic_neqv = logic_neqv .neqv. logics(i)
        END DO
!$omp END sections
!$omp END parallel

        IF (logic_neqv) THEN
          result = result + 1
!         write(1,*) "Error in logic NEQV part 1"
        END IF

        logic_neqv = .false.
        logics(1000/2) = .true.

!$omp parallel
!$omp sections
!$omp section
        DO i=1,300
           logic_neqv = logic_neqv .neqv. logics(i)
        END DO
!$omp section
        DO i=301,700
           logic_neqv = logic_neqv .neqv. logics(i)
        END DO
!$omp section
        DO i=701,1000
           logic_neqv = logic_neqv .neqv. logics(i)
        END DO
!$omp END sections
!$omp END parallel

        IF ( .not. logic_neqv ) THEN
          result = result + 1
!          write(1,*) "Error in logic NEQV part 2"
        END IF


        DO i=1, 1000
           int_array(i) = 1
        END DO
!$omp parallel
!$omp sections
!$omp section
        DO i=1, 300
         bit_and = iand(bit_and,int_array(i))
        END DO
!$omp section
        DO i=301, 700
         bit_and = iand(bit_and,int_array(i))
        END DO
!$omp section
        DO i=701, 1000
         bit_and = iand(bit_and,int_array(i))
        END DO
!$omp END sections
!$omp END parallel

        IF ( bit_and .lt. 1 ) THEN
          result = result + 1
!          write(1,*) "Error in IAND part 1"
        END IF

        bit_and = 1
        int_array(1000/2) = 0

!$omp parallel
!$omp sections
!$omp section
        DO i=1, 300
          bit_and = Iand ( bit_and, int_array(i) )
        END DO
!$omp section
        DO i=301, 700
          bit_and = Iand ( bit_and, int_array(i) )
        END DO
!$omp section
        DO i=701, 1000
          bit_and = Iand ( bit_and, int_array(i) )
        END DO
!$omp END sections
!$omp END parallel

        IF( bit_and .ge. 1) THEN
           result = result + 1
!          write(1,*) "Error in IAND part 2"
        END IF

      DO i=1, 1000
        int_array(i) = 0
      END DO


!$omp parallel
!$omp sections
!$omp section
        DO i=1, 300
          bit_or = Ior(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=301, 700
          bit_or = Ior(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=701, 1000
          bit_or = Ior(bit_or, int_array(i) )
        END DO
!$omp END sections
!$omp END parallel

        IF ( bit_or .ge. 1) THEN
           result = result + 1
!          write(1,*) "Error in Ior part 1"
        END IF


        bit_or = 0
        int_array(1000/2) = 1
!$omp parallel
!$omp sections
!$omp section
        DO i=1, 300
          bit_or = Ior(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=301, 700
          bit_or = Ior(bit_or, int_array(i) )
        END DO
!$omp section
        DO i=701, 1000
          bit_or = Ior(bit_or, int_array(i) )
        END DO
!$omp END sections
!$omp END parallel

        IF ( bit_or .le. 0) THEN
           result = result + 1
!          write(1,*) "Error in Ior part 2"
        END IF

        DO i=1, 1000
          int_array(i) = 0
        END DO

!$omp parallel
!$omp sections
!$omp section
        DO i = 1, 300
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 301, 700
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 701, 1000
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp END sections
!$omp END parallel

        IF ( exclusiv_bit_or .ge. 1) THEN
           result = result + 1
!           write(1,*) "Error in Ieor part 1"
        END IF

        exclusiv_bit_or = 0
        int_array(1000/2) = 1

!$omp parallel
!$omp sections
!$omp section
        DO i = 1, 300
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 301, 700
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp section
        DO i = 701, 1000
            exclusiv_bit_or = ieor(exclusiv_bit_or, int_array(i))
        END DO
!$omp END sections
!$omp END parallel

        IF ( exclusiv_bit_or .le. 0) THEN
          result = result + 1
!          write(1,*) "Error in Ieor part 2"
        END IF

        DO i=1,1000
           int_array(i) = 10 - i
        END DO

        min_value = 65535

!$omp parallel
!$omp sections
!$omp section
        DO i = 1, 300
            min_value = min(min_value,int_array(i) )
        END DO
!$omp section
        DO i = 301, 700
            min_value = min(min_value,int_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
            min_value = min(min_value,int_array(i) )
        END DO
!$omp END sections
!$omp END parallel


        IF ( min_value .gt. (10-1000) )THEN
          result = result + 1
!          write(1,*) "Error in integer MIN"
        END IF

        DO i=1,1000
           int_array(i) = i
        END DO

        max_value = -32768

!$omp parallel
!$omp sections
!$omp section
        DO i = 1, 300
            max_value = max(max_value,int_array(i) )
        END DO
!$omp section
        DO i = 301, 700
            max_value = max(max_value,int_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
            max_value = max(max_value,int_array(i) )
        END DO
!$omp END sections
!$omp END parallel

        IF ( max_value .lt. 1000 )THEN
          result = result + 1
!          write(1,*) "Error in integer MAX"
        END IF

!... test DOuble min, max
        DO i=1,1000
           d_array(i) = 10 - i*dt
        END DO

        dmin = 2**10
        dt = 0.5

!$omp parallel
!$omp sections
!$omp section
        DO i = 1, 300
            dmin= min(dmin,d_array(i) )
        END DO
!$omp section
        DO i = 301, 700
            dmin= min(dmin,d_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
            dmin= min(dmin,d_array(i) )
        END DO
!$omp END sections
!$omp END parallel

        IF ( dmin .gt. (10-dt) )THEN
          result = result + 1
!          write(1,*) "Error in DOuble MIN"
        END IF


        DO i=1,1000
           d_array(i) = i * dt
        END DO

        dmax= - (2**10)

!$omp parallel
!$omp sections
!$omp section
        DO i = 1, 300
            dmax= max(dmax,d_array(i) )
        END DO
!$omp section
        DO i = 301, 700
            dmax= max(dmax,d_array(i) )
        END DO
!$omp section
        DO i = 701, 1000
            dmax= max(dmax,d_array(i) )
        END DO
!$omp END sections
!$omp END parallel

        IF ( dmax .lt. 1000*dt )THEN
          result = result + 1
!          write(1,*) "Error in DOuble MAX"
        END IF

        IF ( result .eq. 0 ) THEN
           crschk_section_reduction =  1
        else
           crschk_section_reduction =  0
        END IF

        close(2)

       END

