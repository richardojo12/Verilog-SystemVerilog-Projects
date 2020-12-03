// NOTE: all active signals are HIGH (1) 
module WDT (pclk, paddr, pwdata, wren, rden, prdata, cpu_forced_reset, cpu_reset_trig);

input pclk, wren, rden, cpu_forced_reset;
input [7:0] paddr;
input [20:0] pwdata;
output reg [20:0] prdata;
output reg cpu_reset_trig;

reg [20:0] mem [0:2];
reg [7:0] new_addr;
reg [20:0] counter, clk_div_counter;
bit default_counter;

// parameters ///////////////////////////////////////////////////////////////////////////////////
// cpu instructions use these addresses to set internal registers in the WDT
parameter CLOCK_DIVIDER_ADDR = 8'h11;
parameter KICK_ADDR = 8'h22;
parameter TIMEOUT_ADDR = 8'h33;

// internal register memory has a much lower, contiguous set of addresses
parameter INT_REG_CLK_DIV = 0;
parameter INT_REG_KICK = 1;
parameter INT_REG_TIMEOUT = 2;

// default values for the internal registers upon generic reset
parameter DEFAULT_CLK_DIV = 21'h0;        // no clock division
parameter DEFAULT_TIMEOUT = 21'h19;   // 25 cycles default
parameter DEFAULT_KICK = 21'h0;

parameter EXPECTED_KICK_VALUE = 21'h01;         // expected active signal for a "cpu kick"    

initial mem[INT_REG_CLK_DIV] = DEFAULT_CLK_DIV;                        
initial mem[INT_REG_TIMEOUT] <= DEFAULT_TIMEOUT;
initial mem[INT_REG_KICK] <= DEFAULT_KICK;
       
// assignment statements  ///////////////////////////////////////////////////////////////////////// 
//assign rd_data = mem[new_addr];         // rd_data always populated. Ignore in-between values 

// always blocks //////////////////////////////////////////////////////////////////////////////////
// adjust input address from CPU (addr) to match the internal register memory addresses 
always @ (posedge pclk) begin
    if (paddr == CLOCK_DIVIDER_ADDR) 
        new_addr <= INT_REG_CLK_DIV;
    else if (paddr == KICK_ADDR)
        new_addr <= INT_REG_KICK;
    else if (paddr == TIMEOUT_ADDR)
        new_addr <= INT_REG_TIMEOUT;
end // always block    

// logic for reading or writing writing to internal (register) memory or rd_data output
always @ (posedge pclk) begin                 
    if (cpu_forced_reset == 1 || cpu_reset_trig == 1 || default_counter != 1) begin   // Set defaults (stored value not important for the kick (use immediately))
       // mem[INT_REG_CLK_DIV] <= DEFAULT_CLK_DIV;                        
       // mem[INT_REG_TIMEOUT] <= DEFAULT_TIMEOUT;
       // mem[INT_REG_KICK] <= DEFAULT_KICK;
        default_counter <= 1;                   // used to initialize registers/variables to default values at first clock cycle                  
    end 
    else if (wren) 
       mem[new_addr] <= pwdata;        // write the value from the cpu instruction into internal (register) memory  
    else if (rden) 
        prdata <= mem[new_addr];
end // always block

// counter logic
always @ (posedge pclk) begin
    if (cpu_forced_reset == 1 || cpu_reset_trig == 1 || default_counter != 1) 
        counter <= 1;
    else if ((paddr == KICK_ADDR && pwdata == EXPECTED_KICK_VALUE) || counter == mem[INT_REG_TIMEOUT])      // check for a "kick" from cpu
        counter <= 1;
    else if (clk_div_counter == mem[INT_REG_CLK_DIV])
        counter <= counter + 1;                           // increment the counter
end // always block

// clk div logic
always @ (posedge pclk) begin
    if (cpu_forced_reset == 1 || cpu_reset_trig == 1 || clk_div_counter == mem[INT_REG_CLK_DIV] || default_counter != 1) 
        clk_div_counter <= 0;                             // roll clock division counter back to 0
    else  
        clk_div_counter <= clk_div_counter + 1;     
end // always block

// cpu reset trigger logic
always @ (posedge pclk) begin
    if (cpu_forced_reset == 1 || cpu_reset_trig == 1)
        cpu_reset_trig <= 0;
    else if (counter == mem[INT_REG_TIMEOUT])            // check if cpu reset trigger should be asserted
        cpu_reset_trig <= 1;
end

endmodule : WDT