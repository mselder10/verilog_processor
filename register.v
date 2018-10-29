module register(data_out, data_in, clk, en, clr);

	// Inputs
	input clk, en, clr;
	input [31:0] data_in;
	// Outputs
	output [31:0] data_out;
	
	// Create 32 bit register
	
	dffe_ref	reg0(data_out[0], data_in[0], clk, en, clr);
	dffe_ref	reg1(data_out[1], data_in[1], clk, en, clr);
	dffe_ref	reg2(data_out[2], data_in[2], clk, en, clr);
	dffe_ref	reg3(data_out[3], data_in[3], clk, en, clr);
	dffe_ref	reg4(data_out[4], data_in[4], clk, en, clr);
	dffe_ref	reg5(data_out[5], data_in[5], clk, en, clr);
	dffe_ref	reg6(data_out[6], data_in[6], clk, en, clr);
	dffe_ref	reg7(data_out[7], data_in[7], clk, en, clr);
	dffe_ref	reg8(data_out[8], data_in[8], clk, en, clr);
	dffe_ref	reg9(data_out[9], data_in[9], clk, en, clr);
	dffe_ref	reg10(data_out[10], data_in[10], clk, en, clr);
	dffe_ref	reg11(data_out[11], data_in[11], clk, en, clr);
	dffe_ref	reg12(data_out[12], data_in[12], clk, en, clr);
	dffe_ref	reg13(data_out[13], data_in[13], clk, en, clr);
	dffe_ref	reg14(data_out[14], data_in[14], clk, en, clr);
	dffe_ref	reg15(data_out[15], data_in[15], clk, en, clr);
	dffe_ref	reg16(data_out[16], data_in[16], clk, en, clr);
	dffe_ref	reg17(data_out[17], data_in[17], clk, en, clr);
	dffe_ref	reg18(data_out[18], data_in[18], clk, en, clr);
	dffe_ref	reg19(data_out[19], data_in[19], clk, en, clr);
	dffe_ref	reg20(data_out[20], data_in[20], clk, en, clr);
	dffe_ref	reg21(data_out[21], data_in[21], clk, en, clr);
	dffe_ref	reg22(data_out[22], data_in[22], clk, en, clr);
	dffe_ref	reg23(data_out[23], data_in[23], clk, en, clr);
	dffe_ref	reg24(data_out[24], data_in[24], clk, en, clr);
	dffe_ref	reg25(data_out[25], data_in[25], clk, en, clr);
	dffe_ref	reg26(data_out[26], data_in[26], clk, en, clr);
	dffe_ref	reg27(data_out[27], data_in[27], clk, en, clr);
	dffe_ref	reg28(data_out[28], data_in[28], clk, en, clr);
	dffe_ref	reg29(data_out[29], data_in[29], clk, en, clr);
	dffe_ref	reg30(data_out[30], data_in[30], clk, en, clr);
	dffe_ref	reg31(data_out[31], data_in[31], clk, en, clr);
	
endmodule