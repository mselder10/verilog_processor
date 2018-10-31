module bypass(irDX, irXM, irMW, insnDX, insnXM, insnMW, isExcepXM, isExcepMW, memMuxCtrl, aluAMuxCtrl, aluBMuxCtrl, bexCtrl);

	input[31:0] irDX, irXM, irMW;
	input[18:0]	insnDX, insnXM, insnMW;
	input isExcepXM, isExcepMW;
	output memMuxCtrl;
	output [1:0] aluAMuxCtrl, aluBMuxCtrl, bexCtrl;
	
	wire[4:0] xmmw, dxxmrs1, dxxmrs2, dxmwrs1, dxmwrs2, regEquality;
	wire[1:0] dxnotxm, regMWbypass;
	wire nisExcepXM, nisExcepMW;
	
	// Reg equality check
	genvar c;
	generate
		for(c=0; c<5; c = c + 1) begin: xnorLoop
			xnor	xmwXNOR(xmmw[c], irXM[c + 22], irMW[c + 22]);
			xnor	xm1(dxxmrs1[c], irDX[c + 17], irXM[c + 22]);
			xnor	xm2(dxxmrs2[c], irDX[c + 12], irXM[c + 22]);
			xnor	mw1(dxmwrs1[c], irDX[c + 17], irMW[c + 22]);
			xnor	mw2(dxmwrs2[c], irDX[c + 12], irMW[c + 22]);
		end
	endgenerate
	
	and	eq0(regEquality[0], dxxmrs1[0], dxxmrs1[1], dxxmrs1[2], dxxmrs1[3], dxxmrs1[4]);
	and	eq1(regEquality[1], dxmwrs1[0], dxmwrs1[1], dxmwrs1[2], dxmwrs1[3], dxmwrs1[4]);
	and	eq2(regEquality[2], dxxmrs2[0], dxxmrs2[1], dxxmrs2[2], dxxmrs2[3], dxxmrs2[4]);
	and	eq3(regEquality[3], dxmwrs2[0], dxmwrs2[1], dxmwrs2[2], dxmwrs2[3], dxmwrs2[4]);
	and	eq4(regEquality[4], xmmw[0], xmmw[1], xmmw[2], xmmw[3], xmmw[4]);
	
	not	eq5(dxnotxm[0], regEquality[0]);
	not	eq6(dxnotxm[1], regEquality[2]);
	
	and	eq7(regMWbypass[0], dxnotxm[0], regEquality[1]);
	and	eq8(regMWbypass[1], dxnotxm[1], regEquality[3]);
	
	/* MEM MUX CTRL
	* X/M(RD) == M/W(RD) --> ctrl == 1
	* Else --> ctrl == 0
	*/
	assign memMuxCtrl = regEquality[4] ? 1'b1 : 1'b0;
	
	/* ALU A MUX CTRL 
	* (D/x(RS1) == X/M(RD)) && No XM Exception --> ctrl == 01
	* (D/x(RS1) == M/W(RD)) && No MW Exception --> ctrl == 10
	* Else --> ctrl == 00
	*/
	
	not	ntEXXM(nisExcepXM, isExcepXM);
	not	ntEXMW(nisExcepMW, isExcepMW);
	
	and	aluAMUXAND1(aluAMuxCtrl[0], regEquality[0], nisExcepXM);
	and	aluAMUXAND2(aluAMuxCtrl[1], regMWbypass[0], nisExcepMW);
	//assign aluAMuxCtrl[0] = regEquality[0] ? 1'b1 : 1'b0;
	//assign aluAMuxCtrl[1] = regMWbypass[0] ? 1'b1 : 1'b0;
	
	/* ALU B MUX CTRL 
	* (D/x(RS2) == X/M(RD)) && No XM Exception --> ctrl == 01
	* (D/x(RS2) == M/W(RD)) && No MW Exception --> ctrl == 10
	* Else --> ctrl == 00
	*/
	
	and	aluBMUXAND1(aluBMuxCtrl[0], regEquality[2], nisExcepXM);
	and	aluBMUXAND2(aluBMuxCtrl[1], regMWbypass[1], nisExcepMW);
	
	//assign aluBMuxCtrl[0] = regEquality[2] ? 1'b1 : 1'b0;
	//assign aluBMuxCtrl[1] = regMWbypass[1] ? 1'b1 : 1'b0;
	
	/* BEX BYPASSING CONTROL
	* D/X(OP) == BEX && X/M(OP) == SETX --> ctrl == 01
	* D/X(OP) == BEX && M/W(OP) == SETX --> ctrl == 10
	* Else --> ctrl == 00
	*/

	and	bexAND1(bexCtrl[0], insnDX[16], insnXM[17]);
	and	bexAND2(bexCtrl[1], insnDX[16], insnMW[17]);

endmodule
