`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:45:05 04/20/2015 
// Design Name: 
// Module Name:    top 
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
module top(
input CCLK, BTN0,BTN1,BTN2,BTN3, 
input [3:0] SW, 
output LCDRS, LCDRW, LCDE, 
output [3:0] LCDDAT, 
output [7:0] LED
);
	wire instr_ren;
	wire [31:0]instr_addr;
	wire [31:0]instr_data;

	wire mem_ren;
	wire mem_wen;
	wire [31:0] mem_addr;  
	wire [31:0] mem_write_in;  
	wire [31:0] mem_read_out;

	wire [31:0] instr_data_ctrl, instr_data_exe, instr_data_mem, instr_data_wb;
	wire imm_ext_ctrl;
	wire [1:0] exe_b_src_ctrl;
	wire exe_a_src_ctrl;
	wire [4:0] exe_alu_oper_ctrl;
	wire mem_ren_ctrl;
	wire mem_wen_ctrl;
	wire [1:0] wb_addr_src_ctrl;
	wire wb_data_src_ctrl;
	wire wb_wen_ctrl;
	wire [1:0] pc_src_ctrl; 
	wire if_rst, if_en, if_valid;
	wire id_rst, id_en, id_valid;
	wire exe_rst, exe_en, exe_valid;
	wire mem_rst, mem_en, mem_valid;
	wire wb_rst, wb_en, wb_valid;
	wire [2:0] fwd_a, fwd_b;
	wire fwd_m;
	wire is_load_ctrl, is_load_exe;
	wire is_store_ctrl, is_store_exe, is_store_mem;
	wire rs_rt_equal;
	wire wb_wen_exe, wb_wen_mem, wb_wen_wb;
	wire [4:0] addr_rt_mem, regw_addr_exe, regw_addr_mem, regw_addr_wb;
	
	wire [4:0] reg_disp_addr;
	wire [31:0] reg_disp_data;

	wire [1:0] pc_src_exe, pc_src_id;

	//for disp
	reg [7:0] clock_count;
	wire [7:0]op_type_id, op_type_if, op_type_exe, op_type_mem, op_type_wb;
	
	wire is_branch_exe, is_jump_exe, is_branch_ctrl, is_jump_ctrl, is_branch_mem, is_jump_mem;

	wire BTN0Out,BTN1Out,BTN2Out,BTN3Out,RST,CLK,REGCHOOSE;
	//anti_jitter button0(CCLK, BTN0, BTN0Out); 	//RESET
	//anti_jitter button1(CCLK, BTN1, BTN1Out);	//CLK
	//anti_jitter button2(CCLK, BTN2, BTN2Out);	//CHOOSE REGISTER
	//anti_jitter button3(CCLK, BTN3, BTN3Out);	//BAKCUP
	
	assign BTN0Out=BTN0;
	assign BTN1Out=BTN1;
	assign BTN2Out=BTN2;
	assign BTN3Out=BTN3;
	
	assign RST=BTN0Out;
	assign CLK=BTN1Out;
	assign REGCHOOSE=BTN2Out;
	
	assign reg_disp_addr = {REGCHOOSE, SW[3:0]};

	initial begin 
		clock_count=0;
	end

	always @(posedge CLK or posedge RST) begin
		if(RST) begin
			clock_count=0;
		end
		else begin
			clock_count=clock_count+1;
		end
	end
	
	IP ip(
		.clka(~CLK), 
		.addra(instr_addr[9:0]),
		.douta(instr_data)
	);

	DATA data(
		.clka(~CLK),
		.addra(mem_addr[9:0]),
		.wea(mem_wen),
		.dina(mem_write_in),
		.douta(mem_read_out)
	);

	stages STAGES (
		.clk(CLK),

		.reg_disp_addr(reg_disp_addr),
		.reg_disp_data(reg_disp_data),

		.instr_data_ctrl(instr_data_ctrl),
		.rs_rt_equal(rs_rt_equal),
		.is_load_exe(is_load_exe),
		.is_store_exe(is_store_exe),
		.regw_addr_exe(regw_addr_exe),
		.wb_wen_exe(wb_wen_exe),
		.is_load_mem(is_load_mem),
		.is_store_mem(is_store_mem),
		.is_jump_exe(is_jump_exe),
		.is_branch_exe(is_branch_exe),
		.is_jump_mem(is_jump_mem),
		.is_branch_mem(is_branch_mem),
		.addr_rt_mem(addr_rt_mem),
		.regw_addr_mem(regw_addr_mem),
		.wb_wen_mem(wb_wen_mem),
		.regw_addr_wb(regw_addr_wb),
		.wb_wen_wb(wb_wen_wb),

		.pc_src_ctrl(pc_src_ctrl),
		.imm_ext_ctrl(imm_ext_ctrl),
		.exe_a_src_ctrl(exe_a_src_ctrl),
		.exe_b_src_ctrl(exe_b_src_ctrl),
		.exe_alu_oper_ctrl(exe_alu_oper_ctrl),
		.mem_ren_ctrl(mem_ren_ctrl),
		.mem_wen_ctrl(mem_wen_ctrl),
		.wb_addr_src_ctrl(wb_addr_src_ctrl),
		.wb_data_src_ctrl(wb_data_src_ctrl),
		.wb_wen_ctrl(wb_wen_ctrl),
		.fwd_a_ctrl(fwd_a),
		.fwd_b_ctrl(fwd_b),
		.fwd_m_ctrl(fwd_m),
		.is_load_ctrl(is_load_ctrl),
		.is_store_ctrl(is_store_ctrl),
		.is_branch_ctrl(is_branch_ctrl),
		.is_jump_ctrl(is_jump_ctrl),

		// IF signals
		.if_rst(if_rst),
		.if_en(if_en),
		.if_valid(if_valid),
		.instr_ren(instr_ren),
		.instr_addr(instr_addr),
		.instr_data(instr_data),
		// ID signals
		.id_rst(id_rst),
		.id_en(id_en),
		.id_valid(id_valid),
		.pc_src_id(pc_src_id),
		// EXE signals
		.exe_rst(exe_rst),
		.exe_en(exe_en),
		.exe_valid(exe_valid),
		.instr_data_exe(instr_data_exe),
		.pc_src_exe(pc_src_exe),
		// MEM signals
		.mem_rst(mem_rst),
		.mem_en(mem_en),
		.mem_valid(mem_valid),
		.mem_ren(mem_ren),
		.mem_wen(mem_wen),
		.mem_addr(mem_addr),
		.mem_dout(mem_write_in),
		.mem_din(mem_read_out),
		.instr_data_mem(instr_data_mem),
		// WB signals
		.wb_rst(wb_rst),
		.wb_en(wb_en),
		.wb_valid(wb_valid),
		.instr_data_wb(instr_data_wb)
	);

	pipeController CONTROLLER (
		.clk(CLK),
		.rst(RST),
		// `ifdef DEBUG
		// .debug_en(debug_en),
		// .debug_step(debug_step),
		// `endif
		// instruction decode
		.pc_src_exe(pc_src_exe),
		.pc_src_id(pc_src_id),
		.instr(instr_data_ctrl),
		.rs_rt_equal(rs_rt_equal),
		.is_load_exe(is_load_exe),
		.is_store_exe(is_store_exe),
		.is_jump_exe(is_jump_exe),
		.is_branch_exe(is_branch_exe),
		.is_jump_mem(is_jump_mem),
		.is_branch_mem(is_branch_mem),
		.regw_addr_exe(regw_addr_exe),
		.wb_wen_exe(wb_wen_exe),
		.is_load_mem(is_load_mem),
		.is_store_mem(is_store_mem),
		.addr_rt_mem(addr_rt_mem),
		.regw_addr_mem(regw_addr_mem),
		.wb_wen_mem(wb_wen_mem),
		.regw_addr_wb(regw_addr_wb),
		.wb_wen_wb(wb_wen_wb),

		.imm_ext(imm_ext_ctrl),
		.exe_b_src(exe_b_src_ctrl),
		.exe_a_src(exe_a_src_ctrl),
		.exe_alu_oper(exe_alu_oper_ctrl),
		.mem_ren(mem_ren_ctrl),
		.mem_wen(mem_wen_ctrl),
		.wb_addr_src(wb_addr_src_ctrl),
		.wb_data_src(wb_data_src_ctrl),
		.wb_wen(wb_wen_ctrl),
		.pc_src(pc_src_ctrl),
		.unrecognized(),

		.is_load(is_load_ctrl),
		.is_store(is_store_ctrl),
		.is_branch(is_branch_ctrl),
		.is_jump(is_jump_ctrl),
		.fwd_a(fwd_a),
		.fwd_b(fwd_b),
		.fwd_m(fwd_m),

		.if_rst(if_rst),
		.if_en(if_en),
		.if_valid(if_valid),

		.id_rst(id_rst),
		.id_en(id_en),
		.id_valid(id_valid),

		.exe_rst(exe_rst),
		.exe_en(exe_en),
		.exe_valid(exe_valid),

		.mem_rst(mem_rst),
		.mem_en(mem_en),
		.mem_valid(mem_valid),

		.wb_rst(wb_rst),
		.wb_en(wb_en),
		.wb_valid(wb_valid)
	);
	
	instrType ifType(instr_data, op_type_if);
	instrType idType(instr_data_ctrl, op_type_id);
	instrType exeType(instr_data_exe, op_type_exe);
	instrType memType(instr_data_mem, op_type_mem);
	instrType wbType(instr_data_wb, op_type_wb);


	//refresh the screen
	wire clk_refresh;
	clock clock2 (CCLK, 2000000, clk_refresh);	
	
	wire [3:0]temp=0;
	//display
	assign LED[0] = SW[0];
	assign LED[1] = SW[1];
	assign LED[2] = SW[2];
	assign LED[3] = SW[3];
	assign LED[4] = temp[0];
	assign LED[5] = temp[1];
	assign LED[6] = temp[2];
	assign LED[7] = temp[3];
	
	wire [3:0] lcdd;
	wire rslcd, rwlcd, elcd;

	assign LCDDAT[3]=lcdd[3];
	assign LCDDAT[2]=lcdd[2];
	assign LCDDAT[1]=lcdd[1];
	assign LCDDAT[0]=lcdd[0];

	assign LCDRS=rslcd;
	assign LCDRW=rwlcd;
	assign LCDE=elcd;

	wire [255:0]strdata;

	//instruction of IF stage
	itoa instruction7(CCLK, instr_data[31:28], strdata[255:248]);
	itoa instruction6(CCLK, instr_data[27:24], strdata[247:240]);
	itoa instruction5(CCLK, instr_data[23:20], strdata[239:232]);
	itoa instruction4(CCLK, instr_data[19:16], strdata[231:224]);
	itoa instruction3(CCLK, instr_data[15:12], strdata[223:216]);
	itoa instruction2(CCLK, instr_data[11:8], strdata[215:208]);
	itoa instruction1(CCLK, instr_data[7:4], strdata[207:200]);
	itoa instruction0(CCLK, instr_data[3:0], strdata[199:192]);

	//space
	assign strdata[191:184]=" ";
	
	//clock count
	itoa count1(CCLK, clock_count[7:4], strdata[183:176]);
	itoa count2(CCLK, clock_count[3:0], strdata[175:168]);

	//space
	assign strdata[167:160]=" ";

	//register content
	wire [15:0] reg_show;
	assign reg_show = REGCHOOSE ? reg_disp_data[31:16] : reg_disp_data[15:0];
	itoa register3(CCLK, reg_show[15:12], strdata[159:152]);
	itoa register2(CCLK, reg_show[11:8], strdata[151:144]);
	itoa register1(CCLK, reg_show[7:4], strdata[143:136]);
	itoa register0(CCLK, reg_show[3:0], strdata[135:128]);

	//operation type of IF stage
	assign strdata[127:120]="F";
	itoa op_if1(CCLK, op_type_if[7:4], strdata[119:112]);
	itoa op_if0(CCLK, op_type_if[3:0], strdata[111:104]);

	//operation type of ID stage
	assign strdata[103:96]="D";
	itoa op_id1(CCLK, op_type_id[7:4], strdata[95:88]);
	itoa op_id0(CCLK, op_type_id[3:0], strdata[87:80]);
	
	//operation type of EXE stage
	assign strdata[79:72]="E";
	itoa op_exe1(CCLK, op_type_exe[7:4], strdata[71:64]);
	itoa op_exe0(CCLK, op_type_exe[3:0], strdata[63:56]);
	
	//operation type of MEM stage
	assign strdata[55:48]="M";
	itoa op_mem1(CCLK, op_type_mem[7:4], strdata[47:40]);
	itoa op_mem0(CCLK, op_type_mem[3:0], strdata[39:32]);
	
	//operation type of WB stage
	assign strdata[31:24]="W";
	itoa op_wb1(CCLK, op_type_wb[7:4], strdata[23:16]);
	itoa op_wb0(CCLK, op_type_wb[3:0], strdata[15:8]);
	
	//Placeholder
	assign strdata[7:0]="+";

	display SHOW(CCLK, clk_refresh, strdata, rslcd, rwlcd, elcd, lcdd);
	
endmodule