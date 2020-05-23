#include "superBlink.h"
#include "count_bits.h"
#include "stack.h"

int main (void)
{
    /* Test the popcount implementations */
    test_count_bits();

    test_stack();

    /* Blink the RGB LEDs forever */
    superBlink();
}