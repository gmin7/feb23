.equ JTAG_UART_BASE, 0x10001020
.equ JTAG_UART_RR, 0
.equ JTAG_UART_TR, 0
.equ JTAG_UART_CSR, 4

.text

writeb_to_uart:
      ldwio r9, JTAG_UART_CSR(r8)   # read CSR in r9
      srli  r9, r9, 16              # keep only the upper 16 bits
      beq   r9, r0, waitt           # as long as the upper 16 bits were zero keep trying

      stwio r2, JTAG_UART_TR(r8)    # place it in the FIFO
      br    waitr                  # life is interesting, keep doing what you do
      ret                           # never reaches here, this is for show
