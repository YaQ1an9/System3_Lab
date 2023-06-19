`timescale 1ns / 1ps

module BTB(
    input clk,
    input [31:0] pc,
    input [31:0] EX_pc,
    input [31:0] pc_jump_1,
    input [31:0] pc_jump_2,
    input [1:0]  EX_pc_src,
    input EX_Find,
    output reg IF_Find,
    output reg [31:0]pc_predicted
    );
    reg [31:0]pc_buffer[0:127];
    reg [31:0]pred_buffer[0:127];
    reg [7:0]cnt;
    integer i;
    initial 
    begin
    cnt = 0;
    IF_Find = 0;
    end
    wire [31 : 0] pc_jump;
    assign pc_jump = (EX_pc_src[0] == 1'b1) ? pc_jump_2 : pc_jump_1;
    always@(*)
    begin
        IF_Find = 0;
        pc_predicted = 0;
        for(i = 0; i < cnt; i = i + 1)
        if(pc_buffer[i] == pc)
            begin
            pc_predicted = pred_buffer[i];
            IF_Find = 1;
            //break;
            end
    end
    always@(posedge clk)
    begin
        if(EX_Find == 0 && EX_pc_src[1] != 1'b0)  //Insertion is here. Judge branch by EX_pc_src.
            begin
            pc_buffer[cnt] = EX_pc;
            pred_buffer[cnt] <= pc_jump;
            cnt = cnt + 1;
            end
    end
endmodule
