module xmLatch(
		// General inputs
		clk, 
		en, 
		clr, 
		// Instruction inputs
		insnTypeIn,
		irIn,
		// Data inputs
		oDataIn, 
		bDataIn,
		// Control inputs
		WEIn,
		RwdIn,
		DMweIn,
		jalIn,
		Rd30In,
		Rd31In,
		WTtoRegIn,
		MathExcepIn,
		// Address inputs
		PCplus1In,
		// Instruction outputs
		insnTypeOut,
		irOut,
		// Data outputs
		oDataOut, 
		bDataOut,
		// Control outputs
		WEOut,
		RwdOut,
		DMweOut,
		jalOut,
		Rd30Out,
		Rd31Out,
		WTtoRegOut,
		MathExcepOut,
		// Address outputs
		PCplus1Out
);


	// General inputs
	input clk, en, clr;
	
	// Instruction inputs
	input[18:0] insnTypeIn;
	input[31:0]	irIn;
	
	// Data inputs
	input[31:0] oDataIn, bDataIn;
	
	// Control inputs
	input WEIn, RwdIn, DMweIn, jalIn, Rd30In, Rd31In, WTtoRegIn, MathExcepIn;
	
	// Address inputs
	input[31:0] PCplus1In;
	
	// Instruction outputs
	input[18:0] insnTypeOut;
	input[31:0]	irOut;
	
	// Data outputs
	output[31:0] oDataOut, bDataOut;
	
	// Control outputs
	output WEOut, RwdOut, DMweOut, jalOut, Rd30Out, Rd31Out, WTtoRegOut, MathExcepOut;
	
	// Address outputs
	output[31:0] PCplus1Out;
	
	// Instruction registers
	register19	insnTp(.data_out(insnTypeOut), .data_in(insnTypeIn), .clk(clk), .en(en), .clr(clr));
	register	irReg(.data_out(irOut), .data_in(irIn), .clk(clk), .en(en), .clr(clr));
	
	// Data registers
	register	oReg(.data_out(oDataOut), .data_in(oDataIn), .clk(clk), .en(en), .clr(clr));
	register	bReg(.data_out(bDataOut), .data_in(bDataIn), .clk(clk), .en(en), .clr(clr));
	
	// Control DFFs
	dffe_ref	dff1(.q(DMweOut), .d(DMweIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff2(.q(WEOut), .d(WEIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff3(.q(RwdOut), .d(RwdIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff4(.q(jalOut), .d(jalIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff5(.q(Rd30Out), .d(Rd30In), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff6(.q(Rd31Out), .d(Rd31In), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff7(.q(WTtoRegOut), .d(WTtoRegIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff8(.q(MathExcepOut), .d(MathExcepIn), .clk(clk), .en(en), .clr(clr));
	
	// Address registers
	register	PCplus1Reg(.data_out(PCplus1Out), .data_in(PCplus1In), .clk(clk), .en(en), .clr(clr));
	
endmodule
