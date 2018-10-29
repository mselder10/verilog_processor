/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as processor.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 
	 // Fetch
	/**
	* Needed:
	* imem --> instantiated in skeleton
	* PC register
	* One ALU (PC + 1)
	* Branch Predictor Module
	* Mux (1) btw BP output and ALU output, controlled by BP taken bit
	* Mux (2) btw Mux (1) output and later branch logic output, controlled by equality of guessed vs. actual branch
	* Mux (3) btw imem output and nop, controlled by equality of guessed vs. actual branch (flush/stall logic)
	*/
	
	wire[11:0] guessedTarget;
	wire[31:0] pcLatchIn, pcLatchOut, PCplus1, PCplus1outFD, inirFD, outirFD, Targetpadded, inFDTG, outFDTG, PCoutFD;
	wire alu1isNEQ, alu1isLT, alu1ovfw, bpTaken, guessedRight, guessedWrong, flushCtrl;
	
	PCLatch	pcReg(.clk(clock), .en(nisStall), .clr(reset), .PCIn(pcLatchIn), .PCOut(pcLatchOut));
	
	assign address_imem = pcLatchOut[11:0];
	
	alu	fALU(.data_operandA(32'd1), .data_operandB(pcLatchOut), .ctrl_ALUopcode(5'd0), .ctrl_shiftamt(5'd0), 
					.data_result(PCplus1), .isNotEqual(alu1isNEQ), .isLessThan(alu1isLT), .overflow(alu1ovfw));
	
	bp	branchPredictor(.clock(clock), .clear(reset), .PC(address_imem), .correctAddress(jumpMuxOut[11:0]), 
							.nextPC(PCplus1outDX[11:0]), .originalPC(PCoutDX[11:0]), .guessedWrong(guessedWrong), 
							.guessedTarget(guessedTarget), .taken(bpTaken));
	
	padAddress	padPC(.addressIn(guessedTarget), .addressOut(Targetpadded));
	
	// Create flush ctrl : OR(isStall, guessedWrong)
	
	or	nopOR(flushCtrl, isStall, guessedWrong);
	
	mux2	myMux1(.dataA(PCplus1), .dataB(Targetpadded), .ctrl(bpTaken), .dataOut(inFDTG));
	mux2	myMux2(.dataA(jumpMuxOut), .dataB(inFDTG), .ctrl(guessedRight), .dataOut(pcLatchIn));
	mux2	myMux3(.dataA(32'b00000000000000000000000000100000), .dataB(q_imem), .ctrl(flushCtrl), .dataOut(inirFD));	// 00000000000000000000000000100000 == nop
	
	/** FD LATCH
	*	Components:
	*		Clock, Enable, Clear, TG, PC, PC + 1, IR
	*/
	
	fdLatch	myFD(.clk(clock), .en(nisStall), .clr(reset), .TGIn(inFDTG), .PCIn(address_imem), .PCplus1In(PCplus1), 
						.irIn(inirFD), .TGOut(outFDTG), .PCOut(PCoutFD), .PCplus1Out(PCplus1outFD), .irOut(outirFD));
	
	// Decode	
	/**
	* Needed:
	* One ALU ((PC + 1) + Immediate)
	* Regfile Module --> Instantiated in skeleton
	* Stall Module
	* Control Module
	* Mux (4) btw RS portion of IR, constant 30, and RD portion of IR, controlled by Rs30 and RsIsRd
	* Mux (5) btw RT portion of IR and constant 0, controlled by Rt0
	* Mux (6) btw IR output of FD latch and nop, controlled by equality of guessed vs. actual branch (flush/stall logic)
	*/
	 
	wire[31:0] immediate, addImmedout, inirDX, outirDX, PCplus1outDX, PCImmedDX, dataAdxOut, dataBdxOut, outDXTG, PCoutDX;
	wire[18:0] insnType, insnTypeDXOut;
	wire[1:0] mux4Ctrl, mux5Ctrl;
	wire alu2isNEQ, alu2isLT, alu2ovfw, isStall, nisStall;
	wire Rs30, Rt0, RtIsRd, RsIsRd, ALUop, ALUinB, BR, BRlt, JP, JR, DMwe, WE, Rwd, jal, Rd30, Rd31, WTtoReg;
	
	signx	sx1(outirFD[16:0], immediate);
	
	alu	dALU(.data_operandA(PCplus1outFD), .data_operandB(immediate), .ctrl_ALUopcode(5'd0), .ctrl_shiftamt(5'd0), 
					.data_result(addImmedout), .isNotEqual(alu2isNEQ), .isLessThan(alu2isLT), .overflow(alu2ovfw));
	
	/* SET UP RS, RT, RD, DATAA, DATAB */
	
	assign mux4Ctrl[0] = Rs30;
	assign mux4Ctrl[1] = RsIsRd;
	assign mux5Ctrl[0] = Rt0;
	assign mux5Ctrl[1] = RtIsRd;
	
	// RS mux
	mux3in5	myMux4(.dataA(outirFD[21:17]), .dataB(5'd30), .dataC(outirFD[26:22]), .ctrl(mux4Ctrl), .dataOut(ctrl_readRegA));
	
	// RT mux
	mux3in5	myMux5(.dataA(outirFD[16:12]), .dataB(5'd0), .dataC(outirFD[26:22]), .ctrl(Rt0), .dataOut(ctrl_readRegB));
	
	stall	stallMod(.irFD(outirFD), .irDX(outirDX), .isStall(isStall), .nisStall(nisStall));
	
	control ctrlMod(.instruction(outirFD), .instructionType(insnType), .Rs30(Rs30), .Rt0(Rt0), .RtIsRd(RtIsRd),
						.RsIsRd(RsIsRd), .ALUop(ALUop), .ALUinB(ALUinB), .BR(BR), .BRlt(BRlt), .JP(JP), .JR(JR), .DMwe(DMwe), 
						.WE(WE), .Rwd(Rwd), .jal(jal), .Rd30(Rd30), .Rd31(Rd31), .WTtoReg(WTtoReg));
	
	mux2	myMux6(.dataA(32'b00000000000000000000000000100000), .dataB(outirFD), .ctrl(flushCtrl), .dataOut(inirDX));
	
	wire[4:0] ALUopDX;
	wire ALUinBDX, BRDX, BRltDX, JPDX, JRDX, DMweDX, WEDX, RwdDX, jalDX, Rd30DX, Rd31DX, WTtoRegDX;
	
	// DX LATCH
	dxLatch	myDX(.clk(clock), .en(1'b1), .clr(reset), 
				// Address inputs
				.TGIn(outFDTG), .PCIn(PCoutFD), .PCplus1In(PCplus1outFD), .PCplus1plusNIn(addImmedout), 
				// Insn Info inputs
				.insnTypeIn(insnType), .irIn(inirDX), 
				// Data inputs
				.aIn(data_readRegA), .bIn(data_readRegB), 
				// Control inputs
				.ALUopIn(ALUop), .ALUinBIn(ALUinB), .BRIn(BR), .BRltIn(BRlt), .JPIn(JP), .JRIn(JR), .DMweIn(DMwe), 
				.WEIn(WE), .RwdIn(Rwd), .jalIn(jal), .Rd30In(Rd30), .Rd31In(Rd31), .WTtoRegIn(WTtoReg), 
				// Address outputs
				.TGOut(outDXTG), .PCOut(PCoutDX), .PCplus1Out(PCplus1outDX), .PCplus1plusNOut(PCImmedDX), 
				// Insn info outputs
				.insnTypeOut(insnTypeDXOut), .irOut(outirDX), 
				// Data outputs
				.aOut(dataAdxOut), .bOut(dataBdxOut), 
				// Control outputs
				.ALUopOut(ALUopDX), .ALUinBOut(ALUinBDX), .BROut(BRDX), .BRltOut(BRltDX), .JPOut(JPDX), .JROut(JRDX), 
				.DMweOut(DMweDX), .WEOut(WEDX), .RwdOut(RwdDX), .jalOut(jalDX), .Rd30Out(Rd30DX), .Rd31Out(Rd31DX), 
				.WTtoRegOut(WTtoRegDX));
	
	
	// Execute
	/**
	* Needed:
	* One ALU (dataInA OP dataInB)
	* Mux (7) for dataInA (A output of DX, O output of XM, or writeback value (Mux (10) output), controlled by aluAMuxCtrl from bypass
	* Mux (8) for dataInB (B output of DX, O output of XM, or writeback value), controlled by aluBMuxCtrl from bypass
	* Mux (9) for dataInB (Mux (8) output or SX Immediate), controlled by ALUinB
	* Mux (10) btw PC + 1 and PC + 1 + N, controlled by BR or BRlt
	* Mux (11) btw output of Mux (10) and T, controlled by JP
	* Mux (12) btw output of Mux (11) and RS data, controlled by JR
	*
	* Bypass Module
	*/
	
	wire alu3isNEQ, alu3isLT, alu3ovfw;
	wire[1:0] aluAMuxCtrl, aluBMuxCtrl, branchctrl, jumpCtrl;
	wire[18:0] insnTypeXMOut;
	wire[31:0] outirXM, dataInA, dataInMux9, dataInB, Ximmediate, aluXOut, dataOOutXM, dataBOutXM, T32bits, branchMuxOut, 
				jumpMuxOut;
	
	signx	sx2(outirDX[16:0], Ximmediate);
	
	// Muxes for data inputs to ALU
	
	mux3	myMux7(.dataA(dataAdxOut), .dataB(dataOOutXM), .dataC(data_writeReg), .ctrl(aluAMuxCtrl), .dataOut(dataInA));
	mux3	myMux8(.dataA(dataBdxOut), .dataB(dataOOutXM), .dataC(data_writeReg), .ctrl(aluBMuxCtrl), .dataOut(dataInMux9));
	mux2	myMux9(.dataA(dataInMux9), .dataB(Ximmediate), .ctrl(ALUinBDX), .dataOut(dataInB));
	
	alu	xALU(.data_operandA(dataInA), .data_operandB(dataInB), .ctrl_ALUopcode(ALUopDX), .ctrl_shiftamt(outirDX[11:7]), 
					.data_result(aluXOut), .isNotEqual(alu3isNEQ), .isLessThan(alu3isLT), .overflow(alu3ovfw));
	
	bypass	bypassMod(.irDX(outirDX), .irXM(outirXM), .irMW(outirMW), .memMuxCtrl(memMuxCtrl), .aluAMuxCtrl(aluAMuxCtrl), 
							.aluBMuxCtrl(aluBMuxCtrl));
							
	// Set up for branch / jump decisions
	
	assign T32bits[26:0] = outirDX;
	assign T32bits[31:27] = PCplus1outDX[31:27];
	
	and	brAND1(branchctrl[0], BRDX, alu3isNEQ);
	and	brAND2(branchctrl[1], BRltDX, alu3isLT);
	
	assign jumpCtrl[0] = JPDX;
	assign jumpCtrl[1] = JRDX;
	
	// Branching / jumping muxes
	mux3	myMux10(.dataA(PCplus1outDX), .dataB(PCImmedDX), .dataC(PCImmedDX), .ctrl(branchctrl), .dataOut(branchMuxOut));
	mux3	myMux11(.dataA(branchMuxOut), .dataB(T32bits), .dataC(dataInA), .ctrl(jumpCtrl), .dataOut(jumpMuxOut));
	
	// Feedback to branch predictor
	equal12bit	guessEq(.dataA(jumpMuxOut[11:0]), .dataB(outDXTG[11:0]), .isEqual(guessedRight), .nisEqual(guessedWrong));
	
	wire WEXM, RwdXM, DMweXM, jalXM, Rd30XM, Rd31XM, WTtoRegXM, MathExcepXM;
	wire[31:0] PCplus1outXM;
	
	// XM LATCH
	xmLatch	myXM(.clk(clock), .en(1'b1), .clr(reset),
			// Insn inputs
			.insnTypeIn(insnTypeDXOut), .irIn(outirDX),
			// Data inputs
			.oDataIn(aluXOut), .bDataIn(dataInMux9),
			// Control inputs
			.WEIn(WEDX), .RwdIn(RwdDX), .DMweIn(DMweDX), .jalIn(jalDX), .Rd30In(Rd30DX), .Rd31In(Rd31DX), 
			.WTtoRegIn(WTtoRegDX), .MathExcepIn(alu3ovfw),
			// Address inputs
			.PCplus1In(PCplus1outDX),
			// Insn outputs
			.insnTypeOut(insnTypeXMOut), .irOut(outirXM),
			// Data outputs
			.oDataOut(dataOOutXM), .bDataOut(dataBOutXM),
			// Control outputs
			.WEOut(WEXM), .RwdOut(RwdXM), .DMweOut(DMweXM), .jalOut(jalXM), .Rd30Out(Rd30XM), .Rd31Out(Rd31XM), 
			.WTtoRegOut(WTtoRegXM), .MathExcepOut(MathExcepXM),
			// Address outputs
			.PCplus1Out(PCplus1outXM));
	
	// Memory
	/**
	* Needed:
	* dmem
	* Mux (13) for dataInMemB (B output of XM or writeback value), controlled by memMuxCtrl from bypass
	*/
	
	assign address_dmem = dataOOutXM[11:0];
	assign wren = DMweXM;
	
	mux2	myMux13(.dataA(dataBOutXM), .dataB(data_writeReg), .ctrl(memMuxCtrl), .dataOut(data));
	
	// MW LATCH
	
	wire WEMW, RwdMW, jalMW, Rd30MW, Rd31MW, WTtoRegMW, MathExcepMW;
	wire[18:0] insnTypeMWOut;
	wire[31:0] outirMW, oDataOutMW, dDataOutMW, PCplus1outMW;
	
	mwLatch	myMW(.clk(clock), .en(1'b1), .clr(reset),
			// Insn inputs
			.insnTypeIn(insnTypeXMOut), .irIn(outirXM),
			// Data inputs
			.oDataIn(dataOOutXM), .dDataIn(q_dmem),
			// Control inputs
			.WEIn(WEXM), .RwdIn(RwdXM), .jalIn(jalXM), .Rd30In(Rd30XM), .Rd31In(Rd31XM), .WTtoRegIn(WTtoRegXM), 
			.MathExcepIn(MathExcepXM),
			// Address inputs
			.PCplus1In(PCplus1outXM),
			// Insn outputs
			.insnTypeOut(insnTypeMWOut), .irOut(outirMW),
			// Data outputs
			.oDataOut(oDataOutMW), .dDataOut(dDataOutMW),
			// Control outputs
			.WEOut(WEMW), .RwdOut(RwdMW), .jalOut(jalMW), .Rd30Out(Rd30MW), .Rd31Out(Rd31MW), .WTtoRegOut(WTtoRegMW), 
			.MathExcepOut(MathExcepMW),
			// Address outputs
			.PCplus1Out(PCplus1outMW));
	
	
	// Write
	/**
	* Needed:
	* Writeback Muxes -->
	* Mux (14) for writeback value (O output or D output), controlled by Rwd
	* Mux (15) for writeback value (Mux (14) output or PC + 1, controlled by jal
	* Mux (16) for writeback value (Mux (15) output or 1)
	* Mux (17) for writeback value (Mux (16) output or 2)
	* Mux (18) for writeback value (Mux (17) output or 3)
	* Mux (19) for writeback value (Mux (18) output or 4)
	* Mux (20) for writeback value (Mux (19) output or 5)
	* rd muxes -->
	* Mux (21) for $rd ($rd or $r31), controlled by Rd31
	* Mux (22) for $rd (Mux (16) or $r30), controlled by Rd30 or MathExcep
	*/
	wire[4:0] excepType;
	
	// Add and exception
	and	exAnd1(excepType[0], insnTypeMWOut[0], MathExcepMW);
	
	// Addi and exception
	and	exAnd2(excepType[1], insnTypeMWOut[1], MathExcepMW);
	
	// Sub and exception
	and	exAnd3(excepType[2], insnTypeMWOut[2], MathExcepMW);

	// Mul and exception ?
	and	exAnd4(excepType[3], insnTypeMWOut[7], MathExcepMW);
	
	// Div and exception ?
	and	exAnd5(excepType[4], insnTypeMWOut[8], MathExcepMW);
	 
	assign ctrl_writeEnable = WEMW;
	
	wire[31:0] wtbackMux1, wtbackMux2, wtbackMux3, wtbackMux4, wtbackMux5, wtbackMux6, wtbackMux7;
	wire[4:0] wRegMux1;
	wire sendto30;
	
	or	wrt30(sendto30, Rd30MW, MathExcepMW);
	
	// Typical writeback muxes
	
	mux2	myMux14(.dataA(oDataOutMW), .dataB(dDataOutMW), .ctrl(RwdMW), .dataOut(wtbackMux1));
	mux2	myMux15(.dataA(wtbackMux1), .dataB(PCplus1outMW), .ctrl(jalMW), .dataOut(wtbackMux2));
	
	// Muxes for sending exception data
	
	mux2	myMux16(.dataA(wtbackMux2), .dataB(32'd1), .ctrl(excepType[0]), .dataOut(wtbackMux3));
	mux2	myMux17(.dataA(wtbackMux3), .dataB(32'd2), .ctrl(excepType[1]), .dataOut(wtbackMux4));
	mux2	myMux18(.dataA(wtbackMux4), .dataB(32'd3), .ctrl(excepType[2]), .dataOut(wtbackMux5));
	mux2	myMux19(.dataA(wtbackMux5), .dataB(32'd4), .ctrl(excepType[3]), .dataOut(wtbackMux6));
	mux2	myMux20(.dataA(wtbackMux6), .dataB(32'd5), .ctrl(excepType[4]), .dataOut(wtbackMux7));
	
	assign data_writeReg = wtbackMux7;
	
	// $rd muxes
	
	mux2	myMux21(.dataA(outirMW[26:22]), .dataB(5'd31), .ctrl(Rd31MW), .dataOut(wRegMux1));
	mux2	myMux22(.dataA(wRegMux1), .dataB(5'd30), .ctrl(sendto30), .dataOut(ctrl_writeReg));
	 

endmodule
