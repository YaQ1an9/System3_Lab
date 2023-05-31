#include "proc.h"
#include "rand.h"
#include "defs.h"
#include "mm.h"
#include "vm.h"

extern unsigned long uapp_start;
extern unsigned long uapp_end;
extern unsigned long swapper_pg_dir;

extern void __dummy();
extern void __switch_to(struct task_struct* prev, struct task_struct* next);
struct task_struct* idle;           // idle process
struct task_struct* current;        // 指向当前运行线程的 `task_struct`
struct task_struct* task[NR_TASKS]; // 线程数组，所有的线程都保存在此

void task_init() {
    // 1. 调用 kalloc() 为 idle 分配一个物理页
   idle = (struct task_struct*)kalloc();
    
    // 2. 设置 state 为 TASK_RUNNING;
    idle->state = TASK_RUNNING;

    // 3. 由于 idle 不参与调度 可以将其 counter / priority 设置为 0
    idle->priority = 0;
    idle->counter = 0;

    // 4. 设置 idle 的 pid 为 0
    idle->pid = 0;

    // 5. 将 current 和 task[0] 指向 idle
    current = idle;
    task[0] = idle;

    /* YOUR CODE HERE */

    for(int i = 1; i < NR_TASKS; i++)
    {
        task[i] = (struct task_struct*)kalloc();
        task[i]->state = TASK_RUNNING;
        task[i]->priority = rand()%(PRIORITY_MAX-PRIORITY_MIN+1)+PRIORITY_MIN;
        // task[i]->counter = task[i]->priority;
        task[i]->counter = 1;
        task[i]->pid = i;
        task[i]->thread.ra = (uint64)__dummy;
        task[i]->thread.sp = (uint64)(task[i]) + 0x1000;
        pagetable_t tmp_pgtbl = (pagetable_t)kalloc();
        memcpy(tmp_pgtbl, &swapper_pg_dir, PGSIZE);
        task[i]->kernel_sp = (unsigned long)(task[i])+PGSIZE;
        task[i]->user_sp = kalloc();
        /*
        //System3-lab4
        // for(int j = 0; j < 512; j++)
        // {
        //     tmp_pgtbl[j] &= 0xfffffffffffffffe;
        // }

        uint64 va = USER_START;
        uint64 pa = 0x0000000000205000 + PHY_START;
        uint64 sz = 0xd76; // sz = uapp_end - uapp_start
        create_mapping(tmp_pgtbl, va, pa, sz, 31);

        va = USER_END-PGSIZE;
        pa = task[i]->user_sp - PA2VA_OFFSET;
        create_mapping(tmp_pgtbl, va, pa, PGSIZE, 23);
        */

        task[i]->thread.sepc = USER_START;
        unsigned long satp = csr_read(satp);
        satp = (satp >> 44) << 44;
        satp |= ((unsigned long)tmp_pgtbl-PA2VA_OFFSET) >> 12;
        task[i]->pgd = satp;

        unsigned long sstatus = csr_read(sstatus);
        sstatus &= ~(1<<8); // set sstatus[SPP] = 0
        sstatus |= 1<<5; // set sstatus[SPIE] = 1
        sstatus |= 1<<18; // set sstatus[SUM] = 1
        task[i]->thread.sstatus = sstatus;
        task[i]->thread.sscratch = USER_END;

        task[i]->mm = (struct mm_struct*)kalloc();
        task[i]->mm->mmap = NULL;
        do_mmap(task[i]->mm, USER_START, 0xd76, 13);
        do_mmap(task[i]->mm, USER_END - PGSIZE, PGSIZE, 3);
       
    }
    // 1. 参考 idle 的设置, 为 task[1] ~ task[NR_TASKS - 1] 进行初始化
    // 2. 其中每个线程的 state 为 TASK_RUNNING, counter 为 0, priority 使用 rand() 来设置, pid 为该线程在线程数组中的下标。
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 `thread_struct` 中的 `ra` 和 `sp`, 
    // 4. 其中 `ra` 设置为 __dummy （见 4.3.2）的地址， `sp` 设置为 该线程申请的物理页的高地址

    /* YOUR CODE HERE */

    printk("...proc_init done!\n");
}

void do_timer()
{
    if(current == idle) 
        schedule();
    else
    {
        current->counter--;
        if(current->counter > 0) return ;
        else schedule();        
    }

}

void schedule()
{
    struct task_struct* next = current;
    next = task[(current->pid) % 3 + 1];
    if(current == task[3] || current == task[0])
    {
    	for (int i = 1; i < NR_TASKS; i++) 
    	{
          task[i]->counter = rand()%(PRIORITY_MAX-PRIORITY_MIN+1)+PRIORITY_MIN;
          if (i == 1) printk("\n");
          printk("SET [PID = %d PRIORITY = %d COUNTER = %d]\n", task[i]->pid, task[i]->priority, task[i]->counter);
        }
    }
    
    
    switch_to(next);
}

