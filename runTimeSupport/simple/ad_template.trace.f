!#########################################################
! This file is part of OpenAD released under the LGPL.   #
! The full COPYRIGHT notice can be found in the top      #
! level directory of the OpenAD distribution             #
!#########################################################
        subroutine template()
          use OAD_trace
          use OAD_rev

          ! original arguments get inserted before version
          ! and declared here together with all local variables
          ! generated by xaifBooster

!$TEMPLATE_PRAGMA_DECLARATIONS

         if (our_rev_mode%plain) then
! original function
!$PLACEHOLDER_PRAGMA$ id=1
          end if
          if (our_rev_mode%tape) then
! tracing
!$PLACEHOLDER_PRAGMA$ id=2
          end if 
        end subroutine template
