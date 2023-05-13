// clock.c
#include"sbi.h"

unsigned long TIMECLOCK = 10000000;

unsigned long get_cycles() {
    unsigned long n;
    __asm__ volatile("rdtime %0":"=r"(n));
    return n;
}

void clock_set_next_event() {
    unsigned long next = get_cycles() + TIMECLOCK;
    
    
    sbi_ecall(SBI_SET_TIMER, 0, next, 0, 0, 0, 0, 0);
} 
