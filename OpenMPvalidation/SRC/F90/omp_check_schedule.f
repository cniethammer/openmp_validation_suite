	integer function check_for_schedule(logfile)
	integer result
	character*20 logfile
	integer check_for_schedule_static
	integer check_for_schedule_dynamic
	integer check_for_schedule_guided

	open (1, FILE = logfile) 
	
	write (1,*) "+ Checking static case:"
	
	result = check_for_schedule_static(logfile)
	write (1,*) "+ Checking dynamic case:"
	if (result .ge. 1 .and.
     &  check_for_schedule_dynamic(logfile).ge. 1 ) then
	  result = 1
	else
	  result = 0
	end if
	write (1,*) "+ Checking guided case:"
	if ( result .ge. 1 .and. 
     &  check_for_schedule_guided(logfile) .ge. 1) then
	  result = 1
	else
	  result = 0
	end if

	close (1)

	check_for_schedule = result
	end

	integer function crosscheck_for_schedule(logfile)
	integer result
	character*20 logfile
	integer crosscheck_for_schedule 
	integer crosscheck_for_schedule_static
	integer crosscheck_for_schedule_dynamic
	integer crosscheck_for_schedule_guided

	open(1, FILE = logfile)
	
	write (1,*) "+ Checking static case:"
	result = crosscheck_for_schedule_static(logfile)
	write (1,*) "+ Checking dynamic case:"
	if ( result .ge. 1 .AND. 
     &   crosscheck_for_schedule_dynamic(logfile) .ge. 1) then
	   result = 1
	else
	   result = 0
	end if
	write (1,*) "+ Checking guided case:"
	if  (result .ge. 1 .and. 
     &   crosscheck_for_schedule_guided(logfile) .ge. 1) then
     	   result = 1
        else
           result = 0
        end if

	crosscheck_for_schedule = result
	return
	end


	integer function check_for_schedule_static(logfile)
	integer MAX_SIZE
	parameter (MAX_SIZE = 1000000)

	integer chunk_size/10/
	integer tid
	integer tids(0:MAX_SIZE-1)
	integer count/0/
	integer tmp_count/0/
	integer i
	integer check_for_schedule_static
	
	integer,allocatable:: tmp(:)
	integer result/0/

	integer omp_get_thread_num

	character*20 logfile

c	open (1, FILE = logfile)

!$omp parallel private(tid) shared(tids, count)
	
	tid = omp_get_thread_num()
!$omp do schedule(static,chunk_size)
	do i = 0 , MAX_SIZE-1
		tids(i) = tid
	end do
!$omp end do	
!$omp end parallel 

	do i = 0, MAX_SIZE-2
		if (tids(i) .NE. tids(i+1) ) then
			count = count + 1
		endif
	end do

	allocate(tmp(0:count))
	tmp(0) = 1

	do i = 0, MAX_SIZE-2
		if (tmp_count .GT. count) then
			write (*,*) "---------------------"
			write (*,*) "testinternal Error: List too small"
			write (*,*) "-----------------------------"
			write (1,*) "-----------------------------"
			write (1,*) "testinternal Error: List too small"
			write (1,*) "-----------------------------"
	 		exit
		endif
		
		if (tids(i) .NE. tids(i+1) ) then
			tmp_count = tmp_count + 1
			tmp(tmp_count) = 1
		else
			tmp(tmp_count) = tmp(tmp_count) + 1
		endif
	end do

	do i = 0, count -1
		if ( tmp(i) .NE. chunk_size) then
			result = result + 1
		endif
	end do


	if (result .EQ. 0) then
		check_for_schedule_static =  1
	else
		write (1,*) "Error: Thread got",result,
     &              " times consecutive chunk"
		check_for_schedule_static =0
	endif

	end


	integer function crosscheck_for_schedule_static(logfile)
	integer MAX_SIZE
	parameter (MAX_SIZE = 1000000)

	integer chunk_size/10/
	integer tid
	integer tids(0:MAX_SIZE-1)
	integer count/0/
	integer tmp_count/0/
	integer i
	
	integer,allocatable:: tmp(:)
	integer result/0/

	integer omp_get_thread_num
	integer crosscheck_for_schedule_static

	character*20 logfile

c	open (1, FILE = logfile)

!$omp parallel private(tid) shared(tids, count)
	
	tid = omp_get_thread_num()
!$omp do
	do i = 0 , MAX_SIZE-1
		tids(i) = tid
	end do
