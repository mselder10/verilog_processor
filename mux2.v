module mux2(dataA, dataB, ctrl, dataOut);

	input[31:0] dataA, dataB;
	input ctrl;
	output[31:0] dataOut;
	
	wire nctrl;
	
	// Ctrl == 0, send dataA
	not	aCtrl(nctrl, ctrl);
	tri32	sndA(dataA, nctrl, dataOut);
	
	// Ctrl == 1, send dataB
	tri32	sndB(dataB, ctrl, dataOut);
	
endmodule
