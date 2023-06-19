`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/03 10:21:51
// Design Name: 
// Module Name: myRam
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


module myRam(
    input clk,
    input we,
    input [2:0] size,
    input [63:0] write_data,
    input [10:0] address,
    output reg [63:0] read_data,

    //for mmu
    input [63:0]Satp,
    input [63:0]vm_pc,
    output [63:0]ph_pc
    //
    );
    reg [63:0] ram [0:2048];
    integer i;
    localparam FILE_PATH = "C:/system3/my_lab/sys3_lab1/simcode/lab2-ram.coe";
    initial begin
        $readmemh(FILE_PATH, ram);
        // for(i = 0; i < 2048; i = i + 1)
        // begin
        //     ram[i][63:0] <= 64'h0;
        // end
    end
    always @(posedge clk) begin
        
        if (we == 1) 
        begin
            case(size)
            3'b000: ram[address][7:0] <= write_data[7:0];
            3'b001: ram[address][15:0] <= write_data[15:0];
            3'b010: ram[address][31:0] <= write_data[31:0];
            3'b101: ram[address][63:0] <= write_data[63:0];
            endcase
            // ram[address] <= write_data[63:0];
        end
    end
    always @(*)
    begin
    case(size)
        3'b000: read_data <= {56'b0,ram[address][7:0]};
        3'b001: read_data <= {48'b0,ram[address][15:0]};
        3'b010: read_data <= {32'b0,ram[address][31:0]};
        3'b101: read_data <= ram[address][63:0];
    endcase
    end

    //for mmu
    wire [8:0] VPN0_va;
    wire [8:0] VPN1_va;
    wire [8:0] VPN2_va;
    wire [63:0] PPN2;
    assign VPN0_va = (vm_pc[20:12] & 9'h1ff);
    assign VPN1_va = (vm_pc[29:21] & 9'h1ff);
    assign VPN2_va = (vm_pc[38:30] & 9'h1ff);
    // assign VPN2_va = (9'h180 & 9'h1ff);
    assign PPN2 = ram[{Satp[1:0],VPN2_va[8:0]}];
    assign ph_pc = (Satp[63:60] == 4'b1000) ? {8'b0, PPN2[53:28], vm_pc[29:0]} : vm_pc;
    //
endmodule
