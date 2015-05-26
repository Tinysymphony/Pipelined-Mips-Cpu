`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:31:15 04/25/2015 
// Design Name: 
// Module Name:    mux32_32
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
module mux32_2(
input wire[31:0]op1, op2,op3, 
input wire Ctrl1,Ctrl2,
output reg[31:0]out
);
	always @* begin
		if(~Ctrl1&&~Ctrl2)
			out=op1;
		if(Ctrl1)
			out=op2;
		if(Ctrl2)
			out=op3;
	end
endmodule