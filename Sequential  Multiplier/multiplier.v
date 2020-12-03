`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2019 09:54:34 PM
// Design Name: 
// Module Name: multiplier
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


module multiplier(input [3:0] a, input [3:0] b, input clk, input reset, input start, output reg [7:0] prod,output valid
);
 
wire en_a,en_b,ld_shift_a,ld_shift_b, en_p, ld_add_p;
wire lsb_b,zero;
wire [1:0]out_state;
wire [7:0] product; initial prod = 8'b00000000;

    data dataPart(a, b, clk, reset, en_a, en_b, 
    ld_shift_a, ld_shift_b, en_p, ld_add_p,valid,out_state,lsb_b, zero, product);

   controller compt(clk, reset, start, lsb_b,
        zero, en_a, ld_shift_a, en_b, ld_shift_b, en_p, 
        ld_add_p, valid, out_state);
        
        always@(product) prod = product;
       // always@(b) lsb_b = b[0]
endmodule
