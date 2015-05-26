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
module MEM_WB(
input wire clk,
input wire rst,
input wire[4:0]rt_in,rd_in,
output wire[4:0]rt_out,rd_out,
input wire[2:0]ctrl_in,
output wire[2:0]ctrl_out,
input wire[31:0]alu_res_in,memdata_in,
output wire[31:0]alu_res_out,memdata_out
    );
	reg [4:0]rt,rd;
	reg [2:0]ctrl;
	reg [31:0]alu_res,memdata;
	
	initial begin ctrl=0; alu_res=0; memdata=0; rt=0; rd=0;	end
	
	always @(posedge clk or posedge rst) begin
		if(rst) begin
			rt=0;
			rd=0;
			ctrl=0;
			alu_res=0;
			memdata=0;
		end
		else begin
			ctrl=ctrl_in[2:0];
			rt=rt_in;
			rd=rd_in;
			alu_res=alu_res_in;
			memdata=memdata_in;
		end
	end
	
	assign rt_out=rt;
	assign rd_out=rd;
	assign ctrl_out=ctrl;
	assign alu_res_out=alu_res;
	assign memdata_out=memdata;
endmodule
