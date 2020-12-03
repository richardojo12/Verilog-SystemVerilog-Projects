module testbench;

//Instantiate Clock
logic PCLK = 1'b0;
logic PRESET, PSEL, PENABLE, PWRITE, PREADY;
logic [3:0] PWAIT;  
logic [7:0] PADDR; 
logic [20:0] PWDATA, PRDATA;
// Instantiate interface
//apbMemInterface intf(PCLK);

// Instantiate device under test
apbMem dut (PCLK, PRESET, PWAIT, PSEL, PENABLE, PADDR, PWRITE, 
		PWDATA, PREADY, PRDATA);

// generate clock
always begin
	PCLK = 1; #5; PCLK = 0; #5; // 10ns period
end

//logic [1:0] wait_val;
//logic [7:0] addr_val;
//int data_val;

task mem_reset;
	PRESET = 1; #10; PRESET = 0; #10;// Apply reset wait
endtask: mem_reset

task mem_write; //Address to write to, write data, and wait time(cycles)
	input [7:0] addr_w; 
	input [20:0] data_w;
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

initial begin 
	mem_reset;
	//Demonstration test for read and write
			//addr_w, data_w, wait_w
//	intf.mem_write(8'h11, 8'hAA, 4'b0000);
			//addr_r, wait_r
//	intf.mem_read(8'h11, 4'b0000);
//	intf.mem_read(8'h10, 4'b0000);//Should result in invalid


//	for (int i = 0; i < 2; i++) begin
//	
//		std::randomize(wait_val); std::randomize(addr_val); std::randomize(data_val); // Generate random values to test with
//		
//		intf.mem_write(addr_val, data_val, wait_val);// Write Value to mem addr
//
//		intf.mem_read(addr_val, wait_val);// Read value from same addr in mem
//
//		$display("wait = %h, addr = %h, data = %h", wait_val, addr_val, data_val);
//		$display("PRDATA = %h", intf.PRDATA);
//		
//		if(intf.PRDATA == data_val) begin
//			$display("Success, the data values are equal!");
//		end
//
//	end
	
	
	mem_write(8'h10, 8'hAC, 4'b0000);

	mem_write(8'h11, 8'hAA, 4'b0000);

	mem_write(8'h12, 8'hAB, 4'b0000);
	
	mem_write(8'h13, 8'hAC, 4'b0000);

//	intf.mem_write(8'h14, 8'hAD, 4'b0101);
//
//	intf.mem_write(8'h15, 8'hAE, 4'b0110);
//
//	intf.mem_write(8'h16, 8'hAF, 4'b0111);

			//addr_r, wait_r

	mem_read(8'h10, 4'b0000);

	mem_read(8'h11, 4'b0000);

	mem_read(8'h12, 4'b0000);

    mem_read(8'h13, 4'b0000);

//intf.mem_read(8'h14, 4'b0000);
//
//intf.mem_read(8'h15, 4'b0000);
//
//intf.mem_read(8'h16, 4'b0000);

	$finish;
end

endmodule



