/*LEGEND*/



#r8: jtag base
#r15: storing steering comparator to r3 to determine branch
#r3: contains the sensor data
#r2: contains speed
#r4: argument reg to jtag for setting steering
#r5 hold state of CSR




#----------------------------------

  .equ RIGHT, 0x1C #28 degrees right
  .equ H_RIGHT, 0x7F #+127
  .equ LEFT, 0x9C #28 degrees left
  .equ H_LEFT, 0xFF #-127
  .equ STRAIGHT, 0x00

  .equ JTAG_UART_BASE, 0x10001020
  .equ JTAG_UART_RR, 0
  .equ JTAG_UART_TR, 0
  .equ JTAG_UART_CSR, 4


#-------


case_table:
  .align 2
  .word st_straight, st_right, st_hright, st_left, st_hleft, else

      st_straight:
        addi r15, r0, STRAIGHT
        call set_steering

      st_right:
        addi r15, r0, RIGHT
        call set_steering

      st_hright:
        addi r15, r0, H_RIGHT
        call set_steering

      st_left:
        addi r15, r0, LEFT
        call set_steering

      st_hleft:
        addi r15, r0, H_LEFT
        call set_steering

      else:
        #Hope this doesn't happen


#----------------------------------


.text
.global _start

_start:
    #initializing r8
    movia r8, JTAG_UART_BASE

    read_sensors_and_speed:
       # Request sensors and speed: Send a 0x02
       addi r4, r0, 0x02
       call writeb_to_uart

      # Read the response
      poll_sensor_speed_read:
       #check that data read is 0
       call readb_from_uart                    #packet type will be in r2
       bne r2, r0,  poll_sensor_speed_read

      read_states:
       #look at sensor states
       call readb_from_uart                    #sensor states will be in r2
       mov r3, r2                              #keep sensor state in r3 to use r2 to read speed

    /*--------DECIDE ON STEERING-------*/

    decideSetSteeringValue:
          #if sensors are 0x1f       0001 1111
            addi r15, r0, 0x1f
            beq r3, r15, st_straight

          #else if sensors are 0x1e  0001 1110
            addi r15, r0, 0x1e
            beq r3, r15, st_right

          #else if sensors are 0x1c  0001 1100
            addi r15, r0, 0x1c
            beq r3, r15, st_straight

          #else if sensors are 0x0f  0000 1111
            addi r15, r0, 0x0f
            beq r3, r15, st_left

          #else if sensors are 0x07  0000 0111
            addi r15, r0, 0x07
            beq r3, r15, st_hleft

          #else
            #Hope this doesn't happen

          # Also do something about the speed.


    /*--------MAINTAIN SPEED-------*/

       #look at current speed
       call readb_from_uart                    #current speed will be in r2

       #maintain speed
       addi r4, r0, 0x04 #request speed change
       call writeb_to_uart

       mov r4, r0 #maintain speed
       call writeb_to_uart

       br _start:


#----------------------------------


set_steering:

  mov r12, ra

  addi r4, r0, 0x05 #command type = set steering
  call writeb_to_uart

  mov r4, r15 #pass the new speed as an argument
  call writeb_to_uart

  mov ra, r12

  ret


#----------------------------------


writeb_to_uart:

  mov r13, ra

  wait_tr:
      ldwio r5, JTAG_UART_CSR(r8)   # read CSR in r2
      srli  r5, r5, 16              # keep only the upper 16 bits
      beq   r5, r0, wait_tr         # as long as the upper 16 bits were zero keep trying

      stwio r4, JTAG_UART_TR(r8)    # place argument in the FIFO

      mov ra, r13
      ret

#----------------------------------


readb_from_uart:

  mov r13, ra

  wait_rr:
        ldwio r2, JTAG_UART_RR(r8)    # read RR in r2
        andi  r10, r2, 0x8000         # extract bit 15 in register r10 / keep a copy of r9 since it contains the character if any
        beq   r10, r0, wait_rr        # if bit 15 was zero, there was no character, keep waiting/trying

  read:
        andi  r2, r2, 0x00ff            # a character was received, keep only that in r2 (mask out all other bits)

        mov ra, r13
        ret
