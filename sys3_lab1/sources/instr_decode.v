`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2022 11:02:11 AM
// Design Name: 
// Module Name: instr_decode
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


module instr_decode(
	input [31:0]instr,
	input stall,
	output reg [31:0]imme
	 );
	 
	reg I_type;
	reg U_type;
	reg J_type;
	reg B_type;
	reg S_type;
	reg JR_type;
	
	reg [31:0]I_imme;
	reg [31:0]U_imme;
	reg [31:0]J_imme;
	reg [31:0]B_imme;
	reg [31:0]S_imme;
	reg [31:0]JR_imme;
	
	

	always@(*)
	begin
	if(~stall)
	   begin
	 I_type=(instr[6:0]==7'b0000011) | (instr[6:0]==7'b0010011)| (instr[6:0] == 7'b1110011); //(instr[6:0]==7'b1101111) | 
	 U_type=(instr[6:0]==7'b0110111) ;
	 J_type=(instr[6:0]==7'b1101111);
     B_type=(instr[6:0]==7'b1100011);
	 S_type=(instr[6:0]==7'b0100011);
	 JR_type=(instr[6:0]==7'b1100111);
	
	
	
	 I_imme={{20{instr[31]}},instr[31:20]}; 
	 U_imme={instr[31:12],{12{1'b0}}};
	 J_imme={{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};   
	 B_imme={{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
	 S_imme={{20{instr[31]}},instr[31:25],instr[11:7]}; 
	 JR_imme={{20{instr[31]}},instr[31:20]};
	
	if(I_type) imme <= I_imme;
	else if(U_type) imme <= U_imme;
	else if(J_type) imme <= J_imme;
	else if(JR_type) imme <= JR_imme;
	else if(B_type) imme <= B_imme;
	else if(S_type) imme <= S_imme;
	else imme <= 32'h0;
	/* imme= I_type?I_imme :
				 U_type?U_imme :
				 J_type?J_imme:
				 JR_type?JR_imme:
				 B_type?B_imme :
				 S_type?S_imme : 32'd0;*/
	    end
	else imme = 32'h0;
    end

endmodule
