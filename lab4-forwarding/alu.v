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
input wire[31:0] a, b,
input wire[4:0]sa,
input wire[4:0] oper,
output reg [31:0]result
);

	`include "mips.vh"
	always @(*) begin
		//adder_mode = 0;
		result = 0;
		case (oper)
			EXE_ALU_ADD: begin
				result = a + b;
			end
			EXE_ALU_ADDU: begin
				result = a + b;
			end
			EXE_ALU_SUB: begin
				result = a - b;
			end
			EXE_ALU_SUBU: begin
				result = a - b;
			end
			EXE_ALU_AND: begin
				result = a & b;
			end
			EXE_ALU_OR: begin
				result = a | b;
			end
			EXE_ALU_XOR: begin
				result = a ^ b;
			end
			EXE_ALU_NOR: begin
				result = ~(a | b);
			end
			EXE_ALU_SLT: begin
				result = $signed(a) < $signed(b) ? 1 : 0;
			end
			EXE_ALU_SLTU: begin
				result = $unsigned(a) < $unsigned(b) ? 1 : 0;
			end
			EXE_ALU_SLL: begin
				result = $unsigned(b) << sa;				
			end
			EXE_ALU_SRL: begin
				result = $unsigned(b) >> sa;
			end
			EXE_ALU_SRA: begin
				result = $signed(b) >> sa;
			end
			EXE_ALU_SLLV: begin
				result = $unsigned(b) << a;
			end
			EXE_ALU_SRLV: begin
				result = $unsigned(b) >> a;
			end
			EXE_ALU_SRAV: begin
				result = $signed(b) >> a;
			end
			EXE_ALU_LUI: begin
				result = {b[15:0], 16'b0};
			end
		endcase
	end
endmodule

