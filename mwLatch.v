module mwLatch(clk, en, clr, xResultIn, memDataIn, irIn, xResultOut, memDataOut, irOut);

	input clk, en, clr;
	input[31:0] xResultIn, memDataIn, irIn;
	output[31:0] xResultOut, memDataOut, irOut;
	
	register	executionReg(xResultOut, xResultIn, clk, en, clr);
	register	memReg(memDataOut, memDataIn, clk, en, clr);
	register	irReg(irOut, irIn, clk, en, clr);

endmodule