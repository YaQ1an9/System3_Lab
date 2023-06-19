`timescale 1ns / 1ps
module CSR(
    input clk,
    input rst,
    input csr_write,
    input [2:0]fun3,
    input [11:0]read_addr,
    input [11:0]addr,
    input ecall_sign,
    input [63:0]pc,
    input [63:0]din,
    output [63:0]dout,
    output [63:0] Satp,
    output [63:0] sys_addr 
    );
    `include "CSR_NUM.vh"
    reg [64:0] CSR [0:1200];
    assign dout = CSR[read_addr];
    assign Satp = CSR[satp];
    assign sys_addr = (!ecall_sign) ? sys_addr : (read_addr == 0) ? CSR[stvec] : CSR[sepc]; 
    integer i;
    initial begin
        for(i = 0; i  < 1200; i = i + 1) CSR[i] = 64'h0; 
    end
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
                   CSR[scause] <= 11;
                   CSR[sepc] <= pc - 4;
                 end
            end
        end
endmodule
