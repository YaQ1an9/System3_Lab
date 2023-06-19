`timescale 1ns / 1ps

module ID_EXE(
    input clk,
    input rst,
    input stall,
    input bubble_sign,
    input [63:0]ID_imme,
    input [63:0]ID_pc,
    input [31:0]ID_inst,
    input [1:0]pc_src,
    input reg_write,
    input csr_write,
    input alu_src_b,
    input alu_src_a,
    input [3:0]alu_op,
    input [1:0]mem_to_reg,
    input mem_read,
    input mem_write,
    input branch,
    input [2:0]b_type,
    input [2:0]mem_size,
    input [63:0]rd_data1,
    input [63:0]rd_data2,
    input [4:0]ID_rd,
    input [4:0]ID_rs1,
    input [4:0]ID_rs2,
    input ecall_sign,
    input ID_Find,
    input ID_Pred_take,
    output reg EX_Pred_take,
    output reg EX_Find,
    output reg EX_ecall_sign,
    output reg [31:0]EX_inst,
    output reg [63:0]EX_rd_data1,
    output reg [63:0]EX_rd_data2,
    output reg [4:0]EX_rd,
    output reg [4:0]EX_rs1,
    output reg [4:0]EX_rs2,
    output reg [63:0]EX_imme,
    output reg [1:0]EX_pc_src,
    output reg EX_reg_write,
    output reg EX_csr_write,
    output reg EX_alu_src_b,
    output reg EX_alu_src_a,
    output reg [3:0]EX_alu_op,
    output reg [1:0]EX_mem_to_reg,
    output reg EX_mem_read,
    output reg EX_mem_write,
    output reg EX_branch,
    output reg [63:0]EX_pc,
    output reg [2:0]EX_mem_size,
    output reg [2:0]EX_b_type
    );
    always @(posedge clk,posedge rst)
    begin
        if(rst || bubble_sign || stall)
            begin
                EX_rd_data1 <= 63'h0;
                EX_rd_data2 <= 63'h0;
                EX_imme <= 63'h0;
                EX_rd <= 5'h0; 
                EX_rs1 <= 5'h0;
                EX_rs2 <= 5'h0;
            end
        else 
            begin
                EX_rd_data1 <= rd_data1;
                EX_rd_data2 <= rd_data2;  
                EX_rd <= ID_rd;
                EX_rs1 <= ID_rs1;
                EX_rs2 <= ID_rs2;
                EX_imme <= ID_imme;  
            end
    end
    always @(posedge clk,posedge rst)
    begin
        if(rst || bubble_sign || stall)
            begin
                EX_pc <= 63'h0;
                EX_inst <=63'h0;
                EX_pc_src <= 2'h0;
                EX_reg_write <= 1'h0;
                EX_csr_write <= 1'h0;
                EX_alu_src_b <= 1'h0;
                EX_alu_src_a <= 1'h0;
                EX_alu_op <=4'h0;
                EX_mem_to_reg <= 1'h0;
                EX_mem_read   <= 1'h0;
                EX_mem_size <= 3'b0;
                EX_mem_write <= 1'h0;
                EX_branch <= 1'h0;
                EX_b_type <= 1'h0;
                EX_ecall_sign <= 1'h0;
                EX_Find <= 1'h0;
                EX_Pred_take <= 0;
            end
        else
            begin
                EX_ecall_sign <= ecall_sign;
                EX_pc <= ID_pc;
                EX_inst <= ID_inst;
                EX_pc_src <= pc_src;
                EX_reg_write <= reg_write;
                EX_csr_write <= csr_write;
                EX_alu_src_b <= alu_src_b;
                EX_alu_src_a <= alu_src_a;
                EX_alu_op <= alu_op;
                EX_mem_to_reg <= mem_to_reg;
                EX_mem_read   <= mem_read;
                EX_mem_write <= mem_write;
                EX_mem_size <= mem_size;
                EX_branch <= branch;
                EX_b_type <= b_type;
                EX_Find <= ID_Find;
                EX_Pred_take <= ID_Pred_take;
            end
    end
endmodule
