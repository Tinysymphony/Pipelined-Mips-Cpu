`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:26:00 03/26/2015 
// Design Name: 
// Module Name:    itoa 
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
module itoa( input wire clk, input wire [3:0] num, output wire [7:0] data);

reg [7:0] r_data;

always @(posedge clk)
begin
    case (num)
        4'b0000:r_data[7:0] <= "0";
        4'b0001:r_data[7:0] <= "1";
        4'b0010:r_data[7:0] <= "2";
        4'b0011:r_data[7:0] <= "3";
        4'b0100:r_data[7:0] <= "4";
        4'b0101:r_data[7:0] <= "5";
        4'b0110:r_data[7:0] <= "6";
        4'b0111:r_data[7:0] <= "7";
        4'b1000:r_data[7:0] <= "8";
        4'b1001:r_data[7:0] <= "9";
        4'b1010:r_data[7:0] <= "A";
        4'b1011:r_data[7:0] <= "B";
        4'b1100:r_data[7:0] <= "C";
        4'b1101:r_data[7:0] <= "D";
        4'b1110:r_data[7:0] <= "E";
        4'b1111:r_data[7:0] <= "F";
        default:r_data[7:0] <= "0";
    endcase
end

assign data = r_data;

endmodule