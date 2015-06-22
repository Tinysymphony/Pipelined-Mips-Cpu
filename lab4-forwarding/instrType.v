`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:02:21 06/17/2015 
// Design Name: 
// Module Name:    instrType 
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
module instrType(
input wire[31:0]instr,
output reg [7:0]op_type
    );
	`include "mips.vh"
	initial op_type=0;
	
	always @(*) begin
		case(instr[31:26]) 
			INST_R: begin
				case(instr[5:0])
					R_FUNC_ADD: begin
						op_type = 1;
					end
					R_FUNC_SUB: begin
						op_type = 2;
					end
					R_FUNC_AND: begin
						op_type = 3;
					end
					R_FUNC_OR: begin
						op_type = 4;
					end
					R_FUNC_XOR: begin
						op_type = 0;
					end
					R_FUNC_SRA: begin
						op_type = 0;
					end
					R_FUNC_SLL: begin
						op_type = 0;
					end
					R_FUNC_SRL: begin
						op_type = 0;
					end
					default: begin
						op_type = 0;
					end
				endcase
			end
			INST_BEQ: begin
				op_type = 13;
			end
			INST_BNE: begin
				op_type = 14;
			end
			INST_LW: begin
				op_type = 11;
			end
			INST_SW: begin
				op_type = 12;
			end
			INST_ADDI: begin
				op_type = 8;
			end
			INST_ANDI: begin
				op_type = 0;
			end
			INST_ORI: begin
				op_type = 10;
			end
			INST_J: begin
				op_type = 15;
			end
			default: begin
				op_type = 0;
			end
		endcase
	end

endmodule
