`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2022 11:10:42 AM
// Design Name: 
// Module Name: ALU
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


 module ALU (
 input [31:0] a,
 input [31:0] b,
 input [3:0] EX_alu_op,
 output reg [31:0] res,
 output zero
 );
 `include "AluOp.vh"
 always @(*)
 case (EX_alu_op)
    ADD: res = a + b;
    SUB:res=a-b;
    SLL:res=a<<b;
    SLT:begin
      res<=31'b0;
      if(a[31]==1&b[31]==0)res<=31'b1;
     if(a[31]==b[31]&a[30:0]<b[30:0])res<=31'b1;
      end
    OR:res=a|b;
    AND:res=a&b;
    SRL:res=a>>b;
    NOP:res = a;
    
    default: res = 0;
 endcase
 endmodule
