module shiftLby2(dataIn, dataOut);

	input[31:0] dataIn;
	output[31:0] dataOut;
	
	genvar c;
	generate
		for(c=29; c>=0; c = c - 1) begin: shiftLoop1
			and	genAnd1(dataOut[c+2], dataIn[c], dataIn[c]);			
		end
	endgenerate
	
	generate
		for(c=0; c<2; c = c + 1) begin: shiftLoop2
			and	genAnd2(dataOut[c], dataIn[c], 1'b0);	// Places zeros wherever data was
		end
	endgenerate
	
endmodule