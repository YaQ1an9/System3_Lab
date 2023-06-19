`timescale 1ns / 1ps

module pc_mux(
    input [63:0] pc_in,
    input [63:0] pc_order,
    input [63 : 0 ] pc_jump_1,
    input [63 : 0] pc_jump_2,
    input [63:0] sys_addr,
    input [ 1 : 0 ]pc_src,
    input   jump,
    input   Pred_take,
    input   EX_Pred_take,
    input   IF_Find,
    input   [63:0] EX_pc,
    input   [63:0]pc_predicted,
    input stall,
    input  ecall_sign,
    input   bubble_sign,
    output reg [63 : 0] pc_new
    );
    wire [63 : 0] pc_jump;
    assign pc_jump = (pc_src[0] == 1'b1) ? pc_jump_2 : pc_jump_1;
    always @(*)
    begin
       if(stall == 1)   //the original logic
                begin
                   if(pc_src[1] == 1 ) pc_new =(jump ==1 ) ? pc_jump : pc_in;
                   else if(ecall_sign == 1) pc_new = sys_addr;
                   else pc_new = pc_in;
                 end
        else
        begin   //2
        if(pc_src[1] == 1'b0 && ecall_sign == 0) pc_new = pc_order;
                 else
                        begin
                                if(ecall_sign == 1)  pc_new = sys_addr;
                                else
                                        begin
                                                if(pc_src[1] == 1'b1 && jump) pc_new = pc_jump;
                                                else  pc_new = pc_order;
                                        end
                        end
        end //2
//        if(stall == 0)
//        begin//1
//        if(bubble_sign)
//        begin
//            if(EX_Pred_take == 1) pc_new = EX_pc + 4;
//            else    pc_new = pc_jump;
//        end
//        else
//        begin//2
//            if(IF_Find == 0) pc_new = pc_order;
//            else if(Pred_take == 1) pc_new = pc_predicted;
//            else pc_new = pc_order;
//        end //2
//        end //1
//        else pc_new = pc_in;
    end
    
    
endmodule
