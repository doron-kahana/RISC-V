.option nopic
.file "is_empty.S"
.include "stack_pointers.inc"

# 
# Name:         is_empty
# Description:  This function checks if the both stacks are empty
# Return:       0: stack is not empty
#               1: stack is empty
# 
.section .text
# .align 1
.globl is_empty
.type is_empty, @function
is_empty:
    addi sp, sp, -16            # Allocate a frame on the stack
    sw ra, 12(sp)               # Store 32-bit return address at the end of the frame
    addi fp, sp, 16             # Set frame pointer to return address
    lw a5, top                  # Load value stack pointer address
    bnez a5, stack_not_empty    # Branch to stack_not_empty if (top != NULL)
    lw a5, min_top              # Load min. value stack pointer address
    bnez a5, stack_not_empty    # Branch to stack_not_empty if min. stack is not empty
    li a5, 1                    # Both stacks are empty, load return value of 1
    j exit                      # Value stack is empty, return to caller
stack_not_empty:                # top != NULL
    li a5, 0                    # Load return value of 0 (false - stack is not empty)
exit:                           # exit: Return to caller
    andi a0, a0, 0              # a0 = 0
    mv a0, a5                   # Copy return value to a0 (addi a0, a5, x0)
    lw ra, 12(sp)               # Restore the return address (32-bit)
    addi sp, sp, 16             # Deallocate the stack frame
    ret                         # Jump to return address (jalr x0, ra, 0)
