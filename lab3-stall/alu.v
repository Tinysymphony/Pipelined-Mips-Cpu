`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:03 03/17/2015 
// Design Name: 
// Module Name:    alu 
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
module alu (
input wire[31:0]opa,opb,
input wire[4:0]sa,
input wire[3:0]alu_ctrl,
output reg zero,
output reg [31:0]alu_out
);
	always@* begin
		case(alu_ctrl)
			4'b0000: alu_out=opa & opb;
			4'b0001: alu_out=opa | opb;
			4'b0010: alu_out=opa+opb;
			4'b0110: alu_out=opa-opb;
			4'b0011: alu_out=opb<<sa;
			4'b0100: alu_out=opb>>sa;
			4'b0101: alu_out=$signed(opa)>>>opb;
			4'b0111: alu_out=(opa<opb)?1:0;
			4'b1000: alu_out=~(opa|opb);
			default: alu_out=0;
		endcase
		if(alu_out==0)zero=1;
		else zero=0;
	end
endmodule

