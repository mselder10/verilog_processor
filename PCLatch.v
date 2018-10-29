module PCLatch(clk, en, clr, PCIn, PCOut);

	input clk, en, clr;
	input[11:0] PCIn;
	output[11:0] PCOut;
	
	register12	PCReg(PCOut, PCIn, clk, en, clr);

endmodule