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
    reg [31:0] cache_data [127:0];
    reg hit;
    wire [3:0] cpu_req_index = cpu_req_addr[3:0];
    wire [28:0] cpu_reg_tag = cpu_reg_addr[31:4];
    integer i;
    //初始化cache
    initial begin
        for(i = 0; i < 128; i++) cache_data[i] = 32'd0; 
    end
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

    //CMU
    always @(*)
    begin
        case(Stage)
            IDLE: next_Stage = cpu_req_valid ? CompareTag : IDLE;
            CompareTag: 
            begin
                if(hit)
                begin
                    next_Stage = CompareTag;
                end
                else if(Dirty)
                begin
                    next_Stage = WriteBack;
                end
                else 
                begin
                    next_Stage = Allocate;
                end
            end
            WriteBack: next_Stage = mem_req_ready ? Allocate : WriteBack;
            Allocate: next_Stage = mem_req_ready ? CompareTag : Allocate;
            default: next_Stage = IDLE;
        endcase
    end

    always @(*)
        if(Stage == CompareTag)
            if(cache_data[cpu_req_index][31] && cache_data)



endmodule

