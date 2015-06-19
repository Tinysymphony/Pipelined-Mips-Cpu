`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:39:26 04/25/2015 
// Design Name: 
// Module Name:    pipeController 
// ProJect Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// ADDItional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pipeController(
	input clk,
	input rst,
	input [31:0]instr, 
	output [14:0]out,
	
	//add new with stall
	
	output reg imm_ext,  // whether using sign extended to immediate data
	output reg exe_b_src,  // data source of operand B for ALU
	output reg [3:0] exe_alu_oper,  // ALU operation type
	output reg mem_ren,  // memory read enable signal
	output reg mem_wen,  // memory write enable signal
	output reg wb_addr_src,  // address source to write data back to registers
	output reg wb_data_src,  // data source of data being written back to registers
	output reg wb_wen,  // register write enable signal
	output reg is_branch,  // whether current instruction is a branch instruction
	output reg rs_used,  // whether RS is used
	output reg rt_used,  // whether RT is used
	output reg unrecognized,  // whether current instruction can not be recognized
	// pipeline control
	input wire reg_stall,  // stall signal when LW instruction followed by an related R instruction
	
	input wire control_stall,
	output reg ip_rst,
	output reg ip_en,
	
	output reg if_rst,  // stage reset signal
	output reg if_en,  // stage enable signal
	
	input wire if_valid,  // stage valid flag
	output reg id_rst,
	output reg id_en,
	
	input wire id_valid,
	output reg exe_rst,
	output reg exe_en,
	
	input wire exe_valid,
	output reg mem_rst,
	output reg mem_en,
	
	input wire mem_valid,
	output reg wb_rst,
	output reg wb_en,

	input wire wb_valid,
	
	input wire single_stall,
	output reg [7:0] op_type
);

	`include "mips.vh"

	wire LW,SW,ADDI,ANDI,ORI,BNE,BEQ,J,R;
	wire [5:0]switch;
	assign switch = instr[31:26];
	and(LW,switch[5],~switch[4],~switch[3],~switch[2],switch[1],switch[0]);
	and(SW,switch[5],~switch[4],switch[3],~switch[2],switch[1],switch[0]);
	and(ADDI,~switch[5],~switch[4],switch[3],~switch[2],~switch[1],~switch[0]);
	and(ANDI,~switch[5],~switch[4],switch[3],switch[2],~switch[1],~switch[0]);
	and(ORI,~switch[5],~switch[4],switch[3],switch[2],~switch[1],switch[0]);
	and(BNE,~switch[5],~switch[4],~switch[3],switch[2],~switch[1],switch[0]);
	and(BEQ,~switch[5],~switch[4],~switch[3],switch[2],~switch[1],~switch[0]);
	and(J,~switch[5],~switch[4],~switch[3],~switch[2],switch[1],~switch[0]);
	and(R,~switch[5],~switch[4],~switch[3],~switch[2],~switch[1],~switch[0]);
	assign out[0]=R; // R-type
	assign out[1]=LW||SW||ADDI;// ALUsrc
	assign out[2]=LW; // write data from mem to reg
	assign out[3]=R||LW||ADDI||ANDI||ORI; // wirte reg
	assign out[4]=SW; // save data to mem
	assign out[5]=BEQ; // branch
	assign out[6]=BNE; //
	assign out[7]=J; // jump
	assign out[8]=ANDI||ORI;//arusrc high bit 
	assign out[9]=R;
	assign out[10]=ADDI;
	assign out[11]=ANDI;
	assign out[12]=ORI;
	assign out[13]=BEQ||BNE;
	assign out[14]=1; //write pc
	
	
	//add new part
	
	always @(*) begin
		imm_ext = 0;
		exe_b_src = EXE_B_RT;
		exe_alu_oper = EXE_ALU_ADD;
		mem_ren = 0;
		mem_wen = 0;
		wb_addr_src = WB_ADDR_RD;
		wb_data_src = WB_DATA_ALU;
		wb_wen = 0;
		is_branch = 0;
		rs_used = 0;
		rt_used = 0;
		unrecognized = 0;
		op_type=0;
		case(instr[31:26]) 
			INST_R: begin
				case(instr[5:0])
					R_FUNC_ADD: begin
						exe_alu_oper = EXE_ALU_ADD;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
						op_type = 1;
					end
					R_FUNC_SUB: begin
						exe_alu_oper = EXE_ALU_SUB;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
						op_type = 2;
					end
					R_FUNC_AND: begin
						exe_alu_oper = EXE_ALU_AND;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
						op_type = 3;
					end
					R_FUNC_OR: begin
						exe_alu_oper = EXE_ALU_OR;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
						op_type = 4;
					end
					R_FUNC_XOR: begin
						exe_alu_oper = EXE_ALU_XOR;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
						op_type = 0;
					end
					R_FUNC_SRA: begin
						exe_alu_oper = EXE_ALU_SRA;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
						op_type = 0;
					end
					R_FUNC_SLL: begin
						exe_alu_oper = EXE_ALU_SLL;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rt_used = 1;
						op_type = 0;
					end
					R_FUNC_SRL: begin
						exe_alu_oper = EXE_ALU_SRL;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rt_used = 1;
						op_type = 0;
					end
					default: begin
						unrecognized = 1;
					end
				endcase
			end
			INST_BEQ: begin
				exe_b_src = EXE_B_IMM;
				imm_ext = 1;
				is_branch = 1;
				rs_used = 1;
				rt_used = 1;
				op_type = 13;
			end
			INST_BNE: begin
				exe_b_src = EXE_B_IMM;
				imm_ext = 1;
				is_branch = 1;
				rs_used = 1;
				rt_used = 1;
				op_type = 14;
			end
			INST_LW: begin
				imm_ext = 1;
				exe_b_src = EXE_B_IMM;
				exe_alu_oper = EXE_ALU_ADD;
				mem_ren = 1;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_MEM;
				wb_wen = 1;
				rs_used = 1;
				op_type = 11;
			end
			INST_SW: begin
				imm_ext = 1;
				exe_b_src = EXE_B_IMM;
				exe_alu_oper = EXE_ALU_ADD;
				mem_wen = 1;
				rs_used = 1;
				rt_used = 1;
				op_type = 12;
			end
			INST_ADDI: begin
				imm_ext = 1;
				exe_b_src = EXE_B_IMM;
				exe_alu_oper = EXE_ALU_ADD;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
				rs_used = 1;
				op_type = 8;
			end
			INST_ANDI: begin
				imm_ext = 1;
				exe_b_src = EXE_B_IMM;
				exe_alu_oper = EXE_ALU_AND;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
				rs_used = 1;
				op_type = 0;
			end
			INST_ORI: begin
				imm_ext = 1;
				exe_b_src = EXE_B_IMM;
				exe_alu_oper = EXE_ALU_OR;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
				rs_used = 1;
				op_type = 10;
			end
			INST_J: begin
				op_type = 15;
			end
			default: begin
				unrecognized = 1;
			end
		endcase
	end

	initial begin 
		ip_rst = 0;
		ip_en = 1;
		if_rst = 0;
		if_en = 1;
		id_rst = 0;
		id_en = 1;
		exe_rst = 0;
		exe_en = 1;
		mem_rst = 0;
		mem_en = 1;
		wb_rst = 0;
		wb_en = 1;
	end
	
	always @(*) begin
		ip_rst = 0;
		ip_en = 1;
		if_rst = 0;
		if_en = 1;
		id_rst = 0;
		id_en = 1;
		exe_rst = 0;
		exe_en = 1;
		mem_rst = 0;
		mem_en = 1;
		wb_rst = 0;
		wb_en = 1;
		if (rst) begin
			if_rst = 1;
			id_rst = 1;
			exe_rst = 1;
			mem_rst = 1;
			wb_rst = 1;
		end
		// this stall indicate that ID is waiting for previous LW instruction, insert one NOP between ID and EXE.
		else if (reg_stall) begin
			if_en = 0;
			id_en = 0;
			exe_rst = 1;
		end
		else if(control_stall) begin
			if_en = 0;
			id_en = 0;
			exe_rst = 1;
			id_rst = 1;
			if_rst = 1;	
			//ip_en = 0;
			//mem_rst = 1;
			//mem_en = 0;
		end
		else if(single_stall) begin
			
		end
	end

endmodule
