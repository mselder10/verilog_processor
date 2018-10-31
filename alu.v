module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
	
	wire [5:0] modEnable;
	translateOpcode	newOp(ctrl_ALUopcode, modEnable);
	
	// Testing out individual modules now
	
	wire [31:0] notB, inB, outWire1, outWire2, outWire3, outWire4, outWire5;
	wire aEq0, bEq0, anEq0, bnEq0, aandb0, ABmodEn, naandb0, subEnable, asOR, cout, ovflow, nEq, lThan;
	
	// 0 - 0 is bottleneck -> check for a = 0, b = 0, modEnable[1], drive 32b'0 to data_result
	
	notEqual	a0(data_operandA, 32'b0, anEq0);
	notEqual	b0(data_operandB, 32'b0, bnEq0);
	not	na0(aEq0, anEq0);
	not	nb0(bEq0, bnEq0);
	and	ab0(aandb0, aEq0, bEq0);
	not	abn0(naandb0, aandb0);						// If sub=1 and a!=b=0, let sub=modEnable[1]
	and	thisAnd(subEnable, naandb0, modEnable[1]);			// ctrl==1 if a=b=0, sub=1
	and	tri0ctrl(ABmodEn, aandb0, modEnable[1]);	// if ctrl==1, set inputs to adder to z, else, keep as modEnable[1/0]
	
	tri32	tri0bus(32'b0, ABmodEn, data_result); //drive
	assign overflow = ABmodEn ? 1'b0 : 1'bz;
	assign isLessThan = ABmodEn ? 1'b0 : 1'bz;
	assign isNotEqual = ABmodEn ? 1'b0 : 1'bz;
	
	// Check equality of inputs
	
	notEqual	inequality(data_operandA, data_operandB, nEq);
	assign isNotEqual = subEnable ? nEq : 1'bz;
	
	// Adder (with Subtraction, Ovflow/lthan/eq check
	
	not32 myNot(data_operandB, notB);
	or	addsubOr(asOR, modEnable[0], subEnable);
	tri32	binB(data_operandB, modEnable[0], inB);
	tri32	notbinB(notB, subEnable, inB);
	
	// AND
	
	and32	myand(data_operandA, data_operandB, outWire2);
	tri32	andtri(outWire2, modEnable[2], data_result);
	
	// OR
	
	or32	myor(data_operandA, data_operandB, outWire3);
	tri32	ortri(outWire3, modEnable[3], data_result);
	
	cla_cs_adder	myadder(data_operandA, inB, subEnable, cout, outWire1, ovflow, lThan);
	
	
	tri32	addsubtri(outWire1, asOR, data_result);
	assign overflow = asOR ? ovflow : 1'bz;
	assign isLessThan = subEnable ? lThan : 1'bz;
	
	// SLL
	
	barrelShiftL	mySLL(data_operandA, ctrl_shiftamt, outWire4);
	tri32	SLLtri(outWire4, modEnable[4], data_result);

	// SRA
	
	barrelShiftR	mySRA(data_operandA, ctrl_shiftamt, outWire5);
	tri32	SRAtri(outWire5, modEnable[5], data_result);
	
endmodule
