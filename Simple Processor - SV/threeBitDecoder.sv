module threeBitDecoder(
input logic [2:0]  binary_in   , //  3 bit binary input
input logic enable,        //  Enable for the decoder
output logic [7:0] decoder_out //  8-bit out 
);



always_comb begin
	decoder_out = 0;
	if(enable)begin

		case(binary_in)
			3'b000 : decoder_out = 8'h00;//Reset
			3'b001 : decoder_out = 8'h01;//Watchdog write
			3'b010 : decoder_out = 8'h02;//WatchDog Read
			3'b011 : decoder_out = 8'h03;//RAM Write
			3'b100 : decoder_out = 8'h04;//MEM Write
			3'b101 : decoder_out = 8'h05;//Mem Read
			3'b110 : decoder_out = 8'h06;
			3'b111 : decoder_out = 8'h07;
		endcase
	end
end

endmodule:threeBitDecoder
