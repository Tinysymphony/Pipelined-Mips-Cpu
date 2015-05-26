`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:27:46 03/21/2015 
// Design Name: 
// Module Name:    ctrl 
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
module ctrl(
input clk,
input rst,
input [5:0]func,
input [5:0]op,
output regDst,
output branch,
output jal,
output writeReg,
output m2reg,
output wmem,
output [3:0]aluc,
output [1:0]aluImm,
output shift,
input rsrtequ,
output sext,
output regrt,
output [3:0]aluBCtrl,
output jump,
output aluACtrl,
output beqOrBne
    );
wire J,R,LW,SW,BEQ,ADD,SUB,AND,OR,SLL,SRL,SRA,ADDI,ANDI,ORI,BNE;
	 
and 
   and1(J,~op[5],~op[4],~op[3],~op[2],op[1],~op[0]),
	and2(R,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0]),
	and3(LW,op[5],~op[4],~op[3],~op[2],op[1],op[0]),
	and4(SW,op[5],~op[4],op[3],~op[2],op[1],op[0]),
	and5(BEQ,~op[5],~op[4],~op[3],op[2],~op[1],~op[0]),
	and13(ADDI,~op[5],~op[4],op[3],~op[2],~op[1],~op[0]),
	and14(ANDI,~op[5],~op[4],op[3],op[2],~op[1],~op[0]),
	and15(ORI,~op[5],~op[4],op[3],op[2],~op[1],op[0]),
	and16(BNE,~op[5],~op[4],~op[3],op[2],~op[1],op[0]);
and //R-TYPE
	and6(ADD,R,func[5],~func[4],~func[3],~func[2],~func[1],~func[0]),
	and7(SUB,R,func[5],~func[4],~func[3],~func[2],func[1],~func[0]),
	and8(AND,R,func[5],~func[4],~func[3],func[2],~func[1],~func[0]),
	and9(OR,R,func[5],~func[4],~func[3],func[2],~func[1],func[0]),
	and10(SLL,R,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]),
	and11(SRL,R,~func[5],~func[4],~func[3],~func[2],func[1],~func[0]),
	and12(SRA,R,~func[5],~func[4],~func[3],~func[2],func[1],func[0]);
	 
assign m2reg=LW;
assign wmem=SW;
assign branch=BEQ|BNE;

assign aluc={func[5],func[2:0]};

assign regDst=R;

assign aluBCtrl[0] = ADD|SUB|OR|AND|BEQ|BNE;
assign aluBCtrl[1] = ANDI|ORI;
assign aluBCtrl[2] = ADDI|LW|SW;
assign aluBCtrl[3] = SLL|SRL|SRA;

assign writeReg = R|ADDI|ANDI|ORI|LW;
assign m2reg = LW;
assign aluACtrl = SLL|SRL|SRA;
assign jump=J;

assign aluImm[0] = ADDI|ORI|SW|LW;
assign aluImm[1] = ANDI|ORI;

assign beqOrBne = BNE;

endmodule
