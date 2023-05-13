.extern start_kernel
.extern _traps
.extern mm_init
.extern task_init

    .section .text.init
    .globl _start
_start:
    lla sp, _stack
    call setup_vm
    
    call relocate
    
    call mm_init
    call  setup_vm_final
    
    #lab2-sys6
    	# set stvec = _traps
	la t0, _traps
	csrw stvec, t0
	
	# set sie[STIE] = 1
	csrr t0, sie
	ori t0, t0, 1<<5
	csrw sie,t0
	
	# set first time interrupt
	rdtime a0
	li a1, 10000000
	add a0, a0, a1
	call sbi_set_timer
	
		# set sstatus[SIE] = 1
	csrr t0, sstatus
	ori  t0, t0, 1<<1
	csrw sstatus, t0
	
	#csrr a0, mstatus
	
    call  task_init
    j start_kernel

relocate:
    # set ra = ra + PA2VA_OFFSET
    # set sp = sp + PA2VA_OFFSET (If you have set the sp before)
    ###################### 
    #   YOUR CODE HERE   #
    ######################
    li t0, 0xffffffdf80000000
    #li t0, PA2VA_OFFSET
    add ra, ra, t0
    add sp, sp, t0

    # set satp with early_pgtbl‘s physical address
    ######################  
    #   YOUR CODE HERE   #
    ######################
    li t0, 8
    slli t0, t0, 60
    la t1, early_pgtbl
    srli t1, t1, 12
    add t0, t0, t1
    csrw satp, t0

    # flush tlb
    sfence.vma zero, zero

    ret
