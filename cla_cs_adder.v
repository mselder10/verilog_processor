module cla_cs_adder(dataA, dataB, cin, cout, sum, overflow, isLessThan);

	// Define inputs and outputs
	input [31:0] dataA, dataB;
	input cin;
	output cout, overflow, isLessThan;
	output [31:0] sum;
	
	// Define wires for add/subing
	wire [31:0] aANDb, aORb;
	wire [3:0] G, P;
	wire [2:0] carries;
	wire [5:0] pg;
	wire [3:0] pc;
	
	// Define wires for carry-select
	wire[7:0] cs1, cs2, cs3, cs4, cs5, cs6;
	wire notCarry0, notCarry1, notCarry2;
	wire[5:0] Gmux, Pmux;
	
	// Define wires for output logic
	wire anEqb, aEqb, anEqsum, notB, andlt1, andlt2;
	
	// Instantiate AND and OR
	
	and32	myAnd(dataA, dataB, aANDb);
	or32	myOr(dataA, dataB, aORb);
	
	/* Perform carry logic */
	
	// Logic for carries[0]
	and	pc_and0(pc[0], P[0], cin);
	or		or_c0(carries[0], G[0], pc[0]);
	
	// Logic for carries[1]
	and	pc_and1(pc[1], P[1], P[0], cin);
	and	pg_and0(pg[0], P[1], G[0]);
	or		or_c1(carries[1], G[1], pg[0], pc[1]);
	
	// Logic for carries[2]
	and	pc_and2(pc[2], P[2], P[1], P[0], cin);
	and	pg_and1(pg[1], P[2], P[1], G[0]);
	and	pg_and2(pg[2], P[2], G[1]);
	or		or_c2(carries[2], G[2], pg[2], pg[1], pc[2]);
	
	// Logic for cout
	and	pc_and3(pc[3], P[3], P[2], P[1], P[0], cin);
	and	pg_and3(pg[3], P[3], P[2], P[1], G[0]);
	and	pg_and4(pg[4], P[3], P[2], G[1]);
	and	pg_and5(pg[5], P[3], G[2]);
	or		or_c3(cout, G[3], pg[5], pg[4], pg[3], pc[3]);
	
	// Instantiate 7 cla_8blocks
	cla_8block	cla_block0(dataA [7:0], dataB[7:0], cin, aANDb[7:0], aORb[7:0], G[0], P[0], sum[7:0]);
	cla_8block	cla_block1(dataA [15:8], dataB[15:8], 1'b1, aANDb[15:8], aORb[15:8], Gmux[0], Pmux[0], cs1);
	cla_8block	cla_block2(dataA [15:8], dataB[15:8], 1'b0, aANDb[15:8], aORb[15:8], Gmux[1], Pmux[1], cs2);
	cla_8block	cla_block3(dataA [23:16], dataB[23:16], 1'b1, aANDb[23:16], aORb[23:16], Gmux[2], Pmux[2], cs3);
	cla_8block	cla_block4(dataA [23:16], dataB[23:16], 1'b0, aANDb[23:16], aORb[23:16], Gmux[3], Pmux[3], cs4);
	cla_8block	cla_block5(dataA [31:24], dataB[31:24], 1'b1, aANDb[31:24], aORb[31:24], Gmux[4], Pmux[4], cs5);
	cla_8block	cla_block6(dataA [31:24], dataB[31:24], 1'b0, aANDb[31:24], aORb[31:24], Gmux[5], Pmux[5], cs6);
	
	// Use "mux" (tristates) to select sum bits
	assign G[1] = carries[0] ? Gmux[0] : Gmux[1];
	assign G[2] = carries[1] ? Gmux[2] : Gmux[3];
	assign G[3] = carries[2] ? Gmux[4] : Gmux[5];
	assign P[1] = carries[0] ? Pmux[0] : Pmux[1];
	assign P[2] = carries[1] ? Pmux[2] : Pmux[3];
	assign P[3] = carries[2] ? Pmux[4] : Pmux[5];
	
	tri8	sum1tri(cs1, cs2, carries[0], sum[15:8]);
	tri8	sum2tri(cs3, cs4, carries[1], sum[23:16]);
	tri8	sum3tri(cs5, cs6, carries[2], sum[31:24]);
	
	/** Perform output logic **/
	
	/* Overflow logic */
	
	xor	ovXor1(anEqb, dataA[31], dataB[31]);
	not	checkEq(aEqb, anEqb);						// abEq == 1 if a == b
	xor	ovXor2(anEqsum, dataA[31], sum[31]);	// a[31] != sum[31] ?
	and	ovAND2(overflow, aEqb, anEqsum);			// If abEq == 1 AND a != sum[31], overflow == 1
	
	/* isLessThan logic (result is negative OR a is - and b is +) */
	
	and	ltand1(andlt1, dataA[31], dataB[31]);
	and	ltand2(andlt2, cin, sum[31]);
	or		ltOR(isLessThan, andlt1, andlt2);

endmodule