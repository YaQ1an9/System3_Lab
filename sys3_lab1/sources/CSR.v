`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/23 15:45:16
// Design Name: 
// Module Name: CSR
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

module CSR(
    input clk,
    input rst,
    input csr_write,
    input [2:0]fun3,
    input [11:0]read_addr,
    input [11:0]addr,
    input ecall_sign,
    input [31:0]pc,
    input [31:0]din,
    output [31:0]dout,
    output [31:0] mtvec
    );
    reg [31:0] CSR [500:1200];
    
    assign dout = CSR[read_addr];
    assign mtvec = (!ecall_sign) ? mtvec : (read_addr == 0) ? CSR[773] : CSR[833]; 
    integer i;
    always @(posedge clk or posedge rst) 
        begin
            if (rst == 1) for (i = 0; i < 4096; i = i + 1); //CSR[i] <= 0; // reset
            else 
             begin
                 if (csr_write == 1 && addr != 0) 
                     begin
                        case(fun3)
                        3'b001: begin CSR[addr] <= din; end  // csrw
                        3'b010: begin CSR[addr] <= din | CSR[addr]; end  // csrs
                        3'b011: begin CSR[addr] <= CSR[addr]& ~din; end  // csrc
                        default : begin end
                        endcase  
                     end
                if(ecall_sign == 1 && read_addr == 0 )
                 begin
                   CSR[834] <= 11;
                   CSR[833] <= pc - 4;
                 end
            end
        end
endmodule
