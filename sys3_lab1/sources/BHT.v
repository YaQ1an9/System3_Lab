`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/16 10:27:07
// Design Name: 
// Module Name: BHT
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


module BHT(
    input clk,
    input [31:0] pc,
    input [31:0] EX_pc,
    input EX_Find,
    input Real_take,
    input [1:0] EX_pc_src,
    output reg [1:0]info_changed,
    output reg Pred_take
    );
    reg [31:0]pc_buffer[0:127];
    reg [1:0] history_info[0:127];
    reg a,b;
    reg [7:0]cnt;
    integer i;
    initial
    begin
    cnt = 0;
    Pred_take = 0;
    a = 0;
    b = 0;
    end
    always@(*)
    begin
        Pred_take = 0;//first appear, predicte not taken
        
        for(i = 0; i < cnt; i = i + 1)
        if(pc_buffer[i] == pc)
        begin
            if(history_info[i][1] == 1'b1)
            begin
                Pred_take = 1;
            end
            else
            begin
                Pred_take = 0;
            end
            //break;
        end
    end
    always@(posedge clk)
    begin
        if(EX_Find == 1)
        begin
            for(i = 0; i < cnt; i = i + 1)
            if(pc_buffer[i] == EX_pc)
            begin
                a = history_info[i][1];
                b = history_info[i][0];
//                history_info[i][0] = (!history_info[i][1] && !history_info[i][0] && Real_take)
//                                  || (!history_info[i][1] && history_info[i][0] && Real_take)
//                                  || (history_info[i][1] && history_info[i][0] && Real_take)
//                                  || (history_info[i][1] && !history_info[i][0] && Real_take);
                                  
//                history_info[i][1] = (history_info[i][1] && history_info[i][0] && Real_take)
//                                  || (history_info[i][1] && history_info[i][0] && !Real_take)
//                                  || (history_info[i][1] && !history_info[i][0] && Real_take);
                history_info[i][0] = (!a && !b && Real_take)
                                  || (!a && b && Real_take)
                                  || (a && b && Real_take)
                                  || (a && !b && Real_take);
                                  
                history_info[i][1] = (a && b && Real_take)
                                  || (a && b && !Real_take)
                                  || (a && !b && Real_take);
                info_changed = history_info[i];
                                 
            end
        end else if(EX_pc_src[1] == 1'b1)   //first appear, load
            begin
                pc_buffer[cnt] = EX_pc;
                history_info[cnt] = 2'b10;
                cnt = cnt + 1;
            end
    end
    
endmodule
