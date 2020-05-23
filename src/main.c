#include "count_bits.h"
#include "superBlink.h"

int main (void)
{
    /* Test the popcount implementations */
    test_count_bits();

    /* Blink the RGB LEDs forever */
    superBlink();
}