module Control(
    input   [6:0]   op_code,
    input   [2:0]   funct3,
    input   [7:0]   funct7,
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
    output  reg [2:0] mem_size,   
    output  reg branch,         
    output  reg [2:0]b_type          
    );
    `include "MEM_ACCESS_SIZE.vh"
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
            7'b0110111:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b01; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end  //LUI
            7'b0111011:
            begin
                case(funct3)
                  3'b000:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 0; alu_op = 4'b1001; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end //ADDW
                  
                endcase
            end
            7'b0011011:
            begin
                case(funct3)
                  3'b000:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b1011; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0;end  //ADDIW
                  3'b001:begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_op = 4'b1010; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end    //SLLIW
                endcase
            end
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
                        3'b111: begin pc_src = 2'b10; reg_write = 0; alu_src_b = 0; alu_op = 4'b1001; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 1; b_type = 2; ill_instr = 0; end    //BGEU
                        3'b101: begin pc_src = 2'b10; reg_write = 0; alu_src_b = 0; alu_op = 4'b1010; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 1; b_type = 3; ill_instr = 0; end    //BGE
                        3'b100: begin pc_src = 2'b10; reg_write = 0; alu_src_b = 0; alu_op = 4'b1010; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 1; b_type = 4; ill_instr = 0; end    //BLT
                        3'b110: begin pc_src = 2'b10; reg_write = 0; alu_src_b = 0; alu_op = 4'b1001; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 1; b_type = 5; ill_instr = 0; end    //BLTU
                        default:begin pc_src = 2'b00; reg_write = 0; alu_src_b = 0; alu_op = 4'b0000; mem_to_reg = 0; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 1; end
                    endcase
                end
            7'b0000011: 
              begin
                case(funct3)
                3'b000: begin reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b11; mem_write = 0;mem_read = 1;mem_size = Signed_Byte; branch = 0; b_type = 0; ill_instr = 0;end  //LB
                3'b001: begin reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b11; mem_write = 0;mem_read = 1;mem_size = Half_Word; branch = 0; b_type = 0; ill_instr = 0;end //LH
                3'b010: begin reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b11; mem_write = 0;mem_read = 1;mem_size = Word; branch = 0; b_type = 0; ill_instr = 0;end // LW
                3'b100: begin reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b11; mem_write = 0;mem_read = 1;mem_size = Unsigned_Byte; branch = 0; b_type = 0; ill_instr = 0;end // LBU
                3'b101: begin reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b11; mem_write = 0;mem_read = 1;mem_size = Half_Word; branch = 0; b_type = 0; ill_instr = 0;end // LHU
                3'b011: begin reg_write = 1; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b11; mem_write = 0;mem_read = 1;mem_size = Double_Word; branch = 0; b_type = 0; ill_instr = 0;end // LD
                endcase
              end
            7'b0100011: 
              begin 
                case(funct3)
                3'b000: begin pc_src = 2'b00; reg_write = 0; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 1;mem_read = 0;mem_size = Signed_Byte; branch = 0; b_type = 0; ill_instr = 0; end  //SB
                3'b001: begin pc_src = 2'b00; reg_write = 0; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 1;mem_read = 0;mem_size = Half_Word; branch = 0; b_type = 0; ill_instr = 0; end  //SH
                3'b010: begin pc_src = 2'b00; reg_write = 0; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 1;mem_read = 0;mem_size = Word; branch = 0; b_type = 0; ill_instr = 0; end  //SW
                3'b011: begin pc_src = 2'b00; reg_write = 0; alu_src_b = 1; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 1;mem_read = 0;mem_size = Double_Word; branch = 0; b_type = 0; ill_instr = 0; end  //SD
                endcase
              end
            7'b0010111: begin pc_src = 2'b00; reg_write = 1; alu_src_b = 1; alu_src_a = 1 ;alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 0;mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end // auipc
            7'b1110011: 
                begin 
                    case(funct3)
                    3'b001: begin csr_write = 1; csr_read = 1; reg_write = 1; pc_src = 2'b00; alu_src_b = 0; alu_op = 4'b1111; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end //csrrw
                    3'b010: begin csr_write = 1; csr_read = 1; reg_write = 1; pc_src = 2'b00; alu_src_b = 0; alu_op = 4'b1111; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end //csrrs
                    3'b011: begin csr_write = 1; csr_read = 1; reg_write = 1; pc_src = 2'b00; alu_src_b = 0; alu_op = 4'b1111; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0; branch = 0; b_type = 0; ill_instr = 0; end //csrrc
                    3'b000:
                        begin 
                            case(funct7)
                                7'b0001000:begin ecall_sign = 1; reg_write = 1; pc_src = 2'b00; alu_src_b = 0; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0; branch = 0; b_type = 0;end //SRET 
                                7'b0011000:begin ecall_sign = 1; reg_write = 1; pc_src = 2'b00; alu_src_b = 0; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0; branch = 0; b_type = 0; end //MRET
                                7'b0000000:begin ecall_sign = 1; reg_write = 1; pc_src = 2'b00; alu_src_b = 0; alu_op = 4'b0000; mem_to_reg = 2'b00; mem_write = 0; mem_read = 0; branch = 0; b_type = 0; end //ecall
                                7'b0001001:begin end //sfence.vma
                            endcase
                        end //ecall && sret
                    endcase
                end
            
            endcase  
            
         end
    end
    
endmodule

