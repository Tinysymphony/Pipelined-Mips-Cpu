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

module pipeController (
	input wire clk,  
	input wire rst, 
	// instruction decode
	input wire [1:0] pc_src_id,
	input wire [1:0] pc_src_exe,
	input wire [31:0] instr,  // instruction
	input wire rs_rt_equal,//whether data from rs and rt are equal
	input wire is_load_exe,//whether instruction in EXE is lw
	inout wire is_store_exe,//whether instruction in EXE is sw
	input wire [4:0] regw_addr_exe, // register write address from EXE stage
	input wire wb_wen_exe, // register write enable signal feedback from EXE stage
	input wire is_load_mem, // whether instruction in MEM stage is LW
	input wire is_store_mem, // whether instruction in MEM stage is SW
	input wire is_jump_exe,
	input wire is_branch_exe,
	input wire is_jump_mem,
	input wire is_branch_mem,
	input wire [4:0] addr_rt_mem, // address of RT from MEM stage
	input wire [4:0] regw_addr_mem, // register write address from MEM stage
	input wire wb_wen_mem, // register write enable signal feedback from MEM stage
	input wire [4:0] regw_addr_wb, // register write address from WB stage
	input wire wb_wen_wb, // register write enable signal feedback from WB stage

	output reg imm_ext,  // whether using sign extended to immediate data
	output reg [1:0] exe_b_src,  // data source of operand B for ALU
	output reg exe_a_src,
	output reg [4:0] exe_alu_oper,  // ALU operation type
	output reg mem_ren,  // memory read enable signal
	output reg mem_wen,  // memory write enable signal
	output reg [1:0] wb_addr_src,  // address source to write data back to registers
	output reg wb_data_src,  // data source of data being written back to registers
	output reg wb_wen,  // register write enable signal
	output reg [1:0] pc_src, // how would Pc change to next
	//output reg is_branch,  // whether current instruction is a branch instruction
	//output reg rs_used,  
	//output reg rt_used,  
	output reg is_load, // whether current is lw
	output reg is_store, // whether current is sw
	output reg is_branch,
	output reg is_jump,
	output reg unrecognized,  // whether current instruction can not be recognized
	
	output reg [2:0] fwd_a,
	output reg [2:0] fwd_b,
	output reg fwd_m,
	output reg if_rst, 
	output reg if_en,  
	input wire if_valid,  

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
	input wire wb_valid
	);

    reg reg_stall, control_stall;
    wire [4:0] addr_rs, addr_rt;
	
	`include "mips.vh"
	reg rs_used,rt_used;
	// instruction decode
	always @(*) begin
		imm_ext = 0;
		exe_b_src = EXE_B_RT;
		exe_a_src = EXE_A_RS;
		exe_alu_oper = EXE_ALU_ADD;
		mem_ren = 0;
		mem_wen = 0;
		wb_addr_src = WB_ADDR_RD;
		wb_data_src = WB_DATA_ALU;
		wb_wen = 0;
		pc_src = 2'b00;
		rs_used = 0;
		rt_used = 0;
        is_load = 0;
        is_store = 0;
        is_branch = 0;
        is_jump = 0;
		unrecognized = 0;
		case (instr[31:26])
			INST_R: begin
				case (instr[5:0])
					R_FUNC_ADD: begin
						exe_alu_oper = EXE_ALU_ADD;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_ADDU: begin
						exe_alu_oper = EXE_ALU_ADDU;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_SUB: begin
						exe_alu_oper = EXE_ALU_SUB;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_SUBU: begin
						exe_alu_oper = EXE_ALU_SUBU;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_AND: begin
						exe_alu_oper = EXE_ALU_AND;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_OR: begin
						exe_alu_oper = EXE_ALU_OR;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_XOR: begin
						exe_alu_oper = EXE_ALU_XOR;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_NOR: begin
						exe_alu_oper = EXE_ALU_NOR;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_SLT: begin
						exe_alu_oper = EXE_ALU_SLT;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_SLTU: begin
						exe_alu_oper = EXE_ALU_SLTU;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rt_used = 1;
					end
					R_FUNC_SLL: begin
						exe_alu_oper = EXE_ALU_SLL;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rt_used = 1;
					end
					R_FUNC_SRL: begin
						exe_alu_oper = EXE_ALU_SRL;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rt_used = 1;
					end
					R_FUNC_SRA: begin
						exe_alu_oper = EXE_ALU_SRA;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rt_used = 1;
					end
					R_FUNC_SLLV: begin
						exe_alu_oper = EXE_ALU_SLLV;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_SRLV: begin
						exe_alu_oper = EXE_ALU_SRLV;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_SRAV: begin
						exe_alu_oper = EXE_ALU_SRAV;
						wb_addr_src = WB_ADDR_RD;
						wb_data_src = WB_DATA_ALU;
						wb_wen = 1;
						rs_used = 1;
						rt_used = 1;
					end
					R_FUNC_JR: begin
						rs_used = 1;
						pc_src = PC_JR;
						is_jump = 1;
					end
					default: begin
						unrecognized = 1;
					end
				endcase
			end
			INST_ADDI:begin
				imm_ext = 1;
				rs_used = 1;
				exe_b_src = EXE_B_IMM;
				exe_alu_oper = EXE_ALU_ADD;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
			end
			INST_ADDIU:begin
				exe_alu_oper = EXE_ALU_ADDU;
				exe_b_src = EXE_B_IMM;
				imm_ext = 1;
				rs_used = 1;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
			end
			INST_ANDI:begin
				exe_alu_oper = EXE_ALU_AND;
				exe_b_src = EXE_B_IMM;
				rs_used = 1;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
			end
			INST_ORI:begin
				exe_alu_oper = EXE_ALU_OR;
				exe_b_src = EXE_B_IMM;
				rs_used = 1;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
			end
			INST_XORI:begin
				exe_alu_oper = EXE_ALU_XOR;
				exe_b_src = EXE_B_IMM;
				rs_used = 1;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
			end
			INST_LUI:begin
				exe_alu_oper = EXE_ALU_LUI;
				exe_b_src = EXE_B_IMM;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
			end

			INST_SLTI:begin
				exe_alu_oper = EXE_ALU_SLT;
				exe_b_src = EXE_B_IMM;
				imm_ext = 1;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
			end
			INST_SLTIU:begin
				exe_alu_oper = EXE_ALU_SLT;
				exe_b_src = EXE_B_IMM;
				wb_addr_src = WB_ADDR_RT;
				wb_data_src = WB_DATA_ALU;
				wb_wen = 1;
			end

			INST_BEQ: begin
				if (rs_rt_equal) begin
					pc_src = PC_BRANCH;
				end
				else begin
					pc_src = PC_NOT_BRANCH;
				end
				exe_b_src = EXE_B_IMM;
				imm_ext = 1;
				rs_used = 1;
				rt_used = 1;
				is_branch = 1;
			end
			INST_BNE: begin
				if (!rs_rt_equal) begin
					pc_src = PC_BRANCH;
				end
				else begin
					pc_src = PC_NOT_BRANCH;
				end
				exe_b_src = EXE_B_IMM;
				imm_ext = 1;
				rs_used = 1;
				rt_used = 1;
				is_branch = 1;
			end
			INST_J: begin
				pc_src = PC_JUMP;
				is_jump = 1;
			end
			INST_JAL: begin
				pc_src = PC_JUMP;
				wb_addr_src = WB_ADDR_LINK;
				wb_data_src = WB_DATA_ALU;
				exe_b_src = EXE_B_LINK;
				exe_a_src = EXE_A_PC;
				wb_wen = 1;
				is_jump = 1;
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
				is_load = 1;
			end
			INST_SW: begin
				imm_ext = 1;
				exe_b_src = EXE_B_IMM;
				exe_alu_oper = EXE_ALU_ADD;
				mem_wen = 1;
				rs_used = 1;
				rt_used = 1;
				is_store = 1;
			end
			default: begin
				unrecognized = 1;
			end
		endcase
	end
	
	// pipeline control

	assign
        addr_rs = instr[25:21],
        addr_rt = instr[20:16];

	always @(*) begin
		reg_stall = 0;
		control_stall = 0;
		fwd_a = 0;
		fwd_b = 0;
		fwd_m = 0;
		//a
		if (rs_used && addr_rs!=0) begin
			if (regw_addr_exe == addr_rs && wb_wen_exe) begin
                if (is_load_exe) begin //stall when the former one is lw instruction
					reg_stall = 1;
                end 
				else begin
					fwd_a = 1; //rs need to be put in the fwd
				end
			end
			else if (regw_addr_mem == addr_rs && wb_wen_mem) begin
                if (is_load_mem) begin
					fwd_a =3;
                end
				else begin
					fwd_a =2;			
				end
			end
            else if (regw_addr_wb == addr_rs && wb_wen_wb) begin
                fwd_a = 4;
            end
		end
		//b
		if (rt_used && addr_rt!=0) begin
			if (regw_addr_exe == addr_rt && wb_wen_exe) begin
                if (is_load_exe) begin
					reg_stall = 1;
                end
				else begin
					fwd_b = 1;
				end
			end
			else if (regw_addr_mem == addr_rt && wb_wen_mem) begin
				if (is_load_mem)
					fwd_b =3;
				else begin
					fwd_b =2;			
				end
			end
            else if (regw_addr_wb == addr_rt && wb_wen_wb) begin
                fwd_b = 4;
            end
		end

		// if (is_branch_exe | is_branch_mem | is_jump_exe | is_jump_mem ) begin
		if (is_branch_exe | is_jump_exe ) begin
			control_stall = 1;
		end
	end
	
	always @(*) begin
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
		else if (control_stall) begin
			if_en = 0;
			id_en = 0;
			// exe_en = 0;
			exe_rst = 1;
			if( pc_src_id == PC_BRANCH )begin
				id_rst = 1;
			end
			//if_rst = 1;	
		end
	end
	
endmodule
