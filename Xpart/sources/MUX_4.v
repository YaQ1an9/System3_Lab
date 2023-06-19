`timescale 1ns / 1ps
 module MUX4T1_64(
 input [63:0]I0,
 input [63:0]I1,
 input [63:0]I2,
 input [63:0]I3,
 input [1:0]s,
 output reg [63:0]o
 );
 always@(*)
 begin
    case(s)
        2'b00:o=I0;
        2'b01:o=I1;
        2'b10:o=I2;
        2'b11:o=I3;
    endcase
 end
 endmodule
