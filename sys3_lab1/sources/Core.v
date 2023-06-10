`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 18:08:36
// Design Name: 
// Module Name: Core
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


module Core(
    input  wire        clk,
    input  wire        aresetn,
    input  wire        step,
    input  wire        debug_mode,
    // input  wire [4:0]  debug_reg_addr, // register address

    output wire [31:0] address,
    output wire [31:0] data_out,
    input  wire [31:0] data_in,
    
    input  wire [31:0] chip_debug_in,
    output wire [31:0] chip_debug_out0,
    output wire [31:0] chip_debug_out1,
    output wire [31:0] chip_debug_out2,
    output wire [31:0] chip_debug_out3,
    output wire [31:0] chip_debug_out5,
    output wire [31:0] chip_debug_out4
);
    wire rst, mem_write, mem_clk, cpu_clk;
    wire [31:0] inst, core_data_in, addr_out, core_data_out, pc_out, gp;
    wire [1:0] info_changed;
    wire [31:0]reg_data;
    reg  [31:0] clk_div;
    wire [31:0]pc_4;
    assign pc_4=pc_out/4;
    assign rst = ~aresetn;
    SCPU cpu(
        .clk(cpu_clk),
        .rst(rst),
        .inst(inst),
        .pc(pc_out),
        .data_in(core_data_in),      // data from data memory
        .addr_out(addr_out),         // data memory address
        .data_out(core_data_out),    // data to data memory
        .pc_out(pc_out),             // connect to instruction memory
        .reg_data(reg_data),
        .gp(gp),
        .info_changed(info_changed),
        .mem_write(mem_write)
    );
    
    always @(posedge clk) begin
        if(rst) clk_div <= 0;
        else clk_div <= clk_div + 1;
    end
    assign mem_clk = ~clk_div[0]; // 50mhz
    assign cpu_clk = debug_mode ? clk_div[0] : step;
    
    
    
//    myRom rom_unit(
//        .address(pc_out[12:2]),
//        .out(inst)
//    );
    
    rom rom_unit (
        .a(pc_4),  
        .spo(inst) 
    );
    
    // TODO:
    /*ram ram_unit (
        .clka(mem_clk),  
        .wea(mem_write),   
        .addra(addr_out), 
        .dina(core_data_out),  
        .douta(core_data_in)  
    );*/
    
    // TODO: 
    assign chip_debug_out0 = pc_out;
    assign chip_debug_out1 = info_changed;
    assign chip_debug_out2 = reg_data;
    assign chip_debug_out3 = gp;
    assign chip_debug_out5 = reg_data;
    assign chip_debug_out4 = info_changed;
    
    
    //assign chip_debug_out4=
endmodule
