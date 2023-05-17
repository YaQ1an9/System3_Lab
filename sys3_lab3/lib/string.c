#include "string.h"
#include "defs.h"

void *memset(void *dst, int c, uint64 n) {
    char *cdst = (char *)dst;
    for (uint64 i = 0; i < n; ++i)
        cdst[i] = c;
    return dst;
}
void *memcpy(void *dest, const void *src, uint64 n) {
    char *cdest = (char *)dest;
    char *csrc = (char *)src;
    for (uint64 i = 0; i < n; ++i)
        cdest[i] = csrc[i];
    return dest;
}