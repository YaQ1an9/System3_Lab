// trap.c 
#include"printk.h"
#include "clock.h"
#include "../include/proc.h"
#include "../../../user/syscall.h"
extern struct task_struct *current;
extern void syscall(struct pt_regs *regs);;

void trap_handler(unsigned long scause, unsigned long sepc, struct pt_regs* regs) {
    
    if ((scause & (1LL << 63)) == (1LL << 63)) {
        // if (scause & (1UL << 4) == (1UL << 4)) {
        if(scause ^ (1LL << 63) == 5){
            //printk("[S] Supervisor Mode Timer Interrupt\n");
            do_timer();
            clock_set_next_event();
        }
        else {}
    }
    else {
        if(scause == 8)
        {
            // syscall(regs);
            // printk("[S] Systemcall\n");
            if(regs->regs[17] == SYS_WRITE)
            {
                if(regs->regs[10] == 1)
                {
                    ((char*)(regs->regs[11]))[regs->regs[12]] = '\0';
                    regs->regs[10] = printk((char*)(regs->regs[11]));
                }
            }
            else if(regs->regs[17] == SYS_GETPID)
            {
                regs->regs[10] = current->pid;
            }
            else
            {
                printk("unknown syscall!\n");
            }
            regs->sepc += 4;
        }
    }
}
