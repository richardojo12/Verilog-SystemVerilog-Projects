`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2019 05:28:03 PM
// Design Name: 
// Module Name: data
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


module data(input [3:0] a, input [3:0] b, input clk, input reset, input en_a, input en_b, 
input ld_shift_a,input ld_shift_b, input en_p, input ld_add_p, input valid,input[1:0] state
,output reg lsb_b, output reg zero, output reg [7:0] product
);

parameter zeros = 8'b00000000;reg [7:0] multiplicand; reg [3:0] multiplier;initial product = 8'b00000000;
always @(posedge clk)  begin 
    if(reset) begin multiplicand = 8'b00000000; multiplier = 4'b0000;product = zeros;lsb_b = multiplier[0]; zero = 1;
    end 
    else   
    if (!reset)begin
    if(state == 2'b00)begin
    multiplicand = {4'b0000,a}; 
    multiplier = b;
    product = zeros;
    end
    //Left shift register for a/multiplicand
    if(en_a) begin
        if(ld_shift_a) multiplicand = multiplicand << 1;
           end 
    //Right shift register for b/multiplier
    if(en_b) begin
        if(ld_shift_b) multiplier = multiplier >> 1;
           end else begin
    end
   
  
    //Product calculations 
      if(!valid && !zero) begin
        if(en_p) begin
            if(ld_add_p) product = product + multiplicand;
                else
            product = product;
              end end end
              
   lsb_b = multiplier[0];
    if(multiplier != 4'b0000) begin
    zero = 0;
   end else begin
    zero = 1;
   end
end
endmodule
