.data

case_table:
.align 2
.word st_straight, st_right, st_hright, st_left, st_hleft, else

    st_straight:
      call SetSteering to steer straight

    st_right:
      call SetSteering to steer right

    st_hright:
      call SetSteering to steer hard right

    st_left:
      call SetSteering to steer left

    st_hleft:
      call SetSteering to steer hard left

    else:
      #Hope this doesn't happen

.text
.global car_world_main

car_world_main:
    call read_sensors_and_speed

    # Decide what to do
    #if sensors are 0x1f
      br
    #else if sensors are 0x1e
      call SetSteering to steer right
    #else if sensors are 0x1c
      call SetSteering to steer hard right
    #else if sensors are 0x0f
      call SetSteering to steer left
    #else if sensors are 0x07
      call SetSteering to steer hard left
    #else
      Hope this doesn't happen

    # Also do something about the speed.
