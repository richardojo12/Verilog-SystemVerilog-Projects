`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2019 06:24:42 PM
// Design Name: 
// Module Name: vending
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


module vending(
    input [3:0] open,    
    input clk,input reset,input N,input D,input Q,
    output reg [5:0]state
    );
    
    parameter zero = 6'b000000, five = 6'b000101, ten = 6'b001010, fifteen = 6'b001111
    , twenty = 6'b010100, twentyfive = 6'b011001, thirty = 6'b011110, thirtyfive = 6'b100011;
    //Products Key: open[0001] = 15,open[0010] = 20, open[0100] = 25, open[1000] = 30 | SW0 -> SW3
    reg [5:0]next_state; initial next_state = zero; 
    reg reset2; initial reset2 = 0;
    reg [3:0] next_open;initial next_open =  4'b0000;
    initial state =  zero;
    
    always @(open)begin
      next_open = open;
    end
    
   always @(N or  D or  Q or state or reset) begin
   // $display("Count = %2b",next_count); 
  //  $display("reset2 = %1b",reset2);
  // $display("Next_state = %6b",next_state);  
    //  $display("state = %6b",state); 
//  if(next_state == state && next_state == zero && reset2 == 1 && !reset)begin
 //  reset2 =0;
 //  end else
 if(reset)begin
    next_state = zero; 
 end else begin
 
 if(reset2 && next_state == zero && state == zero) begin
 reset2 = 0;
 end else
 if(reset2 && next_state != zero)begin
   next_state = zero; 
 end 
 begin
     case (state)      
     zero: begin                                 
     if (Q) begin
      next_state = twentyfive; 
     end              
     else if (D) begin               
      next_state = ten;              
      end              
      else if (N) begin                
      next_state = five;      
      end              
      else begin                
      next_state = zero;              
      end end          
          
     five: begin
     if (Q) begin
      next_state = thirty; 
     end              
     else if (D) begin   
      next_state = fifteen; 
      end              
      else if (N) begin                
      next_state = ten; 
      end              
      else begin                
      next_state = five; 
      end end          
      
      ten: begin 
      if (Q) begin
      next_state = thirtyfive;   
      end              
      else if (D) begin         
      next_state = twenty; 
      end              
      else if (N) begin                
      next_state = fifteen; 
      end              
      else begin                
      next_state = ten; 
      end end
      
      fifteen:begin 
      if (Q) begin
      next_state = thirtyfive;  
     end              
     else if (D) begin   
      next_state = twentyfive; 
      end              
      else if (N) begin                
      next_state = twenty; 
      end              
      else begin                
      next_state = fifteen; 
      end end
      
      twenty: begin 
       if (Q) begin
      next_state = thirtyfive;  
     end              
     else if (D) begin   
      next_state = thirty; 
      end              
      else if (N) begin                
      next_state = twentyfive; 
      end              
      else begin                
      next_state = twenty; 
      end end
      
      twentyfive:begin 
      if (Q) begin
      next_state = thirtyfive;  
     end              
     else if (D) begin   
      next_state = thirtyfive; 
      end              
      else if (N) begin                
      next_state = thirty; 
      end              
      else begin                
      next_state = twentyfive; 
      end end
      
      thirty:begin
      if (Q) begin
      next_state = thirtyfive;  
     end              
     else if (D) begin   
      next_state = thirtyfive; 
      end              
      else if (N) begin                
      next_state = thirtyfive; 
      end              
      else begin                
      next_state = thirty; 
      end end
         
       thirtyfive: begin              
       next_state = thirtyfive;              
       end
       endcase

      if(next_state != thirtyfive && next_state != zero 
        && next_state != five && next_state != ten && next_state != fifteen 
        && next_state != twenty && next_state != twentyfive && next_state != thirty) begin
        next_state = thirtyfive;
        end          
      end
      
     if (next_open != 4'b0000) begin
      reset2 = 1;
    
      case(next_state)
      zero: begin reset2 = 0;end
      five: begin reset2 = 0;end
      ten:  begin reset2 = 0;end
      fifteen: case(next_open)
                4'b0001: next_state[5:0] = zero;
                4'b0010: next_state[5:0] = next_state;
                4'b0100: next_state[5:0] = next_state;
                4'b1000: next_state[5:0] = next_state;
            endcase
      twenty: case(next_open)
                4'b0001: next_state[5:0] = five;
                4'b0010: next_state[5:0] = zero;
                4'b0100: next_state[5:0] = next_state;
                4'b1000: next_state[5:0] = next_state;
            endcase
      twentyfive:case(next_open)
                4'b0001: next_state[5:0] = ten;
                4'b0010: next_state[5:0] = five;
                4'b0100: next_state[5:0] = zero;
                4'b1000: next_state[5:0] = next_state;
            endcase
      thirty:case(next_open)
                4'b0001: next_state[5:0] = fifteen;
                4'b0010: next_state[5:0] = ten;
                4'b0100: next_state[5:0] = five;
                4'b1000: next_state[5:0] = zero;
            endcase
      thirtyfive:case(next_open)
                4'b0001: next_state[5:0] = twenty;
                4'b0010: next_state[5:0] = fifteen;
                4'b0100: next_state[5:0] = ten;
                4'b1000: next_state[5:0] = five;
            endcase   
      endcase         
     end
  end   
  end 

     
   always @(posedge clk) begin   
     state <= next_state;
    end

  

endmodule
