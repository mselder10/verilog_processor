module decode5to32(ctrl, out);

	// The outputs of this decoder will be fed into tristate buffers as enables. Only tristates with enables of 1 will pass their bits
	// Each register will have 32 tristate buffers (each one gets the same enable)

	input [4: 0] ctrl;
	output [31:0] out;
	
	wire s0, s1, s2, s3, s4;
	
	not		n0(s0, ctrl[0]);	// The not of the least significant bit
	not		n1(s1, ctrl[1]);
	not		n2(s2, ctrl[2]);
	not		n3(s3, ctrl[3]);
	not		n4(s4, ctrl[4]);	// The not of the most significant bit
	
	and 	a0(out[0], s4, s3, s2, s1, s0);
	and 	a1(out[1], s4, s3, s2, s1, ctrl[0]);
	and 	a2(out[2], s4, s3, s2, ctrl[1], s0);
	and 	a3(out[3], s4, s3, s2, ctrl[1], ctrl[0]);
	and 	a4(out[4], s4, s3, ctrl[2], s1, s0);
	and 	a5(out[5], s4, s3, ctrl[2], s1, ctrl[0]);
	and 	a6(out[6], s4, s3, ctrl[2], ctrl[1], s0);
	and 	a7(out[7], s4, s3, ctrl[2], ctrl[1], ctrl[0]);
	and 	a8(out[8], s4, ctrl[3], s2, s1, s0);
	and 	a9(out[9], s4, ctrl[3], s2, s1, ctrl[0]);
	and 	a10(out[10], s4, ctrl[3], s2, ctrl[1], s0);
	and 	a11(out[11], s4, ctrl[3], s2, ctrl[1], ctrl[0]);
	and 	a12(out[12], s4, ctrl[3], ctrl[2], s1, s0);
	and 	a13(out[13], s4, ctrl[3], ctrl[2], s1, ctrl[0]);
	and 	a14(out[14], s4, ctrl[3], ctrl[2], ctrl[1], s0);
	and 	a15(out[15], s4, ctrl[3], ctrl[2], ctrl[1], ctrl[0]);
	and 	a16(out[16], ctrl[4], s3, s2, s1, s0);
	and 	a17(out[17], ctrl[4], s3, s2, s1, ctrl[0]);
	and 	a18(out[18], ctrl[4], s3, s2, ctrl[1], s0);
	and 	a19(out[19], ctrl[4], s3, s2, ctrl[1], ctrl[0]);
	and 	a20(out[20], ctrl[4], s3, ctrl[2], s1, s0);
	and 	a21(out[21], ctrl[4], s3, ctrl[2], s1, ctrl[0]);
	and 	a22(out[22], ctrl[4], s3, ctrl[2], ctrl[1], s0);
	and 	a23(out[23], ctrl[4], s3, ctrl[2], ctrl[1], ctrl[0]);
	and 	a24(out[24], ctrl[4], ctrl[3], s2, s1, s0);
	and 	a25(out[25], ctrl[4], ctrl[3], s2, s1, ctrl[0]);
	and 	a26(out[26], ctrl[4], ctrl[3], s2, ctrl[1], s0);
	and 	a27(out[27], ctrl[4], ctrl[3], s2, ctrl[1], ctrl[0]);
	and 	a28(out[28], ctrl[4], ctrl[3], ctrl[2], s1, s0);
	and 	a29(out[29], ctrl[4], ctrl[3], ctrl[2], s1, ctrl[0]);
	and 	a30(out[30], ctrl[4], ctrl[3], ctrl[2], ctrl[1], s0);
	and 	a31(out[31], ctrl[4], ctrl[3], ctrl[2], ctrl[1], ctrl[0]);	// the most significant output bit

endmodule