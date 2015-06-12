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
module IF(
	input wire en,
   input wire clk,
   input wire rst,
   input wire[31:0] ipc,
   output reg[31:0] opc,
	output reg valid
    );

	initial begin opc= 32'hFFFFFFFF; end

	always @(posedge clk) begin
		if(rst) begin
			valid = 0;
			opc = 0;
		end
		else if(en) begin
			opc = ipc;
			valid = 1;
		end
	end

endmodule
