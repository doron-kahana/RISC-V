#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "count_bits.h"


#define NUM_TESTS   (1000000)

int main(void)
{
    static uint32_t bits __attribute__((used)) = 0;
    clock_t end;
    clock_t start = clock();
    float seconds = 0.0f;

    start = clock();
    for (uint32_t i = 1; i < NUM_TESTS; i++)
    {
        bits = fast_popcnt32(i);
    }
    end = clock();
    seconds = (float)(end - start) / CLOCKS_PER_SEC;
    printf("fast_popcnt32 took %f seconds\n", seconds);

    start = clock();
    for (uint32_t i = 1; i < NUM_TESTS; i++)
    {
        bits = popcnt32(i);
    }
    end = clock();
    seconds = (float)(end - start) / CLOCKS_PER_SEC;
    printf("popcnt32 took %f seconds\n", seconds);
    
    return 0;
}
