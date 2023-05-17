// trap.c 
#include"printk.h"
#include "clock.h"
// #include "../../../user/syscall.h"
extern void syscall(struct pt_regs *regs);

void trap_handler(unsigned long scause, unsigned long sepc, struct pt_regs* regs) {
    
    if (scause & (1UL << 63) == (1UL << 63)) {
        // if (scause & (1UL << 4) == (1UL << 4)) {
        if(scause ^ (1LL << 63) == 5){
            //printk("[S] Supervisor Mode Timer Interrupt\n");
            do_timer();
            clock_set_next_event();
        }
        else {}
    }
    else {
        if(scause == 0)
        {
            // syscall(regs);
            printk("[S] Systemcall\n");
        }
    }
}