!$omp end do	
!$omp end parallel 

	do i = 0, MAX_SIZE-2
		if (tids(i) .NE. tids(i+1) ) then
			count = count + 1
		endif
	end do

	allocate(tmp(0:count))
	tmp(0) = 1

	do i = 0, MAX_SIZE-2
		if (tmp_count .GT. count) then
			write (*,*) "---------------------"
			write (*,*) "testinternal Error: List too small"
			write (*,*) "-----------------------------"
			write (1,*) "-----------------------------"
			write (1,*) "testinternal Error: List too small"
			write (1,*) "-----------------------------"
	 		exit
		endif
		
		if (tids(i) .NE. tids(i+1) ) then
			tmp_count = tmp_count + 1
			tmp(tmp_count) = 1
		else
			tmp(tmp_count) = tmp(tmp_count) + 1
		endif
	end do

	do i = 0, count -1
		if ( tmp(i) .NE. chunk_size) then
			result = result + 1
		endif
	end do


	if (result .EQ. 0) then
		crosscheck_for_schedule_static =  1
	else
		crosscheck_for_schedule_static =0
	endif

	end

	integer function check_for_schedule_dynamic(logfile)
	integer tid
	integer MAX_SIZE
	parameter (MAX_SIZE = 1000000)
	
	integer tids(0:MAX_SIZE-1)
	integer i
	integer,allocatable:: tmp(:)
	integer chunk_size/10/,count/0/,result/1/,tmp_count/0/
	integer omp_get_thread_num

	character*20 logfile
	integer          check_for_schedule_dynamic

c	open(1,FILE = logfile)

c	print *, "check dynamic"

!$omp parallel private(tid) shared(tids,count)

	tid = omp_get_thread_num()
 
!$omp do schedule(dynamic,chunk_size)
	do i = 0, MAX_SIZE-1
		tids(i) = tid
	end do
!$omp end do 
!$omp end parallel

	do i = 0,MAX_SIZE-2
		if (tids(i) .NE. tids(i+1)) then
			count = count + 1
		endif		
	end do

	allocate(tmp(0:count))
	tmp(0) = 1
	
	do i = 0, MAX_SIZE - 2
		if (tmp_count .GT. count) then
			write (*,*) "--------------------"
			write (*,*) "Testinternal Error: List too small" 
			write (*,*) "--------------------" 
			exit
		endif
		if (tids(i) .NE. tids(i+1)) then
			tmp_count = tmp_count + 1
			tmp(tmp_count) = 1
		else
			tmp(tmp_count) = tmp(tmp_count) + 1
		endif
	end do
c	is dynamic statement working
	
	do i = 0, count 
	  if (tmp(i) .NE. chunk_size) then
		result = result + ((tmp(i)/chunk_size) - 1)
 	  endif
	end do

	if ((tmp(0) .NE. MAX_SIZE ) .and. (result .GT. 1)) then
		write (1,*) "Seem to work. (Treads got", result, 
     &     "times chunks twice by a total of",
     &      MAX_SIZE/chunk_size,"chunks" 
		check_for_schedule_dynamic= 1
c		return
	else
		write (1,*) "Test negative"
		check_for_schedule_dynamic= 0
c		return
	endif
c	print *, "dynmic=",check_for_schedule_dynamic

	end

	integer function crosscheck_for_schedule_dynamic(logfile)
	integer tid
	integer MAX_SIZE
	parameter (MAX_SIZE = 1000000)
	
	integer tids(0:MAX_SIZE)
	integer i
	integer,allocatable:: tmp(:)
	integer chunk_size/10/,count/0/,result/1/,tmp_count/0/
	integer omp_get_thread_num

	character*20 logfile
	integer          crosscheck_for_schedule_dynamic

c	open(1,FILE = logfile)

!$omp parallel private(tid) shared(tids,count)

	tid = omp_get_thread_num()
 
!$omp do 
	do i = 0, MAX_SIZE-1
		tids(i) = tid
	end do
!$omp end do 
!$omp end parallel

	do i = 0,MAX_SIZE-2
		if (tids(i) .NE. tids(i+1)) then
			count = count + 1
		endif		
	end do

	allocate(tmp(0:count))
	tmp(0) = 1
	
	do i = 0, MAX_SIZE - 2
		if (tmp_count .GT. count) then
			write (*,*) "--------------------"
			write (*,*) "Testinternal Error: List too small" 
			write (*,*) "--------------------" 
			exit
		endif
		if (tids(i) .NE. tids(i+1)) then
			tmp_count = tmp_count + 1
			tmp(tmp_count) = 1
		else
			tmp(tmp_count) = tmp(tmp_count) + 1
		endif
	end do
