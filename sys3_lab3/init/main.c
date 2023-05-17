#include "printk.h"
#include "sbi.h"

extern void schedule();
extern void test();

int start_kernel() {
    //printk(2022);
    // printk(" ZJU Computer System II\n");
    printk("[S-MODE] Hello RISC-V\n");
    schedule();
    test(); // DO NOT DELETE !!!
	return 0;
}
