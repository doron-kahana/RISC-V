#ifndef __COUNT_BITS_H
#define __COUNT_BITS_H

#include <stdint.h>
uint32_t popcnt32(uint32_t num);
uint8_t fast_popcnt8(uint8_t num);
uint32_t fast_popcnt32(uint32_t num);

#endif  // __COUNT_BITS_H