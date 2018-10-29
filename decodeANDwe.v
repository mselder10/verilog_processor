module decodeANDwe(en, decoded, out);

	input en;
	input [31:0] decoded;
	output [31:0] out;

	and 	and_0(out[0], en, 1'b0);				// Set write enable to constant 0 for reg0
	
	genvar c;
	generate
		for(c=1; c<32; c = c+1) begin: loop1
			and 	and_gate(out[c], en, decoded[c]);
		end
	endgenerate
	
endmodule