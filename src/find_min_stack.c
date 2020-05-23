#include <stdio.h>
#include "stack.h"

void test_stack(void)
{
    init_stack();
    push(4);
    push(6);
    push(14);
    push(3);
    push(15);
    push(10);
    push(20);
    push(7);
    push(2);
    push(17);

    int min = get_min();
    printf("Minimum value on the stack: %d\n", min);
 
    pop();
    pop();
 
    min = get_min();
    printf("Minimum value on the stack: %d\n", min);
 
    pop();
    pop();
    pop();
    pop();
    pop();
 
    min = get_min();
    printf("Minimum value on the stack: %d\n", min);
 
    clear();

    return;
}
