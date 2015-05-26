`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:17:16 04/25/2015 
// Design Name: 
// Module Name:    ID 
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
module ID_EX(
input wire clk,
input wire rst,
input wire [4:0]rs_in,rd_in,rt_in,shift_in,
input wire [31:0]pc_in,instr_in,sign_ext_in,zero_ext_in,opa_in,opb_in,
input wire [14:0]ctrl_in,
output wire [14:0]ctrl_out,
output wire [4:0]rs_out,rt_out,rd_out,shift_out,
output wire [31:0]pc_out,instr_out,sign_ext_out,zero_ext_out,opa_out,opb_out
    );
	reg [14:0] ctrl;
	reg [4:0] rs,rt,rd,shift;
	reg [31:0] pc,sign_ext,zero_ext,opa,opb,instr;
	
	initial begin ctrl=0; rs=0; rt=0; rd=0; shift=0; pc=32'hFFFFFFFF; opa=0; opb=0; zero_ext=0; sign_ext=0; end
	
	always @(posedge clk or posedge rst)begin
		if(rst)begin
			pc=32'hFFFFFFFF;
			instr=32'hFFFFFFFF;
			ctrl=0;
			sign_ext=0;
			zero_ext=0;
			opa=0;
			opb=0;
			shift=0;
			rt=0;
			rs=0;
			rd=0;
		end
		else begin
			ctrl=ctrl_in;
			instr=instr_in;
			pc=pc_in;
			sign_ext=sign_ext_in;
			zero_ext=zero_ext_in;
			opa=opa_in;
			opb=opb_in;
			shift=instr_in[10:6];
			rt=instr_in[20:16];
			rs=instr_in[25:21];
			rd=instr_in[15:11];

		end
	end
	
	assign	ctrl_out=ctrl;
	assign	instr_out=instr;
	assign	pc_out=pc;
	assign	sign_ext_out=sign_ext;
	assign	zero_ext_out=zero_ext;
	assign	opa_out=opa;
	assign	opb_out=opb;
	assign	shift_out=shift;
	assign	rt_out=rt;
	assign	rs_out=rs;
	assign	rd_out=rd;	

endmodule
