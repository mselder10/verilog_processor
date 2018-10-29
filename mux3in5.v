module mux3in5(dataA, dataB, dataC, ctrl, dataOut);

	input[4:0] dataA, dataB, dataC;
	input[1:0] ctrl;
	output[4:0] dataOut;
	
	wire sendA;
	
	// Ctrl == 0, send dataA
	nor	aCtrl(sendA, ctrl[0], ctrl[1]);
	tri32	sndA(dataA, sendA, dataOut);
	
	// Ctrl == 1, send dataB
	tri32	sndB(dataB, ctrl[0], dataOut);
	
	// Ctrl == 2, send dataC
	tri32	sndC(dataC, ctrl[1], dataOut);
	
endmodule
