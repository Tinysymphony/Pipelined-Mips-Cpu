`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:51:34 03/21/2015 
// Design Name: 
// Module Name:    mux4 
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
module mux4(
input[31:0]opa,opb,opc,opd,
input[1:0]ctrl,
output[31:0]out
    );

assign out=(ctrl==2'b00) ? opa : (ctrl==2'b01) ? opb : (ctrl==2'b10)? opc : opd;

endmodule
