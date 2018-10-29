module register5(data_out, data_in, clk, en, clr);

	// Inputs
	input clk, en, clr;
	input [4:0] data_in;
	// Outputs
	output [4:0] data_out;
	
	// Create 32 bit register
	
	dffe_ref	reg0(data_out[0], data_in[0], clk, en, clr);
	dffe_ref	reg1(data_out[1], data_in[1], clk, en, clr);
	dffe_ref	reg2(data_out[2], data_in[2], clk, en, clr);
	dffe_ref	reg3(data_out[3], data_in[3], clk, en, clr);
	dffe_ref	reg4(data_out[4], data_in[4], clk, en, clr);
	
endmodule