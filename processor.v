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
	
	wire[11:0] pcLatchIn, guessedTarget, inTG, outTG, PCoutFD, PCplus1outFD;
	wire[31:0] PCpadded, PCplus1, inirFD, outirFD;
	wire alu1isNEQ, alu1isLT, alu1ovfw, bpTaken;
	
	PCLatch	pcReg(.clk(clock), .en(nisStall), .clr(reset), .PCIn(pcLatchIn), .PCOut(address_imem));
	
	padAddress	padPC(.addressIn(address_imem), .addressOut(PCpadded));
	
	alu	fALU(.data_operandA(32'd1), .data_operandB(PCpadded), .ctrl_ALUopcode(5'd0), .ctrl_shiftamt(5'd0), 
					.data_result(PCplus1), .isNotEqual(alu1isNEQ), .isLessThan(alu1isLT), .overflow(alu1ovfw));
	
	bp	branchPredictor(.clock(clock), .clear(reset), .PC(address_imem), .correctAddress(), .nextPC(), 
							.originalPC(), .guessedWrong(), .guessedTarget(guessedTarget), .taken(bpTaken));
	
	mux2in12	myMux1(.dataA(PCplus1[11:0]), .dataB(guessedTarget), .ctrl(bpTaken), .dataOut(inTG));
	mux2in12	myMux2(.dataA(inTG), .dataB(), .ctrl(), .dataOut(pcLatchIn));
	mux2	myMux3(.dataA(32'b00000000000000000000000000100000), .dataB(q_imem), .ctrl(isStall), .dataOut(inirFD));	// 00000000000000000000000000100000 == nop
	
	/** FD LATCH
	*	Components:
	*		Clock, Enable, Clear, TG, PC, PC + 1, IR
	*/
	
	fdLatch	myFD(.clk(clock), .en(nisStall), .clr(reset), .TGIn(inTG), .PCIn(address_imem), .PCplus1In(PCplus1), 
						.irIn(inirFD), .TGOut(outTG), .PCOut(PCoutFD), .PCplus1Out(PCplus1outFD), .irOut(outirFD));
	
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
	
	output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 
	wire[31:0] immediate, addImmedout, outirDX;
	wire[18:0] insnType;
	wire[1:0] mux4Ctrl;
	wire alu2isNEQ, alu2isLT, alu2ovfw, isStall, nisStall;
	wire Rs30, Rt0, RsIsRd, ALUop, ALUinB, BR, BRlt, JP, JR, DMwe, WE, Rwd, jal, Rd30, Rd31, WTtoReg;
	
	signx	sx(outirFD[16:0], immediate);
	
	alu	dALU(.data_operandA(PCplus1outFD), .data_operandB(immediate), .ctrl_ALUopcode(5'd0), .ctrl_shiftamt(5'd0), 
					.data_result(addImmedout), .isNotEqual(alu2isNEQ), .isLessThan(alu2isLT), .overflow(alu2ovfw));
	
	/* SET UP RS, RT, RD, DATAA, DATAB */
	
	assign mux4Ctrl[0] = Rs30;
	assign mux4Ctrl[1] = RsIsRd;
	
	// RS mux
	mux3in5	myMux4(.dataA(outirFD[21:17]), .dataB(5'd30), .dataC(outirFD[26:22]), .ctrl(mux4Ctrl), .dataOut(ctrl_readRegA));
	
	// RT mux
	mux2in5	myMux5(.dataA(outirFD[16:12]), .dataB(5'd0), .ctrl(Rt0), .dataOut(ctrl_readRegB));
	
	stall	stallMod(.irFD(outirFD), .irDX(outirDX), .isStall(isStall), .nisStall(nisStall));
	
	control ctrlMod(.instruction(outirFD), .instructionType(insnType), .Rs30(Rs30), .Rt0(Rt0), .RsIsRd(RsIsRd), 
						.ALUop(ALUop), .ALUinB(ALUinB), .BR(BR), .BRlt(BRlt), .JP(JP), .JR(JR), .DMwe(DMwe), 
						.WE(WE), .Rwd(Rwd), .jal(jal), .Rd30(Rd30), .Rd31(Rd31), .WTtoReg(WTtoReg));
	
	mux2	myMux6(.dataA(32'b00000000000000000000000000100000), .dataB(outirFD), .ctrl(isStall), .dataOut(outirDX));
	
	
	// DX LATCH
	dxLatch	myDX(clk, en, clr, TGd, PCd, aIn, bIn, ird, TGOut, PCOut, aOut, bOut, irOut);
	
	
	// Execute
	/**
	* Needed:
	* One ALU (dataInA OP dataInB)
	* Mux (7) for dataInA (A output of DX, O output of XM, or writeback value (Mux (10) output), controlled by aluAMuxCtrl from bypass
	* Mux (8) for dataInB (B output of DX, O output of XM, or writeback value), controlled by aluBMuxCtrl from bypass
	* Mux (9) for dataInB (Mux (6) output or PC + Immediate (from D)), controlled by ALUinB
	* Bypass Module
	*/
	
	alu	xALU(.data_operandA(), .data_operandB(), .ctrl_ALUopcode(), .ctrl_shiftamt(), .data_result(), 
	.isNotEqual(), .isLessThan(), .overflow());
	
	mux3	myMux5(.dataA(), .dataB(), .dataC(), .ctrl(), .dataOut());
	mux3	myMux6(.dataA(), .dataB(), .dataC(), .ctrl(), .dataOut());
	mux2	myMux7(.dataA(), .dataB(), .ctrl(), .dataOut());
	
	bypass	bypassMod(.irDX(), .irXM(), .irMW(), .memMuxCtrl(), .aluAMuxCtrl(), .aluBMuxCtrl());
	
	// XM LATCH
	xmLatch	myXM(.clk(clock), .en(), .clr(reset), .oResultIn(), .bDataIn(), .irIn(), .oResultOut(), .bDataOut(), .irOut());
	
	
	// Memory
	/**
	* Needed:
	* dmem
	* Mux (8) for dataInMemB (B output of XM or writeback value), controlled by memMuxCtrl from bypass
	*/
	
	mux2	myMux8(.dataA(), .dataB(), .ctrl(), .dataOut());
	
	// MW LATCH
	mwLatch	myMW(clk, en, clr, xResultIn, memDataIn, irIn, xResultOut, memDataOut, irOut);
	
	
	// Write
	/**
	* Needed:
	* Writeback Muxes -->
	* Mux (9) for writeback value (O output or D output), controlled by Rwd
	* Mux (10) for writeback value (Mux (8) output or PC + 1, controlled by jal
	* rd muxes -->
	* Mux (11) for $rd ($rd or $r31), controlled by Rd31
	* Mux (12) for $rd ($rd or $r30), controlled by MathExcep
	*/
	
	mux2	myMux9(.dataA(), .dataB(), .ctrl(), .dataOut());
	mux2	myMux10(.dataA(), .dataB(), .ctrl(), .dataOut());
	mux2	myMux11(.dataA(), .dataB(), .ctrl(), .dataOut());
	mux2	myMux12(.dataA(), .dataB(), .ctrl(), .dataOut());
	 

endmodule
