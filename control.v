module control(

	// Creates instruction based controls for various muxes throughout processor

	// Input to module
	instruction, 
	
	// Array of bits to signify instruction type
	instructionType,
	
	// D controls
	Rs30,
	Rt0,
	RtIsRd,
	RtIsRs,
	RsIsRd,
	
	// X controls
	ALUop,
	ALUinB,
	BR,
	BRlt,
	JP,
	JR,
	
	// M controls
	DMwe,
	
	// W controls
	WE,
	Rwd,
	jal,
	Rd30,
	Rd31,
	WTtoReg
	
	);
	
	// Input to module
	input[31:0] instruction;
	
	// 18 bits to uniquely signify instruction type
	output[18:0] instructionType;
	
	// D controls
	output Rs30, Rt0, RtIsRd, RtIsRs, RsIsRd;
	
	// X controls
	output[4:0] ALUop;
	output ALUinB,	BR, BRlt, JP, JR;
	
	// M controls
	output DMwe;
	
	// W controls
	output WE, Rwd, jal, Rd30,	Rd31,	WTtoReg;

	wire[4:0] notOp, notALUOp;
	wire[10:0] opOption;
	wire[8:0] aluOption;
	wire[4:0] aluMux;
	wire notMD;
	
	// Not of ALU/opcode bits
	genvar c;
	generate
		for(c=0; c<5; c = c + 1) begin: notLoop
			not	not0(notOp[c], instruction[c + 27]);
			not	not1(notALUOp[c], instruction[c + 2]);
		end
	endgenerate
	
	/* BUILD INSTRUCTION TYPE OUTPUT */
	// Generate descriptor bits for opcode
	
	and	and0(opOption[0], notOp[4], notOp[3], notOp[2], notOp[1], notOp[0]);	// Opcode is 00000 --> only WE is high, ALU op = instruction[6:2]
	and	and1(opOption[1], notOp[4], notOp[3], notOp[2], notOp[1], instruction[27]);	// Opcode is 00001
	and	and2(opOption[2], notOp[4], notOp[3], notOp[2], instruction[28], notOp[0]);	// Opcode is 00010	
	and	and3(opOption[3], notOp[4], notOp[3], notOp[2], instruction[28], instruction[27]);	// Opcode is 00011
	and	and4(opOption[4], notOp[4], notOp[3], instruction[29], notOp[1], notOp[0]);	// Opcode is 00100
	and	and5(opOption[5], notOp[4], notOp[3], instruction[29], notOp[1], instruction[27]);	// Opcode is 00101	
	and	and6(opOption[6], notOp[4], notOp[3], instruction[29], instruction[28], notOp[0]);	// Opcode is 00110
	and	and7(opOption[7], notOp[4], notOp[3], instruction[29], instruction[28], instruction[27]);	// Opcode is 00111
	and	and8(opOption[8], notOp[4], instruction[30], notOp[2], notOp[1], notOp[0]);	// Opcode is 01000
	and	and9(opOption[9], instruction[31], notOp[3], instruction[29], notOp[1], instruction[27]);	// Opcode is 10101
	and	and10(opOption[10], instruction[31], notOp[3], instruction[29], instruction[28], notOp[0]);	// Opcode is 10110
	

	// Generate descriptor bits for ALUopcode
	
	and	and11(aluOption[0], notALUOp[4], notALUOp[3], notALUOp[2], notALUOp[1], notALUOp[0]);	// ALUOpcode is 00000
	and	and12(aluOption[1], notALUOp[4], notALUOp[3], notALUOp[2], notALUOp[1], instruction[2]);	// ALUOpcode is 00001
	and	and13(aluOption[2], notALUOp[4], notALUOp[3], notALUOp[2], instruction[3], notALUOp[0]);	// ALUOpcode is 00010	
	and	and14(aluOption[3], notALUOp[4], notALUOp[3], notALUOp[2], instruction[3], instruction[2]);	// ALUOpcode is 00011
	and	and15(aluOption[4], notALUOp[4], notALUOp[3], instruction[4], notALUOp[1], notALUOp[0]);	// ALUOpcode is 00100
	and	and16(aluOption[5], notALUOp[4], notALUOp[3], instruction[4], notALUOp[1], instruction[2]);	// ALUOpcode is 00101	
	and	and17(aluOption[6], notALUOp[4], notALUOp[3], instruction[4], instruction[3], notALUOp[0]);	// ALUOpcode is 00110
	and	and18(aluOption[7], notALUOp[4], notALUOp[3], instruction[4], instruction[3], instruction[2]);	// ALUOpcode is 00111
	and	and19(aluOption[8], notALUOp[4], instruction[5], notALUOp[2], notALUOp[1], notALUOp[0]);	// ALUOpcode is 01000
	
	
	// Use descriptor bits to generate instructionType
	and	insnAnd0(instructionType[0], opOption[0], aluOption[0]);	// add
	assign instructionType[1] = opOption[5];	// addi
	and	insnAnd2(instructionType[2], opOption[0], aluOption[1]);	// sub
	and	insnAnd3(instructionType[3], opOption[0], aluOption[2]);	// and
	and	insnAnd4(instructionType[4], opOption[0], aluOption[3]);	// or
	and	insnAnd5(instructionType[5], opOption[0], aluOption[4]);	// sll
	and	insnAnd6(instructionType[6], opOption[0], aluOption[5]);	// sra
	and	insnAnd7(instructionType[7], opOption[0], aluOption[6]);	// mul
	and	insnAnd8(instructionType[8], opOption[0], aluOption[7]);	// div
	assign instructionType[9] = opOption[7];	// sw
	assign instructionType[10] = opOption[8];	// lw
	assign instructionType[11] = opOption[1];	// j
	assign instructionType[12] = opOption[2];	// bne
	assign instructionType[13] = opOption[3];	// jal
	assign instructionType[14] = opOption[4];	// jr
	assign instructionType[15] = opOption[6];	// blt
	assign instructionType[16] = opOption[10];// bex
	assign instructionType[17] = opOption[9];	// setx
	and	insnAnd9(instructionType[18], opOption[0], aluOption[8]); // nop
	
	/* BUILD D CONTROLS
	*	Rs30 - bex
	*	Rt0 - bex
	*	RtIsRd - sw
	*	RtIsRs - bne, blt
	*	RsIsRd - jr, bne, blt
	*/
	
	assign Rs30 = instructionType[16];
	assign Rt0 = instructionType[16];
	assign RtIsRd = instructionType[9];
	
	or	rtrsOR(RtIsRs, instructionType[12], instructionType[15]);
	or	rsrdOR(RsIsRd, instructionType[14], instructionType[12], instructionType[15]);
	//assign RsIsRd = instructionType[14];
	
	/* BUILD X CONTROLS
	* ALUop (5 bit) - for opOption[0]: instruction[6:2]; for bne/blt/bex: 00001; else, 00000
	* ALUinB - addi, sw, lw
	* BR - bne
	* BRlt - blt
	* JP - j, jal, bex
	* JR - jr
	*/
	
	
	assign aluMux[0] = instructionType[7];
	assign aluMux[1] = instructionType[8];
	nor	nor1(notMD, instructionType[7], instructionType[8]);
	and	andMD(aluMux[2], notMD, opOption[0]);
	
	or	aluOr1(aluMux[3], opOption[2], opOption[6], opOption[10]);
	nor	aluOr2(aluMux[4], opOption[0], opOption[2], opOption[6], opOption[10]);
	tri5	aluMux1(5'b00000, aluMux[0], ALUop);			// If instructionType[7] --> set ALUop to 00000 (add) 
	tri5	aluMux2(5'b00001, aluMux[1], ALUop);			// If instructionType[8] --> set ALUop to 00001 (sub)
	tri5	aluMux3(instruction[6:2], aluMux[2], ALUop);	// If neither of these two AND opOption[0] --> ALUop == instruction[6:2]
	tri5	aluMux4(5'b00001, aluMux[3], ALUop);			// If opOption[2], opOption[6], opOption[10] --> 00001
	tri5	aluMux5(5'b00000, aluMux[4], ALUop);			// Else --> 00000
	
	or	ORaluinb(ALUinB, instructionType[1], instructionType[9], instructionType[10]);
	assign BR = instructionType[12];
	assign BRlt = instructionType[15];
	or	jpOr(JP, instructionType[11], instructionType[13], instructionType[16]);
	assign JR = instructionType[14];
	
	/* BUILD M CONTROLS
	* DMwe - sw
	*/
	
	assign DMwe = instructionType[9];
	
	/* BUILD W CONTROLS
	* WE - NOR(j, bne, jr, blt, sw, bex, nop)
	* Rwd - lw
	* jal - jal
	* Rd30 - setx
	* Rd31 - jal
	* WTtoReg - setx
	*/
	nor	weNOR(WE, instructionType[11], instructionType[12], instructionType[14], 
					instructionType[15], instructionType[9], instructionType[16], instructionType[18]);
	
	assign Rwd = instructionType[10];
	assign jal = instructionType[13];
	assign Rd30 = instructionType[17];
	assign Rd31 = instructionType[13];
	assign WTtoReg = instructionType[17];

	
endmodule
