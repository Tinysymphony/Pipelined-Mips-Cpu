`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:22:14 03/20/2015 
// Design Name: 
// Module Name:    clock 
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
module clock(input CCLK, input [31:0] clkscale, output reg clk);
									// CCLK crystal clock oscillator 50 MHz
reg [31:0] clkq = 0;			// clock register, initial value of 0
	
always@(posedge CCLK)
	begin
		clkq=clkq+1;			// increment clock register
			if (clkq>=clkscale)  	// clock scaling
				begin
					clk=~clk;	// output clock
					clkq=0;		// reset clock register
				end
	 end

endmodule
