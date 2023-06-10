`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/06 22:05:07
// Design Name: 
// Module Name: DataPath
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

module Datapath(
    input clk,
    input rst,
    input [31:0] inst_in,
    input [31:0] pc_in,
    input [31:0] data_in,
    output mem_write,
    output  [31:0] addr_out,
    output  [31:0] data_out,
    output [31:0] reg_data,
    output [31:0] gp,
    output [1:0] info_changed,
    output  [31:0]pc_out
);
  wire Jump;      //EX ???????????
  wire mem_read;  // ID
  wire stall;
  wire [31:0]ID_imme;
  wire zero;
  wire [31:0]pc_order;
  wire [31:0]pc_order1;
  wire [31:0]pc_new;
  wire [31:0]pc_new_final;
  wire [31:0] pc_new_final_normal;
  
  wire [31:0] mtvec, EX_mtvec, MEM_mtvec;
  wire [1:0]pc_src;
  wire [31:0]pc_jump;
  wire [2:0] b_type;
    
  wire ecall_sign, EX_ecall_sign, MEM_ecall_sign;
    
  wire [31:0] ID_inst;
  wire [31:0] ID_pc;
  wire [4:0]  ID_rs1;
  wire [4:0]  ID_rs2;
  wire [4:0]  ID_rd;
  wire branch;
  wire [3:0]alu_op;
  wire [31:0]alu_result;
  wire alu_src_b;
  wire alu_src_a;
  wire [1:0]mem_to_reg;
  wire [31:0]rd_data1_gp,rd_data2_gp;
  wire [31:0]rd_data1_csr;
  wire [31:0]rd_data1, rd_data2;
  wire [31:0]EX_alu_data1;
  wire [31:0]EX_alu_data2;
  wire [31:0] EX_alu_data1_forward;
  wire [31:0] EX_alu_data2_forward;
    
  wire [31:0] EX_inst;
  wire [31:0] EX_alu_result;
  wire [31:0] EX_reg_data1;
  wire [31:0] EX_reg_data2;
  wire [31:0] EX_reg_data1_final;
  wire [31:0] EX_imme;
  wire [3:0]  EX_alu_op;
  wire [31:0] EX_pc;
  wire [1:0]  EX_pc_src;
  wire [31:0] EX_pc_jump;     
  wire [31:0] EX_pc_jump_1;       //pc+imme;
  wire [4:0]  EX_rd;
  wire [4:0]  EX_rs1;
  wire [4:0]  EX_rs2;
  wire [1:0]  EX_mem_to_reg;
  wire EX_branch;
  wire [2:0] EX_b_type;
  wire EX_alu_sec_b;
    
  wire [31:0] MEM_pc;
  wire [31:0] MEM_pc_jump_1;
  wire [31:0] MEM_pc_jump;
  wire [31:0] MEM_alu_result;
  wire [31:0] MEM_imme;
  wire [4:0]  MEM_rd;
  wire [4:0]  MEM_rs1;
  wire [4:0]  MEM_rs2;
  wire [31:0] MEM_reg_data2;
  wire [31:0] MEM_alu_data2_forward;
  wire [1:0]  MEM_mem_to_reg;
  wire [1:0]  MEM_pc_src;
  wire [31:0] ram_data_out;
    
  
  wire [4:0] WB_rd;
  wire [31:0]WB_alu_result;
  wire [31:0]WB_data_to_reg;
  wire [31:0]WB_pc;
  wire [1:0] WB_pc_src;
  wire [31:0]WB_ram_data_out;
  wire [31:0]WB_imme;
  wire [1:0] WB_mem_to_reg;
    
  wire [1:0]ForwardA;
  wire [1:0]ForwardB;
  wire EX_Find;
  wire ID_Find;
  wire IF_Find;
  wire [31:0]pc_predicted;
  wire Real_take;
  wire Pred_take;
  wire ID_Pred_take;
  wire EX_Pred_take;
  wire bubble_sign;
  qjq pc1(
  .x(pc_in),
  .y(32'h4),
  .cin(0),
  .s(pc_order1),
  .cout()             // ??pc + 4 ?????
  );
    
  qjq pc2(
  .x(EX_pc),
  .y(EX_imme),
  .cin(0),
  .s(EX_pc_jump_1),
  .cout()             //??pc + imme ?????
  );
  Jump jump(
  .Branch(EX_branch),
  .alu_result(EX_alu_result),
  .b_type(EX_b_type),
  .pc_src(EX_pc_src),
  .Jump(Jump)             // ??EX????????????B????
  );//??jump??


   pc_mux pc_mux(
  .pc_in(pc_in),
  .pc_order(pc_order1),
  .pc_jump_1(EX_pc_jump_1),
  .pc_jump_2(EX_alu_result),
  .mtvec(mtvec),
  .pc_src(EX_pc_src),
  .jump(Jump),
  .Pred_take(Pred_take),
  .EX_Pred_take(EX_Pred_take),
  .IF_Find(IF_Find),
  .EX_pc(EX_pc),
  .pc_predicted(pc_predicted),
  .stall(stall),
  .ecall_sign(EX_ecall_sign),
  .bubble_sign(bubble_sign),
  .pc_new(pc_new_final)
  );
        
//        Bubble bubble(
//        .EX_Pred_take(EX_Pred_take),
//        .Real_take(Jump),
//        .bubble_sign(bubble_sign)
//        );
        

  BTB btb(
  .clk(clk),
  .pc(pc_in),
  .EX_pc(EX_pc),
  .pc_jump_1(EX_pc_jump_1),
  .pc_jump_2(EX_alu_result),
  .EX_pc_src(EX_pc_src),
  .EX_Find(EX_Find),
  .IF_Find(IF_Find),
  .pc_predicted(pc_predicted)
  );

  BHT bht(
  .clk(clk),
  .pc(pc_in),
  .EX_pc(EX_pc),
  .EX_Find(EX_Find),
  .Real_take(Jump),   //Judge if real_take by Jump.
  .EX_pc_src(EX_pc_src),
  .info_changed(info_changed),
  .Pred_take(Pred_take)
  );
    
  NPC npc(
  .clk(clk),
  .rst(rst),
  .ecall_sign(ecall_sign),
  .mtvec(rd_data1_csr),
  .pc_new_final(pc_new_final),
  .pc_out(pc_out) 
  );
    
  IF_ID if_id(
  .clk(clk),
  .rst(rst),
  .stall(stall),
  .bubble_sign(bubble_sign),  //need bubble_sign
  .jump(Jump||MEM_ecall_sign),
  .IF_inst(inst_in),
  .IF_pc(pc_in),
  .IF_Find(IF_Find),
  .Pred_take(Pred_take),
  .ID_Pred_take(ID_Pred_take),
  .ID_Find(ID_Find),
  .ID_inst(ID_inst),
  .ID_rs1(ID_rs1),
  .ID_rs2(ID_rs2),
  .ID_rd(ID_rd),
  .ID_pc(ID_pc)
  );
    
  Regs regs(
  .stall(stall),
  .rst(rst),
  .clk(clk),
  .we(WB_reg_write),
  .read_addr_1(ID_rs1),
  .read_addr_2(ID_rs2),
  .write_addr(WB_rd),
  .write_data(WB_data_to_reg),
  .gp(gp),
  .read_data_1(rd_data1_gp),
  .read_data_2(rd_data2_gp)
  );
    
  CSR csrs(
  .clk(clk),
  .rst(rst),
  .csr_write(EX_csr_write),
  .fun3(EX_inst[14:12]),
  .read_addr(ID_imme[11:0]),
  .addr(EX_imme[11:0]),
  .ecall_sign(ecall_sign),
  .pc(pc_in),
  .din(EX_alu_data1),
  .dout(rd_data1_csr),
  .mtvec(mtvec)
  
  );
    
  MUX2T1_32 mux_csr(
  .I0(rd_data1_gp),
  .I1(rd_data1_csr),
  .s(csr_read),
  .o(rd_data1)
  );  
  
  instr_decode instr_decode(
  .instr(ID_inst),
  .stall(stall),
  .imme(ID_imme)
  );
    
  Stall stall_con(
  .EX_mem_read(EX_mem_read),
  .EX_pc_src(EX_pc_src),
  .MEM_pc_src(MEM_pc_src),
  .WB_pc_src(WB_pc_src),
  .EX_rd(EX_rd),
  .ID_rs1(ID_rs1),
  .ID_rs2(ID_rs2),
  .EX_csr_write(EX_csr_write),
  .EX_ecall_sign(EX_ecall_sign),
  .MEM_ecall_sign(MEM_ecall_sign),
  .stall(stall)
  );
    
  Control control ( 
  .op_code(ID_inst[6:0]),
  .funct3(ID_inst[14:12]),
  .funct7_5(ID_inst[30]),
  .stall(stall),
  .pc_src(pc_src),         
  .reg_write(reg_write),   
  .csr_write(csr_write),
  .csr_read(csr_read),
  .ecall_sign(ecall_sign),
  .alu_src_b(alu_src_b),   
  .alu_src_a(alu_src_a),
  .alu_op(alu_op),         
  .mem_to_reg(mem_to_reg),
  .mem_read(mem_read), 
  .mem_write(mem_write),   
  .branch(branch),         
  .b_type(b_type)          
  );
    
  ID_EXE id_exe(
  .clk(clk),
  .rst(rst),
  .bubble_sign(bubble_sign),  //need bubble_sign
  .ID_imme(ID_imme),
  .ID_pc(ID_pc),
  .ID_inst(ID_inst),
  .pc_src(pc_src),
  .reg_write(reg_write),
  .csr_write(csr_write),
  .alu_src_b(alu_src_b),
  .alu_src_a(alu_src_a),
  .alu_op(alu_op),
  .mem_to_reg(mem_to_reg),
  .mem_read(mem_read),
  .mem_write(mem_write),
  .branch(branch),
  .b_type(b_type),
  .rd_data1(rd_data1),
  .rd_data2(rd_data2_gp),
  .ID_rd(ID_rd),
  .ID_rs1(ID_rs1),
  .ID_rs2(ID_rs2),
  .ecall_sign(ecall_sign),
  .ID_Find(ID_Find),
  .ID_Pred_take(ID_Pred_take),
  .EX_Pred_take(EX_Pred_take),
  .EX_Find(EX_Find),
  .EX_ecall_sign(EX_ecall_sign),
  .EX_inst(EX_inst),
  .EX_rd_data1(EX_reg_data1),
  .EX_rd_data2(EX_reg_data2),
  .EX_rd(EX_rd),
  .EX_rs1(EX_rs1),
  .EX_rs2(EX_rs2),
  .EX_imme(EX_imme),
  .EX_pc_src(EX_pc_src),
  .EX_reg_write(EX_reg_write),
  .EX_csr_write(EX_csr_write),
  .EX_alu_src_b(EX_alu_src_b),
  .EX_alu_src_a(EX_alu_src_a),
  .EX_alu_op(EX_alu_op),
  .EX_mem_to_reg(EX_mem_to_reg),
  .EX_mem_read(EX_mem_read),
  .EX_mem_write(EX_mem_write),
  .EX_branch(EX_branch),
  .EX_pc(EX_pc),
  .EX_b_type(EX_b_type)
  );
        
  Forwarding forward(
  .EX_rs1(EX_rs1),
  .EX_rs2(EX_rs2),
  .MEM_rd(MEM_rd),
  .MEM_reg_write(MEM_reg_write),
  .WB_rd(WB_rd),
  .WB_reg_write(WB_reg_write),
  .ForwardA(ForwardA),
  .ForwardB(ForwardB)
  );
        
  MUX2T1_32 for_auipc(
  .I0(EX_reg_data1),
  .I1(EX_pc),
  .s(EX_alu_src_a),
  .o(EX_reg_data1_final)
  );
        
        
        
        
  MUX4T1_32 Alu_1(
  .I0(EX_reg_data1_final),
  .I1(WB_data_to_reg),
  .I2(MEM_alu_result),
  .I3(32'h0),
  .s(ForwardA),
  .o(EX_alu_data1_forward)
  );
  MUX2T1_32  Alu_1_imme(
  .I0(EX_alu_data1_forward),
  .I1(MEM_imme),
  .s(MEM_mem_to_reg[0]&&~MEM_mem_to_reg[1]&&ForwardA ==2'b10),
  .o(EX_alu_data1)
  ); 
        
  MUX4T1_32 Alu_2(
  .I0(EX_reg_data2),
  .I1(WB_data_to_reg),
  .I2(MEM_alu_result),
  .I3(EX_imme),
  .s(ForwardB),
  .o(EX_alu_data2_forward)
  );
  MUX2T1_32  Alu_2_imme(
  .I0(EX_alu_data2_forward),
  .I1(EX_imme),
  .s(EX_alu_src_b),
  .o(EX_alu_data2)
  ); 
    
  ALU alu(
  .a(EX_alu_data1),
  .b(EX_alu_data2),
  .EX_alu_op(EX_alu_op),
  .res(EX_alu_result),
  .zero()
  );
        
  EXE_MEM exe_mem(
  .clk(clk),
  .rst(rst),
  .alu_result(EX_alu_result),
  .EX_pc(EX_pc),
  .EX_pc_src(EX_pc_src),
  .EX_reg_write(EX_reg_write),
  .EX_mem_to_reg(EX_mem_to_reg),
  .EX_mem_read(EX_mem_read),
  .EX_mem_write(EX_mem_write),
  .EX_rd(EX_rd),
  .EX_rs1(EX_rs1),
  .EX_rs2(EX_rs2),
  .EX_reg_data2(EX_reg_data2),
  .EX_alu_data2_forward(EX_alu_data2_forward),
  .EX_pc_jump_1(EX_pc_jump_1),
  .EX_imme(EX_imme),
  .EX_ecall_sign(EX_ecall_sign),
        
  .MEM_ecall_sign(MEM_ecall_sign),
  .MEM_pc_jump_1(MEM_pc_jump_1),
  .MEM_imme(MEM_imme),
  .MEM_reg_data2(MEM_reg_data2),
  .MEM_alu_data2_forward(MEM_alu_data2_forward),
  .MEM_rd(MEM_rd),
  .MEM_rs1(MEM_rs1),
  .MEM_rs2(MEM_rs2),
  .MEM_alu_result(MEM_alu_result),
  .MEM_pc_src(MEM_pc_src),
  .MEM_reg_write(MEM_reg_write),
  .MEM_pc(MEM_pc),
  .MEM_mem_to_reg(MEM_mem_to_reg),
  .MEM_mem_read(MEM_mem_read),
  .MEM_mem_write(MEM_mem_write)
  );
    
  Data_memory data_memory(
  .clk(clk),
  .addr(MEM_alu_result),
  .MEM_mem_write(MEM_mem_write),
  .data_to_ram(MEM_alu_data2_forward),
  .ram_data_out(ram_data_out)
  );
        
  MEM_WB mem_wb(
  .clk(clk),
  .rst(rst),
  .MEM_rd(MEM_rd),
  .MEM_alu_result(MEM_alu_result),
  .MEM_pc(MEM_pc),
  .MEM_pc_src(MEM_pc_src),
  .MEM_reg_write(MEM_reg_write),
  .MEM_mem_to_reg(MEM_mem_to_reg),
  .MEM_mem_write(MEM_mem_write),
  .ram_data_out(ram_data_out),
  .MEM_imme(MEM_imme),
  .WB_ram_data_out(WB_ram_data_out),
  .WB_imme(WB_imme),
  .WB_rd(WB_rd),
  .WB_alu_result(WB_alu_result),
  .WB_pc_src(WB_pc_src),
  .WB_reg_write(WB_reg_write),
  .WB_pc(WB_pc),
  .WB_mem_to_reg(WB_mem_to_reg),
  .WB_mem_write(WB_mem_write)
  );
        
  MUX4T1_32 reg_wb_data_mux(
  .I0(WB_alu_result),
  .I1(WB_imme),
  .I2(WB_pc+4),
  .I3(WB_ram_data_out),
  .s(WB_mem_to_reg),
  .o(WB_data_to_reg)
  );
  assign reg_data = WB_data_to_reg;

endmodule






