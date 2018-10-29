module shiftRby2(dataIn, dataOut);

	input[31:0] dataIn;
	output[31:0] dataOut;
	
	genvar c;
	generate
		for(c=2; c<32; c = c + 1) begin: shiftLoop1
			and	genAnd1(dataOut[c-2], dataIn[c], dataIn[c]);			
		end
	endgenerate
	
	generate
		for(c=31; c>29; c = c - 1) begin: shiftLoop2
			and	genAnd2(dataOut[c], dataIn[31], dataIn[31]);	// Retains MSB
		end
	endgenerate
	
endmodule