module translateOpcode(ctrl_ALUopcode, modEnable);

	input [4:0] ctrl_ALUopcode;
	output [5:0] modEnable;
	
	// 6 bits for 6 opcodes --> use logic to set the bit values
	
	wire [4:0] notOP;
	not	not0(notOP[0], ctrl_ALUopcode[0]);
	not	not1(notOP[1], ctrl_ALUopcode[1]);
	not	not2(notOP[2], ctrl_ALUopcode[2]);
	not	not3(notOP[3], ctrl_ALUopcode[3]);
	not	not4(notOP[4], ctrl_ALUopcode[4]);
	
	and	ADD(modEnable[0], notOP[0], notOP[1], notOP[2], notOP[3], notOP[4]);
	and	SUB(modEnable[1], ctrl_ALUopcode[0], notOP[1], notOP[2], notOP[3], notOP[4]);
	and	AND(modEnable[2], notOP[0], ctrl_ALUopcode[1], notOP[2], notOP[3], notOP[4]);
	and	OR(modEnable[3], ctrl_ALUopcode[0], ctrl_ALUopcode[1], notOP[2], notOP[3], notOP[4]);
	and	SLL(modEnable[4], notOP[0], notOP[1], ctrl_ALUopcode[2], notOP[3], notOP[4]);
	and	SRA(modEnable[5], ctrl_ALUopcode[0], notOP[1], ctrl_ALUopcode[2], notOP[3], notOP[4]);

endmodule