`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:12:14 03/20/2015 
// Design Name: 
// Module Name:    pbdebounce 
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
module pbdebounce(input clk, input button, output reg pbreg); 

reg [3:0] pbshift;
	
always@(posedge clk)
	begin
		pbshift=pbshift<<1;
		pbshift[0]=button;
	if (pbshift==0)
		pbreg=0;
	if (pbshift==15)
		pbreg=1;			
	end

endmodule



