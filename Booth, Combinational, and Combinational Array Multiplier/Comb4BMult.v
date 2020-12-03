`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2019 04:49:29 PM
// Design Name: 
// Module Name: Comb4BMult
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


module Comb4BMult(
    input [3:0] a,
    input [3:0] b,
    output [7:0] s
    );
    wire  [15:0] c ;
   assign c[0] = a[0] & b[0];     
   assign c[1] = a[1] & b[0];   
   assign c[2] = a[0] & b[1];      
   assign c[3] = a[0] & b[2];
   assign c[4] = a[1] & b[1];
   assign c[5] = a[2] & b[0];  
   assign c[6] = a[0] & b[3];
   assign c[7] = a[1] & b[2];
   assign c[8] = a[2] & b[1];
   assign c[9] = a[3] & b[0];  
   assign c[10] = a[1] & b[3];
   assign c[11] = a[2] & b[2];
   assign c[12] = a[3] & b[1];  
   assign c[13] = a[2] & b[3];
   assign c[14] = a[3] & b[2];
   assign c[15] = a[3] & b[3];
   wire hfs1c,fas2c,hfs3c,hfs3s,fas31c,fas31s,fas32c,fas41c,fas41s,hfs4c,fas51c,fas51s,fas42c,fas42s,fas52c;
  HalfAdder hfs1(.a(c[1]),.b(c[2]),.c_out(hfs1c),.s(s[1])); 
  HalfAdder hfs2(.a(c[3]),.b(c[4]),.c_out(hfs2c),.s(hfs2s));    
  FullAdder fas2(.a(c[5]),.b(hfs2s),.c_in(hfs1c),.sum(s[2]),.c_out(fas2c));   
  HalfAdder hfs3(.a(c[7]),.b(c[6]),.c_out(hfs3c),.s(hfs3s)); 
  FullAdder fas31(.a(c[8]),.b(hfs3s),.c_in(hfs2c),.sum(fas31s),.c_out(fas31c));   
  FullAdder fas32(.a(c[9]),.b(fas31s),.c_in(fas2c),.sum(s[3]),.c_out(fas32c));    
  FullAdder fas41(.a(c[10]),.b(c[11]),.c_in(hfs3c),.sum(fas41s),.c_out(fas41c));      
  FullAdder fas42(.a(c[12]),.b(fas41s),.c_in(fas31c),.sum(fas42s),.c_out(fas42c));       
  HalfAdder hfs4(.a(fas42s),.b(fas32c),.c_out(hfs4c),.s(s[4]));
  FullAdder fas51(.a(c[14]),.b(c[13]),.c_in(fas41c),.sum(fas51s),.c_out(fas51c));   
  FullAdder fas52(.a(fas51s),.b(fas42c),.c_in(hfs4c),.sum(s[5]),.c_out(fas52c)); 
  FullAdder fas6(.a(c[15]),.b(fas51c),.c_in(fas52c),.sum(s[6]),.c_out(s[7]));   
  assign s[0] = c[0];
endmodule
