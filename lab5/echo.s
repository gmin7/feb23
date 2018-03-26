.equ JTAG_UART_BASE, 0xff201000
.equ JTAG_UART_RR, 0
.equ JTAG_UART_TR, 0
.equ JTAG_UART_CSR, 4

.data

thechar: .byte


.section .exceptions, “ax”
.align 2
handler:

      movia r10, JTAG_UART_BASE

      ldwio r10, JTAG_UART_RR(r10)  # read RR in r2
                                    # this also clears the IRQ1 request line

      andi  r10, r10, 0xff          # a character was received, copy the lower 8 bits to r9
      movia r9, thechar             # write it to memory
      stbio r10, 0(r9)

      subi  ea, ea, 4               # make sure we execute the instruction that was interrupted. Ea/r29 points to the instruction after it
      eret                          # return from interrupt
                                    # this restores ctl0 to it’s previous state that was saved in ctl1
                                    # and does pc = ea


.text
.global _start

_start:
    movia r8, JTAG_UART_BASE


waitt:
    movia r6, thechar
    ldw r9, 0(r6)
    srli  r9, r9, 16              # keep only the upper 16 bits
    beq   r9, r0, waitt           # as long as the upper 16 bits were zero keep trying


    stwio r2, JTAG_UART_TR(r8)    # place it in the FIFO
    br    waitr                  # life is interesting, keep doing what you do
    ret                           # never reaches here, this is for show
