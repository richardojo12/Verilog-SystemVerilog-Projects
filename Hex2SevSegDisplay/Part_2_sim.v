`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2019 02:43:50 PM
// Design Name: 
// Module Name: Part_2_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Part_2_sim();
    reg [3:0] x; //Input
    wire [6:0] ca; //Output
    
    hex2sevseg uut (
		.x(x), 
		.ca(ca)
	);
    
    initial begin
		// Initialize Inputs
		x = 0;
	#20 x = 1;
	#20 x = 2;
	#20 x = 3;	
	#20 x = 4;	
	#20 x = 5;
	#20 x = 6;
	#20 x = 7;	
	#20 x = 8;	
	#20 x = 9;
	#20 x = 10;
	#20 x = 11;	
	#20 x = 12;	
	#20 x = 13;
	#20 x = 14;
	#20 x = 15;	
	#40;
    end  
 
		initial begin
		 $monitor("x=%h,ca=%7b",x,ca);
		 end
    
endmodule
