`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:42:41 04/07/2015 
// Design Name: 
// Module Name:    mux3 
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
module mux4(
input [31:0]a,
input [31:0]b,
input [31:0]c,
input [31:0]d,
output [31:0]e,
input [3:0]choose
    );
assign e=(choose[0]==1)? a :(choose[1]==1)? b:(choose[3]==1)? d:c ;
endmodule
