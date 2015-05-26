`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:41:56 04/25/2015 
// Design Name: 
// Module Name:    aluC 
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
module aluC(aluop, code, aluc);
	input [4:0]aluop;
	input [5:0]code;
	output reg[3:0]aluc;
	
	always@*begin
		if(aluop[4]==1)aluc<=4'b0110;//_
		if(aluop[3]==1)aluc<=4'b0001;//ori
		if(aluop[2]==1)aluc<=4'b0000;//andi
		if(aluop[1]==1)aluc<=4'b0010;//addi
		if(aluop[0])begin
		case(code)
			6'b100000:aluc<=4'b0010;//+
			6'b100010:aluc<=4'b0110;//_
			6'b100100:aluc<=4'b0000;//&
			6'b100101:aluc<=4'b0001;//|
			6'b101010:aluc<=4'b0111;//compare
			6'b000000:aluc<=4'b0011;//<<
			6'b000010:aluc<=4'b0100;//>>
			6'b000011:aluc<=4'b0101;//>>>
			6'b100111:aluc<=4'b1000;//nor
			default :aluc<=4'b0010;
		endcase

		end
		if(aluop==0)aluc<=4'b0010;

	end
endmodule


