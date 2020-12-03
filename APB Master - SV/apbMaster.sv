module apbMaster( 
input logic APBMASTERENABLE, input logic [7:0]CPUSEL, input logic [7:0] addr, 
input logic [20:0] data, input logic PCLK, input logic PRESET,
output logic [2:0]PSEL, output logic PENABLE, 
output logic [7:0] PADDR, output logic PWRITE, 
output logic [20:0] PWDATA, output logic CPUPREADY, input logic PREADY);

logic mux_output;
logic mux_enable;
apbMasterOutputMux outputMux (CPUSEL, mux_enable, mux_output); //Mux to push outputs to slave

// Store the current and next state
enum logic [1:0]{
	IDLE = 2'b00,
	SETUP = 2'b01,
	ACCESS = 2'b10
} next_state, curr_state;

task clearMAPB;//Reset APB
	begin	
		PSEL <= 3'b000;
		PENABLE <= 0;
		PADDR <= 0;
		PWRITE <= 0;
		PWDATA <= 0;
		mux_enable <= 0;
		CPUPREADY <= 0;
	end
endtask: clearMAPB

task pushToSlave;
	begin			
	    mux_enable <= 1; 
		PADDR <= addr;
		PWDATA <= data; 
		PWRITE <= mux_output; 
	end
endtask: pushToSlave

//Current State logic
always_ff@(posedge PCLK or posedge PRESET) begin
	if(PRESET) begin
		clearMAPB;
		curr_state <= IDLE; //If reset -> go to the first state
		end
	else begin
		curr_state <= next_state; //go to the next state
		end
end

//Set signals on posedge clock 
always_ff@(posedge PCLK) begin
	case(curr_state)
		IDLE:begin //No transfer
		    //CPUPREADY <= 0;
			if(APBMASTERENABLE) begin  //Instruction from CPU has come/ Set APBMASTERENABLE = 1 for > 1 cycle
			     pushToSlave;//Push signals to apb slaves
			end else begin
			    clearMAPB;//Reset outputs on a new instruction
			end
		end
		
		SETUP:begin//Transfer
		        pushToSlave;//Push signals to apb slaves
			if(CPUSEL == 8'h1 || CPUSEL == 8'h2)begin //Watchdog
				PSEL <= 3'b001;
			end else begin //Memory module
				PSEL <= 3'b010;
			end
		end

		ACCESS:begin
			PENABLE <= 1;
			if(PREADY)begin //Wait for peripheral to finish
				CPUPREADY <= 1;
			end else begin
			    CPUPREADY <= 0;
			end
		end
	endcase
end

//Next State Logic
always_comb begin
	case(curr_state)
		IDLE:begin //No transfer
			if(APBMASTERENABLE) begin  //Instruction from CPU has come/ Set APBMASTERENABLE = 1 for > 1 cycle
				next_state = curr_state.next;
			end else begin
				next_state = curr_state.first;
			end
		end

		SETUP:begin//Transfer
			next_state = curr_state.next;;
		end

		ACCESS:begin
			if(PREADY)begin //Wait for peripheral to finish
				next_state = curr_state.first;
			end else begin
				next_state = curr_state;
			end
		end
	endcase
end
endmodule: apbMaster
