module stall(irFD, irDX, isStall, nisStall);

	/* STALL LOGIC IMPLEMENTED FOR FULL BYPASSING WITHOUT MULTIPLIER */

	input[31:0] irFD, irDX;
	output isStall, nisStall;
	
	wire[4:0] fd1, fd2;
	wire[1:0] regEquality, opCheck, stallLogic;
	wire[2:0] opNots;
	
	// Reg equality check
	genvar c;
	generate
		for(c=0; c<5; c = c + 1) begin: xnorLoop
			xnor	xm1(fd1[c], irFD[c + 17], irDX[c + 22]);
			xnor	xm2(fd2[c], irFD[c + 12], irDX[c + 22]);
		end
	endgenerate
	
	// F/D(RS1) == D/X(RD)
	and	eq0(regEquality[0], fd1[0], fd1[1], fd1[2], fd1[3], fd1[4]);
	// F/D(RS2) == D/X(RD)
	and	eq1(regEquality[1], fd2[0], fd2[1], fd2[2], fd2[3], fd2[4]);
	
	
	/* STALL LOGIC
	* D/X(OP) == Load &&
	* [
	*	(F/D(RS1) == D/X(RD) || F/D(RS2) == D/X(RD)) &&
	*	F/D(OP) != Store
	* ] --> isStall == 1, nisStall == 0
	* Else (flipped)
	*/
	
	// D/X(OP) == Load --> opCheck[0] == 1
	not loadNot(opNots[0], irDX[30]);
	nor	loadNOR(opCheck[0], irDX[31], opNots[0], irDX[29], irDX[28], irDX[27]);
	
	// F/D(OP) != Store --> opCheck[1] == 1
	not swNot1(opNots[1], irFD[30]);
	not swNot2(opNots[2], irFD[31]);
	nand	swAND(opCheck[1], opNots[2], opNots[1], irFD[29], irFD[28], irFD[27]);

	// (F/D(RS1) == D/X(RD) || F/D(RS2) == D/X(RD))
	or	or0(stallLogic[0], regEquality[0], regEquality[1]);

	// (F/D(RS1) == D/X(RD) || F/D(RS2) == D/X(RD)) && F/D(OP) != Store
	and	and0(stallLogic[1], stallLogic[0], opCheck[1]);
	
	// D/X(OP) == Load && [(F/D(RS1) == D/X(RD) || F/D(RS2) == D/X(RD)) && F/D(OP) != Store]
	and	and1(isStall, stallLogic[1], opCheck[0]);
	not	endNot(nisStall, isStall);
	
endmodule
