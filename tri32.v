module tri32(in, ctrl, out);

	input [31:0] in;
	input ctrl;
	output [31:0] out;
	
	assign out[0] = ctrl ? in[0] : 1'bz;
	assign out[1] = ctrl ? in[1] : 1'bz;
	assign out[2] = ctrl ? in[2] : 1'bz;
	assign out[3] = ctrl ? in[3] : 1'bz;
	assign out[4] = ctrl ? in[4] : 1'bz;
	assign out[5] = ctrl ? in[5] : 1'bz;
	assign out[6] = ctrl ? in[6] : 1'bz;
	assign out[7] = ctrl ? in[7] : 1'bz;
	assign out[8] = ctrl ? in[8] : 1'bz;
	assign out[9] = ctrl ? in[9] : 1'bz;
	assign out[10] = ctrl ? in[10] : 1'bz;
	assign out[11] = ctrl ? in[11] : 1'bz;
	assign out[12] = ctrl ? in[12] : 1'bz;
	assign out[13] = ctrl ? in[13] : 1'bz;
	assign out[14] = ctrl ? in[14] : 1'bz;
	assign out[15] = ctrl ? in[15] : 1'bz;
	assign out[16] = ctrl ? in[16] : 1'bz;
	assign out[17] = ctrl ? in[17] : 1'bz;
	assign out[18] = ctrl ? in[18] : 1'bz;
	assign out[19] = ctrl ? in[19] : 1'bz;
	assign out[20] = ctrl ? in[20] : 1'bz;
	assign out[21] = ctrl ? in[21] : 1'bz;
	assign out[22] = ctrl ? in[22] : 1'bz;
	assign out[23] = ctrl ? in[23] : 1'bz;
	assign out[24] = ctrl ? in[24] : 1'bz;
	assign out[25] = ctrl ? in[25] : 1'bz;
	assign out[26] = ctrl ? in[26] : 1'bz;
	assign out[27] = ctrl ? in[27] : 1'bz;
	assign out[28] = ctrl ? in[28] : 1'bz;
	assign out[29] = ctrl ? in[29] : 1'bz;
	assign out[30] = ctrl ? in[30] : 1'bz;
	assign out[31] = ctrl ? in[31] : 1'bz;
	

endmodule