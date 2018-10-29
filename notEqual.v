module notEqual(dataA, dataB, isNotEqual);

	input [31:0] dataA, dataB;
	output isNotEqual;
	
	// Check if each bit is 0 -> if not, isNotEqual == 1
	
	wire [31:0]	nEq;
	wire [3:0] orWire;
	
	genvar c;
	generate
		for(c=0; c<32; c = c + 1) begin : xorLoop
			xor	xorEQ(nEq[c], dataA[c], dataB[c]);
		end
		for(c=0; c<32; c = c + 8) begin : orLoop
			or	orEQ(orWire[c/8], nEq[c], nEq[c+1], nEq[c+2], nEq[c+3], nEq[c+4], nEq[c+5], nEq[c+6], nEq[c+7]);
		end
	endgenerate
	or	notEqGateEnd(isNotEqual, orWire[0], orWire[1], orWire[2], orWire[3]);
	
	/*	Below would work for equality check based on subtraction output
	genvar c;
	generate
		for(c=0; c<32; c = c + 8) begin : orLoop
			or	orEQ(orWire[c/8], data[c], data[c+1], data[c+2], data[c+3], data[c+4], data[c+5], data[c+6], data[c+7]);
		end
	endgenerate
	or	notEqGateEnd(nEq, orWire[0], orWire[1], orWire[2], orWire[3]);
	not	finalgate(isNotEqual, nEq);
	*/
	
	/*
	or	or1(orWire[0], data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]);
	or	or2(orWire[1], data[8], data[9], data[10], data[11], data[12], data[13], data[14], data[15]);
	or	or3(orWire[2], data[16], data[17], data[18], data[19], data[20], data[21], data[22], data[23]);
	or	or4(orWire[3], data[24], data[25], data[26], data[27], data[28], data[29], data[30], data[31]);
	or	notEqGateEnd(isNotEqual, orWire[0], orWire[1], orWire[2], orWire[3]);
	//not	finalgate(isNotEqual, nEq);
	*/
	
endmodule