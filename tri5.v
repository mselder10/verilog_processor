module tri5(in, ctrl, out);

	input [4:0] in;
	input ctrl;
	output [4:0] out;
	
	assign out[0] = ctrl ? in[0] : 1'bz;
	assign out[1] = ctrl ? in[1] : 1'bz;
	assign out[2] = ctrl ? in[2] : 1'bz;
	assign out[3] = ctrl ? in[3] : 1'bz;
	assign out[4] = ctrl ? in[4] : 1'bz;
	
endmodule
