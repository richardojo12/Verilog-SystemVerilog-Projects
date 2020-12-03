module cpu(input logic RUN, input logic CPUPREADY, input logic [20:0] PRDATA,
input logic CCLK,input logic INCPURESET, output logic APBMASTERENABLE, 
output logic [7:0] addr, output logic [20:0] data, output logic[7:0] CPUSEL,
input logic CPURESET, output logic CPUDONE);

//logic [11:0] LAST_PC;
//Define constants
`define data_size 32
`define addr_size 12
`define decoder_output_size 8
//Write, Read from main memeory
logic ce, mem_wren, mem_rden, mem_cpu_ready, MWRITE;
logic [`data_size - 1:0] wr_instruction, rd_instruction;

//Program counter, Memory access register
logic [`addr_size - 1:0] PC, MAR; 
//Memory data register, Instruction register
logic [`data_size - 1:0] MDR, IR; 
//Decode the instruction
logic instr_decoder_enable;
logic [`decoder_output_size - 1:0] instr_decoder_output;

// Store the current and next state
enum logic [3:0]{
	FETCH1 = 4'b000,
	FETCH2 = 4'b001,
	DECODE = 4'b010,
	EXECUTE = 4'b011,
	IDLE = 4'b100,//Final or rest state
	MEMORY1 = 4'b101,// Special State for writing to the main mem
	MEMORY2 = 4'b110, // Special State for writing to the main mem
	WRITEBACK1 = 4'b111, // Special State for writing to the main mem
	WRITEBACK2 = 4'b1000 // Special State for writing to the main mem
} next_state, curr_state;

task cpu_reset;
	begin
		PC <= 0;
		MAR <= 0;
		MDR <= 0;
		IR <= 0;
		MWRITE <= 0;
		CPUDONE <= 0;
	end
endtask: cpu_reset;

task new_instr;
    begin
        MAR <= PC;
        APBMASTERENABLE <= 0;
	    addr <= 0;
	    data <= 0;
        CPUSEL <= 0;
        MWRITE <= 0;
        CPUDONE <= 0;
     end
endtask:new_instr

task readyToRW(input read_on, input write_on);//Push values for reading and writting to mem
	begin
		mem_wren <= write_on;
		mem_rden <= read_on; 
        ce <= 1;
	end
endtask:readyToRW

//Instruction memory
mainMem imemory(MAR, ce, mem_wren, mem_rden, wr_instruction, rd_instruction, CCLK, mem_cpu_ready);
//Instruction Decoder
threeBitDecoder instrDecoder(IR[31:29],instr_decoder_enable, instr_decoder_output); //8-bit out 

//Current State logic
always_ff@(posedge CCLK or posedge CPURESET or posedge INCPURESET) begin
	if(CPURESET)begin //CPU Reset signal
		cpu_reset;
		new_instr;
		curr_state <= FETCH1;
	end else if(INCPURESET) begin //Interrupt signal from peripheral
	    cpu_reset;
		new_instr;
		curr_state <= FETCH1;
	end else begin
		curr_state <= next_state;
	end
end

//Drive signals 
always_ff@(posedge CCLK) begin
    case(curr_state)
		FETCH1:begin//Fetch the next instruction from the main(RAM) memory
			if(RUN)begin	
				MAR <= PC;
			end else begin
			    MAR <= 0;
			end			
		end
		FETCH2:begin//Fetch the next instruction from the main(RAM) memory
			 PC <= PC + 1'b1;
			 MDR <= rd_instruction;
		end

		DECODE:begin
		    MAR <= PC;   
			IR <= MDR;
		end

		EXECUTE:begin
		    if(!IR) begin // No instruction 
		      CPUDONE <= 1;  
		    end else if(IR && (instr_decoder_output == 8'h01 || instr_decoder_output == 8'h02 ||
		     instr_decoder_output == 8'h04 || instr_decoder_output == 8'h05)) begin
				CPUSEL <= instr_decoder_output;				
  				addr <= IR[28:21];
				data <= IR[20:0];
				APBMASTERENABLE <= 1;
				CPUDONE <= 1;
			end else if(IR && instr_decoder_output == 8'h03) begin//RAM Write Instruction
			     PC <= PC + 1'b1;
			end else if(IR && !instr_decoder_output) begin //Reset
                 PC <= 0;
			end 
		end
		
		//Stages for main memory write instruction i.e. OpCode=011
		MEMORY1:begin
		end
        MEMORY2:begin
            MDR <= rd_instruction;
        end
   
        WRITEBACK1:begin
            wr_instruction <= MDR;
            MAR[11:8] <= 4'b0000;
            MAR[7:0] <= IR[28:21];
            MWRITE <= 1;
        end
        WRITEBACK2:begin
            CPUDONE <= 1;
        end
        
        //State for waiting for current instruction to finish
		IDLE:begin
		  MWRITE <= 0;
		  if(!CPUPREADY && !mem_cpu_ready)begin
		         // APBMASTERENABLE <= 0;
			end else begin
			     
			     new_instr;
			end
		end
	endcase
end

//Next state logic/ Control Unit FSM
always_comb begin
	case(curr_state)
		FETCH1:begin//Fetch the next instruction from the main(RAM) memory
			if(RUN)begin	
				readyToRW(!MWRITE, MWRITE);//Prepare memory to read next instruction	
				next_state = curr_state.next;
			end else begin
			    next_state = curr_state;
			end			
		end
		FETCH2:begin//Fetch the next instruction from the main(RAM) memory
			next_state = curr_state.next;
		end

		DECODE:begin
			instr_decoder_enable <= 1;
		    readyToRW(!MWRITE, MWRITE);//Prepare memory to read next instruction
			next_state = curr_state.next;
		end

		EXECUTE:begin
		    if(!IR) begin // No instruction
		         next_state = curr_state.next;//IDLE, instruction is done
		    end else if(IR && (instr_decoder_output == 8'h01 || instr_decoder_output == 8'h02 || 
		    instr_decoder_output == 8'h04 || instr_decoder_output == 8'h05)) begin
			     next_state = curr_state.next;//IDLE, instruction is done
			end else if(IR && instr_decoder_output == 8'h03) begin//RAM Write Instruction
			     next_state = MEMORY1;//Memory Write Instruction requires additional stages
			end else if(IR && !instr_decoder_output) begin //Reset
			     next_state = curr_state.next;//IDLE, instruction is done
			end 
		end
		
        //Stages for main memory write instruction i.e. OpCode=011
       MEMORY1:begin
        next_state = curr_state.next;
       end  
        MEMORY2:begin
            next_state = curr_state.next;
        end
        WRITEBACK1:begin
            next_state = curr_state.next;
        end
        WRITEBACK2:begin
            readyToRW(!MWRITE, MWRITE);//Write new instruction to main mem
            next_state = IDLE;
        end
        
        //State for waiting for current instruction to finish
		IDLE:begin
			if(!CPUPREADY && !mem_cpu_ready)begin
				next_state = curr_state;
			end else begin
			    ce <= 0;
			     instr_decoder_enable <= 0;
				next_state = curr_state.first;	
			end
		end
	endcase
end

endmodule:cpu
