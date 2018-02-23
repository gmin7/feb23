call read_sensors_and_speed

  # Decide what to do
  if sensors are 0x1f
    call SetSteering to steer straight
  else if sensors are 0x1e
    call SetSteering to steer right
  else if sensors are 0x1c
    call SetSteering to steer hard right
  else if sensors are 0x0f
    call SetSteering to steer left
  else if sensors are 0x07
    call SetSteering to steer hard left
  else
    Hope this doesn't happen

  # Also do something about the speed.
