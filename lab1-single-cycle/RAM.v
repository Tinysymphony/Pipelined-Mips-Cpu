`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:45:38 03/21/2015 
// Design Name: 
// Module Name:    RAM 
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
module RAM(
input clk,
input we,
input[9:0]addr,
input[31:0]din,
output reg [31:0]dout
    );
	 
	 (* bram_map="yes" *)
	 reg [31:0] RAM_ID[1023:0];
	 
	 initial begin
		$readmemh("./RAM_ID.coe",RAM_ID);
	 end
	 
	 always @(posedge clk) begin
		if (we) begin
			RAM_ID[addr]<=din;
		end
		else
			dout<=RAM_ID[addr];
	 end

endmodule
