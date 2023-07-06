`timescale 1ns / 1ps
module MMU(
    input clk,
    input rst,
    input [63:0] Satp,
    input [63:0] vm_pc_out,
    input [63:0] vm_data_addr,
    output MMU_READY,
    output [63:0] ph_data_addr,
    output [63:0] ph_pc_out
);
    `include "MEM_ACCESS_SIZE.vh"
    wire [8:0] VPN0_va;
    wire [8:0] VPN1_va;
    wire [8:0] VPN2_va;
    assign VPN0_va = (vm_addr[20:12] & 9'h1ff);
    assign VPN1_va = (vm_addr[29:21] & 9'h1ff);
    assign VPN2_va = (vm_addr[38:30] & 9'h1ff);

    wire [63:0] PPN2;
    wire [63:0] PPN1;
    wire [63:0] PPN0;
    reg [14:0] address_in;
    reg [2:0] status;

    myRam my_ram
    (
        .clk(clk),
        .we(0),
        .size(3'b101),
        .write_data(64'h0),
        .address({Satp[1:0], VPN2_va[8:0]}),
        .read_data(PPN2)
    );
    assign ph_addr = (Satp[63:60] == 4'b1000) ? {8'b0, PPN0[53:10], vm_addr[11:0]} : vm_addr;
endmodule