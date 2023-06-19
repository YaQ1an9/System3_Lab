`timescale 1ns / 1ps

 module NPC(
    input clk,
    input rst,
    input ecall_sign,
    input [63:0]pc_new_final,
    output reg [63:0]pc_out
 );
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            pc_out<=63'h0;
        else
            pc_out <= pc_new_final;
    end
 endmodule
