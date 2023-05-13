`timescale 1ns / 1ps
module I_cache(
    input wire clk,
    input wire rst,

    input [31:0] cpu_req_addr,
    input cpu_req_valid,
    input cpu_req_wr,
    output reg [31:0] cpu_req_data,
    output reg cput_req_ready,

    output reg [31:0] mem_req_addr,
    output reg [31:0] mem_wr_data,
    output reg 

);