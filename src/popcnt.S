.option nopic
.section .text

# 
# bitcount_lut is an 8-bit lookup table which holds the number 
# of ON bits for each value in the range [0,255]
# 
# uint8_t bitcount_lut[] = {
#     0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,
#     1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
#     1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
#     2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
#     1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
#     2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
#     2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
#     3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
#     1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
#     2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
#     2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
#     3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
#     2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
#     3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
#     3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
#     4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8,
# };
# 
.data
.align 3
.type bitcount_lut, @object
.size bitcount_lut, 256
bitcount_lut:
.string	""
.ascii	"\001\001\002\001\002\002\003\001\002\002\003\002\003\003\004"
.ascii	"\001\002\002\003\002\003\003\004\002\003\003\004\003\004\004"
.ascii	"\005\001\002\002\003\002\003\003\004\002\003\003\004\003\004"
.ascii	"\004\005\002\003\003\004\003\004\004\005\003\004\004\005\004"
.ascii	"\005\005\006\001\002\002\003\002\003\003\004\002\003\003\004"
.ascii	"\003\004\004\005\002\003\003\004\003\004\004\005\003\004\004"
.ascii	"\005\004\005\005\006\002\003\003\004\003\004\004\005\003\004"
.ascii	"\004\005\004\005\005\006\003\004\004\005\004\005\005\006\004"
.ascii	"\005\005\006\005\006\006\007\001\002\002\003\002\003\003\004"
.ascii	"\002\003\003\004\003\004\004\005\002\003\003\004\003\004\004"
.ascii	"\005\003\004\004\005\004\005\005\006\002\003\003\004\003\004"
.ascii	"\004\005\003\004\004\005\004\005\005\006\003\004\004\005\004"
.ascii	"\005\005\006\004\005\005\006\005\006\006\007\002\003\003\004"
.ascii	"\003\004\004\005\003\004\004\005\004\005\005\006\003\004\004"
.ascii	"\005\004\005\005\006\004\005\005\006\005\006\006\007\003\004"
.ascii	"\004\005\004\005\005\006\004\005\005\006\005\006\006\007\004"
.ascii	"\005\005\006\005\006\006\007\005\006\006\007\006\007\007\b"
.section	.rodata

# RISC-V RV32 impl.
#if (__riscv_xlen == 32)
.align 4
# 
# Name:         popcnt32
# Description:  Count ON bits in a 32-bit number
# I/O:          [in] long int value: a0 = 32-bit number 
# Return:       number of ON bits in the range [0,32]
# 
# C Code:
# --------
# uint32_t popcnt32(uint32_t num)
# {
#     uint32_t count = 0;
#     for (; num != 0; num &= num - 1)
#         count++;
    
#     return count;
# }
# 
.section .text
.globl popcnt32
.type popcnt32, @function
popcnt32:
    addi sp, sp, -16        # Allocate a stack frame
    sw ra, 12(sp)           # Store the return address at the end of the frame
    sw s0, 8(sp)            # Store frame pointer on the stack
    sw s1, 4(sp)            # Store saved register s1 on the stack
    mv t0, a0               # Copy the passed value into t0
    and t1, t1, zero        # t1 = 0, t1 is the bit counter
loop:                       # Loop while the num > 0
    beqz t0, exit           # num == 0, return to caller
    addi t1, t1, 1          # Count ON bits
    mv t2, t0               # t2 <- num
    addi t2, t2, -1         # t2 <- num -1
    and t0, t0, t2          # num &= (num - 1)
    j loop                  # Jump to loop
exit:
    mv a0, t1               # Copy return value into a0
    lw ra, 12(sp)           # Restore return address from stack frame
    lw s0, 8(sp)            # Restore saved frame pointer from the stack
    lw s1, 4(sp)            # Restore saved register s1 from the stack
    addi sp, sp, 16         # Deallocate stack frame
    ret                     # Return to caller

# 
# Name:         fast_popcnt8
# Description:  Count ON bits in an 8-bit number using a LUT
# I/O:          [in]  uint8_t num:  a0 = 8-bit number
# Return:       number of ON bits in the range [0,8]
# 
# C Code:
# --------
# uint32_t fast_popcnt8(uint8_t num)
# {
#     return bitcount_lut[num];
# }
# 
.align 4
.globl fast_popcnt8
.type fast_popcnt8, @function
fast_popcnt8:
    addi sp, sp, -16        # Allocate a stack frame
    sw ra, 12(sp)           # Store the return address at the end of the frame
    sw s0, 8(sp)            # Store frame pointer on the stack
    sw s1, 4(sp)            # Store saved register s1 on the stack
    la t0, bitcount_lut     # Load LUT address into t0
    add t0, t0, a0          # Add LUT cell offset
    andi a0, a0, 0          # Set return register a0 value to 0
    lb a0, 0(t0)            # Load return value from LUT into a0
    lw ra, 12(sp)           # Restore return address from stack frame
    lw s0, 8(sp)            # Restore saved frame pointer from the stack
    lw s1, 4(sp)            # Restore saved register s1 from the stack
    addi sp, sp, 16         # Deallocate stack frame
    ret                     # Return to caller

# 
# Name:         fast_popcnt32
# Description:  Count ON bits in a 32-bit number using an LUT
#               The function breaks down the number into 8-bit chunks and calls
#               fast_popcnt8 four times
# I/O:          [in] uint32_t num:  a0 = 32-bit number
# Return:       number of ON bits in the range [0,32]
# 
# C Code:
# --------
# uint32_t fast_popcnt32(uint32_t num)
# {
#     uint32_t count = 0;
#     count += (uint32_t)fast_popcnt8((uint8_t)(num & 0x000000ff));
#     count += (uint32_t)fast_popcnt8((uint8_t)((num >> 8) & 0x000000ff));
#     count += (uint32_t)fast_popcnt8((uint8_t)((num >> 16) & 0x000000ff));
#     count += (uint32_t)fast_popcnt8((uint8_t)((num >> 24) & 0x000000ff));

#     return count;
# }
# 
.align 4
.globl fast_popcnt32
.type fast_popcnt32, @function
fast_popcnt32:
    addi sp, sp, -16        # Allocate a stack frame
    sw ra, 12(sp)           # Store the return address at the end of the frame
    sw s0, 8(sp)            # Store frame pointer on the stack
    sw s1, 4(sp)            # Store saved register s1 on the stack
    mv s1, a0               # Save 32-bit value before calling fast_popcnt8

    # Call fast_popcnt8 with 1st byte chunk
    andi a0, a0, 0x000000FF
    call fast_popcnt8
    mv s0, a0

    # Call fast_popcnt8 with 2nd byte chunk
    srli a0, s1, 8
    andi a0, a0, 0x000000FF
    call fast_popcnt8
    add s0, s0, a0

    # Call fast_popcnt8 with 3rd byte chunk
    srli a0, s1, 16
    andi a0, a0, 0x000000FF
    call fast_popcnt8
    add s0, s0, a0

    # Call fast_popcnt8 with 3rd byte chunk
    srli a0, s1, 24
    andi a0, a0, 0x000000FF
    call fast_popcnt8
    add s0, s0, a0

    mv a0, s0               # a0 <- return value
    lw ra, 12(sp)           # Restore return address from stack frame
    lw s0, 8(sp)            # Restore saved frame pointer from the stack
    lw s1, 4(sp)            # Restore saved register s1 from the stack
    addi sp, sp, 16         # Deallocate stack frame
    ret                     # Return to caller

#endif
