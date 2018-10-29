module not32(dataIn, dataOut);

	input [31:0] dataIn;
	output [31:0] dataOut;
	
	genvar c;
	generate
		for(c=0; c<32; c = c + 1) begin: notLoop
			not	notIn(dataOut[c], dataIn[c]);
		end
	endgenerate

endmodule