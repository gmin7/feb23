read_sensors_and_speed:
  # Request sensors and speed: Send a 0x02.
   addi r4, r0, 0x02
   call writeb_to_uart

   # Read the response
   call readb_from_uart

   #sensor reading,

   check that data read is 0
   call ReadOneByteFromUART()
   look at sensor states
   call ReadOneByteFromUART()
   look at current speed
   ret
