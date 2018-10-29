module tri8(inA, inB, ctrl, out);

	input [7:0] inA, inB;
	input ctrl;
	output [7:0] out;
	
	assign out[0] = ctrl ? inA[0] : inB[0];
	assign out[1] = ctrl ? inA[1] : inB[1];
	assign out[2] = ctrl ? inA[2] : inB[2];
	assign out[3] = ctrl ? inA[3] : inB[3];
	assign out[4] = ctrl ? inA[4] : inB[4];
	assign out[5] = ctrl ? inA[5] : inB[5];
	assign out[6] = ctrl ? inA[6] : inB[6];
	assign out[7] = ctrl ? inA[7] : inB[7];
	
endmodule