// trap.c 
#include"printk.h"
#include "clock.h"
void trap_handler(unsigned long scause, unsigned long sepc) {
    
    if (scause & (1UL << 63) == (1UL << 63)) {
        if (scause & (1UL << 4) == (1UL << 4)) {
            //printk("[S] Supervisor Mode Timer Interrupt\n");
            do_timer();
            clock_set_next_event();
        }
        else {}
    }
    else {}
}
