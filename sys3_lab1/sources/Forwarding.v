`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/19 23:43:02
// Design Name: 
// Module Name: Forwarding
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


module Forwarding(
    input [4:0] EX_rs1,
    input [4:0] EX_rs2,
    input [4:0] MEM_rd,
    input MEM_reg_write,
    input [4:0] WB_rd,
    input WB_reg_write,
    
    output reg [1:0]ForwardA,
    output reg [1:0]ForwardB
    );
    
    always @(*)
    begin
    if(MEM_reg_write && MEM_rd != 5'h0 && MEM_rd==EX_rs1) ForwardA = 2'b10;
    else if(WB_reg_write && WB_rd != 5'h0 && WB_rd==EX_rs1) ForwardA = 2'b01;
    else ForwardA = 2'b00;
    
    if(MEM_reg_write && MEM_rd != 5'h0 && MEM_rd==EX_rs2) ForwardB = 2'b10;
    else if(WB_reg_write && WB_rd != 5'h0 && WB_rd==EX_rs2) ForwardB = 2'b01;
    else ForwardB = 2'b00;
    end
    
endmodule
