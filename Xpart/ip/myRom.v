`timescale 1ns / 1ps

module myRom(
    input [63:0] address,
    output [31:0] out
);
    reg [31:0] rom [0:2047];


    // localparam FILE_PATH = "C:/system3/my_lab/Xpart/xpart_code/kernel.coe";
    localparam FILE_PATH = "C:/system3/my_lab/Xpart/xpart_code_myself/kernel.coe";
//     localparam FILE_PATH = "C:/system3/simfile/build-normal/kernel.sim";
//    localparam FILE_PATH = "C:/system3/my_lab/sys3_lab1/simcode/lab2-rom.coe";
    initial begin
        $readmemh(FILE_PATH, rom);
    end


    assign out = rom[address];
endmodule
