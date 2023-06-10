`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/07/2022 03:13:56 PM
// Design Name: 
// Module Name: Data_memory
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


module Data_memory(
    input clk,
    input [31:0]addr,
    input MEM_mem_write,
    input [31:0]data_to_ram,
    output[31:0] ram_data_out
    );
        wire ram_clk = ~clk;
        
        ram to_ram(
        .clka(ram_clk),         //this ram_clk = ~clk
        .wea(MEM_mem_write),
//        .addra(addr/4),
        .addra(addr),
        .dina(data_to_ram),
        .douta(ram_data_out)
        );
//       myRam my_ram(
//       .clk(ram_clk),             //this ram_clk = clk;
//       .we(MEM_mem_write),
//       .write_data(data_to_ram),
//       .address(addr[12:2]),
//       .read_data(ram_data_out)
//       );
endmodule
