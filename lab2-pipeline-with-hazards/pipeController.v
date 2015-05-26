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
input [5:0]switch, 
output [14:0]out
);
	wire LW,SW,ADDI,ANDI,ORI,BNE,BEQ,J,R;
	
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
endmodule
