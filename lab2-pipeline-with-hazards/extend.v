`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:21:14 03/21/2015 
// Design Name: 
// Module Name:    extend 
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
module zeroExtend(
input[15:0]dataIn,
output[31:0]dataOut
    );
assign dataOut={16'h0000,dataIn};
endmodule
