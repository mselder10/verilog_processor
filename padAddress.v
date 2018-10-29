module padAddress(addressIn, addressOut);

	input[11:0] addressIn;
	output[31:0] addressOut;

	assign addressOut[11:0] = addressIn;
	
	genvar c;
	generate
		for(c=0; c<20; c = c + 1) begin : forLoop
			and	genAnd(addressOut[c+12], 1'b0, 1'b0);
		end
	endgenerate
	
endmodule
