// arch/riscv/kernel/vm.c
/*
extern unsigned long _stext;
extern unsigned long _srodata;
extern unsigned long _sdata;
extern unsigned long  _sbsss;

#include "defs.h"
#include <string.h>
#include <stddef.h>
#include "mm.h"
#include "printk.h"
#include "types.h"
*/

/* early_pgtbl: 用于 setup_vm 进行 1GB 的 映射。 */
/*
#define VPN0(va) ((va >> 12) & 0x1ff)
#define VPN1(va) ((va >> 21) & 0x1ff)
#define VPN2(va) ((va >> 30) & 0x1ff)
*/

#include "vm.h"
unsigned long early_pgtbl[512] __attribute__((__aligned__(0x1000)));
void setup_vm(void)
{
    /*
    1. 由于是进行 1GB 的映射 这里不需要使用多级页表
    2. 将 va 的 64bit 作为如下划分： | high bit | 9 bit | 30 bit |
        high bit 可以忽略
        中间9 bit 作为 early_pgtbl 的 index
        低 30 bit 作为 页内偏移 这里注意到 30 = 9 + 9 + 12， 即我们只使用根页表， 根页表的每个 entry 都对应 1GB 的区域。
    3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    4. early_pgtbl 对应的是虚拟地址，而在本函数中你需要将其转换为对应的物理地址使用
    */
    memset(early_pgtbl, 0x0, PGSIZE);
    unsigned long va = VM_START , pa = PHY_START;
    int index = VPN2(va);
    early_pgtbl[VPN2(PHY_START)] = 15 | ((pa >> 30) & 0x3ffff) << 28;
    early_pgtbl[index] = 15 | ((pa >> 30) & 0x3ffff) << 28; // 64 - 30 = 34 = 0x3fff
    printk("SET UP VM DONE!\n");
}


/* swapper_pg_dir: kernel pagetable 根目录， 在 setup_vm_final 进行映射。 */
unsigned long  swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

void setup_vm_final(void) {
    memset(swapper_pg_dir, 0x0, PGSIZE);

    uint64 va = VM_START + OPENSBI_SIZE;
    uint64 pa = PHY_START + OPENSBI_SIZE;
    uint64 sz;
    // No OpenSBI mapping required

    // mapping kernel text X|-|R|V
    //sz = (uint64)(_srodata) - (uint64)(_stext);
    create_mapping(swapper_pg_dir, pa, pa, 0x8000000, 15);
    sz = 0x2000;
    create_mapping(swapper_pg_dir, va, pa, sz, 11);
    va += sz;
    pa += sz;

    // mapping kernel rodata -|-|R|V
    //sz = (uint64)_sdata - (uint64)_srodata;
    sz = 0x1000;
    create_mapping(swapper_pg_dir, va, pa, sz, 15); //3
    va += sz;
    pa += sz;
  
    // mapping other memory -|W|R|V
    //sz = 0x8000000-((unsigned long)_sdata-(unsigned long)_stext);
    sz = 0x8000000 - 0x3000;
    create_mapping(swapper_pg_dir, va, pa, sz, 7);
  
    // set satp with swapper_pg_dir
    
    //YOUR CODE HERE
    uint64 PG_ADDR = (uint64)swapper_pg_dir - PA2VA_OFFSET;

    asm volatile (
        "li t0, 8\n"
        "slli t0, t0, 60\n"
        "mv t1, %[PG_ADDR]\n"
        "srli t1, t1, 12\n"
        "add t0, t0, t1\n"
        "csrw satp, t0"
        :
        :[PG_ADDR]"r"(PG_ADDR)
        :"memory"
    );

    // flush TLB
    asm volatile("sfence.vma zero, zero");
    
    printk("SET UP VM FINAL DONE!\n");
    return;
}


#if 0
/* 创建多级页表映射关系 */
void create_mapping(uint64 *pgtbl, uint64 va, uint64 pa, uint64 sz, int perm) {
    /*
    pgtbl 为根页表的基地址
    va, pa 为需要映射的虚拟地址、物理地址
    sz 为映射的大小
    perm 为映射的读写权限

    将给定的一段虚拟内存映射到物理内存上
    物理内存需要分页
    创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
    可以使用 V bit 来判断页表项是否存在
    */
    int i;
    uint64 VPN[3];
    uint64 *pgtbls[3];
    uint64 * new_page;
    uint64 PTE;
    uint64 end_addr = va + sz;

    pgtbls[2] = pgtbl;

    while(va < end_addr)
    {
        VPN[0] = VPN0(va);
    	VPN[1] = VPN1(va);
    	VPN[2] = VPN2(va);
        for(i = 2; i >= 0; i--)
        {
            PTE = pgtbls[i][VPN[i]];
            if(i > 0 &&(PTE & 1) != 1)
            {
                new_page = kalloc();
                PTE = (((uint64)new_page - PA2VA_OFFSET) >> 12) << 10 | 1; 
                pgtbls[i][VPN[i]] = PTE;
            }
            if(i > 0) pgtbls[i - 1] = (uint64 *)((PTE >> 10) << 12);
            
            if(i == 0)
            {
                pgtbls[i][VPN[i]] = (perm & 15) | ((pa >> 12) << 10);
            }
        }
        
        va += PGSIZE;
        pa += PGSIZE;
    }
	
}
#endif 

#if 1
void create_mapping(unsigned long *root_pgtbl, unsigned long va, unsigned long pa, unsigned long sz, int perm) {
    /*
    root_pgtbl 为根页表的基地址
    va, pa 为需要映射的虚拟地址、物理地址
    sz 为映射的大小
    perm 为映射的读写权限
    创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
    可以使用 V bit 来判断页表项是否存在
    */

    unsigned int vpn[3]; // 存储三、二、一级页表中所求PTE的偏移量
    unsigned long* pgtbl[3]; // 存储三、二、一级页表的物理地址
    unsigned long pte[3]; // 存储三、二、一级页表中所求PTE的值
    unsigned long* new_pg;

    unsigned long end = va + sz; // end是判断终止地址

    while (va < end)
    {
        pgtbl[2] = root_pgtbl;
        vpn[2] = VPN2(va);
        pte[2] = pgtbl[2][vpn[2]];
        if (!(pte[2]&1)) {
            new_pg = (unsigned long*)kalloc();
            pte[2] = ((((unsigned long)new_pg-PA2VA_OFFSET) >> 12) << 10) | 1;
            pgtbl[2][vpn[2]] = pte[2];
        }

        pgtbl[1] = (unsigned long*)((pte[2] >> 10) << 12);
        vpn[1] = VPN1(va);
        pte[1] = pgtbl[1][vpn[1]];
        if (!(pte[1]&1)) {
            new_pg = (unsigned long*)kalloc();
            pte[1] = ((((unsigned long)new_pg-PA2VA_OFFSET) >> 12) << 10) | 1;
            pgtbl[1][vpn[1]] = pte[1];
        }

        pgtbl[0] = (unsigned long*)((pte[1] >> 10) << 12);
        vpn[0] = VPN0(va);
        pte[0] = (perm & 127) | ((pa >> 12) << 10);
        pgtbl[0][vpn[0]] = pte[0];

        va += PGSIZE;
        pa += PGSIZE;
    }

    return;
}
#endif
