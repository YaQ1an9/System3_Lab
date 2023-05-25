#ifndef _SYSCALL_H
#define _SYSCALL_H

#define SYS_WRITE   64
#define SYS_GETPID  172

#define SYS_MUNMAP   215
#define SYS_CLONE    220 // fork
#define SYS_MMAP     222
#define SYS_MPROTECT 226

struct pt_regs {
    unsigned long regs[32];
    unsigned long sepc;
};
void syscall(struct pt_regs *regs);

#endif