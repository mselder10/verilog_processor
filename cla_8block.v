module cla_8block(dataA, dataB, cin, g, p, G, P, sum);

	// Define in/outputs
	input [7:0] dataA, dataB, g, p;
	input cin;
	output G, P;
	output [7:0] sum;
	
	// Create wires to store g and p values
	//wire [7:0] g, p;
	wire G1, G2, G3, G4, G5, G6, G7;
	wire [6:0] carries, pc;
	wire [20:0] pg;
	
	// Define individual carries sum bits
	// c1
	and	and1(pc[0], p[0], cin);
	or		or1(carries[0], g[0], pc[0]);
	// c2
	and	and2(pc[1], p[1], p[0], cin);
	and	and3(pg[0], p[1], g[0]);
	or		or2(carries[1], g[1], pg[0], pc[1]);
	// c3
	and	and4(pc[2], p[2], p[1], p[0], cin);
	and	and5(pg[1], p[2], p[1], g[0]);
	and	and6(pg[2], p[2], g[1]);
	or		or3(carries[2], g[2], pg[2], pg[1], pc[2]);
	// c4
	and	and7(pc[3], p[3], p[2], p[1], p[0], cin);
	and	and8(pg[3], p[3], p[2], p[1], g[0]);
	and	and9(pg[4], p[3], p[2], g[1]);
	and	and10(pg[5], p[3], g[2]);
	or		or4(carries[3], g[3], pg[5], pg[4], pg[3], pc[3]);
	// c5
	and	and11(pc[4], p[4], p[3], p[2], p[1], p[0], cin);
	and	and12(pg[6], p[4], p[3], p[2], p[1], g[0]);
	and	and13(pg[7], p[4], p[3], p[2], g[1]);
	and	and14(pg[8], p[4], p[3], g[2]);
	and	and15(pg[9], p[4], g[3]);
	or		or5(carries[4], g[4], pg[9], pg[8], pg[7], pg[6], pc[4]);
	// c6
	and	and16(pc[5], p[5], p[4], p[3], p[2], p[1], p[0], cin);
	and	and17(pg[10], p[5],  p[4], p[3], p[2], p[1], g[0]);
	and	and18(pg[11], p[5],  p[4], p[3], p[2], g[1]);
	and	and19(pg[12], p[5],  p[4], p[3], g[2]);
	and	and20(pg[13], p[5],  p[4], g[3]);
	and	and21(pg[14], p[5],  g[4]);
	or		or6(carries[5], g[5], pg[14], pg[13], pg[12], pg[11], pg[10], pc[5]);
	// c7
	and	and22(pc[6], p[6], p[5], p[4], p[3], p[2], p[1], p[0], cin);
	and	and23(pg[15], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and	and24(pg[16], p[6],  p[5], p[4], p[3], p[2], g[1]);
	and	and25(pg[17], p[6],  p[5], p[4], p[3], g[2]);
	and	and26(pg[18], p[6],  p[5], p[4], g[3]);
	and	and27(pg[19], p[6],  p[5], g[4]);
	and	and28(pg[20], p[6],  g[5]);
	or		or7(carries[6], g[6], pg[20], pg[19], pg[18], pg[17], pg[16], pg[15], pc[6]);
	
	xor	sum_xor0(sum[0], dataA[0], dataB[0], cin);
	
	genvar c;
	generate
		for(c=1; c<8; c = c+1) begin: sumLoop
			//and	g_and(g[c], dataA[c], dataB[c]);
			//or		p_or(p[c], dataA[c], dataB[c]);
			xor	sum_xor(sum[c], dataA[c], dataB[c], carries[c-1]);
		end
	endgenerate
	
	// Create G and P
	and	P_and(P, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);
	and	G_and1(G1, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and	G_and2(G2, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
	and	G_and3(G3, p[7], p[6], p[5], p[4], p[3], g[2]);
	and	G_and4(G4, p[7], p[6], p[5], p[4], g[3]);
	and	G_and5(G5, p[7], p[6], p[5], g[4]);
	and	G_and6(G6, p[7], p[6], g[5]);
	and	G_and7(G7, p[7], g[6]);
	or		G_or(G, g[7], G1, G2, G3, G4, G5, G6, G7);

endmodule