program driver

 implicit none
 
 double precision   f
 double precision, dimension(:), allocatable :: x
 integer numProcs
 integer i

 read *, numProcs

 allocate (x(numProcs))
 do i = 1, numProcs
    call init(x(i),i)
 end do
 call compute(x,f,numProcs)
 print *, f

end
