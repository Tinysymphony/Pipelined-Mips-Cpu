`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:57:48 03/21/2015 
// Design Name: 
// Module Name:    singlePc 
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
module singlePc(
                 input wire clk,
					  input wire rst,
					  input wire[31:0] iPc,
					  output wire[31:0] oPc
    );
reg[31:0] tPc;

initial tPc = 32'hFFFFFFFF;
assign oPc = rst?32'hFFFFFFFF:tPc;

always @(posedge clk,posedge rst)
if(rst) tPc <= 32'hFFFFFFFF;
else
tPc <= iPc;


endmodule
