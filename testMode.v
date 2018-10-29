module testMode(en, decoded, out);

	// Different from decodeANDwe, since this write to all 32 registers
	
	input en;
	input [31:0] decoded;
	output [31:0] out;
	
	genvar c;
	generate
		for(c=0; c<32; c = c+1) begin: loop1
			and 	and_gate(out[c], en, decoded[c]);
		end
	endgenerate
	
endmodule
