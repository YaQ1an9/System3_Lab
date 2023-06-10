`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/01 11:02:13
// Design Name: 
// Module Name: qjq
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

    module FA(
    input x,y,cin,
    output s,cout
 );
    assign s=x^y^cin;
    assign cout=(x&y)|(x&cin)|(y&cin);
    endmodule

module qjq(
    input [31:0]x,y,
    input cin,
    output [31:0]s,
    output cout
    );
    wire[32:0] c; 
    assign c[0]=cin;
    genvar count;
    generate
    for(count=0;count<32;count=count+1)
    begin
    FA fa(x[count],y[count],c[count],s[count],c[count+1]);
    end
    endgenerate
    assign cout=c[32];
endmodule


