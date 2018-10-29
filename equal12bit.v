module equal12bit(dataA, dataB, isEqual, nisEqual);

	input[11:0] dataA, dataB;
	output isEqual, nisEqual;
	
	wire[11:0] eqBits;
	wire[3:0] andWire;

	genvar c;
	generate
		for(c=0; c<12; c = c + 1) begin: xnorLoop
			xnor	bitwiseEQ(eqBits[c], dataA[c], dataB[c]);
		end
	endgenerate
	
	and	eqAND1(andWire[0], eqBits[0], eqBits[1], eqBits[2]);
	and	eqAND2(andWire[1], eqBits[3], eqBits[4], eqBits[5]);
	and	eqAND3(andWire[2], eqBits[6], eqBits[7], eqBits[8]);
	and	eqAND4(andWire[3], eqBits[9], eqBits[10], eqBits[11]);

	and	eqANDend(isEqual, andWire[0], andWire[1], andWire[2], andWire[3]);
	not	neq(nisEqual, isEqual);
	
endmodule
