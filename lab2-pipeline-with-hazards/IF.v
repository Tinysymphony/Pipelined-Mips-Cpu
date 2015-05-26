`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:24:20 04/22/2015 
// Design Name: 
// Module Name:    IF 
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
module IF_ID(
input wire clk,
input wire rst,
input wire [31:0]instr_in,
output wire [31:0]instr_out,
input wire [31:0]pc_in,
output wire [31:0]pc_out
);
	reg [31:0]tmp_pc,tmp_instr;
	
	initial begin tmp_pc=32'hFFFFFFFFF; tmp_instr=0; end
	
	always @(posedge clk or posedge rst)begin
	if(rst)begin
		tmp_instr=32'hFFFFFFFF;
		tmp_pc=32'hFFFFFFFF;
	end
	else begin
		tmp_instr=instr_in;
		tmp_pc=pc_in;
	end
	end
	assign pc_out=tmp_pc;
	assign instr_out=tmp_instr;
endmodule
