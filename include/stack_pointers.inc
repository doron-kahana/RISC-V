# top: pointer to the top of the value stack
    .globl top
    ; .section .sbss,"aw",@nobits
    .section .bss
    ; .align 3
    .type top, @object
    .size top, 8
top:

# min_top: pointer to the top of the minimum value stack
    ; .zero    8
    .globl   min_top
    ; .section .sbss,"aw",@nobits
    .section .bss
    ; .align   3
    .type    min_top, @object
    .size    min_top, 8
min_top:
