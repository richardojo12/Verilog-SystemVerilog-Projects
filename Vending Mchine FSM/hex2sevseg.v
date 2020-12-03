`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2019 02:24:33 PM
// Design Name: 
// Module Name: hex2sevseg
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


module hex2sevseg(
    input [3:0] x,
    output reg [6:0] ca
    );
   
   always @*
case (x)
4'b0000 :      	//Hexadecimal 0
ca = 7'b0000001;
4'b0001 :    	//Hexadecimal 1
ca = 7'b1001111  ;
4'b0010 :  		// Hexadecimal 2
ca = 7'b0010010 ; 
4'b0011 : 		// Hexadecimal 3
ca = 7'b0000110 ;
4'b0100 :		// Hexadecimal 4
ca = 7'b1001100 ;
4'b0101 :		// Hexadecimal 5
ca = 7'b0100100 ;  
4'b0110 :		// Hexadecimal 6
ca = 7'b0100000 ;
4'b0111 :		// Hexadecimal 7
ca = 7'b0001111 ;
4'b1000 :     	//Hexadecimal 8
ca = 7'b0000000 ;
4'b1001 :    	//Hexadecimal 9
ca = 7'b0000100 ;
4'b1010 :  		// Hexadecimal A
ca = 7'b0001000 ; 
4'b1011 : 		// Hexadecimal B
ca = 7'b1100000 ;
4'b1100 :		// Hexadecimal C
ca = 7'b0110001 ;
4'b1101 :		// Hexadecimal D
ca = 7'b1000010 ;
4'b1110 :		// Hexadecimal E
ca = 7'b0110000 ;
4'b1111 :		// Hexadecimal F
ca = 7'b0111000 ;
endcase 
    
endmodule
