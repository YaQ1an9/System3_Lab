`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2022 10:03:31 PM
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
        input clk,
        input rst,
        input stall,
        input bubble_sign,
        input jump,
        input [31:0] IF_inst,
        input [31:0] IF_pc,
        input IF_Find,
        input Pred_take,
        output reg ID_Pred_take,
        output reg ID_Find,
        output reg [4:0]ID_rs1,
        output reg [4:0]ID_rs2,
        output reg [4:0]ID_rd,
        output reg [31:0]ID_inst,
        output reg [31:0]ID_pc
    );
    always @(posedge clk,posedge rst)
    begin
        if(rst || bubble_sign)ID_inst <= 32'h0;
        else if(~stall) ID_inst <= IF_inst;
        else if(stall && jump) ID_inst <= 32'h0;
    end
    
    always @(posedge clk, posedge rst)
    begin
        if(rst || bubble_sign)
            begin
                ID_rs1 <= 5'h0;
                ID_rs2 <= 5'h0;
                ID_rd  <= 5'h0;
                ID_Find <= 0;
                ID_Pred_take <= 0;
            end
        else if(~stall)
            begin
                ID_rs1 <=IF_inst[19:15];
	            ID_rs2 <=IF_inst[24:20];
	            ID_rd  <=IF_inst[11:7];
	            ID_Find <= IF_Find;
	            ID_Pred_take <= Pred_take;
            end
    end
    always @(posedge clk,posedge rst)
    begin
        if(rst || bubble_sign)ID_pc <= 32'h0;
        else if(~stall)ID_pc <= IF_pc;
    end
    
endmodule
