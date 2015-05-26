`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:03 03/17/2015 
// Design Name: 
// Module Name:    alu 
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
module alu(
	input [31:0]opa,
	input [31:0]opb,
	input [3:0]alu_ctrl,
	input [1:0]aluImm,
	output zero,
	output reg [31:0]alu_out
    );
	wire [31:0] signOut;
	
	//assign alu_out = (aluImm==0 && alu_ctrl==4'b1000)? opa+opb :
	//								  (aluImm==0 && alu_ctrl==4'b1101)? opa|opb :
	//								  (aluImm==0 && alu_ctrl==4'b1010)? opa-opb :
	//								  (aluImm==0 && alu_ctrl==4'b1100)? opa&opb :
	//								  (aluImm==0 && alu_ctrl==4'b0000)? opa<<opb :
	//								  (aluImm==0 && alu_ctrl==4'b0010)? opa>>opb :
	//								  (aluImm==0 && alu_ctrl==4'b0011)? $signed(opa)>>>opb :
	//								  (aluImm==1 && alu_out==4'b1000)? opa+opb :
	//							     (aluImm==1 && alu_out==2'b01)? opa+opb :
	//								  (aluImm==1 && alu_out==2'b10)? opa&opb : opa|opb;
	
	always @ *
	begin
		if(aluImm==0)begin
			case(alu_ctrl)
				4'b1000:alu_out=opa+opb;
				4'b1101:alu_out=opa|opb;
				4'b1010:alu_out=opa-opb; 
				4'b1100:alu_out=opa&opb;
				//4'b0111:alu_out=(opa<opb?1:0);
				4'b0000:alu_out=opa<<opb;		//sll
				4'b0010:alu_out=opa>>opb;		//srl
				4'b0011:alu_out=$signed(opa)>>>opb;
			endcase
			end
		else begin
			case(aluImm)
				2'b01:alu_out=opa+opb;
				2'b10:alu_out=opa&opb;
				2'b11:alu_out=opa|opb;
			endcase
			end
	end
	
	assign zero=(opa==opb)? 1:0;
	
endmodule

