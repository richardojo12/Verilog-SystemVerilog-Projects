// import path for package files 
import typedef_pkg::address_t;
import typedef_pkg::data_t;

interface cpu_if(input logic clk);
  	// declare signals
  	logic APBMASTERENABLE, CPUREADY;
 	address_t CPUSEL, addr;				
    data_t data;				  
    
  	// DUT modport could be used if creating a new slave DUT or modifying and existing one
  modport CPU (input clk, CPUREADY, 
               output APBMASTERENABLE, addr, data, CPUSEL);
  
  modport APBMASTER (input clk, CPUREADY, APBMASTERENABLE, addr, data, CPUSEL);  
  
  endinterface: cpu_if
    