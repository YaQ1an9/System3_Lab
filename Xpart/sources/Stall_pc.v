`timescale 1ns / 1ps

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
