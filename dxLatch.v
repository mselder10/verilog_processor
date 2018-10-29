module dxLatch(
	// General inputs
	clk, 
	en, 
	clr, 
	// Address inputs
	TGIn, 
	PCIn, 
	PCplus1In,
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
	PCplus1Out,
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

	// General inputs
	input clk, en, clr;
	
	// Address inputs
	input[31:0] TGIn, PCIn, PCplus1In, PCplus1plusNIn;
	
	// Instruction inputs
	input[18:0] insnTypeIn;
	input[31:0] irIn;
	
	// Data inputs
	input[31:0] aIn, bIn;
	
	// Control inputs
	input[4:0] ALUopIn;
	input ALUinBIn, BRIn, BRltIn, JPIn, JRIn, DMweIn, WEIn, RwdIn, jalIn, Rd30In, Rd31In, WTtoRegIn;
	
	// Address outputs
	output[31:0] TGOut, PCOut, PCplus1Out, PCplus1plusNOut;
	
	// Instruction outputs
	output[18:0] insnTypeOut;
	output[31:0] irOut;
	
	// Data outputs
	output[31:0] aOut, bOut;
	
	// Control outputs
	output[4:0] ALUopOut;
	output ALUinBOut, BROut, BRltOut, JPOut, JROut, DMweOut, WEOut, RwdOut, jalOut, Rd30Out, Rd31Out, WTtoRegOut;
	
	
	// Addresses
	register	TGReg(.data_out(TGOut), .data_in(TGIn), .clk(clk), .en(en), .clr(clr));
	register	PCReg(.data_out(PCOut), .data_in(PCIn), .clk(clk), .en(en), .clr(clr));
	register	PCplus1Reg(.data_out(PCplus1Out), .data_in(PCplus1In), .clk(clk), .en(en), .clr(clr));
	register	PCplusNReg(.data_out(PCplus1plusNOut), .data_in(PCplus1plusNIn), .clk(clk), .en(en), .clr(clr));
	
	// Instructions
	register	irReg(.data_out(irOut), .data_in(irIn), .clk(clk), .en(en), .clr(clr));
	register19	insnTp(.data_out(insnTypeOut), .data_in(insnTypeIn), .clk(clk), .en(en), .clr(clr));
	
	// Data
	register	aReg(.data_out(aOut), .data_in(aIn), .clk(clk), .en(en), .clr(clr));
	register	bReg(.data_out(bOut), .data_in(bIn), .clk(clk), .en(en), .clr(clr));
	
	// Control
	register5	alu(.data_out(ALUopOut), .data_in(ALUopIn), .clk(clk), .en(en), .clr(clr));
	
	dffe_ref	dff1(.q(ALUinBOut), .d(ALUinBIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff2(.q(BROut), .d(BRIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff3(.q(BRltOut), .d(BRltIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff4(.q(JPOut), .d(JPIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff5(.q(JROut), .d(JRIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff6(.q(DMweOut), .d(DMweIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff7(.q(WEOut), .d(WEIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff8(.q(RwdOut), .d(RwdIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff9(.q(jalOut), .d(jalIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff10(.q(Rd30Out), .d(Rd30In), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff11(.q(Rd31Out), .d(Rd31In), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff12(.q(WTtoRegOut), .d(WTtoRegIn), .clk(clk), .en(en), .clr(clr));

endmodule
