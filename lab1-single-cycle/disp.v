`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:07:03 03/26/2015 
// Design Name: 
// Module Name:    disp 
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
module display(input CCLK, reset,input [255:0]strdata, output rslcd, rwlcd, elcd, 
					output [3:0] lcdd);
wire [7:0] lcddatin;
					
lcd M0 (CCLK, resetlcd, clearlcd, homelcd, datalcd, addrlcd,
			lcdreset, lcdclear, lcdhome, lcddata, lcdaddr,
			rslcd, rwlcd, elcd, lcdd, lcddatin, initlcd);
			
genlcd M1 (CCLK, reset, strdata, resetlcd, clearlcd, homelcd, datalcd,
				addrlcd, initlcd, lcdreset, lcdclear, lcdhome,
				lcddata, lcdaddr, lcddatin);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        				
endmodule


module genlcd(input CCLK, debpb0, input [255:0]strdata, output reg resetlcd,
					output reg clearlcd, output reg homelcd,
					output reg datalcd, output reg addrlcd,
					output reg initlcd, input lcdreset, lcdclear,
					input lcdhome, lcddata, lcdaddr,
					output reg [7:0] lcddatin);
					
reg [3:0] gstate;		// state register

integer i;
	
always@(posedge CCLK)
	begin
		if (debpb0==1)
			begin
				resetlcd=0;
				clearlcd=0;
				homelcd=0;
				datalcd=0;
				gstate=0;
			end
		else
		
		case (gstate)
			0: begin
					initlcd=1;
					gstate=1;
				end
			1:	begin
					initlcd=0;
					gstate=2;
				end
			2:	begin
					resetlcd=1;
					if (lcdreset==1)
						begin
						   resetlcd=0;
							gstate=3;
						end
				end
			3: begin
					initlcd=1;
					gstate=4;
				end
			4:	begin
					initlcd=0;
					gstate=5;
				end
			5: begin
					clearlcd=1;
					if (lcdclear==1)
						begin
							clearlcd=0;
							gstate=6;
						end
				end
			6: begin
					initlcd=1;
					gstate=7;
				end
			7:	begin
					initlcd=0;
					i=255;
					gstate=8;
				end
			8: begin  
					if(i>127)
						lcddatin[7:0]=8'b0000_0000;
					else
						lcddatin[7:0]=8'b0100_0000;
						
					addrlcd=1;
					if (lcdaddr==1)
						begin
							addrlcd=0;
							gstate=9;
						end
				end
			9:	begin
					initlcd=1;
					gstate=10;
				end
			10: begin
					initlcd=0;
					gstate=11;
				end
			11: begin
					lcddatin[7:0]=strdata[i-:8];
					datalcd=1;
					if (lcddata==1)
						begin
							datalcd=0;
							gstate=12;
						end
				end
			12: begin
					initlcd=1;
					gstate=13;
				end
			13: begin
					initlcd=0;
					gstate=14;
				end
			14: begin
					i=i-8;
					if (i<0)
						gstate=15;
					else if (i==127)
						gstate=8;
					else
						gstate=11;
				end
			15: gstate=15;
			default: gstate=15;
		endcase

	end

endmodule
