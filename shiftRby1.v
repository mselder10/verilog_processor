module shiftRby1(dataIn, dataOut);

	input[31:0] dataIn;
	output[31:0] dataOut;
	
	genvar c;
	generate
		for(c=1; c<32; c = c + 1) begin: shiftLoop1
			and	genAnd1(dataOut[c-1], dataIn[c], dataIn[c]);			
		end
	endgenerate
	
	and	genAnd2(dataOut[31], dataIn[31], dataIn[31]);	// Retains MSB
	
endmodule