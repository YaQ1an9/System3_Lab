`timescale 1ns / 1ps

module Stall(
    input EX_mem_read,
    input [1:0]EX_pc_src,
    input [1:0]MEM_pc_src,
    input [1:0]WB_pc_src,
    input [4:0]EX_rd,
    input [4:0]ID_rs1,
    input [4:0]ID_rs2,
    input EX_csr_write,
    input EX_ecall_sign,
    input MEM_ecall_sign,
    output reg stall
    );
    always @(*)
    begin
    stall <= 1'b0;
    if(EX_mem_read && (ID_rs1==EX_rd||ID_rs2==EX_rd))stall <= 1'b1;
//    else if(EX_pc_src||MEM_pc_src) stall <= 1'b1;
    else if(EX_pc_src) stall <= 1'b1;
    else if(EX_csr_write) stall <= 1'b1;
//    else if(EX_ecall_sign || MEM_ecall_sign)  stall <= 1'b1;
    else if(EX_ecall_sign) stall <= 1'b1;
    end
endmodule
