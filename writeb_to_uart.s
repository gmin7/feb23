#LEGEND
  #r8: stores JTAG UART base address
  #r2: return value from UART

.data
  .equ JTAG_UART_BASE, 0x10001020
  .equ JTAG_UART_RR, 0
  .equ JTAG_UART_TR, 0
  .equ JTAG_UART_CSR, 4

.text
  writeb_to_uart:
    movia r8, JTAG_UART_BASE

  wait_tr:
    ldwio r2, JTAG_UART_CSR(r8)   # read CSR in r2
    srli  r2, r2, 16              # keep only the upper 16 bits
    beq   r2, r0, wait_tr            # as long as the upper 16 bits were zero keep trying

    stwio r4, JTAG_UART_TR(r8)    # place it in the FIFO
    ret
