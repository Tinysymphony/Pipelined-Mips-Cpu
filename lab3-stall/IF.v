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
module ID(
input wire en,
input wire clk,
input wire rst,
input wire [31:0]instr_in,
output reg [31:0]instr_out,
input wire [31:0]pc_in,
output reg [31:0]pc_out,
input wire valid_in,
output reg valid,
input wire [31:0] pc_next_in,
output reg [31:0] pc_next_out
);
	
	initial begin pc_out=0; instr_out=0; valid=0; pc_next_out=0; end
	
	always @(posedge clk)begin
		if(rst) begin
			valid=0;
			pc_out = 0;
			instr_out = 0;
			pc_next_out = 0;
		end
		else if(en) begin
			pc_out = pc_in;
			instr_out = instr_in;
			valid = valid_in;
			pc_next_out = pc_next_in;
		end
	end

endmodule
