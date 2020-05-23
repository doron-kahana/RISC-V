.section .text
.align 2
.globl setupGPIO

.include "memory_map.inc"
.include "gpio.inc"

setupGPIO:
    addi sp, sp, -16                # Allocate the stack frame
    sw ra, 12(sp)                   # Save the return addrress onto the stack

    li t0, GPIO_CTRL_ADDR           # Load the base GPIO address
    li t1, GPIO_RGB_PINS            # Get the RGB pins offset
    sw t1, GPIO_OUTPUT_EN(t0)       # Enable output on the RBG pins so they are writable
    sw t1, GPIO_OUTPUT_XOR(t0)      # Set the XOR so the RGB pins are Active High
    sw x0, GPIO_OUTPUT_VAL(t0)      # Set all the writable pins to 0 to clear the LEDs
    
    lw ra, 12(sp)                   # Restore the return address
    addi sp, sp, 16                 # Deallocate the stack frame
    ret