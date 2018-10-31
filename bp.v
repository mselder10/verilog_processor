module bp(

	clock,
	clear,
	// Current PC
	PC,
	// Final branch logic output
	correctAddress,
	// Default PC + 1 value
	nextPC, 
	// PC at the time of fetching
	originalPC,
	// Was prediction wrong?
	guessedWrong, 
	// Predicted target
	guessedTarget, 
	// Predicted direction
	taken
);

	input[11:0] PC, correctAddress, nextPC, originalPC;
	input clock, clear, guessedWrong;
	output[11:0] guessedTarget;
	output taken;
	
	wire isNextPC, nisNextPC;
	wire[31:0] WE, writeDecode, readDecode;
	
	/*
	* Information needed for write port:
	* 	write enable --> output of equality module
	* 	PC (at time of this fetch, for indexing the write)
	* 	Correct address
	* 	PC + 1 (if correct address == PC + 1, set direction bit to not taken
	*
	*	Given the correct next address is not equal to the guessed address, there are three options:
	*		1. Guess was taken, should have been not taken (PC + 1) --> write to direction bit
	*		2. Guess was taken (good), but the branch address was wrong --> write to address bits
	*		3. Guess was wrong in some other way --> write to both direction and address bits
	*		Generally, in module, check if Correct address == PC + 1
	*			If so, set taken to 0 (address doesn't really matter
	*			Else, set taken to 1 and write correct address to address bits
	*/

	// Check if correctAddress == nextPC : if so, write 0 to taken
	
	equal12bit	eqCheck(.dataA(correctAddress), .dataB(nextPC), .isEqual(isNextPC), .nisEqual(nisNextPC));
	//not	neq(nisNextPC, isNextPC);
	
	/**
	* ARRAY PORTION OF BRANCH PREDICTOR - REGFILE FORMAT
	* One read port
	* One write port
	*/
	
	// WRITE PORT
	
	decode5to32	dcWrite(.ctrl(originalPC[4:0]), .out(writeDecode));
	decodeANDweBP	decoder(.en(guessedWrong), .decoded(writeDecode), .out(WE));
	
	// READ PORT
	decode5to32	dcRead(.ctrl(PC[4:0]), .out(readDecode));
	
	// Instantiate 32 registers and dffes
	// Index these with 5 bits
	
	genvar c;
	generate
		for(c=0; c<32; c = c+1) begin: regLoop
			wire [11:0] writtenAddress;
			wire takenBit;
			register12	addresses(.data_out(writtenAddress), .data_in(correctAddress), .clk(clock), 
											.en(WE[c]), .clr(clear));
			
			dffe_ref		tknBit(.q(takenBit), .d(nisNextPC), .clk(clock), .en(WE[c]), .clr(clear));
			
			// Send output to tristate buffer section for address read
			tri12		triRead(.in(writtenAddress), .ctrl(readDecode[c]), .out(guessedTarget));
			assign	taken = readDecode[c] ? takenBit : 1'bz;
		end
	endgenerate
	
endmodule
