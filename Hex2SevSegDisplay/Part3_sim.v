`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2019 05:43:38 PM
// Design Name: 
// Module Name: Part3_sim
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


module Part3_sim();  
   wire [6:0] ca; //Output
   wire [3:0] an; //Output
   reg clk;
   reg reset;
    // Inputs
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
  
    initial clk = 0;
    
lookaheaddisplay uut(.CLOCK(clk),.RESET(reset),.A(A),.B(B),.C_IN(Cin),.AN(an),.CA(ca));
     
clk_enable Clk_enable(.clk(clk) ,.reset(reset),.clk_en(clk_en));

initial begin 
    clk=0;
    forever #10 clk=~clk;
    end
    
    initial begin
        reset=1;
        #10;
        reset=0;
     // Initialize Inputs
    A = 0;  B = 0;  Cin = 0;
    // Wait 100 ns for global reset to finish
    #100;#10;
        
    #10 A=4'b1111;B=4'b0000;Cin=1'b0;
end

always @ (posedge clk_en)
            $monitor("A=%4b,B=%4b,an=%4b,ca=%7b",A,B,an,ca);    
endmodule
