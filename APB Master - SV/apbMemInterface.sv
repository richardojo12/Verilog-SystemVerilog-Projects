interface apbMemInterface(input logic PCLK);

logic PRESET, PSEL, PENABLE, PWRITE, PREADY;
logic [3:0] PWAIT;  
logic [7:0] PADDR; 
logic [31:0] PWDATA, PRDATA;

task mem_reset;
	PRESET = 1; #10; PRESET = 0; #10;// Apply reset wait
endtask: mem_reset

task mem_write; //Address to write to, write data, and wait time(cycles)
	input [7:0] addr_w; 
	input [31:0] data_w;
	input [3:0] wait_w;

	@(posedge PCLK) begin
		PENABLE = 0;
		PSEL = 0;	
		PADDR = addr_w; 
		PWDATA =  data_w;
		PWRITE = 1'b1;
		PWAIT = wait_w;
		#10;
		if(!PSEL) begin
			PSEL = 1; #10;
		end
		PENABLE = 1; 
		for(int i = 0; i <= wait_w; i++) begin //Wait as long as it takes for PREADY == 1
			#10;
		end 
	end
endtask: mem_write

task mem_read;//Address to read from, and wait time(cycles)
	input [7:0] addr_r; 
	input [3:0] wait_r;

	@(posedge PCLK) begin
		PENABLE = 0;
		PSEL = 0;	
		PADDR = addr_r;
		PWRITE = 1'b0;
		PWAIT = wait_r;
		#10;
		if(PSEL == 1'b0) begin
			PSEL = 1; #10;
		end
		PENABLE = 1;
		for(int i = 0; i <= wait_r; i++) begin //Wait as long as it takes for PREADY == 1
			#10;
		end 
	end
endtask: mem_read

endinterface: apbMemInterface
