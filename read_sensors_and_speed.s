read_sensors_and_speed:
  # Request sensors and speed: Send a 0x02.
   addi r4, r0, 0x02
   call writeb_to_uart

   # Read the response

poll:
   #check that data read is 0
   call readb_from_uart #packet type will be in r2
   bne r2, r0, poll

read_states:
   #look at sensor states
   call readb_from_uart     #sensor states will be in r2
   mov r3, r2               #keep sensor state in r3 to use r2 to read speed

   #look at current speed
   call readb_from_uart     #current speed will be in r2

   ret
