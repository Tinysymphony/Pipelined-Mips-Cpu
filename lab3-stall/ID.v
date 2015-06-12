`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:17:16 04/25/2015 
// Design Name: 
// Module Name:    ID 
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
module EXE(
input wire en,
input wire clk,
input wire rst,
input wire valid_in,
output reg valid,
input wire shift_in,
input wire [31:0]pc_in,instr_in,sign_ext_in,zero_ext_in,opa_in,opb_in,
input wire [14:0]ctrl_in,
output reg [14:0]ctrl_out,
output reg [4:0]shift_out,
input wire [4:0]regw_addr_in,
output reg[4:0]regw_addr_out,
output reg [31:0]pc_out,instr_out,sign_ext_out,zero_ext_out,opa_out,opb_out,
input wire wb_wen_in,
output reg wb_wen_out,
input wire mem_wen_in,
output reg mem_wen_out,
input wire [31:0]data_rt_in,
output reg [31:0]data_rt_out
    );
	
	initial begin 
		ctrl_out=0; shift_out=0; 
		pc_out=0; opa_out=0; opb_out=0; zero_ext_out=0; sign_ext_out=0;
		regw_addr_out=0; valid=0;
		wb_wen_out=0;
		mem_wen_out=0;
		data_rt_out=0;
	end
	
	always @(posedge clk)begin
		if(rst)begin
			pc_out<=0;
			instr_out<=0;
			sign_ext_out<=0;
			zero_ext_out<=0;
			opa_out<=0;
			opb_out<=0;
			shift_out<=0;
			valid<=0;
			wb_wen_out<=0;
			mem_wen_out<=0;
			data_rt_out<=0; 
		end
		else if(en) begin
			valid<=valid_in;
			ctrl_out<=ctrl_in[14:0];
			instr_out<=instr_in;
			pc_out<=pc_in;
			sign_ext_out<=sign_ext_in;
			zero_ext_out<=zero_ext_in;
			opa_out<=opa_in;
			opb_out<=opb_in;
			shift_out<=instr_in[10:6];
			regw_addr_out<=regw_addr_in;
			wb_wen_out<=wb_wen_in;
			mem_wen_out<=mem_wen_in;
			data_rt_out<=data_rt_in;
		end
	end

endmodule
