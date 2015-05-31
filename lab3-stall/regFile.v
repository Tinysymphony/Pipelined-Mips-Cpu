`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:53:44 03/21/2015 
// Design Name: 
// Module Name:    regFile 
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
module regFile(
input wire clk,
input wire rst,
input wire wreg,
input wire[4:0] n1,n2,n3,
input wire[4:0] writeReg,
input wire[31:0] regData,
output wire[31:0] op1,op2,op3
    );
reg[31:0] mem[31:0];
initial begin
	mem[0] = 0;
	mem[1] = 0;
	mem[2] = 0;
	mem[3] = 0;
	mem[4] = 0;
	mem[5] = 0;
	mem[6] = 0;
	mem[7] = 0;
	mem[8] = 0;
	mem[9] = 0;
	mem[10] = 0;
	mem[11] = 0;
	mem[12] = 0;
	mem[13] = 0;
	mem[14] = 0;
	mem[15] = 0;
	mem[16] = 0;
	mem[17] = 0;
	mem[18] = 0;
	mem[19] = 0;
	mem[20] = 0;
	mem[21] = 0;
	mem[22] = 0;
	mem[23] = 0;
	mem[24] = 0;
	mem[25] = 0;
	mem[26] = 0;
	mem[27] = 0;
	mem[28] = 0;
	mem[29] = 0;
	mem[30] = 0;
	mem[31] = 0;
end

always @(negedge clk,posedge rst)
if (rst) begin
	mem[0] = 0;
	mem[1] = 0;
	mem[2] = 0;
	mem[3] = 0;
	mem[4] = 0;
	mem[5] = 0;
	mem[6] = 0;
	mem[7] = 0;
	mem[8] = 0;
	mem[9] = 0;
	mem[10] = 0;
	mem[11] = 0;
	mem[12] = 0;
	mem[13] = 0;
	mem[14] = 0;
	mem[15] = 0;
	mem[16] = 0;
	mem[17] = 0;
	mem[18] = 0;
	mem[19] = 0;
	mem[20] = 0;
	mem[21] = 0;
	mem[22] = 0;
	mem[23] = 0;
	mem[24] = 0;
	mem[25] = 0;
	mem[26] = 0;
	mem[27] = 0;
	mem[28] = 0;
	mem[29] = 0;
	mem[30] = 0;
	mem[31] = 0;
	end
else if(wreg & writeReg!=0) begin
   mem[writeReg] =regData;
	end
	
assign op1 = mem[n1];
assign op2 = mem[n2];
assign op3 = mem[n3];

endmodule
