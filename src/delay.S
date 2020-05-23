.section .text
.align 2
.globl delay

.include "memory_map.inc"

#
# a0[in]: delay value in ms
# 
delay:
    addi sp, sp, -16            # Allocate a stack frame
    sw ra, 12(sp)               # Store the return address

    li t0, MTIME                # Load the time register
    lw t1, 0(t0)                # Load the current timer register value

    li t2, MTIME_FREQUENCY      # Load mtime register clock frequency
    mul t2, t2, a0              # Multiply milliseconds with frequency
    add t2, t1, t2              # Target time is now in t2

1:
    lw t1, 0(t0)                # Load the current timer register value
    blt t1, t2, 1b              # Keep looping until timeout

    lw ra, 12(sp)               # Restore the return address
    addi sp, sp, 16             # Deallocate the stack frame
    ret