/*


While debugging, you may want to occasionally reset the communication between
the Car World game and your assembly program (that is, drain both the receive
and send JTAG UART buffers). Doing this takes two steps:

Have your assembly code send byte 0x00 to the JTAG UART in case Car World
is waiting for a multi-byte packet. Car World treats excess 0x00 commands as a no-op.
In the Altera Monitor program, select the Memory tab, go to the memory
address 0x10001020, check the Query Memory Mapped Devices check-box and click the Refresh button.
Then uncheck the check-box. This is equivalent to reading the UART receive FIFO data until the FIFO is empty.

It may be convenient to write a reset subroutine and run it at the beginning of your program.


*/
