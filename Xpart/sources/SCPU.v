`timescale 1ns / 1ps

module SCPU(
    input         clk,
    input         rst,
    input  [31:0] inst,
    input  [63:0] pc,
    input  [63:0] data_in,  // data from data memory
    output [63:0] addr_out, // data memory address
    output [63:0] data_out, // data to data memory
    output [63:0] vm_pc_out,
    output [63:0] ph_pc_out,   // connect to instruction memoryx
    output [63:0] reg_data,
    output [63:0] gp,
    output [63:0] Satp,
    output [1:0]info_changed,
    output        mem_write
    );
    wire [63:0] MEM_alu_result;
    wire [63:0] ram_data_out;
    wire [63:0] MEM_alu_data2_forward;
    wire  MEM_mem_write;
    wire [2:0] MEM_mem_size;

    wire stall;
    wire EX_mem_read;
    wire [1:0]EX_pc_src;
    wire [1:0]MEM_pc_src;
    wire [1:0]WB_pc_src;
    wire [4:0]EX_rd;
    wire [4:0]ID_rs1;
    wire [4:0]ID_rs2;
    wire EX_csr_write;
    wire EX_ecall_sign;
    wire MEM_ecall_sign;
    Datapath datapath (
        .clk(clk),
        .rst(rst),
        .inst_in(inst),
        .pc_in(pc),
        // for data_memory
        .ram_data_out(ram_data_out),
        .MEM_mem_write(MEM_mem_write),
        .MEM_alu_result(MEM_alu_result),
        .MEM_alu_data2_forward(MEM_alu_data2_forward),
        .MEM_mem_size(MEM_mem_size),
        //
        //for stall_con
        .stall(stall),
        .EX_mem_read(EX_mem_read),
        .EX_pc_src(EX_pc_src),
        .MEM_pc_src(MEM_pc_src),
        .WB_pc_src(WB_pc_src),
        .EX_rd(EX_rd),
        .ID_rs1(ID_rs1),
        .ID_rs2(ID_rs2),
        .EX_csr_write(EX_csr_write),
        .EX_ecall_sign(EX_ecall_sign),
        .MEM_ecall_sign(MEM_ecall_sign),
        //
        .reg_data(reg_data),
        .gp(gp),
        .Satp(Satp),
        .info_changed(info_changed),
        .pc_out(vm_pc_out)
    );
    
    // MMU rom_mmu(
    //     .clk(0),
    //     .rst(rst),
    //     .Satp(Satp),
    //     .vm_addr(vm_pc),
    //     .MMU_READY(MMU_ready),
    //     .ph_addr(pc_out)
    // );

    // MMU ram_mmu(

    // );

    Data_memory data_memory(
        .clk(clk),
        .addr(MEM_alu_result),
        .MEM_mem_write(MEM_mem_write),
        .data_to_ram(MEM_alu_data2_forward),
        .MEM_mem_size(MEM_mem_size),
        .ram_data_out(ram_data_out),

        .vm_pc(vm_pc_out),
        .Satp(Satp),
        .ph_pc(ph_pc_out)
    );

    Stall stall_con(
    // .MMU_ready()
    .EX_mem_read(EX_mem_read),
    .EX_pc_src(EX_pc_src),
    .MEM_pc_src(MEM_pc_src),
    .WB_pc_src(WB_pc_src),
    .EX_rd(EX_rd),
    .ID_rs1(ID_rs1),
    .ID_rs2(ID_rs2),
    .EX_csr_write(EX_csr_write),
    .EX_ecall_sign(EX_ecall_sign),
    .MEM_ecall_sign(MEM_ecall_sign),
    .stall(stall)
    );
    
endmodule

