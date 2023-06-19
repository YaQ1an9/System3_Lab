`timescale 1ns / 1ps

module EXE_MEM(
    input clk,
    input rst,
    input [4:0]EX_rd,
    input [4:0]EX_rs1,
    input [4:0]EX_rs2,
    input [63:0]alu_result,
    input [63:0]EX_pc,
    input [1:0]EX_pc_src,
    input EX_reg_write,
    input [1:0]EX_mem_to_reg,
    input EX_mem_read,
    input EX_mem_write,
    input [2:0] EX_mem_size,
    input [63:0]EX_reg_data2,
    input [63:0]EX_alu_data2_forward,
    input [63:0]EX_pc_jump_1,
    input [63:0]EX_imme,
    input EX_ecall_sign,
    output reg MEM_ecall_sign,
    output reg [63:0]MEM_imme, 
    output reg [63:0]MEM_pc_jump_1,
    output reg [63:0]MEM_reg_data2,
    output reg [63:0]MEM_alu_data2_forward,
    output reg [4:0]MEM_rd,
    output reg [4:0]MEM_rs1,
    output reg [4:0]MEM_rs2,
    output reg [63:0]MEM_alu_result,
    output reg [1:0]MEM_pc_src,
    output reg MEM_reg_write,
    output reg [63:0]MEM_pc,
    output reg [1:0]MEM_mem_to_reg,
    output reg MEM_mem_read,
    output reg [2:0]MEM_mem_size,
    output reg MEM_mem_write
    
    );
    always @(posedge clk,posedge rst)
    begin
        if(rst)
        begin
            MEM_alu_result <= 63'h0;
            MEM_pc <= 63'h0;
            MEM_pc_src <= 2'h0;
            MEM_reg_write <= 1'h0;
            MEM_mem_to_reg <= 1'h0;
            MEM_mem_read   <= 1'h0;
            MEM_mem_write <= 1'h0;
            MEM_mem_size <= 3'b0;
            MEM_rd <= 5'h0;
            MEM_rs1 <= 5'h0;
            MEM_rs2 <= 5'h0;
            MEM_reg_data2 <= 63'h0;
            MEM_alu_data2_forward <= 63'h0;
            MEM_imme <= 63'h0;
            MEM_pc_jump_1 <= 63'h0;
            MEM_ecall_sign <= 1'h0;
        end
        else
        begin
            MEM_alu_result <= alu_result;
            MEM_pc <= EX_pc;
            MEM_pc_src <= EX_pc_src;
            MEM_reg_write <= EX_reg_write;
            MEM_mem_to_reg <= EX_mem_to_reg;
            MEM_mem_read   <= EX_mem_read;
            MEM_mem_write <= EX_mem_write;
            MEM_mem_size <= EX_mem_size;
            MEM_rd <= EX_rd;
            MEM_rs1 <= EX_rs1;
            MEM_rs2 <= EX_rs2;
            MEM_reg_data2 <= EX_reg_data2;
            MEM_alu_data2_forward <= EX_alu_data2_forward;
            MEM_imme <= EX_imme;
            MEM_pc_jump_1<= EX_pc_jump_1;
            MEM_ecall_sign <= EX_ecall_sign;
            end
    end
endmodule