c	is dynamic statement working
	
	do i = 0, count 
	  if (tmp(i) .NE. chunk_size) then
		result = result + ((tmp(i)/chunk_size) - 1)
 	  endif
	end do

	if ((tmp(0) .NE. MAX_SIZE ) .and. (result .GT. 1)) then
c		write (1,*) "Seem to work. (Treads got", result, 
c     &     "times chunks twice by a total of",
c     &      MAX_SIZE/chunk_size,"chunks" 
		crosscheck_for_schedule_dynamic= 1
c		return
	else
c		write (1,*) "Test negative"
		crosscheck_for_schedule_dynamic= 0
c		return
	endif
c	print *, "dynmic=",crosscheck_for_schedule_dynamic

	end

	integer function check_for_schedule_guided(logfile)
	integer NUMBER_OF_THREADS 
	integer CFSMAX_SIZE
	integer MAX_TIME 
	integer SLEEPTIME 
	
	parameter( NUMBER_OF_THREADS = 10)
	parameter(CFSMAX_SIZE = 1000)
	parameter(MAX_TIME = 10)
	parameter(SLEEPTIME = 1)

        integer threads
        integer tids(0:CFSMAX_SIZE)
        integer i,m,tmp
        integer,allocatable:: chunksizes(:)
        integer result/1/
        integer notout/1/ 
        integer maxiter/0/ 
	integer check_for_schedule_guided
	character*20 logfile
	integer omp_get_num_threads
	integer omp_get_thread_num

	integer count
	integer tid

	integer global_chunknr
	integer local_chunknr(0:NUMBER_OF_THREADS-1)
	integer openwork
	integer expected_chunk_size

!$omp parallel 
!$omp single
	threads = omp_get_num_threads()
!$omp end single
!$omp end parallel 

        if( threads .LT.  2) then
                write (*,*) 
     &   "This test only works with at least two threads ."
	  check_for_schedule_guided=0
	  return
	endif

c	Now the real parallel work:
c
c	Each thread will start immediately with the first chunk.

!$omp parallel shared(tids)
        count=0
	tid = omp_get_thread_num()	
	
!$omp do schedule(guided,1)
	do i=0, CFSMAX_SIZE -1
	count = 0
!$omp flush(maxiter)
            if (i .GT. maxiter) then
!$omp critical
              maxiter=i
!$omp end critical
	     endif

c 	if it is not our turn we wait
c 	a) until another thread executed an iteration
c          with a higher iteration count
c      	b) we are at the end of the loop (first thread 
c	   finished and set notout=0
c	c) timeout arrived 

	     do while(notout .ge. 1.and.count .LT. MAX_TIME 
     &        .and.  maxiter .EQ. i )
!$omp flush(maxiter,notout)
	       call sleep(SLEEPTIME)
               count= count + SLEEPTIME
	     end do
	
	     tids(i) = tid
	end do
!$omp end do nowait

        notout = 0
!$omp flush(notout)

!$omp end parallel 

c	print *, "end of // region of check guided"

	m=1
        tmp=tids(0)

	global_chunknr=0
	openwork = CFSMAX_SIZE

	do i = 0, NUMBER_OF_THREADS-1
		local_chunknr(i)=0
	enddo

	tids(CFSMAX_SIZE)= -1

	do i = 1, CFSMAX_SIZE
		if (tmp .EQ. tids(i)) then
		  m = m+1
		else
		  write (1,*) global_chunknr,tmp,
     &             local_chunknr(tmp),m
		  global_chunknr = global_chunknr + 1
		  local_chunknr(tmp) = local_chunknr(tmp) + 1
		  tmp = tids(i)
		  m = 1
		endif
	enddo

	allocate ( chunksizes(0:global_chunknr-1) )

	global_chunknr = 0

	m = 1
	tmp=tids(0)

        do i = 1, CFSMAX_SIZE
                if (tmp .EQ. tids(i)) then
                        m = m+1
                else
	         chunksizes(global_chunknr) = m
		 global_chunknr = global_chunknr + 1
		 local_chunknr(tmp)=local_chunknr(tmp)+1
                 tmp = tids(i)
                 m = 1
                endif
        enddo

	do i = 0, global_chunknr-1
		if( expected_chunk_size .GT. 2) then
		  expected_chunk_size=openwork/threads
		endif
		if (result .ge. 1 .and. 
     &    abs(chunksizes(i)-expected_chunk_size) .LT. 2) then
		   result = 1
		else
		   result = 0
		end if
		openwork = openwork - chunksizes(i)
	enddo

