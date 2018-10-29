module mwLatch(
		// General inputs
		clk, 
		en, 
		clr, 
		// Instruction inputs
		insnTypeIn,
		irIn,
		// Data inputs
		oDataIn, 
		dDataIn,
		// Control inputs
		WEIn,
		RwdIn,
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
		dDataOut,
		// Control outputs
		WEOut,
		RwdOut,
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
	input[31:0] oDataIn, dDataIn;
	
	// Control inputs
	input WEIn, RwdIn, jalIn, Rd30In, Rd31In, WTtoRegIn, MathExcepIn;
	
	// Address inputs
	input[31:0] PCplus1In;
	
	// Instruction outputs
	input[18:0] insnTypeOut;
	input[31:0]	irOut;
	
	// Data outputs
	output[31:0] oDataOut, dDataOut;
	
	// Control outputs
	output WEOut, RwdOut, jalOut, Rd30Out, Rd31Out, WTtoRegOut, MathExcepOut;
	
	// Address outputs
	output[31:0] PCplus1Out;
	
	
	// Instruction registers
	register19	insnTp(.data_out(insnTypeOut), .data_in(insnTypeIn), .clk(clk), .en(en), .clr(clr));
	register	irReg(.data_out(irOut), .data_in(irIn), .clk(clk), .en(en), .clr(clr));
	
	// Data registers
	register	oReg(.data_out(oDataOut), .data_in(oDataIn), .clk(clk), .en(en), .clr(clr));
	register	dReg(.data_out(dDataOut), .data_in(dDataIn), .clk(clk), .en(en), .clr(clr));
	
	// Control DFFs
	dffe_ref	dff1(.q(WEOut), .d(WEIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff2(.q(RwdOut), .d(RwdIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff3(.q(jalOut), .d(jalIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff4(.q(Rd30Out), .d(Rd30In), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff5(.q(Rd31Out), .d(Rd31In), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff6(.q(WTtoRegOut), .d(WTtoRegIn), .clk(clk), .en(en), .clr(clr));
	dffe_ref	dff7(.q(MathExcepOut), .d(MathExcepIn), .clk(clk), .en(en), .clr(clr));

	// Address registers
	register	PCplus1Reg(.data_out(PCplus1Out), .data_in(PCplus1In), .clk(clk), .en(en), .clr(clr));
	
endmodule