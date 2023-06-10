`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 15:11:21
// Design Name: 
// Module Name: SCPU
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


module SCPU(
    input         clk,
    input         rst,
    input  [31:0] inst,
    input  [31:0] pc,
    input  [31:0] data_in,  // data from data memory
    output [31:0] addr_out, // data memory address
    output [31:0] data_out, // data to data memory
    output [31:0] pc_out,   // connect to instruction memoryx
    output [31:0] reg_data,
    output [31:0] gp,
    output [1:0]info_changed,
    output        mem_write
    );
    
    Datapath datapath (
        .clk(clk),
        .rst(rst),
        .inst_in(inst),
        .pc_in(pc),
        .data_in(data_in),
        .mem_write(mem_write),
        .addr_out(addr_out),
        .data_out(data_out),
        .reg_data(reg_data),
        .gp(gp),
        .info_changed(info_changed),
        .pc_out(pc_out)
    );
    
endmodule

