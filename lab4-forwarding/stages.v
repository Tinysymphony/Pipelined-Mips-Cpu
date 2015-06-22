`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:04:45 06/22/2015 
// Design Name: 
// Module Name:    stages 
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
module stages(
	input wire clk,

	input wire [4:0] reg_disp_addr,
	output wire [31:0] reg_disp_data,
	
	output reg [31:0] instr_data_ctrl,  // instruction
    output reg rs_rt_equal,
    output reg is_load_exe,
    output reg is_store_exe,
    output reg [4:0] regw_addr_exe,
    output reg wb_wen_exe,
    output reg is_load_mem,
    output reg is_store_mem,
    output reg is_jump_exe,
	output reg is_branch_exe,
	output reg is_jump_mem,
	output reg is_branch_mem,
    output reg [4:0] addr_rt_mem,
    output reg [4:0] regw_addr_mem,
    output reg wb_wen_mem,
    output reg [4:0] regw_addr_wb,
    output reg wb_wen_wb,

    input wire [1:0] pc_src_ctrl,
	input wire imm_ext_ctrl,  // whether using sign extended to immediate data
	input wire exe_a_src_ctrl,
	input wire [1:0] exe_b_src_ctrl,  // data source of operand B for ALU

	input wire [4:0] exe_alu_oper_ctrl,  // ALU operation type


	input wire mem_ren_ctrl,  // memory read enable signal
	input wire mem_wen_ctrl,  // memory write enable signal
	input wire [1:0] wb_addr_src_ctrl,  // address source to write data back to registers
	input wire wb_data_src_ctrl,  // data source of data being written back to registers
	input wire wb_wen_ctrl,  // register write enable signal
	input wire [2:0] fwd_a_ctrl,
	input wire [2:0] fwd_b_ctrl,
	input wire fwd_m_ctrl,
	input wire is_load_ctrl,
	input wire is_store_ctrl,
	input wire is_branch_ctrl,
	input wire is_jump_ctrl,
	
	// IF signals
	input wire if_rst,  // stage reset signal
	input wire if_en,  // stage enable signal
	output reg if_valid,  // working flag
	output reg instr_ren,  // instruction read enable signal
	output reg [31:0] instr_addr,  // address of instruction needed
	input wire [31:0] instr_data,  // instruction fetched
	// ID signals
	input wire id_rst,
	input wire id_en,
	output reg id_valid,
	// EXE signals
	input wire exe_rst,
	input wire exe_en,
	output reg exe_valid,
	output reg [31:0] instr_data_exe,
	// MEM signals
	input wire mem_rst,
	input wire mem_en,
	output reg mem_valid,
	output wire mem_ren,  // memory read enable signal
	output wire mem_wen,  // memory write enable signal
	output wire [31:0] mem_addr,  // address of memory
	output wire [31:0] mem_dout,  // data writing to memory
	input wire [31:0] mem_din,  // data read from memory
	output reg [31:0] instr_data_mem,
	// WB signals
	input wire wb_rst,
	input wire wb_en,
	output reg [31:0] instr_data_wb,
	output reg wb_valid
    );


	// control signals
	reg [4:0] exe_alu_oper_exe;
	reg mem_ren_exe, mem_ren_mem;
	reg mem_wen_exe, mem_wen_mem;
	reg wb_data_src_exe, wb_data_src_mem;
	
	// IF signals
	wire [31:0] instr_addr_next;
	
	// ID signals
	reg [31:0] instr_addr_id;
	reg [31:0] instr_addr_next_id;
	reg [4:0] regw_addr_id;
	wire [4:0] addr_rs, addr_rt;
	wire [31:0] data_rs, data_rt, data_imm;
	reg AFromEXLW,BFromEXLW;	
	
	// EXE signals
	// reg [31:0] instr_data_exe;
	reg [31:0] instr_addr_exe;
	reg [31:0] instr_addr_next_exe;
	reg [31:0] data_rt_exe;
	wire [31:0] alu_a_exe, alu_b_exe;
	wire [31:0] alu_out_exe;
    reg [31:0] data_rs_fwd, data_rt_fwd;
    reg [4:0] addr_rs_exe, addr_rt_exe;
    reg [31:0] data_rs_exe, data_imm_exe;
    reg [1:0]exe_b_src_exe;
	reg exe_a_src_exe;
	
	// MEM signals
	// reg [31:0] instr_data_mem;
	reg [31:0] instr_addr_mem;
	reg [31:0] data_rt_mem;
	reg [31:0] alu_out_mem;
	reg [31:0] regw_data_mem;

	
	// WB signals
    // reg [31:0] instr_data_wb;
	reg [31:0] regw_data_wb;
    reg [4:0] regw_addr_final;
    reg [31:0] regw_data_final;
    reg wb_wen_final;
	
	`include "mips.vh"
	
	initial begin 
		instr_addr = 32'hFFFFFFFF;
	end


	// IF stage
	assign
		instr_addr_next = instr_addr + 1;
	
	always @(posedge clk) begin
		if (if_rst) begin
			if_valid <= 0;
			instr_ren <= 0;
			instr_addr <= 0;
		end
		else if (if_en) begin
			if_valid <= 1;
			instr_ren <= 1;
			case (pc_src_ctrl)
				PC_NEXT: instr_addr <= instr_addr_next;
				PC_JUMP: instr_addr <= instr_addr_id[31:26] + instr_data_ctrl[25:0];
				PC_BRANCH: instr_addr <= instr_addr_next_id + data_imm[31:0];
				PC_JR:instr_addr <= data_rs_fwd;
			endcase
		end
	end
	
	// ID stage
	always @(posedge clk) begin
		if (id_rst) begin
			id_valid <= 0;
			instr_addr_id <= 0;
			instr_data_ctrl <= 0;
			instr_addr_next_id <= 0;
		end
		else if (id_en) begin
			id_valid <= if_valid;
			instr_addr_id <= instr_addr;
			instr_data_ctrl <= instr_data;
			instr_addr_next_id <= instr_addr_next;
		end
	end
	

   assign
        addr_rs = instr_data_ctrl[25:21],
        addr_rt = instr_data_ctrl[20:16],
        data_imm = imm_ext_ctrl ? (instr_data_ctrl[15] == 1 ? {16'hffff, instr_data_ctrl[15:0]} : {16'h0, instr_data_ctrl[15:0]}) : {16'h0, instr_data_ctrl[15:0]};
	
	always @(*) begin
		regw_addr_id = instr_data_ctrl[15:11];
		case (wb_addr_src_ctrl)
			WB_ADDR_RD: regw_addr_id = instr_data_ctrl[15:11];
			WB_ADDR_RT: regw_addr_id = instr_data_ctrl[20:16];
			WB_ADDR_LINK: regw_addr_id = 5'd31;
		endcase
	end
	
	regFile REGFILE (
		.clk(clk),
		.n1(addr_rs),
		.op1(data_rs),
		.n2(addr_rt),
		.op2(data_rt),
		.n3(reg_disp_addr),
		.op3(reg_disp_data),
		.wreg(wb_wen_wb),
		.writeReg(regw_addr_wb),
		.regData(regw_data_wb)
		);
	
	always @(*) begin 
		data_rs_fwd = data_rs;
		data_rt_fwd = data_rt;
		case (fwd_a_ctrl)
            0: data_rs_fwd = data_rs;
            1: data_rs_fwd = alu_out_exe;
            2: data_rs_fwd = alu_out_mem;
            3: data_rs_fwd = mem_din;
            4: data_rs_fwd = regw_data_wb;
		endcase
        case (fwd_b_ctrl)
            0: data_rt_fwd = data_rt;
            1: data_rt_fwd = alu_out_exe;
            2: data_rt_fwd = alu_out_mem;
            3: data_rt_fwd = mem_din;
            4: data_rt_fwd = regw_data_wb;
        endcase
        rs_rt_equal = (data_rs_fwd == data_rt_fwd);
	end
	
	// EXE stage
	always @(posedge clk) begin
		if (exe_rst) begin
			exe_valid <= 0;
			instr_addr_exe <= 0;
			instr_data_exe <= 0;
			regw_addr_exe <= 0;
			exe_a_src_exe <= 0;
			exe_b_src_exe <= 0;
			addr_rs_exe <= 0;
			addr_rt_exe <= 0;
			data_rs_exe <= 0;
			data_rt_exe <= 0;
			data_imm_exe <= 0;
			exe_alu_oper_exe <= 0;
			mem_ren_exe <= 0;
			mem_wen_exe <= 0;
			wb_data_src_exe <= 0;
			wb_wen_exe <= 0;
			is_load_exe <= 0;
			is_store_exe <= 0;
			is_jump_exe <= 0;
			is_branch_exe <= 0;
			instr_addr_next_exe <= 0;
		end
		else if (exe_en) begin
			exe_valid <= id_valid;
			instr_addr_exe <= instr_addr_id;
			instr_addr_next_exe <= instr_addr_next_id;
			instr_data_exe <= instr_data_ctrl;
			regw_addr_exe <= regw_addr_id;
			exe_a_src_exe <= exe_a_src_ctrl;
			exe_b_src_exe <= exe_b_src_ctrl;
			addr_rs_exe <= addr_rs;
			addr_rt_exe <= addr_rt;
			data_rs_exe <= data_rs_fwd;
			data_rt_exe <= data_rt_fwd;
			data_imm_exe <= data_imm;
			exe_alu_oper_exe <= exe_alu_oper_ctrl;
			mem_ren_exe <= mem_ren_ctrl;
			mem_wen_exe <= mem_wen_ctrl;
			wb_data_src_exe <= wb_data_src_ctrl;
			wb_wen_exe <= wb_wen_ctrl;
			is_load_exe <= is_load_ctrl;
			is_store_exe <= is_store_ctrl;
			is_jump_exe <= is_jump_ctrl;
			is_branch_exe <= is_branch_ctrl;
		end
	end

	assign alu_a_exe = exe_a_src_exe ? instr_addr_next_exe:data_rs_exe;
    assign alu_b_exe = exe_b_src_exe[1] ? 1 :(exe_b_src_exe[0] ? data_imm_exe : data_rt_exe);
		
	alu ALU (
		.sa(instr_data_exe[10:6]),
		.a(alu_a_exe),
		.b(alu_b_exe),
		.oper(exe_alu_oper_exe),
		.result(alu_out_exe)
		);
	
	// MEM stage
	always @(posedge clk) begin
		if (mem_rst) begin
			mem_valid <= 0;
			instr_addr_mem <= 0;
			instr_data_mem <= 0;
			regw_addr_mem <= 0;
			data_rt_mem <= 0;
			alu_out_mem <= 0;
			mem_ren_mem <= 0;
			mem_wen_mem <= 0;
			wb_data_src_mem <= 0;
			wb_wen_mem <= 0;
            is_load_mem <= 0;
            is_store_mem <= 0;
            is_jump_mem <= 0;
			is_branch_mem <= 0;
		end
		else if (mem_en) begin
			mem_valid <= exe_valid;
			instr_addr_mem <= instr_addr_exe;
			instr_data_mem <= instr_data_exe;
			regw_addr_mem <= regw_addr_exe;
			data_rt_mem <= data_rt_exe;
			alu_out_mem <= alu_out_exe;
			mem_ren_mem <= mem_ren_exe;
			mem_wen_mem <= mem_wen_exe;
			wb_data_src_mem <= wb_data_src_exe;
			wb_wen_mem <= wb_wen_exe;
            is_load_mem <= is_load_exe;
            is_store_mem <= is_store_exe;
            is_jump_mem <= is_jump_exe;
			is_branch_mem <= is_branch_exe;
		end
	end

	always @(*) begin
		regw_data_mem = alu_out_mem;
		case (wb_data_src_mem)
			WB_DATA_ALU: regw_data_mem = alu_out_mem;
			WB_DATA_MEM: regw_data_mem = mem_din;
		endcase
	end
	
	assign
		mem_ren = mem_ren_mem,
		mem_wen = mem_wen_mem,
		mem_addr = alu_out_mem,
		mem_dout = fwd_m_ctrl ? regw_data_wb : data_rt_mem;//forwarding

	// WB stage		
    always @(posedge clk) begin
        if (wb_rst) begin
            wb_valid <= 0;
            wb_wen_wb <= 0;
            regw_addr_wb <= 0;
            regw_data_wb <= 0;
            instr_data_wb <= 0;
        end
        else if (wb_en) begin
            wb_valid <= mem_valid;
            wb_wen_wb <= wb_wen_mem;
            regw_addr_wb <= regw_addr_mem;
            regw_data_wb <= regw_data_mem;
            instr_data_wb <= instr_data_mem;
        end
    end

    // always @(*) begin
    //     wb_wen_final = wb_wen_mem & wb_en;
    //     regw_addr_final = regw_addr_mem;
    //     regw_data_final = regw_data_mem;
    // end
	

endmodule
