`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2019 04:15:10 PM
// Design Name: 
// Module Name: display
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


module display(
 input [3:0] dig1, 
 input [3:0] dig2, 
 input [3:0] dig3, 
 input [3:0] dig4,
 input Clock,
 input Reset,
 output [3:0] AN,
 output [6:0] CA
 );

wire clk_en;
reg [3:0] X;
wire [1:0] Sel;

clk_enable Clk_enable(
 .clk(Clock) ,
 .reset(Rest),
 .clk_en(clk_en)
);

anode_driver Driver(
 .reset(Reset),
 .clk_en(clk_en),
 .clk(Clock),
 .AN(AN),
 .S(Sel)
);

 always @(dig1 or dig2 or dig3 or dig4 or Sel)
 case (Sel)
 2'b00: X = dig1;
 2'b01: X = dig2;
 2'b10: X = dig3;
 2'b11: X = dig4;
 default: X = 4'b0000;
 endcase
 
 //assign AN = an;
 
 hex2sevseg hts(
 .x(X),
 .ca(CA)
 );
 
endmodule
