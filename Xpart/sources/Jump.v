`timescale 1ns / 1ps
module Jump(
    input  Branch,
    input [63:0] alu_result,
    input [2:0] b_type,
    input [1:0] pc_src,
    output reg Jump
    );
    always @(*)
    begin
    if(((!Branch)||
        (b_type == 1 && alu_result == 0)||
        (b_type == 0 && alu_result != 0)||
        (b_type == 2 && alu_result[63] != 1'b1)||
        (b_type == 3 && alu_result[63] != 1'b1)||
        (b_type == 4 && alu_result[63] == 1'b1)||
        (b_type == 5 && alu_result[63] == 1'b1))&& pc_src[1] == 1'b1)
        Jump = 1;
    else
        Jump = 0;
    end
endmodule
