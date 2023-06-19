`timescale 1ns / 1ps

module Data_memory(
    //normal
    input clk,
    input [63:0]addr,
    input MEM_mem_write,
    input [63:0]data_to_ram,
    input [2:0] MEM_mem_size,
    output [63:0] ram_data_out,

    //for mmu
    input [63:0]vm_pc,
    input [63:0]Satp,
    output [63:0]ph_pc
    //
    );
    `include "MEM_ACCESS_SIZE.vh"
    wire ram_clk = ~clk;
        
//        ram to_ram(
//        .clka(ram_clk),         //this ram_clk = ~clk
//        .wea(MEM_mem_write),
////        .addra(addr/4),
//        .addra(addr),
//        .dina(data_to_ram),
//        .douta(ram_data_out)
//        );
    reg [63:0] ram_data;
    myRam my_ram(
    .clk(ram_clk),             //this ram_clk = clk;
    .we(MEM_mem_write),
    .size(MEM_mem_size),
    .write_data(data_to_ram),
    .address(addr[13:3]),
    .read_data(ram_data_out),

    .Satp(Satp),
    .vm_pc(vm_pc),
    .ph_pc(ph_pc)
    );
endmodule
