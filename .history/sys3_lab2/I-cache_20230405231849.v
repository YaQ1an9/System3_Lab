`timescale 1ns / 1ps
`include "I_Stage.vh"
module I_cache(
    //Instruction Cache
    input wire clk,
    input wire rst,

    //to CPU
    input [31:0] cpu_req_addr,
    input cpu_req_valid,
    output reg [31:0] cpu_req_data,
    output reg cput_req_ready,
    //to Mem 
    input [31:0] mem_req_data,
    input mem_req_ready,
    output reg [31:0] mem_req_addr,
    output reg [31:0] mem_wr_data,
    output reg mem_req_vaild,
    output reg mem_req_wr
);
    reg [2:0] Stage, next_Stage;
    always @(posedge clk)
    begin
       if(rst) 
        begin
        Stage <= IDLE;
        end  
       else
        begin
        Stage <= next_Stage;
        end
    end

    always @(*)
    begin
        case(Stage)
            IDLE: next_Stage = cpu_req_valid ? 
        endcase
    end




endmodule

