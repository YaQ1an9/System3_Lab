#include "syscall.h"
#include "stdio.h"
#include "../arch/riscv/include/proc.h"
extern struct task_struct* current;

static inline long getpid() {
    long ret;
    asm volatile ("li a7, %1\n"
                  "ecall\n"
                  "mv %0, a0\n"
                : "+r" (ret) 
                : "i" (SYS_GETPID));
    return ret;
}

void syscall(struct pt_regs *regs)
{
    if(regs->regs[17] == SYS_WRITE)
    {
        if(regs->regs[10] == 1)
        {
            ((char*)(regs->regs[11]))[regs->regs[12]] = '\0';
            regs->regs[10] = printf((char*)(regs->regs[11]));
        }
    }
    else if(regs->regs[17] == SYS_GETPID)
    {
        regs->regs[10] = getpid();
    }
    else
    {
        printf("unknown syscall!\n");
    }
}