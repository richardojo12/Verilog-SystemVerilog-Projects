// import path for package files 
import typedef_pkg::address_t;
import typedef_pkg::data_t;
import typedef_pkg::wait_t;

interface sys_if(input bit pclk);
	// declare signals
	logic  psel_0, psel_1,
	       presetn, penable, pwrite, pready_0, pready_1;
  	  	
	address_t paddr;
	data_t pwdata, prdata_0, prdata_1;
	wait_t wait_time = 0;
	
	// DUT modport could be used if creating a new slave DUT or modifying and existing one
  //modport WDT (input pclk, paddr, pwdata, 
	//		 	output prdata);

  modport WDT_APBSLAVE (input pclk, presetn, psel_0, penable, pwrite, paddr, pwdata, wait_time, 
                        output prdata_0, pready_0);

  modport memory_APBSLAVE (input pclk, presetn, psel_1, penable, pwrite, paddr, pwdata, wait_time, 
                        output prdata_1, pready_1);
	
endinterface : sys_if

