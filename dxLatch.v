module dxLatch(
	// General inputs
	clk, 
	en, 
	clr, 
	// Address inputs
	TGIn, 
	PCIn, 
	PCplus1plusNIn,
	// Instruction inputs
	insnTypeIn,
	irIn,
	// Data inputs
	aIn, 
	bIn, 
	// Control inputs
	ALUopIn, 
	ALUinBIn, 
	BRIn, 
	BRltIn, 
	JPIn, 
	JRIn, 
	DMweIn, 
	WEIn, 
	RwdIn, 
	jalIn, 
	Rd30In, 
	Rd31In, 
	WTtoRegIn,
	//
	// Address outputs
	TGOut, 
	PCOut, 
	PCplus1plusNOut,
	// Instruction outputs
	insnTypeOut,
	irOut,
	// Data outputs
	aOut, 
	bOut, 
	// Control outputs
	ALUopOut, 
	ALUinBOut, 
	BROut, 
	BRltOut, 
	JPOut, 
	JROut, 
	DMweOut, 
	WEOut, 
	RwdOut, 
	jalOut, 
	Rd30Out, 
	Rd31Out, 
	WTtoRegOut
);

	input clk, en, clr;
	input[11:0] TGIn, PCIn;
	input[31:0] aIn, bIn, irIn;
	input[11:0] TGOut, PCOut;
	output[31:0] aOut, bOut, irOut;
	
	register12	TGReg(TGOut, TGIn, clk, en, clr);
	register12	PCReg(PCOut, PCIn, clk, en, clr);
	register	aReg(aOut, aIn, clk, en, clr);
	register	bReg(bOut, bIn, clk, en, clr);
	register	irReg(irOut, irIn, clk, en, clr);

endmodule
