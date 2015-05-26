`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:30:05 03/21/2015 
// Design Name: 
// Module Name:    cpu 
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
module cpu(
input CCLK, BTN0,BTN1,BTN2,BTN3, 
input [3:0] SW, 
output LCDRS, LCDRW, LCDE, 
output [3:0] LCDDAT, 
output [7:0] LED
    );
	wire [1:0]aluImm;
	wire [3:0]aluBCtrl;
	wire [4:0]whichReg;
	wire [9:0]memAddr;
	wire [3:0]aluCtrl;
	wire [31:0]regData;
	wire [31:0]regOut1,regOut2,regOut3;
	wire [31:0]pc;
	wire [31:0]pcPlus;
	wire [31:0]branchAddr;
	wire [31:0]instr;
	wire [31:0]memData;
	wire [31:0]writeData;
	wire [31:0]aluOut;
	wire [31:0]aluA,aluB;
	wire [31:0]extendOut;
	wire [31:0]signExtendOut;
	wire [31:0]branchData, branchOut;
	wire [31:0]shiftOut;
	wire  BTN0Out, BTN1Out, BTN2Out,BTN3Out;
	wire RST,CLK, REGCHOOSE;
	wire isZero;
	wire  memToReg,writeReg,memWrite,regDst,branch,jal,jump,shift,rsrtEqu,sext,regrt,jr,zero,aluACtrl, beqOrBne;
	//wire shiftExtend;
	wire  clk_refresh;
	wire [31:0]jumpOrNot;
	
	//assign shiftExtend=signExtendOut<<2;
	
	clock clock2 (CCLK, 2000000, clk_refresh);
	
	//pbdebounce button0(CCLK, BTN0, BTN0Out); 	//RESET
	//pbdebounce button1(CCLK, BTN1, BTN1Out);	//CLK
	//pbdebounce button2(CCLK, BTN2, BTN2Out);	//CHOOSE REGISTER
	//pbdebounce button3(CCLK, BTN3, BTN3Out);	//BAKCUP
	
	assign BTN0Out=BTN0;	
	assign BTN1Out=BTN1;
	assign BTN2Out=BTN2;
	assign BTN3Out=BTN3;

	assign RST=BTN0Out;
	assign CLK=BTN1Out;
	assign REGCHOOSE=BTN2Out;
	
	reg [3:0] temp=0;
	
	wire [255:0]strdata;

	assign memAddr=aluOut[9:0];
	
	assign writeData=regOut2;
	
	assign shiftOut = {27'b000000000000000000000000000, instr[10:6]};

	singlePc single(CLK,RST,jumpOrNot,pc);

	singlePcPlus pcplus(pc, pcPlus);	
	
	ipn newip(CCLK,pc[9:0],instr);
	
	zeroExtend ext0(instr[15:0],extendOut);
	
	signExtend ext1(instr[15:0],signExtendOut);

	ram mem(CLK,writeMem,memAddr,writeData,memData);
	
	ctrl mipsctrl(CLK,RST,instr[5:0],instr[31:26],regDst,branch,jal,writeReg,memToReg,writeMem,aluCtrl,aluImm,shfit,rsrtEqu,sext,regrt,aluBCtrl,jump,aluACtrl,beqOrBne);

	regFile regfile(CLK,RST,writeReg,instr[25:21],instr[20:16],{REGCHOOSE,SW[3:0]},whichReg,regData,regOut1,regOut2,regOut3);

	alu a1(aluA,aluB,aluCtrl,aluImm,zero,aluOut);
	
	add32 add1(pcPlus, signExtendOut, branchData);

	//make a choice
	mux32
		m0(aluOut,memData,regData,memToReg),
		m1(regOut1, regOut2, aluA, aluACtrl),
		m2(instr[20:16],instr[15:11],whichReg,regDst),
		m3(pcPlus,branchData, branchOut,isZero),
		m4(branchOut,{pcPlus[31:26],instr[25:0]},jumpOrNot,jump);
	
	mux4
		m5(regOut2, extendOut, signExtendOut, shiftOut, aluB, aluBCtrl);
	
	wire tmpAnd;
	and and0(tmpAnd,branch,zero);
	xor xor0(isZero, beqOrBne, tmpAnd);
	
	
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
	assign strdata[255:232]="PC:";
	assign strdata[199:192]="-";
	assign strdata[127:64]="Register";
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
	itoa pcount3(CCLK, pc[15:12], strdata[231:224]);
	itoa pcount2(CCLK, pc[11:8], strdata[223:216]);
	itoa pcount1(CCLK, pc[7:4], strdata[215:208]);
	itoa pcount0(CCLK, pc[3:0], strdata[207:200]);
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
