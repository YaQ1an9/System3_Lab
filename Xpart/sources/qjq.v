`timescale 1ns / 1ps
module FA(
    input x,y,cin,
    output s,cout
);
    assign s=x^y^cin;
    assign cout=(x&y)|(x&cin)|(y&cin);
endmodule

module qjq(
    input [63:0]x,y,
    input cin,
    output [63:0]s,
    output cout
    );
    wire[64:0] c; 
    assign c[0]=cin;
    genvar count;
    generate
    for(count=0;count<64;count=count+1)
    begin
    FA fa(x[count],y[count],c[count],s[count],c[count+1]);
    end
    endgenerate
    assign cout=c[64];
endmodule


