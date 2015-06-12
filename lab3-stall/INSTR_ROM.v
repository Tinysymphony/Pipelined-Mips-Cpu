`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:05 06/09/2015 
// Design Name: 
// Module Name:    INSTR_ROM 
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
module INSTR_ROM(
	input wire clk,
	input wire [31:0] addr,
	output reg [31:0] inst
	);
	
	parameter
		ADDR_WIDTH = 6;
	
	reg [31:0] inst_mem [0:(1<<ADDR_WIDTH)-1];
	
	initial	begin
		$readmemh("inst_mem.hex", inst_mem);
	end
	
	always @(negedge clk) begin
		if (addr[31:ADDR_WIDTH] != 0)
			inst <= 32'h0;
		else
			inst <= inst_mem[addr[ADDR_WIDTH-1:0]];
	end


endmodule
