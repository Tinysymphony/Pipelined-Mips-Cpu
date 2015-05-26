`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:38:24 05/12/2015
// Design Name:   top
// Module Name:   D:/3120101996/tinypiple/htiny.v
// Project Name:  tinypiple
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module htiny;

	// Inputs
	reg CCLK;
	reg BTN0;
	reg BTN1;
	reg BTN2;
	reg BTN3;
	reg [3:0] SW;

	// Outputs
	wire LCDRS;
	wire LCDRW;
	wire LCDE;
	wire [3:0] LCDDAT;
	wire [7:0] LED;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.CCLK(CCLK), 
		.BTN0(BTN0), 
		.BTN1(BTN1), 
		.BTN2(BTN2), 
		.BTN3(BTN3), 
		.SW(SW), 
		.LCDRS(LCDRS), 
		.LCDRW(LCDRW), 
		.LCDE(LCDE), 
		.LCDDAT(LCDDAT), 
		.LED(LED)
	);

	initial begin
		// Initialize Inputs
		CCLK = 0;
		BTN0 = 0;
		BTN1 = 0;
		BTN2 = 0;
		BTN3 = 0;
		SW = 0;

		// Wait 100 ns for global reset to finish
		#100;
      
		// Add stimulus here

	end
	
	initial forever begin
		#100;
		BTN1=~BTN1;
	end
      
endmodule

