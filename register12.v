module register12(data_out, data_in, clk, en, clr);

	// Inputs
	input clk, en, clr;
	input [11:0] data_in;
	// Outputs
	output [11:0] data_out;
	
	// Create 12 bit register
	
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
	
endmodule
