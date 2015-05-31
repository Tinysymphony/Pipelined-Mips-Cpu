`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:17:53 04/25/2015 
// Design Name: 
// Module Name:    EX_MEM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MEM(
input wire en,
input wire clk,
input wire rst,
input wire zero_in,
output reg zero_out,
input wire[31:0]pc_in,opb_in,alu_res_in,im_pc_in,jmp_pc_in,
input wire[14:0]ctrl_in,
output reg[31:0]pc_out,opb_out,alu_res_out,im_pc_out,jmp_pc_out,
input wire[4:0]regw_addr_in,
output reg[4:0]regw_addr_out,
output reg[7:0]ctrl_out,
input wire wb_wen_in,
output reg wb_wen_out,
input wire valid_in,
output reg valid,
input wire mem_wen_in,
output reg mem_wen_out
    );
	
	initial begin 
		zero_out=0; ctrl_out=0; opb_out=0; regw_addr_out=0; 
		alu_res_out=0; jmp_pc_out=0; im_pc_out=0; pc_out=0;
		wb_wen_out=0; valid=0;
		mem_wen_out=0;
	end
	
	always @(posedge clk)begin
		if(rst)begin
			valid=0;
			pc_out=0;
			im_pc_out=0;
			jmp_pc_out=0;
			alu_res_out=0;
			opb_out=0;
			ctrl_out=0;
			zero_out=0;
			regw_addr_out=0;
			wb_wen_out=0;
			mem_wen_out=0;
		end
		else if(en) begin
			valid=valid_in;
			pc_out=pc_in;
			im_pc_out=im_pc_in;
			jmp_pc_out=jmp_pc_in;
			alu_res_out=alu_res_in;
			opb_out=opb_in;
			ctrl_out={ctrl_in[14],ctrl_in[7:2],ctrl_in[0]};
			regw_addr_out=regw_addr_in;
			zero_out=zero_in;
			wb_wen_out=wb_wen_in;
			mem_wen_out=mem_wen_in;
		end
	end
	
endmodule
