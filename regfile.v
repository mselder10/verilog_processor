module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;
   
	wire [31:0] writeDecode, WE, readDecodeA, readDecodeB;
				
	// WRITE PORT
	
	decode5to32 dcW(ctrl_writeReg, writeDecode);
	decodeANDwe decoder(ctrl_writeEnable, writeDecode, WE);
	
	// READ PORTS
	
	decode5to32 dcRA(ctrl_readRegA, readDecodeA);
	decode5to32 rcRB(ctrl_readRegB, readDecodeB);
	
	// Instantiate 32 registers
	
	genvar c;
	generate
		for(c=0; c<32; c = c+1) begin: loop1
			wire [31:0] regOut;
			register	register(regOut, data_writeReg, clock, WE[c], ctrl_reset);
			// Send output to two tristate buffer sections for R1 and R2
			tri32 		triReadA(regOut, readDecodeA[c], data_readRegA);
			tri32 		triReadB(regOut, readDecodeB[c], data_readRegB);
		end
	endgenerate

endmodule
