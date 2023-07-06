#ifndef _VM_H
#define _VM_H

#include "defs.h"
#include <string.h>
#include <stddef.h>
#include "mm.h"
#include "printk.h"

/* early_pgtbl: 用于 setup_vm 进行 1GB 的 映射。 */

#define VPN0(va) ((va >> 12) & 0x1ff)
#define VPN1(va) ((va >> 21) & 0x1ff)
#define VPN2(va) ((va >> 30) & 0x1ff)
void setup_vm(void);

/* swapper_pg_dir: kernel pagetable 根目录， 在 setup_vm_final 进行映射。 */

void setup_vm_final(void);

void create_mapping(uint64 *pgtbl, uint64 va, uint64 pa, uint64 sz, int perm);

#endif