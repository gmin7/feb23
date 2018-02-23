#LEGEND
  #r4 is the argument sent to UART, can specify command type or value
  #r2 contains the new angle we want to set the steering to

set_steering:
    addi r4, r0, 0x05 #command type = set steering
    call writeb_to_uart

    mov r4, r2 #get the new value to send to UART
    call writeb_to_uart

    ret
