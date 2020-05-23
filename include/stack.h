#ifndef _STACK_H_
#define _STACK_H_

#include <stdbool.h>

typedef struct node_s
{
    long int data;
    struct node_s *pNode;
} node_t;

// typedef struct stack_s
// {
//     node_t *head;
//     node_t *tail;
//     int size;
// } stack_t;

void test_stack(void);
bool init_stack(void);
bool is_empty(void);
bool clear(void);
bool push(int value);
bool pop(void);
int peek(void);
int get_min(void);

#endif  // _STACK_H_