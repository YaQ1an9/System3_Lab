`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/20 22:14:13
// Design Name: 
// Module Name: Stall_pc
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


module Stall_pc(
    input [31:0] pc_order1,
    input stall,
    input jump,
    output reg [31:0]pc_order
    );
    always@(*)
    begin
    if(stall && ~jump)pc_order <= pc_order1-4;
    else pc_order <= pc_order1;
    end
endmodule
