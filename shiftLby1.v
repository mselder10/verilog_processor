module shiftLby1(dataIn, dataOut);

	input[31:0] dataIn;
	output[31:0] dataOut;
	
	genvar c;
	generate
		for(c=30; c>=0; c = c - 1) begin: shiftLoop1
			and	genAnd1(dataOut[c+1], dataIn[c], dataIn[c]);			
		end
	endgenerate
	
	and	genAnd2(dataOut[0], dataIn[0], 1'b0);	// Places zero in 0 index
	
endmodule