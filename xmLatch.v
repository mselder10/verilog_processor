module xmLatch(clk, en, clr, oResultIn, bDataIn, irIn, oResultOut, bDataOut, irOut);

	input clk, en, clr;
	input[31:0] oResultIn, bDataIn, irIn;
	output[31:0] oResultOut, bDataOut, irOut;
	
	register	executionReg(oResultOut, oResultIn, clk, en, clr);
	register	bReg(bDataOut, bDataIn, clk, en, clr);
	register	irReg(irOut, irIn, clk, en, clr);

endmodule