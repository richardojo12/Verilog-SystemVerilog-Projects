module testbench;


//Instantiate Clock
logic PCLK = 1'b0;

// Instantiate interface
apbMemInterface intf(PCLK);

// Instantiate device under test
apbMem dut (PCLK, intf.PRESET, intf.PWAIT, intf.PSEL, intf.PENABLE, intf.PADDR, intf.PWRITE, 
		intf.PWDATA, intf.PREADY, intf.PRDATA);

// generate clock
always begin
	PCLK = 1; #5; PCLK = 0; #5; // 10ns period
end

logic [1:0] wait_val = 0;
logic [7:0] addr_val;
int data_val;
int counter = 1;

initial begin 
	intf.mem_reset;
	//Demonstration test for read and write
			//addr_w, data_w, wait_w
//	intf.mem_write(8'h11, 8'hAA, 4'b0000);
			//addr_r, wait_r
//	intf.mem_read(8'h11, 4'b0000);
	//intf.mem_read(8'h10, 4'b0000);//Should result in invalid


/*	for (int i = 0; i < 15; i++) begin
	
		std::randomize(wait_val); 
		std::randomize(addr_val); 
		std::randomize(data_val); // Generate random values to test with
		
		intf.mem_write(addr_val, data_val, wait_val);// Write Value to mem addr

		intf.mem_read(addr_val, wait_val);// Read value from same addr in mem

		$display("Test %d: wait = %h, addr = %h, data = %h", counter, wait_val, addr_val, data_val);
		$display("PRDATA = %h", intf.PRDATA);
		
		if(intf.PRDATA == data_val) begin
			$display("Success, the data values are equal!");
		end
        
        counter++;
	end*/
	
	
	intf.mem_write(8'h10, 8'hAC, 4'b0000);

	intf.mem_write(8'h11, 8'hAA, 4'b0000);

	intf.mem_write(8'h12, 8'hAB, 4'b0000);
	
	intf.mem_write(8'h13, 8'hAC, 4'b0000);

	intf.mem_write(8'h14, 8'hAD, 4'b0000);

	intf.mem_write(8'h15, 8'hAE, 4'b0000);

	intf.mem_write(8'h16, 8'hAF, 4'b0000);

			//addr_r, wait_r

	intf.mem_read(8'h10, 4'b0001);

	intf.mem_read(8'h11, 4'b0010);

	intf.mem_read(8'h12, 4'b0011);

    intf.mem_read(8'h13, 4'b0100);

    intf.mem_read(8'h14, 4'b0101);

    intf.mem_read(8'h15, 4'b0110);

    intf.mem_read(8'h16, 4'b0111); 

	$finish;
end

endmodule
