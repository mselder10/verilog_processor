module fdLatch(clk, en, clr, TGIn, PCIn, PCplus1In, irIn, TGOut, PCOut, PCplus1Out, irOut);

	/**
	* Takes in clock, enable, clear, taken guess of address, PC, PC + 1, and instruction
	* Outputs taken guess of address, PC, PC + 1, and instruction
	*
	*/

	input clk, en, clr;
	input[31:0] TGIn, PCIn, PCplus1In, irIn;
	output[31:0] TGOut, PCOut, PCplus1Out, irOut;
	
	register	TGReg(TGOut, TGIn, clk, en, clr);
	register	PCReg(PCOut, PCIn, clk, en, clr);
	register	PCPlus1Reg(PCplus1Out, PCplus1In, clk, en, clr);
	register	irReg(irOut, irIn, clk, en, clr);

endmodule