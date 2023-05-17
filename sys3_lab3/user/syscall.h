#ifndef _SYSCALL_H
#define _SYSCALL_H

#define SYS_WRITE   64
#define SYS_GETPID  172

struct pt_regs {
    unsigned long regs[32];
    unsigned long sstatus;
    unsigned long sepc;
};
void syscall(struct pt_regs *regs);

#endif