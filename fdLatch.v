module fdLatch(clk, en, clr, TGIn, PCIn, PCplus1In, irIn, TGOut, PCOut, PCplus1Out, irOut);

	/**
	* Takes in clock, enable, clear, taken guess of address, PC, PC + 1, and instruction
	* Outputs taken guess of address, PC, PC + 1, and instruction
	*
	*/

	input clk, en, clr;
	input[11:0] TGIn, PCIn, PCplus1In;
	input[31:0] irIn;
	input[11:0] TGOut, PCOut, PCplus1Out;
	output[31:0] irOut;
	
	register12	TGReg(TGOut, TGIn, clk, en, clr);
	register12	PCReg(PCOut, PCIn, clk, en, clr);
	register12	PCPlus1Reg(PCplus1Out, PCplus1In, clk, en, clr);
	register	irReg(irOut, irIn, clk, en, clr);

endmodule