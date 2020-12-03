module decoderTestBench();


logic CLK = 0;

always begin
CLK = ~CLK; #5; //10ns Period
end

logic [2:0]  binary_in ; //  3 bit binary input
logic enable;        //  Enable for the decoder
logic [7:0] decoder_out; //  8-bit out 

threeBitDecoder dut(binary_in, enable, decoder_out);



initial begin
binary_in = 0;
enable = 0;
#20;

binary_in = 3'b001; #10;
enable = 1;#20;

binary_in = 3'b100; #10;
enable = 1;#20;



end

endmodule
