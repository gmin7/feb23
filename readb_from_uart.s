.data

.equ JTAG_UART_BASE, 0x10001020
.equ JTAG_UART_RR, 0
.equ JTAG_UART_TR, 0
.equ JTAG_UART_CSR, 4

.text

readb_from_uart:
  movia r8, JTAG_UART_BASE

wait_rr:

  ldwio r2, JTAG_UART_RR(r8)    # read RR in r2
  andi  r10, r2, 0x8000         # extract bit 15 in register r10 / keep a copy of r9 since it contains the character if any
  beq   r10, r0, wait_rr           # if bit 15 was zero, there was no character, keep waiting/trying

  andi  r2, r2, 0xff            # a character was received, keep only that in r2 (mask out all other bits)
  ret
