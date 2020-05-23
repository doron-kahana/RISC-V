#include <stdlib.h>
#include "stack.h"

extern node_t *top;
extern node_t *min_top;

bool init_stack(void)
{
    top = NULL;
    min_top = NULL;

    return true;
}

bool clear(void)
{
    if(is_empty())
        return false;

    while(pop());

    return true;
}

bool push(int value)
{
    node_t *new = (node_t *)malloc(sizeof(node_t));
    node_t *min_new = (node_t *)malloc(sizeof(node_t));

    if(!new || !min_new)
    {
        return false;
    }

    if(is_empty() || (value < min_top->data))
    {
        /* New minimum value, push it onto the min. stack */
        min_new->data = value;
    }
    else
    {
        /* No new minimum, push current min. value onto the min. stack */
        min_new->data = min_top->data;
    }

    min_new->pNode = min_top;
    min_top = min_new;

    /* Push value onto the main stack */
    new->data = value;
    new->pNode = top;
    top = new;

    return true;
}

bool pop(void)
{
    if(is_empty())
    {
        return false;
    }

    /* Pop elements from top of main and min. stacks */
    node_t *ele = top;
    top = top->pNode;
    free(ele);
    ele = min_top;
    min_top = min_top->pNode;
    free(ele);

    return true;
}

int peek(void)
{
    return top->data;
}

int get_min(void)
{
    return min_top->data;
}