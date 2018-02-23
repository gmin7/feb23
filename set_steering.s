set_steering:
    call WriteOneByteToUART(5)
    call WriteOneByteToUART(new_steering_value)
    ret
