module signx(signedIn, signedOut);

	input[16:0] signedIn;
	output[31:0] signedOut;
	
	assign signedOut[16:0] = signedIn;
	
	genvar c;
	generate
		for(c=17; c<32; c = c + 1) begin: andLoop
			and	assignAnd(signedOut[c], signedIn[16], signedIn[16]);
		end
	endgenerate

endmodule