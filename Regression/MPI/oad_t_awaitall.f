        subroutine template()
          use OADtape
          use OADrev

!$TEMPLATE_PRAGMA_DECLARATIONS

          integer iaddr
          external iaddr
          integer i

         if (our_rev_mode%plain) then
! original function
! do nothing
          end if
          if (our_rev_mode%tape) then
! taping
! do nothing
          end if 
          if (our_rev_mode%adjoint) then
! adjoint
            call mpi_waitall( 
     +      count, 
     +      requests, 
     +      statuses, 
     +      ierror)
            do i=1,count
               call oadhandlerequest(requests(i))
            end do
          end if 
        end subroutine template
