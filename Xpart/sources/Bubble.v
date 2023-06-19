`timescale 1ns / 1ps

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
