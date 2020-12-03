`timescale 1ns / 1ps

module memory (clk, addr, ce, wren, rden, wr_data, rd_data);

input logic clk, ce, wren, rden;
input logic [7:0] addr;
input logic [20:0] wr_data;
output logic [20:0] rd_data;

logic [20:0] mem [0:255];

always @ (posedge clk) 
	if (ce) begin
		if (rden) begin
			// $display("entering read memory area.");		
			rd_data <= mem[addr];
	   end
   else if (wren) begin
		// $display("entering write memory area.");		
	    mem[addr] <= wr_data;
	end
end // end always block

endmodule : memory
