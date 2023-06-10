`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/18 14:40:03
// Design Name: 
// Module Name: Bubble
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


module Bubble(
    input EX_Pred_take,
    input Real_take,
    output reg bubble_sign
    );
    always@(*)
    begin
        bubble_sign = 0;
        if(EX_Pred_take != Real_take) bubble_sign = 1;
    end
endmodule