void dummy()
{
    uint64 MOD = 1000000007;
    uint64 auto_inc_local_var = 0;
    int last_counter = -1; // 记录上一个counter
    int last_last_counter = -1; // 记录上上个counter
    while(1) {
    if (last_counter == -1 || current->counter != last_counter) {
        last_last_counter = last_counter;
        last_counter = current->counter;
        auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
        printk("[PID = %d] is running. auto_inc_local_var = %d\n", current->pid, auto_inc_local_var);
        printk("Thread space begin at %lx\n", current); //test
    } else if((last_last_counter == 0 || last_last_counter == -1) && last_counter == 1) { // counter恒为1的情况
        // 这里比较 tricky，不要求理解。
        last_counter = 0; 
        current->counter = 0;
    }

    }
}
void switch_to(struct task_struct* next) {
    if(current != next)
    {
        printk("\n");
        printk("switch to [PID = %d PRIORITY = %d COUNTER = %d]\n", next->pid, next->priority, next->counter);

        struct task_struct* prev = current;
        current = next;
        __switch_to(prev, next);
    }
    else return;

}
/*
* @mm          : current thread's mm_struct
* @address     : the va to look up
*
* @return      : the VMA if found or NULL if not found
*/
struct vm_area_struct *find_vma(struct mm_struct *mm, uint64 addr)
{
    struct vm_area_struct *vma = mm->mmap;
    while (vma != NULL) {
        if (addr >= vma->vm_start && addr < vma->vm_end) {
            return vma;
        }
        vma = vma->vm_next;
    }
    return NULL;
}
/*
 * @mm     : current thread's mm_struct
 * @addr   : the suggested va to map
 * @length : memory size to map
 * @prot   : protection
 *
 * @return : start va
*/
uint64 do_mmap(struct mm_struct *mm, uint64 addr, uint64 length, int prot)
{
    // 1. 首先调用 find_vma() 查找是否有重叠的 VMA
    // 2. 如果有重叠的 VMA，根据不同的情况进行处理
    // 3. 如果没有重叠的 VMA，调用 get_unmapped_area() 来获取一个合法的 va
    // 4. 创建一个新的 VMA，插入到 VMA 链表中
    // 5. 调用 create_mapping() 来创建映射关系
    // 6. 返回 start va

    /* YOUR CODE HERE */
    struct vm_area_struct *vma = find_vma(mm, addr);
    if(vma != NULL)
    {
        addr = get_unmapped_area(mm, length);
    }
    else
    {
        vma = (struct vm_area_struct*)kalloc();
        vma->vm_start = addr;
        vma->vm_end = addr + length;
        vma->vm_flags = prot;
        vma->vm_next = vma->vm_prev = NULL;
        vma->vm_mm = mm;
        Insert_vma(mm , vma);
    }

    return addr;
}
uint64 get_unmapped_area(struct mm_struct *mm, uint64 length)
{
    // 1. 首先从 USER_START 开始，遍历整个虚拟地址空间
    // 2. 调用 find_vma() 查找是否有重叠的 VMA
    // 3. 如果有重叠的 VMA，将 addr 更新为 VMA 的结束地址
    // 4. 如果没有重叠的 VMA，返回 addr

    /* YOUR CODE HERE */
    uint64 addr = USER_START;
    while(addr < USER_END)
    {
        struct vm_area_struct *vma_begin = find_vma(mm, addr);
        struct vm_area_struct *vma_end = find_vma(mm, addr + length);
        if(vma_begin == NULL && vma_end == NULL)
        {
            return addr;
        }
        addr += PGSIZE;
    }
    return 0;
}
void Insert_vma(struct mm_struct *mm, struct vm_area_struct *vma)
{
    struct vm_area_struct *vma_cur = mm->mmap;
    if(vma_cur == NULL)
    {
        mm->mmap = vma;
        return ;
    }
    while(vma_cur->vm_next != NULL && vma_cur->vm_next->vm_start < vma->vm_start)
    {
        vma_cur = vma_cur->vm_next;
    }
    if(vma_cur->vm_next == NULL)
    {
        vma_cur->vm_next = vma;
        vma->vm_prev = vma_cur;
    }
    else
    {
        vma->vm_next = vma_cur->vm_next;
        vma_cur->vm_next->vm_prev = vma;
        vma_cur->vm_next = vma;
        vma->vm_prev = vma_cur;
    }
}
