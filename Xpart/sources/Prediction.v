`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/16 10:23:24
// Design Name: 
// Module Name: BTB
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


module BTB(
    input [31:0]pc,
    input [31:0] pc_jump,
    input [1:0]pc_src,
    output reg Take_if,
    output reg [31:0]pc_predicted
    );
    reg [31:0]pc_buffer[0:127];
    reg [31:0]pred_buffer[0:127];
    reg [7:0]cnt;
    integer i;
    always@(*)
    begin
        for(i = 0; i < cnt; i = i + 1)
        if(pc_buffer[i] == pc)
            begin
            pc_predicted = pred_buffer[i];
            break;
            end
        
        if(i == cnt && pc_src[1] == 1)  //??branch????buffer??????
        begin
            pc_buffer[i] = pc;
            pred_buffer[i] = pc_jump;
            cnt = cnt + 1;
        end
        
        
    end
endmodule
