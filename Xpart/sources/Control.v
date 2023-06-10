// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sat May 29 13:57:02 2021
// Host        : DESKTOP-M082HN9 running 64-bit major release  (build 9200)
// Command     : write_verilog -mode synth_stub D:Control.v
// Design      : Control
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module Control(
    input   [6:0]   op_code,
    input   [2:0]   funct3,
    input   funct7_5,
    input   stall,
    output  reg  [1:0]pc_src,         
    output  reg reg_write,   
    output  reg csr_write,
    output  reg csr_read,
    output  reg ecall_sign,
    output  reg alu_src_b,
    output  reg alu_src_a,  
    output  reg [3:0]   alu_op,        
    output  reg [1:0]   mem_to_reg, 
    output  reg mem_read,
    output  reg mem_write,   
    output  reg branch,         
    output  reg [2:0]b_type          
    );
    
    reg     [1:0]   aluop;
    reg     ill_instr;
    wire    [3:0]   funt;
    assign  funt =   {funct3, funct7_5};
    always  @ (*)  begin
    
        alu_src_b   =   0;
        mem_to_reg  =   0;
        mem_read    =   0;
        mem_write   =   0;
        csr_write   =   0;
        csr_read    =   0;
        ecall_sign  =   0;
        reg_write   =   0;
        branch      =   0;
        b_type      =   0;
        alu_op      =   4'b0000;
        pc_src      =   2'b0;
        alu_src_a   =   0;
        ill_instr   =   0;
        if(~stall)
        begin
        case(op_code)
            7'b0010011:
                begin
                    case(funct3)
                        3'b000:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end      //ADDI                    
                        3'b010:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b0010; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end      //SLTI
                        3'b111:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b0111; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end      //ANDI
                        3'b110:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b0110; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end      //ORI
                        3'b001: begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b0001; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end    //SLLI
                        3'b101:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b0101; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end      //SRLI
                        3'b100: begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b0100; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end     //XORI
                        default: begin pc_src = 2'b00; reg_write = 0; alu_src_b = 0; alu_op = 4'b0000; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 1; end
                    endcase
                end
            7'b0110111:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b0001; mem_to_reg = 2'b01; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end  //LUI
            7'b0110011:
                begin
                    case(funct3)
                        3'b000: begin
                        if(funct7_5==0) //ADD
                         begin pc_src = 2'b00; reg_write = 1; alu_src_b = 0; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end
                         else       //SUB
                         begin pc_src = 2'b00; reg_write = 1; alu_src_b = 0; alu_op = 4'b1000; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end
                         end    
                        3'b010: begin pc_src = 2'b00; reg_write = 1; alu_src_b = 0; alu_op = 4'b0010; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end    //SLT
                        3'b111: begin pc_src = 2'b00; reg_write = 1; alu_src_b = 0; alu_op = 4'b0111; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end    //AND
                        3'b110: begin pc_src = 2'b00; reg_write = 1; alu_src_b = 0; alu_op = 4'b0110; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end    //OR
                        3'b001: begin pc_src = 2'b00; reg_write = 1; alu_src_b = 0; alu_op = 4'b0001; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end    //SLL
                        3'b101:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 0; alu_op = 4'b0101; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0;branch = 0; b_type = 0; ill_instr = 0; end      //SRL
                        default: begin pc_src = 2'b00; reg_write = 0; alu_src_b = 0; alu_op = 4'b0000; mem_to_reg = 0; mem_write = 0; mem_read = 0;branch = 0; b_type = 0; ill_instr = 1; end
                    endcase
                end
            7'b1101111:begin pc_src = 2'b10; reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b10; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end              //JAL
            7'b1100111:begin pc_src = 2'b11; reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b10; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end              //JALR
            7'b1100011:
                begin
                    case(funct3)
                        3'b000: begin pc_src = 2'b10; reg_write = 0; alu_src_b = 0; alu_op = 4'b1000; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 1; b_type = 1; ill_instr = 0; end    //BEQ
                        3'b001: begin pc_src = 2'b10; reg_write = 0; alu_src_b = 0; alu_op = 4'b1000; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 1; b_type = 0; ill_instr = 0; end    //BNE
                        3'b111: begin pc_src = 2'b10; reg_write = 0; alu_src_b = 0; alu_op = 4'b1000; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 1; b_type = 2; ill_instr = 0; end    //BGEU
                        //3'b111: begin pc_src = 2'b10; reg_write = 0; alu_src_b = 0; alu_op = 4'b1000; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 1; b_type = 2; ill_instr = 0; end    //BGEU
                        default:begin pc_src = 2'b00; reg_write = 0; alu_src_b = 0; alu_op = 4'b0000; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 1; end
                    endcase
                end
            7'b0000011: begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b11; mem_write = 0;mem_read = 1; branch = 0; b_type = 0; ill_instr = 0; end            //LW
            7'b0100011: begin pc_src = 2'b00; reg_write = 0; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 1;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end            //SW
            7'b0010111: begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_src_a = 1 ;alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end // auipc
            7'b1110011: 
                begin 
                    case(funct3)
                    3'b001: begin csr_write = 1; csr_read = 1; reg_write = 1; pc_src = 2'b00; alu_src_b = 0; alu_op = 4'b1111; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end //csrrw
                    3'b010: begin csr_write = 1; csr_read = 1; reg_write = 1; pc_src = 2'b00; alu_src_b = 0; alu_op = 4'b1111; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end //csrrs
                    3'b011: begin csr_write = 1; csr_read = 1; reg_write = 1; pc_src = 2'b00; alu_src_b = 0; alu_op = 4'b1111; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end //csrrc
                    3'b000: begin ecall_sign = 1; reg_write = 1; pc_src = 2'b00; alu_src_b = 0; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0; branch = 0; b_type = 0;   end //ecall
                    endcase
                end
            
            endcase  
            
         end
    end
    
endmodule

