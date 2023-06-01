// trap.c 
#include "printk.h"
#include "clock.h"
#include "defs.h"
#include "../include/proc.h"
#include "../../../user/syscall.h"

extern void ret_from_fork(struct pt_regs *regs);
extern struct task_struct *current;
extern struct task_struct *task[NR_TASKS];
extern uint64 task_counter;
extern void syscall(struct pt_regs *regs);
extern unsigned long swapper_pg_dir;
void forkret();
uint64 clone(struct pt_regs *regs) ;

void trap_handler(unsigned long scause, unsigned long sepc, struct pt_regs* regs) 
{
    
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
            // printk("[S] Systemcall\n");
            syscall(regs);
            // if(regs->regs[17] == SYS_WRITE)
            // {
            //     if(regs->regs[10] == 1)
            //     {
            //         ((char*)(regs->regs[11]))[regs->regs[12]] = '\0';
            //         regs->regs[10] = printk((char*)(regs->regs[11]));
            //     }
            // }
            // else if(regs->regs[17] == SYS_GETPID)
            // {
            //     regs->regs[10] = current->pid;
            // }
            // else
            // {
            //     printk("unknown syscall!\n");
            // }
            regs->sepc += 4;
        }
        else if(scause == 12)
        {
            //Instruction Page Fault
            printk("[S] Instruction Page Fault\n");
            do_page_fault(regs);
        }
        else if(scause == 13)
        {
            //Load Page Fault
            printk("[S] Load Page Fault\n");
            do_page_fault(regs);
        }
        else if(scause == 15)
        {
            //Store/AMO Page Fault
            printk("[S] Store/AMO Page Fault\n");
            do_page_fault(regs);
        }
    }
}

void syscall(struct pt_regs *regs)
{
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
    else if(regs->regs[17] == SYS_CLONE)
    {
        regs->regs[10] = clone(regs);
    }
    else
    {
        printk("unknown syscall!\n");
    }
}
void forkret() {
    ret_from_fork(current->trapframe);
}

uint64 do_fork(struct pt_regs *regs) 
{
    task[task_counter] = (struct task_struct*)kalloc();
    task[task_counter]->state = TASK_RUNNING;
    task[task_counter]->counter = 2;
    task[task_counter]->priority = 1;
    task[task_counter]->pid = task_counter;
    task[task_counter]->user_sp = kalloc();
    memcpy(task[task_counter]->user_sp, current->user_sp, PGSIZE);
    
    task[task_counter]->thread.ra = (uint64)forkret;
    task[task_counter]->thread.sp = task[task_counter]->thread.sscratch 
                                  = task[task_counter]->kernel_sp
                                  = (uint64)(task[task_counter]) + 0x1000;
    task[task_counter]->thread.sepc = regs->sepc;

    unsigned long sstatus = csr_read(sstatus);
    sstatus &= ~(1<<8); // set sstatus[SPP] = 0
    sstatus |= 1<<5; // set sstatus[SPIE] = 1
    sstatus |= 1<<18; // set sstatus[SUM] = 1
    task[task_counter]->thread.sstatus = sstatus;

    pagetable_t tmp_pgtbl = (pagetable_t)kalloc();
    memcpy(tmp_pgtbl, &swapper_pg_dir, PGSIZE);
    unsigned long satp = csr_read(satp);
    satp = (satp >> 44) << 44;
    satp |= ((unsigned long)tmp_pgtbl-PA2VA_OFFSET) >> 12;
    task[task_counter]->pgd = satp;

    task[task_counter]->mm = (struct mm_struct*)kalloc();
    memcpy(task[task_counter]->mm, current->mm, PGSIZE);
    task[task_counter]->trapframe = kalloc();
    memcpy(task[task_counter]->trapframe, regs, sizeof(struct pt_regs));
    uint64 sscratch = csr_read(sscratch);
    task[task_counter]->trapframe->regs[2] = sscratch;
    task[task_counter]->trapframe->regs[10] = 0;
    task[task_counter]->trapframe->sepc += 4;
    task_counter++;

    return task[task_counter - 1]->pid;
}

uint64 clone(struct pt_regs *regs) 
{
    return do_fork(regs);
}

void do_page_fault(struct pt_regs *regs) 
{
    /*
    1. 通过 stval 获得访问出错的虚拟内存地址（Bad Address）
    2. 通过 scause 获得当前的 Page Fault 类型
    3. 通过 find_vm() 找到对应的 vm_area_struct
    4. 通过 vm_area_struct 的 vm_flags 对当前的 Page Fault 类型进行检查
        4.1 Instruction Page Fault      -> VM_EXEC
        4.2 Load Page Fault             -> VM_READ
        4.3 Store Page Fault            -> VM_WRITE
    5. 最后调用 create_mapping 对页表进行映射
    */
    uint64 stval, scause, sepc;
    asm volatile("csrr %0, stval":"=r"(stval));
    asm volatile("csrr %0, scause":"=r"(scause));
    sepc = regs->sepc;
    struct vm_area_struct *vma = find_vma(current->mm, stval);
    if (scause == 12 && (vma->vm_flags & VM_READ) == 0 && (vma->vm_flags & VM_EXEC) == 0 && (vma->vm_flags & VM_WRITE) == 0) 
    {
        printk("Invalid vm area in page fault\n");
        return;
    }
    else
    {
        if(stval >= USER_START && stval <= USER_START + 0xd76)
        {
            uint64 va = vma->vm_start;
            uint64 pa = 0x0000000000205000 + PHY_START;
            uint64 sz = vma->vm_end - vma->vm_start;
            uint64 addr = ((uint64)(current->pgd) << 12 ^ 0xffffffe000000000) ;
            addr -= 0x80000000;
            create_mapping((pagetable_t)addr, va, pa, sz, 31);
        }
        else
        {
            uint64 va = vma->vm_start;;
            uint64 pa = current->user_sp - PA2VA_OFFSET;
            uint64 sz = vma->vm_end - vma->vm_start;
            create_mapping(((uint64)(current->pgd) << 12 + PA2VA_OFFSET), va, pa, sz, 31);
        }
    }
    
}