c	print *,"check guided=",result
	check_for_schedule_guided = result

	end

	
	integer function crosscheck_for_schedule_guided(logfile)
	integer NUMBER_OF_THREADS 
	integer CFSMAX_SIZE
	integer MAX_TIME 
	integer SLEEPTIME 
	
	parameter( NUMBER_OF_THREADS = 10)
	parameter(CFSMAX_SIZE = 1000)
	parameter(MAX_TIME = 10)
	parameter(SLEEPTIME = 1)

        integer threads
        integer tids(0:CFSMAX_SIZE)
        integer i,m,tmp
        integer,allocatable:: chunksizes(:)
        integer result/1/
        integer notout/1/ 
        integer maxiter/0/ 
	integer crosscheck_for_schedule_guided
	character*20 logfile
	integer omp_get_num_threads
	integer omp_get_thread_num

	integer count
	integer tid

	integer global_chunknr
	integer local_chunknr(0:NUMBER_OF_THREADS-1)
	integer openwork
	integer expected_chunk_size

!$omp parallel 
!$omp single
	threads = omp_get_num_threads()
!$omp end single
!$omp end parallel 

        if( threads .LT.  2) then
                write (*,*) 
     &   "This test only works with at least two threads ."
	  check_for_schedule_guided=0
	  return
	endif

c	Now the real parallel work:
c
c	Each thread will start immediately with the first chunk.

!$omp parallel shared(tids)
        count=0
	tid = omp_get_thread_num()	
	
!$omp do 
	do i=0, CFSMAX_SIZE -1
	count = 0
!$omp flush(maxiter)
            if (i .GT. maxiter) then
!$omp critical
              maxiter=i
!$omp end critical
	     endif

c 	if it is not our turn we wait
c 	a) until another thread executed an iteration
c          with a higher iteration count
c      	b) we are at the end of the loop (first thread 
c	   finished and set notout=0
c	c) timeout arrived 

	     do while(notout .ge. 1.and.count .LT. MAX_TIME 
     &        .and.  maxiter .EQ. i )
!$omp flush(maxiter,notout)
	       call sleep(SLEEPTIME)
               count= count + SLEEPTIME
	     end do
	
	     tids(i) = tid
	end do
!$omp end do nowait

        notout = 0
!$omp flush(notout)

!$omp end parallel 

c	print *, "end of // region of check guided"

	m=1
        tmp=tids(0)

	global_chunknr=0
	openwork = CFSMAX_SIZE

	do i = 0, NUMBER_OF_THREADS-1
		local_chunknr(i)=0
	enddo

	tids(CFSMAX_SIZE)= -1

	do i = 1, CFSMAX_SIZE
		if (tmp .EQ. tids(i)) then
		  m = m+1
		else
		  write (1,*) global_chunknr,tmp,
     &             local_chunknr(tmp),m
		  global_chunknr = global_chunknr + 1
		  local_chunknr(tmp) = local_chunknr(tmp) + 1
		  tmp = tids(i)
		  m = 1
		endif
	enddo

	allocate ( chunksizes(0:global_chunknr-1) )

	global_chunknr = 0

	m = 1
	tmp=tids(0)

        do i = 1, CFSMAX_SIZE
                if (tmp .EQ. tids(i)) then
                        m = m+1
                else
	         chunksizes(global_chunknr) = m
		 global_chunknr = global_chunknr + 1
		 local_chunknr(tmp)=local_chunknr(tmp)+1
                 tmp = tids(i)
                 m = 1
                endif
        enddo

	do i = 0, global_chunknr-1
		if( expected_chunk_size .GT. 2) then
		  expected_chunk_size=openwork/threads
		endif
		if (result .ge. 1 .and. 
     &    abs(chunksizes(i)-expected_chunk_size) .LT. 2) then
		   result = 1
		else
		   result = 0
		end if
		openwork = openwork - chunksizes(i)
	enddo

c	print *,"crosscheck guided=",result
	crosscheck_for_schedule_guided = result

	end

