`timescale 1ns / 1ps

module MEM_WB(
    input clk,
    input rst,
    input [4:0]MEM_rd,
    input [63:0]MEM_alu_result,
    input [63:0]MEM_pc,
    input [1:0]MEM_pc_src,
    input MEM_reg_write,
    input [1:0]MEM_mem_to_reg,
    input MEM_mem_write,
    input [63:0]ram_data_out,
    input [63:0]MEM_imme,
    output reg [63:0]WB_ram_data_out,
    output reg [63:0]WB_imme,
    output reg [4:0] WB_rd,
    output reg [63:0]WB_alu_result,
    output reg [1:0]WB_pc_src,
    output reg WB_reg_write,
    output reg [63:0]WB_pc,
    output reg [1:0]WB_mem_to_reg,
    output reg WB_mem_write
    
    );
    always @(posedge clk,posedge rst)
    begin
        if(rst)
        begin
            WB_alu_result <= 64'h0;
            WB_pc <= 64'h0;
            WB_pc_src <= 1'h0;
            WB_reg_write <= 1'h0;
            WB_mem_to_reg <= 1'h0;
            WB_mem_write <= 1'h0;
            WB_rd <= 5'h0;
            WB_ram_data_out <= 64'h0;
            WB_imme <= 64'h0;
        end
        else
        begin
            WB_alu_result <= MEM_alu_result;
            WB_pc <= MEM_pc;
            WB_pc_src <= MEM_pc_src;
            WB_reg_write <= MEM_reg_write;
            WB_mem_to_reg <= MEM_mem_to_reg;
            WB_mem_write <= MEM_mem_write;
            WB_rd <= MEM_rd;
            WB_ram_data_out <= ram_data_out;
            WB_imme <= MEM_imme;
            end
    end
endmodule
