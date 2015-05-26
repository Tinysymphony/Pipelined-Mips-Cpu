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
	
	//anti_jitter & inp	ut signals
	wire BTN0Out,BTN1Out,BTN2Out,BTN3Out,RST,CLK,REGCHOOSE;
	//anti_jitter button0(CCLK, BTN0, BTN0Out); 	//RESET
	//anti_jitter button1(CCLK, BTN1, BTN1Out);	//CLK
	///anti_jitter button2(CCLK, BTN2, BTN2Out);	//CHOOSE REGISTER
	//anti_jitter button3(CCLK, BTN3, BTN3Out);	//BAKCUP
	
	assign BTN0Out=BTN0;
	assign BTN1Out=BTN1;
	assign BTN2Out=BTN2;
	assign BTN3Out=BTN3;
	
	wire[2:0]ctrl_4out;
	
	assign RST=BTN0Out;
	assign CLK=BTN1Out;
	assign REGCHOOSE=BTN2Out;
	
	//wire [3:0]temp;
	
	wire [31:0]instr,memDataOut;
	
	//IF_ID -----1Start------ IF_ID//
	wire [31:0]instr_1in,instr_1out;
	wire [31:0]pc_1in,pc_1out;
	wire [31:0]pc_in,pc_out;
	
	assign instr_1in=instr;
	
	singlePc single0(CLK,RST,pc_in,pc_out);
	
	singlePcPlus pcplus0(pc_out,pc_1in);
	
	IF_ID if_stage(
		.clk(CLK),
		.rst(RST),
		.instr_in(instr_1in),
		.instr_out(instr_1out),
		.pc_in(pc_1in),
		.pc_out(pc_1out)
	);
	//IF_ID -----1End------ IF_ID//
	
	
	//ID_EX -----2Start------ ID_EX//
	//regFile
	wire [4:0]reg1,reg2,reg3,regAddr;
	wire writeReg;
	wire [31:0]regOut1,regOut2,regOut3,writeRegData;
	assign reg1=instr_1out[25:21];
	assign reg2=instr_1out[20:16];
	assign reg3={REGCHOOSE,SW[3:0]};
	
	assign writeReg=ctrl_4out[2];
	
	regFile regfile0(
		.clk(CLK),
		.rst(RST),
		.wreg(writeReg),
		.n1(reg1),.n2(reg2),.n3(reg3),
		.writeReg(regAddr),
		.regData(writeRegData),
		.op1(regOut1),.op2(regOut2),.op3(regOut3)
	);

	wire [31:0]sign_ext_2in,sign_ext_2out,zero_ext_2in,zero_ext_2out,opa_2in,opa_2out,opb_2in,opb_2out;
	wire [14:0]ctrl_2in,ctrl_2out;
	wire [31:0]pc_2out,instr_2out;
	wire [4:0]shift_2out,rs_2out,rt_2out,rd_2out;
	
	assign opa_2in=regOut1;
	assign opb_2in=regOut2;
	
	zeroExtend zero0(instr_1out[15:0],zero_ext_2in);

	signExtend sign0(instr_1out[15:0],sign_ext_2in);

	pipeController ctrl0(instr_1out[31:26],ctrl_2in);

	ID_EX id_stage(
		.clk(CLK),
		.rst(RST),
		.pc_in(pc_1out),
		.pc_out(pc_2out),
		.sign_ext_in(sign_ext_2in),
		.sign_ext_out(sign_ext_2out),
		.zero_ext_in(zero_ext_2in),
		.zero_ext_out(zero_ext_2out),
		.opa_in(opa_2in),
		.opa_out(opa_2out),
		.opb_in(opb_2in),
		.opb_out(opb_2out),
		.ctrl_in(ctrl_2in),
		.ctrl_out(ctrl_2out),
		.instr_in(instr_1out),
		.instr_out(instr_2out),
		.rs_out(rs_2out),
		.rt_out(rt_2out),
		.rd_out(rd_2out),
		.shift_out(shift_2out)
	);
	//ID_EX -----2End------ ID_EX//
	
	
	//EX_MEM -----3Start------ EX_MEM//
	//alu
	wire [31:0]aluA,aluB,aluOut;
	wire [3:0]aluCtrl;
	wire [4:0]sa;
	wire zero;
	assign sa=shift_2out;
	assign aluA=opa_2out;

	mux32_2 alub0(opb_2out,sign_ext_2out,zero_ext_2out,ctrl_2out[1],ctrl_2out[8],aluB);

	aluC alc0(ctrl_2out[13:9],instr_2out[5:0],aluCtrl);
	
	alu a0(
		.opa(aluA),
		.opb(aluB),
		.alu_ctrl(aluCtrl),
		.sa(sa),
		.zero(zero),
		.alu_out(aluOut)
	);

	wire [31:0]jmp_pc,opb_3out,alu_3out,pc_3out,im_pc_3out,jmp_pc_3out;
	wire [7:0]ctrl_3out;
	wire [4:0]rd_3out,rt_3out;
	wire [31:0]im_pc;
	wire zero_3out;
	assign im_pc=sign_ext_2out+pc_2out;
	assign jmp_pc={pc_2out[31:26],instr_2out[25:0]};
	
	EX_MEM ex_stage(
		.clk(CLK),
		.rst(RST),
		.pc_in(pc_2out),
		.pc_out(pc_3out),
		.zero_in(zero),
		.zero_out(zero_3out),
		.alu_res_in(aluOut),
		.alu_res_out(alu_3out),
		.opb_in(opb_2out),
		.opb_out(opb_3out),
		.rt_in(rt_2out),
		.rt_out(rt_3out),
		.rd_in(rd_2out),
		.rd_out(rd_3out),
		.im_pc_in(im_pc),
		.im_pc_out(im_pc_3out),
		.jmp_pc_in(jmp_pc),
		.jmp_pc_out(jmp_pc_3out),
		.ctrl_in(ctrl_2out),
		.ctrl_out(ctrl_3out)
	);
	//EX_MEM -----3End------ EX_MEM//

	
	//MEM_WB -----4Start------ MEM_WB//	

	wire[31:0]alu_4out,memdata_4in,memdata_4out;
	wire[4:0]rt_4out,rd_4out;
	assign memdata_4in=memDataOut;
	MEM_WB mem_stage(
		.clk(CLK),
		.rst(RST),
		.rt_in(rt_3out),
		.rt_out(rt_4out),
		.rd_in(rd_3out),
		.rd_out(rd_4out),
		.ctrl_in(ctrl_3out),
		.ctrl_out(ctrl_4out),
		.alu_res_in(alu_3out),
		.alu_res_out(alu_4out),
		.memdata_in(memdata_4in),
		.memdata_out(memdata_4out)
	);
	//MEM_WB -----4End------ MEM_WB//
	
	
	mux5 regaddr0(rt_4out,rd_4out,regAddr,ctrl_4out[0]);
	
	wire [31:0]tmpPc;
	wire jumpSignal,branchSignal,bne,beq;
	assign jumpSignal=ctrl_3out[6];
	assign bne=ctrl_3out[5]&&~zero_3out;
	assign beq=ctrl_3out[4]&&zero_3out;
	assign branchSignal=beq|bne;
	mux32 
		regdata0(alu_4out,memdata_4out,writeRegData,ctrl_4out[1]),
		branch0(pc_1in,im_pc_3out,tmpPc,branchSignal),
		jump0(tmpPc,jmp_pc_3out,pc_in,jumpSignal);
	
	//instr_rom
	wire [31:0]instrAddr;
	//wire [31:0]instr;
	assign instrAddr=pc_out;
	IP ip0(
		.clka(CLK),  //CHANGED
		.addra(instrAddr[9:0]),
		.douta(instr)
	);
	
	//data_ram
	wire memWrite;
	wire [31:0]memAddr,memDataIn;
	assign memDataIn=alu_3out;
	assign memWrite=ctrl_3out[3];
	assign memAddr=opb_3out;
	DATA data0(
		.clka(CLK),
		.addra(memAddr[9:0]),
		.wea(memWrite),
		.dina(memDataIn),
		.douta(memDataOut)
	);


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

	//wire [255:0]strdata = "PC:0000-00000000Register00000000";
	wire [255:0]strdata;
	assign strdata[255:240]="FD";
	
	itoa instruction00(CCLK, pc_1in[7:4], strdata[239:232]);
	itoa instruction01(CCLK, pc_1in[3:0], strdata[231:224]);
	
	assign strdata[223:216]="-";
	
	itoa instruction02(CCLK, pc_1out[7:4], strdata[215:208]);
	itoa instruction03(CCLK, pc_1out[3:0], strdata[207:200]);

	assign strdata[199:192]="-";
	//assign strdata[127:64]="Register";
	
	assign strdata[127:112]="EM";
	
	itoa instruction04(CCLK, pc_2out[7:4], strdata[111:104]);
	itoa instruction05(CCLK, pc_2out[3:0], strdata[103:96]);

	assign strdata[95:88]="-";

	itoa instruction06(CCLK, pc_3out[7:4], strdata[87:80]);
	itoa instruction07(CCLK, pc_3out[3:0], strdata[79:72]);

	
	assign strdata[71:64]="-";
	//INSTRUCTION 191:128
	itoa instruction7(CCLK, instr[31:28], strdata[191:184]);
	itoa instruction6(CCLK, instr[27:24], strdata[183:176]);
	itoa instruction5(CCLK, instr[23:20], strdata[175:168]);
	itoa instruction4(CCLK, instr[19:16], strdata[167:160]);
	itoa instruction3(CCLK, instr[15:12], strdata[159:152]);
	itoa instruction2(CCLK, instr[11:8], strdata[151:144]);
	itoa instruction1(CCLK, instr[7:4], strdata[143:136]);
	itoa instruction0(CCLK, instr[3:0], strdata[135:128]);
	//PC COUNT 231:200
	
	//REGISTER VALUE
	itoa register7(CCLK, regOut3[31:28],strdata[63:56]);
	itoa register6(CCLK, regOut3[27:24],strdata[55:48]);
	itoa register5(CCLK, regOut3[23:20],strdata[47:40]);
	itoa register4(CCLK, regOut3[19:16],strdata[39:32]);
	itoa register3(CCLK, regOut3[15:12],strdata[31:24]);
	itoa register2(CCLK, regOut3[11:8],strdata[23:16]);
	itoa register1(CCLK, regOut3[7:4],strdata[15:8]);
	itoa register0(CCLK, regOut3[3:0],strdata[7:0]);
	//DISPLAY MODULE
	display SHOW(CCLK, clk_refresh, strdata, rslcd, rwlcd, elcd, lcdd);          
	
endmodule
