`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2019 10:02:38 PM
// Design Name: 
// Module Name: BoothMult
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


module BoothMult(
    input [3:0] a,[3:0] b,
    output [7:0] p
    );
    
    reg [15:0]ps;
    reg [7:0] A;
    reg [6:0] B;

    integer i; reg [10:0]add; reg[3:0]A1;   reg [3:0]zeros = 4'b0000;
    reg [15:0]add2;
   always @(a or b) begin
      A = a;    B = b<<1;   A1 = -A;    ps = 0;
   for (i = 0; i<3; i=i+1) begin

    case (B[2:0])
    3'b000: assign add = 0;
    3'b001: assign add = A;
    3'b010: assign add = A;
    3'b011: assign add = A<<<1;
    3'b100: assign add = -(A<<<1);
    3'b101:assign add = A1;
    3'b110:assign add = A1;
    3'b111: assign add = 0;
    default : begin end
    endcase
   
    add2 = (add<<<(2*i));
    ps = ps + add2; 
    B = B >> 2;
    end
    end
    assign p = ps[7:0];
endmodule
