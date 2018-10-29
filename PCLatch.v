module PCLatch(clk, en, clr, PCIn, PCOut);

	input clk, en, clr;
	input[31:0] PCIn;
	output[31:0] PCOut;
	
	register	PCReg(PCOut, PCIn, clk, en, clr);

endmodule