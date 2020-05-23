.section .text
.align 2
.globl setLED

.include "memory_map.inc"
.include "gpio.inc"

.equ NOERROR,   0x0
.equ ERROR,     0x1
.equ LEDON,     0x1

setLED:
    addi sp, sp, -16                # Allocate the stack frame
    sw ra, 12(sp)                   # Save the return address onto the stack

    li t0, GPIO_CTRL_ADDR           # Load GPIO control register address
    lw t1, GPIO_OUTPUT_VAL(t0)      # Get the current value of the pins

    beqz a1, ledOff                 # Branch off to turn off LED if a1 requests it
    li t2, LEDON                    # Load ON value into temp register
    beq a1, t2, ledOn               # Branch if ON requested
    li a0, ERROR                    # Bad status request, return an error
    j exit

ledOn:
    xor t1, t1, a0                  # Do an XOR to change the value of the requested LED
    sw t1, GPIO_OUTPUT_VAL(t0)      # Write the new output value to the GPIO output
    li a0, NOERROR
    j exit

ledOff:
    xor a0, a0, 0xFFFFFFFF          # Invert all bits to '1' except the LED being turned off
    and t1, t1, a0                  # And a0 and t1 to get the LED we want to turn off
    sw t1, GPIO_OUTPUT_VAL(t0)      # write the new output value to the right GPIO register
    li a0, NOERROR

exit:
    lw ra, 12(sp)                   # Restore the return address
    addi sp, sp, 16                 # Deallocate the stack frame
    ret


