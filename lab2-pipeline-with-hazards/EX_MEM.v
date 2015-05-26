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
module EX_MEM(
input wire clk,
input wire rst,
input wire zero_in,
output wire zero_out,
input wire[31:0]pc_in,opb_in,alu_res_in,im_pc_in,jmp_pc_in,
input wire[4:0]rt_in,rd_in,
input wire[14:0]ctrl_in,
output wire[31:0]pc_out,opb_out,alu_res_out,im_pc_out,jmp_pc_out,
output wire[4:0]rt_out,rd_out,
output wire[7:0]ctrl_out
    );
	reg [31:0]pc,im_pc,jmp_pc,alu_res,opb;
	reg [7:0]ctrl;
	reg [4:0]rt,rd;
	reg zero;
	
	initial begin zero=0; ctrl=0; rt=0; rd=0; opb=0; alu_res=0; jmp_pc=0; im_pc=0; pc=32'hFFFFFFFF; end
	
	always @(posedge clk or posedge rst)begin
		if(rst)begin
			pc=32'hFFFFFFFF;
			im_pc=0;
			jmp_pc=0;
			alu_res=0;
			opb=0;
			ctrl=0;
			rt=0;
			rd=0;
			zero=0;
		end
		else begin
			pc=pc_in;
			im_pc=im_pc_in;
			jmp_pc=jmp_pc_in;
			alu_res=alu_res_in;
			opb=opb_in;
			ctrl={ctrl_in[14],ctrl_in[7:2],ctrl_in[0]};
			rt=rt_in;
			rd=rd_in;
			zero=zero_in;
		end
	end
	
	assign pc_out=pc;
	assign im_pc_out=im_pc;
	assign jmp_pc_out=jmp_pc;
	assign alu_res_out=alu_res;
	assign opb_out=opb;
	assign ctrl_out=ctrl;
	assign rt_out=rt;
	assign rd_out=rd;
	assign zero_out=zero;
endmodule
