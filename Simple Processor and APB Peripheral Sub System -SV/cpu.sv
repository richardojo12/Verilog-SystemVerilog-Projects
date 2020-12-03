module cpu(input logic RUN, input logic CPUPREADY,
input logic CCLK,input logic INCPURESET, output logic APBMASTERENABLE, 
output logic [7:0] addr, output logic [20:0] data, output logic[7:0] CPUSEL,
input logic CPURESET, output logic CPUDONE, output logic CPUPERPHRESET);

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
enum logic [4:0]{
	FETCH1 = 5'b000,
	FETCH2 = 5'b001,
	DECODE = 5'b010,
	EXECUTE = 5'b011,
	IDLE = 5'b100,//Final or rest state
	MEMORY1 = 5'b101,// Special State for writing to the Instruction mem
	MEMORY2 = 5'b110, // Special State for writing to the Instruction mem
	WRITEBACK1 = 5'b111, // Special State for writing to the Instruction mem
	WRITEBACK2 = 5'b1000, // Special State for writing to the Instruction mem
	RESET = 5'b1001 // Special State for reseting the cpu and perph
} next_state, curr_state;

task cpu_reset;
	begin
	    CPUPERPHRESET <= 1;
		CPUDONE <= 1;
        PC <= 0;
        MAR <= 0;
        APBMASTERENABLE <= 0;  
	    addr <= 0;
	    data <= 0;
        CPUSEL <= 0;
        MWRITE <= 0;
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
        CPUDONE <= 1;
     end
endtask:new_instr

task readyToRW(input read_on, input write_on);//Push values for reading and writting to Instruction mem
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
		curr_state <= RESET;
	end else if(INCPURESET) begin //Interrupt signal from peripheral
		curr_state <= RESET;
	end else begin
		curr_state <= next_state;
	end
end

//Drive signals 
always_ff@(posedge CCLK) begin
    case(curr_state)
		FETCH1:begin//Fetch the next instruction from the Instruction memory
			CPUDONE <= 0;
		    CPUPERPHRESET <= 0;
			if(RUN)begin	
				MAR <= PC;
			end else begin
			    MAR <= MAR;
			end			
		end
		FETCH2:begin//Fetch the next instruction from the Instruction memory
			 PC <= PC + 1;
			 MDR <= rd_instruction;
		end

		DECODE:begin
		    MAR <= PC;   
			IR <= MDR;
		end

		EXECUTE:begin
		    if(!IR) begin // No instruction 
		       APBMASTERENABLE <= 0;
			   PC <= PC;
		    end else if (IR) begin
		         if (instr_decoder_output == 8'h01 || instr_decoder_output == 8'h02 ||
		              instr_decoder_output == 8'h04 || instr_decoder_output == 8'h05) begin
				    CPUSEL <= instr_decoder_output;				
  				    addr <= IR[28:21];
				    data <= IR[20:0];
				    APBMASTERENABLE <= 1;
				    PC <= PC;
			     end else if(instr_decoder_output == 8'h03) begin//Instruction Mem Write Instruction
			        PC <= PC + 1;
			        APBMASTERENABLE <= 0; 
			     end else if(instr_decoder_output == 8'h06 || instr_decoder_output == 8'h07) begin //Invalid instruction
				    PC <= PC;
				    APBMASTERENABLE <= 0;
			     end else if(!instr_decoder_output) begin //Reset
			     end 
			end else begin //Unknown State
			end 
		end
		
		//Stages for Instruction memory write instruction i.e. OpCode=011
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
        end
        
        //State for waiting for current instruction to finish
		IDLE:begin
		  MWRITE <= 0;
		  if(!CPUPREADY && !mem_cpu_ready) begin
			end else begin
			     new_instr;
			end
		end
		
		//State to handle reset instructions
		RESET:begin
          cpu_reset;
		end
	endcase
end

//Next state logic/ Control Unit FSM
always_comb begin
	case(curr_state)
		FETCH1:begin//Fetch the next instruction from the Instruction memory
			if(RUN)begin	
				readyToRW(!MWRITE, MWRITE);//Prepare memory to read next instruction	
				next_state = curr_state.next;
			end else begin
			    next_state = curr_state;
			end			
		end
		FETCH2:begin//Fetch the next instruction from the Instruction memory
			next_state = curr_state.next;
		end

		DECODE:begin
			instr_decoder_enable <= 1;
		    readyToRW(!MWRITE, MWRITE);//Prepare memory to read next instruction
			next_state = curr_state.next;
		end

		EXECUTE:begin
		    if(!IR) begin // No instruction
		         next_state = IDLE;//IDLE, instruction is done
		    end else if(IR) begin
		          if(instr_decoder_output == 8'h01 || instr_decoder_output == 8'h02 || 
		              instr_decoder_output == 8'h04 || instr_decoder_output == 8'h05) begin
			             next_state = IDLE;//IDLE, instruction is done
			      end else if(instr_decoder_output == 8'h03) begin//Instruction Mem Write Instruction
			             next_state = MEMORY1;//Memory Write Instruction requires additional stages
			      end else if(instr_decoder_output == 8'h06 || instr_decoder_output == 8'h07) begin //Invalid instruction
				         next_state = curr_state; //Stall the cpu
			      end else if(!instr_decoder_output) begin //Reset
			             next_state = RESET;//RESET, instruction is done
			      end 
			 end else begin //Unknown State
			      next_state = curr_state.first;
			end 
		end
		
        //Stages for Instruction memory write instruction i.e. OpCode=011
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
            readyToRW(!MWRITE, MWRITE);//Write new instruction to Instruction mem
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
		
		//State to handle reset instructions
		RESET:begin
		        ce <= 0;
			    instr_decoder_enable <= 0;
				next_state = curr_state.first;        
		end
	endcase
end

endmodule:cpu
