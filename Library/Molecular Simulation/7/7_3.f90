! gfortran 7_3.f90 -o 7_3 && ./7_3

program photon
	implicit none
    integer, parameter :: nstep = 1e8, ninit = 1e6
    real*8, parameter :: beta = 1d-1
	integer :: new, old = 1, i, dist(0:100)
	real*8 :: av1 = 0d0, av2 = 0d0, r1
	
    call random_seed()
    open (21, file = '7_3.dat')
    ! loop over all cycles
	do i = 1, nstep
		call random_number(r1)
		if (r1 > 0.5) then
			new = old + 1
		else
			new = old - 1
		end if
		! check for acceptance
		call random_number(r1)
		if (new >= 0 .and. r1 < exp(-beta*(new - old))) old = new
		! calculate average occupancy result
		if (i > ninit) then
			if (old <= 100) dist(old) = dist(old) + 1
			av1 = av1 + real(old, 8)
			av2 = av2 + 1.0d0
		end if
	end do
    ! write the final result	
	write (21, *) 'average value : ', av1/av2
	write (21, *) 'theoretical value : ', 1d0/(exp(beta)-1d0)
	write (21, *) 'error : ', abs((exp(beta)-1.0d0)*((av1/av2)-(1.0d0/(exp(beta)-1.0d0))))
	write (21, *) 'numerical distribution vs. theoretical distribution : '
	do i = 0, 100
		write (21, *) real(dist(i), 8) / dist(0), exp(-beta*i)
	end do
	stop
end program photon