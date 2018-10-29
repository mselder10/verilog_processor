module barrelShiftR(dataIn, shiftamt, dataOut);

	input [31:0] dataIn;
	input [4:0] shiftamt;
	output [31:0] dataOut;

	wire[31:0] sftMod16, sftMod8, sftMod4, sftMod2, sftMod1,
					mux16, mux8, mux4, mux2;
	wire[4:0] notShift;
	
	// not each shift bit (for tristate)
	
	not	not0(notShift[0], shiftamt[0]);
	not	not1(notShift[1], shiftamt[1]);
	not	not2(notShift[2], shiftamt[2]);
	not	not3(notShift[3], shiftamt[3]);
	not	not4(notShift[4], shiftamt[4]);
	
	// Instantiate each shift module and tristate buffers
	shiftRby16	sht16(dataIn, sftMod16);
	tri32	mux16tri1(sftMod16, shiftamt[4], mux16);
	tri32	mux16tri2(dataIn, notShift[4], mux16);
	
	shiftRby8	sht8(mux16, sftMod8);
	tri32	mux8tri1(sftMod8, shiftamt[3], mux8);
	tri32	mux8tri2(mux16, notShift[3], mux8);
	
	shiftRby4	sht4(mux8, sftMod4);
	tri32	mux4tri1(sftMod4, shiftamt[2], mux4);
	tri32	mux4tri2(mux8, notShift[2], mux4);
	
	shiftRby2	sht2(mux4, sftMod2);
	tri32	mux2tri1(sftMod2, shiftamt[1], mux2);
	tri32	mux2tri2(mux4, notShift[1], mux2);
	
	shiftRby1	sht1(mux2, sftMod1);
	tri32	mux1tri1(sftMod1, shiftamt[0], dataOut);
	tri32	mux1tri2(mux2, notShift[0], dataOut);
	
endmodule