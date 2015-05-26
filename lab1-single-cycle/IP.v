`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:17:58 03/21/2015 
// Design Name: 
// Module Name:    IP 
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
module IP(
input clk,
input[31:0]pc,
output reg [31:0]iout
    );
	 
	 (* bram_map="yes" *)
	 reg [31:0] Instr[1023:0];
	 
	 initial begin
		$readmemh("./IP.coe",Instr);
	 end
	 
	 always @(posedge clk) begin
			iout<=Instr[pc];
	 end

endmodule
