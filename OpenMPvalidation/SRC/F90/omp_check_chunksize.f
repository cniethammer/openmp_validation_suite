	program omp_check_chunksize
	integer NUMBER_OF_THREADS, MAXSIZE,MAX_TIME,SLEEPTIME
	parameter(NUMBER_OF_THREADS=10)
	parameter(MAXSIZE=1000)
	parameter(MAX_TIME=10)
	parameter(SLEEPTIME=1)
	integer threads, max_size
	integer,allocatable:: tids(:)
	integer i,m,tmp
	integer,allocatable:: chunksizes(:)
	integer,allocatable:: tids_for_chunk(:)
	integer result/1/
        integer notout/1/
        integer maxiter/0/
        double precision factor/1.0/
	integer omp_get_num_threads,omp_get_thread_num

	integer count/0/ 
	integer tid

	integer global_chunknr/0/
        integer local_chunknr(NUMBER_OF_THREADS)
        integer expected_chunk_size

	max_size = MAXSIZE
        expected_chunk_size=max_size

	print *,"# Using an iteration count of ",max_size
	allocate( tids(0:max_size) )

!$OMP PARALLEL
!$OMP SINGLE
	threads = omp_get_num_threads()
!$OMP END SINGLE
!$OMP END PARALLEL

	if (threads .lt. 2 ) then
	    print *,"This test only works with at least two threads"
	    stop
	end if

!$omp parallel shared(tids)
	count = 0
	tid = omp_get_thread_num()
!$omp do schedule(runtime)
	do i=0,max_size-1
	  count = 0
!$omp flush(maxiter)
	  if (i .gt. maxiter) then
!$omp critical
	    maxiter = i
!$omp end critical
	  end if
	  do while (notout .ge. 1 .and. (count .lt. MAX_TIME)
     &         .and. (maxiter .eq. i) )
!$omp flush(maxiter,notout)
	       print *, "Thread Nr. ",tid,"sleeping"
	       call sleep(SLEEPTIME)
	       count = count + sleeptime
	  end do
          tids(i) = tid
	  print *,"i=",i,"tids(i)=",tids(i)
	 end do
!$omp end do nowait

	notout = 0
!$omp flush(notout)
!$omp end parallel

c	print *, "chunk size"

	m = 1
	tmp = tids(0) 
	print *,"tmp=",tmp,"max_size=",max_size

	global_chunknr=0
        openwork = max_size
        expected_chunk_size=max_size


	do i=0,NUM_OF_THREADS-1
	   local_chunknr(i) = 0
	end do

	tids(max_size) = -1

	do i=1,max_size
	  if ( tmp .eq. tids(i)) then
              m = m +1
	  else
	      global_chunknr = global_chunkr + 1
	      local_chunknr(tmp)=local_chunknr(tmp) + 1
	      tmp = tids(i) 
	      m = 1
	  end if
	end do
	print *,"global_chunknr=",global_chunknr,"m=",m
	allocate (chunksizes(0:(global_chunknr-1)))
	allocate (tids_for_chunk(0:(global_chunknr-1)))
	global_chunknr = 0

	m = 1
	tmp = tids(0) 
	do i=1,max_size
	   if (tmp .eq. tids(i)) then
		m = m + 1
	   else
		chunksizes(global_chunknr) = m
		tids_for_chunk(global_chunknr) = tmp
		global_chunknr = global_chunknr + 1
		local_chunknr(tmp) = local_chunknr(tmp) + 1
		tmp = tids(i) 
		m = 1
	   end if
	end do

	print *,"tids_for_chunk(1)=",tids_for_chunk(1)
	print *,"global_chunknr=",global_chunknr

	print *, "# global_chunknr thread_id chunksize",
     &  " remaining_items lin_factor expected_chunk"
	do i=0,global_chunknr-1
	   if ( expected_chunk_size .gt. 1) then   
             	expected_chunk_size = openwork/threads
	   end if
	   if ( result .ge. 1 .and. (abs(chunksizes(i)-
     &        expected_chunk_size) .lt. 2 ) ) then
		result = 1
	   else
		result = 0
	   end if
	   openwork = openwork - chunksizes(i)
	   print *,i,tids_for_chunk(i),chunksizes(i),openwork,
     &     dble(chunksizes(i))/expected_chunk_size, 
     &     INT(factor*expected_chunk_size + 0.5)	
	   factor = dble(chunksizes(i))/expected_chunk_size
	end do
	if ( result .ge. 1) then
	   print *, "Alles OK"
	else
	   print *, "FEHLER!"
	end if
	deallocate(tids)
	end
