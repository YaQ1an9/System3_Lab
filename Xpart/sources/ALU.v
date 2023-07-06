`timescale 1ns / 1ps
 module ALU (
 input [63:0] a,
 input [63:0] b,
 input [3:0] EX_alu_op,
 output reg [63:0] res,
 output zero
 );
 `include "AluOp.vh"
 reg [63:0]tmp;
 always @(*)
 case (EX_alu_op)
    ADD: res = a + b;
    SUB:res=a-b;
    SLL:res=a<<b;
    SLT:begin
      res<=31'b0;
    if(a[31]==1&b[31]==0)res<=31'b1;
    if(a[31]==b[31]&a[30:0]<b[30:0])res<=31'b1;
      end
    OR:res=a|b;
    AND:res=a&b;
    SRL:res=a>>b;
    NOP:res = a;
    CMP: res = ((a[63] == 1'b0 && b[63] == 1'b1)||(a[63] == 1'b0 && b[63] == 1'b0 && a > b)||(a[63] == 1'b1 && b[63] == 1'b1 && a < b)) ? 64'h1 : ((a == b) ? 64'h0 : 64'hffffffffffffffff);
    CMP_U: res = (a > b) ? 64'h1 : ((a==b) ? 64'h0 : 64'hffffffffffffffff);
    ADDIW: begin
      tmp = a + b;
      res = (tmp[31] == 1'b1)?({32'hffffffff, tmp[31:0]}) : ({32'h0, tmp[31:0]});
      end
    default: res = 0;
 endcase
 endmodule
