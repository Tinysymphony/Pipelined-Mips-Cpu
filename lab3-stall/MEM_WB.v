`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:31:15 04/25/2015 
// Design Name: 
// Module Name:    MEM_WB 
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
module WB(
input wire en,
input wire clk,
input wire rst,
input wire[4:0]rt_in,rd_in,
output reg[4:0]rt_out,rd_out,
input wire[2:0]ctrl_in,
output reg[2:0]ctrl_out,
input wire[31:0]alu_res_in,memdata_in,
output reg[31:0]alu_res_out,memdata_out,
input wire[4:0]regw_addr_in,
output reg[4:0]regw_addr_out,
input wire wb_wen_in,
output reg wb_wen_out,
output reg valid,
input wire valid_in
    );
	initial begin valid=0; ctrl_out=0; alu_res_out=0; memdata_out=0; regw_addr_out=0; wb_wen_out=0;end
	
	always @(posedge clk) begin
		if(rst) begin
			ctrl_out=0;
			alu_res_out=0;
			memdata_out=0;
			regw_addr_out=0;
			wb_wen_out=0;
			valid=0;
		end
		else begin
			valid = en;
			ctrl_out=ctrl_in[2:0];
			alu_res_out=alu_res_in;
			memdata_out=memdata_in;
			regw_addr_out=regw_addr_in;
			wb_wen_out = wb_wen_in & en;
		end
	end

endmodule
