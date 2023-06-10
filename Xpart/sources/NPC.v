`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2022 11:18:39 AM
// Design Name: 
// Module Name: NPC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


 module NPC(
    input clk,
    input rst,
    input ecall_sign,
    input [31:0]mtvec,
    input [31:0]pc_new_final,
    output reg [31:0]pc_out
 );
    always@(posedge clk or posedge rst)
    begin
       //if(ecall_sign == 0)
       //begin
        if(rst)
            pc_out<=32'h0;
        else
            pc_out <= pc_new_final;
       //end
       //else
            //pc_out <= mtvec;
    end
 endmodule
