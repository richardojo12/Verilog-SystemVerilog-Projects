`timescale 1ns / 1ps

module APB_Slave_WDT(pclk, presetn, paddr, psel, penable, pwrite, pwdata, wait_time, cpu_forced_reset, prdata, pready, wren, rden);

input logic pclk, presetn, psel, penable, pwrite, cpu_forced_reset; 
input logic [7:0] paddr;
input logic [20:0] pwdata;
input logic [3:0] wait_time;
input logic [20:0] prdata;
output logic pready, wren, rden;

logic [3:0] wait_counter;
logic ce;
// enums ///////////////////////////////////////////////////////////////////////////////////////////////////
enum logic [1:0]
{
	IDLE = 2'b00,
	SETUP = 2'b01,
	WAITT = 2'b10,
	TRANSFER = 2'b11
} next_state, curr_state;

// instantiate modules /////////////////////////////////////////////////////////////////////////////////////
//WDT wdt_inst1(.clk(pclk), .addr(paddr), .wren(wren), .rden(rden), .wr_data(pwdata), .rd_data(prdata), 
//                .cpu_forced_reset(cpu_forced_reset), .cpu_reset_trig(cpu_reset_trig));

// assign statements ///////////////////////////////////////////////////////////////////////////////////////
assign pready = psel && penable && (wait_counter == wait_time);

// always blocks //////////////////////////////////////////////////////////////////////////////////////////
// next state handling
always_comb begin
	case (curr_state)
		IDLE : begin
			ce = 0; wren = 0; rden = 0;
			if ((psel) && (~penable))
				next_state = SETUP; //2'b01;
			else 
				next_state = IDLE; //2'b00;
		end
		SETUP : begin 
			wren = pwrite; rden = ~pwrite; 		
			if ((psel) && (penable) && (~pready) && (wait_counter < wait_time)) begin
				next_state = WAITT; //2'b10; 
				ce = 0;
			end
			else begin
				next_state = TRANSFER; //2'b11;
				ce = 1;				
			end
		end
		WAITT : begin 
			if ((psel) && (penable) && (wait_counter === wait_time)) begin //(pready)) begin
				next_state = TRANSFER; //2'b11;
				ce = 1;	
			end
			else
				next_state = WAITT; //2'b10;
		end
		TRANSFER : begin 
			ce = 0;
			if ((psel) && (~penable) && (pready)) 
				next_state = SETUP; //2'b01;
			else 
				next_state = IDLE; //2'b00;
		end
	endcase 
end // always_comb

// wait counter handling
always_ff @ (posedge pclk or presetn) begin
	if (~presetn)
		wait_counter <= 0;
	else if (next_state == SETUP)
		wait_counter <= 0;
	else if ((next_state == WAITT) && (wait_counter < wait_time))
		++wait_counter;
end // always_ff

// logic for current state status
always_ff @ (posedge pclk) begin
     if (presetn) 
        curr_state <= IDLE;
     else
        curr_state <= next_state;       
end // always_ff 

endmodule : APB_Slave_WDT