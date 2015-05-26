`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:50:51 03/21/2015 
// Design Name: 
// Module Name:    singlePcPlus 
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
module singlePcPlus(
input wire[31:0] i_pc,
output wire[31:0] o_pc
    );
	 
assign o_pc = i_pc + 1;

endmodule
