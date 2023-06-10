`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/16 10:27:23
// Design Name: 
// Module Name: Jump
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


module Jump(
    input  Branch,
    input [31:0] alu_result,
    input [2:0] b_type,
    input [1:0] pc_src,
    output reg Jump
    );
    always @(*)
    begin
    if(((!Branch)||(alu_result == 0 && b_type == 1)||(alu_result != 0 && b_type == 0)||(b_type == 2 && alu_result >=0) )&& pc_src[1] == 1'b1)
        Jump = 1;
    else
        Jump = 0;
    end
endmodule
