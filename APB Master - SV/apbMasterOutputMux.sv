module apbMasterOutputMux(
input logic [7:0]  binary_in   , //  8 bit binary input
input logic enable,        //  Enable for the mux
output logic mux_out //  1-bit out 
);


// Output based on whther we want to read or write
always_comb begin
	mux_out = 0;
	if(enable)begin

		case(binary_in)
			8'h0 : mux_out = 0;//Reset
			8'h1 : mux_out = 1;//Watchdog write
			8'h2 : mux_out = 0;//WatchDog Read
			8'h3 : mux_out = 1;//RAM Write
			8'h4 : mux_out = 1;//MEM Write
			8'h5 : mux_out = 0;//Mem Read
			8'h6 : mux_out = 0;
			8'h7 : mux_out = 0;

		endcase
	end
end

endmodule:apbMasterOutputMux
