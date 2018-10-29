module or32(dataA, dataB, dataOut);

	input [31:0] dataA, dataB;
	output [31:0] dataOut;
	
	genvar c;
	generate
		for(c=0; c<32; c = c + 1) begin: orLoop
			or	orAB(dataOut[c], dataA[c], dataB[c]);
		end
	endgenerate

endmodule