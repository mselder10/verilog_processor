module mux2in5(dataA, dataB, ctrl, dataOut);

	input[4:0] dataA, dataB;
	input ctrl;
	output[4:0] dataOut;
	
	wire nctrl;
	
	// Ctrl == 0, send dataA
	not	aCtrl(nctrl, ctrl);
	tri5	sndA(dataA, nctrl, dataOut);
	
	// Ctrl == 1, send dataB
	tri5	sndB(dataB, ctrl, dataOut);
	
endmodule
