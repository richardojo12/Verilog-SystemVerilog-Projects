`include "cpu_if.sv"
`include "sys_if.sv"

module DUT(input logic clk, 
           input logic reset, 
           input logic run,
           output logic [20:0] prdata_0, 
           output logic [20:0] prdata_1, 
           output logic wdt_trigger_reset,
           output logic cpuinstrdone);

//clock and reset signal declaration
    logic 
        wren_w,wren_m, //Watchdog r/w signals
  		rden_w, rden_m,//Mem per r/w signals 
  		ce,
  		incpureset,		// signal from watchdog timer to CPU to force cpu reset
  	 	cpudone,		//signal from cpu when instruction is completed
  	 	cpuperphreset;     // signal from cpu driven to peripherals to force a peripheral reset
 	

    //instantiate interfaces
    cpu_if cpuif(clk);
    sys_if sysif(clk);

    //Push output wire signals
    assign prdata_0 = sysif.prdata_0;
    assign prdata_1 = sysif.prdata_1;
    assign wdt_trigger_reset = incpureset;
    assign cpuinstrdone = cpudone;

		// APB interfaces for cpu and peripherals
  	apbMaster apb_master (.APBMASTERENABLE	(cpuif.APBMASTERENABLE), 
                         .CPUSEL			(cpuif.CPUSEL), 
                         .addr				(cpuif.addr),
                         .data				(cpuif.data),  
                         .PCLK 				(sysif.pclk),  
                         .PRESET	 		(cpuperphreset),
                         .PSEL_0			(sysif.psel_0),
			             .PSEL_1            (sysif.psel_1),
                         .PENABLE    		(sysif.penable),
                         .PADDR		 		(sysif.paddr),  
                         .PWRITE	 		(sysif.pwrite),
                         .PWDATA			(sysif.pwdata), 
                         .CPUPREADY			(cpuif.CPUREADY), 
                         .PREADY_0			(sysif.pready_0),
                         .PREADY_1          (sysif.pready_1));
   	
  	// rename APB_Slave_WDT to generic APB_Slave
  	APB_Slave_WDT apb_memory (.pclk(sysif.pclk),
 				.presetn(cpuperphreset), 
				.paddr(sysif.paddr), 
				.psel(sysif.psel_1), 
				.penable(sysif.penable), 
				.pwrite(sysif.pwrite), 
				.pwdata(sysif.pwdata), 
				.wait_time(sysif.wait_time), 
				.cpu_forced_reset(cpuperphreset), 
				.prdata(sysif.prdata_1), 
				.pready(sysif.pready_1), 
                .wren(wren_m), 
                .rden(rden_m));


  	APB_Slave_WDT apb_wdt (.pclk(sysif.pclk),
 				.presetn(cpuperphreset), 
				.paddr(sysif.paddr), 
				.psel(sysif.psel_0), 
				.penable(sysif.penable), 
				.pwrite(sysif.pwrite), 
				.pwdata(sysif.pwdata), 
				.wait_time(sysif.wait_time), 
                .cpu_forced_reset (cpuperphreset), 
                .prdata(sysif.prdata_0),
                .pready(sysif.pready_0),
                .wren(wren_w), 
                .rden(rden_w));

	// cpu and peripheral modules
    cpu cpu1(       .RUN(run),
                    .CPUPREADY(cpuif.CPUREADY),
                    .CCLK(cpuif.clk), 
      			    .INCPURESET(incpureset),
      			    .APBMASTERENABLE(cpuif.APBMASTERENABLE), 
                	.addr(cpuif.addr),  
                	.data(cpuif.data), 
                	.CPUSEL(cpuif.CPUSEL),
                	.CPURESET(reset), 
                	.CPUDONE(cpudone),
                	.CPUPERPHRESET(cpuperphreset));


    WDT wdt1(.pclk(sysif.pclk), 
             .paddr(sysif.paddr),
             .pwdata(sysif.pwdata),
             .wren(wren_w), 
             .rden(rden_w), 
             .prdata(sysif.prdata_0),
             .cpu_forced_reset(cpudone), 
             .cpu_reset_trig(incpureset));
  
    memory mem1 (.clk 		(sysif.pclk), 
                 .addr		(sysif.paddr), 
                 .ce 		(ce), 
                 .wren 		(wren_m), 
                 .rden 		(rden_m), 
                 .wr_data 	(sysif.pwdata), 
                 .rd_data 	(sysif.prdata_1));
      
endmodule: DUT
