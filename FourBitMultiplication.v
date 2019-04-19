

/*
	STATE : 

*/



//Need to connect two 4-bit Adders together
/*The sum of the two 4-bit Adders is then
multiplied by 3 in a 4-bit multiplier*/


module testbench;
	initial
	
	reg [7:0] a,b;
	reg C_in;
	wire [7:0] s;
	wire C_out;
	
	module full_adder8 dut(

	input [7:0] a,b, //Inputs a3..a0 and b3..b0
	input C_in,      //Carry in input
	output [7:0] s,  //Sum s3..s0
	output C_out);   //Carry out
	
		begin
		$dumpvars(1 ,test);
		
		#5
		a=15;
		b=4;
		C_in=0;
		
			$display("This a test display Passengers = a, Crew = b");
			$finish ;
			
		end
	endmodule
	
/*module Full_Adder
(
	//Inputs a, b, and Carry in
	input a, b, C_in,
	//Outputs Sum and Carry out
	output Sum, C_out;
);

wire c1, c2, c3; //Connections between gates


xor (c1, a, b); 	 // a xor b = c1
xor (Sum, c1, C_in); // c1 xor C_in = Sum
and (c3, a, b);		 // a and b = c3
and (c2, c1, C_in);  // ci and C_in = c2
or  (C_out, c2, c3); // c2 or c3 = C_out

endmodule*/

//Creating 4-bit Full Adder to calculate Passengers + Crew
module full_adder4_1(

	input [3:0] a,b, //Inputs a3..a0 and b3..b0
	input C_in,      //Carry in input
	output [3:0] s,  //Sum s3..s0
	output C_out);   //Carry out
	
wire [2:0] carry;    //Carry c2..c0

//First Full Adder
full_adder fa0(
	.a(a[0]),
	.b(b[0]),
	.C_in(C_in),
	,s(s[0]),
	.C_out(carry[0]));
	
//Second Full Adder
full_adder fa1(
	.a(a[1]),
	.b(b[1]),
	.C_in(carry[0]),
	,s(s[1]),
	.C_out(carry[1]));
	
//Third Full Adder
	full_adder fa2(
	.a(a[2]),
	.b(b[2]),
	.C_in(carry[1]),
	,s(s[2]),
	.C_out(carry[2]));
	
//Fourth Full Adder
	full_adder fa3(
	.a(a[3]),
	.b(b[3]),
	.C_in(carry[2]),
	,s(s[3]),
	.C_out(C_out));
	
endmodule

module full_adder4_2(

	input [3:0] a,b, //Inputs a3..a0 and b3..b0
	input C_in,      //Carry in input
	output [3:0] s,  //Sum s3..s0
	output C2_out);   //Carry out
	
wire [2:0] carry;    //Carry c2..c0

//First Full Adder
full_adder fa4(
	.a(a[0]),
	.b(b[0]),
	.C_in(C_out),
	,s(s[0]),
	.C2_out(carry[0]));
	
//Second Full Adder
full_adder fa5(
	.a(a[1]),
	.b(b[1]),
	.C_in(carry[0]),
	,s(s[1]),
	.C2_out(carry[1]));
	
//Third Full Adder
	full_adder fa6(
	.a(a[2]),
	.b(b[2]),
	.C_in(carry[1]),
	,s(s[2]),
	.C2_out(carry[2]));
	
//Fourth Full Adder
	full_adder fa7(
	.a(a[3]),
	.b(b[3]),
	.C_in(carry[2]),
	,s(s[3]),
	.C2_out(C_out));
	
endmodule


module Mult4bit 
(
	input  [3:0] Q,
	input  [3:0] M,
	output [7:0] p
);

wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11;

wire d1, d2, d3, d4, d5, d6, d7;

wire e1, e2, e3;

wire f1, f2, f3, f4, f5, f6, f7;

wire g1, g2, g3, g4;

and(c1, M[3], Q[1]), 

(c2, M[2], Q[2]), 

(c3, M[1], Q[3]), 

(c4, M[3], Q[0]), 

(c5, M[2], Q[1]), 

(c6, M[1], Q[2]), 

(c7, M[2], Q[0]), 

(c8, M[1], Q[1]), 

(c9, M[0], Q[2]), 

(c10, M[1], Q[0]), 

(c11, M[0], Q[1]), 

(P[0], M[0], Q[0]); 

FullAdder fa8(c1, c2, c3, d2, d1);  

FullAdder fa9(c4, c5, c6, d4, d3);   

FullAdder fa10(c7, c8, c9, d6, d5);  

FullAdder fa11(c10, c11, 0, P[1], d7);  

and(e1, M[2], Q[3]), 

(e2, M[3], Q[2]), 

(e3, M[0], Q[3]); 

FullAdder fa12(e1, e2, d1, f2, f1);

FullAdder fa13(d2, d3, f5, f4, f3);

FullAdder fa14(d4, e3, d5, f6, f5);

FullAdder fa15(d6, d7, 0, P[2], f7);

and(g1, M[3], Q[3]); 

FullAdder fa16(g1, f1, g2, P[6], P[7]);

FullAdder fa17(f2, f3, g3, P[5], g2);

FullAdder fa18(f4, 0, g4, P[4], g3);

FullAdder fa19(f6, f7, 0, P[3], g4);

endmodule

//Creating 8-bit Full Adder to calculate Passengers + Crew
/*module full_adder8_1(

	input [7:0] a,b, //Inputs a3..a0 and b3..b0
	input C_in,      //Carry in input
	output [7:0] s,  //Sum s3..s0
	output C_out);   //Carry out
	
wire [6:0] carry;    //Carry c2..c0

//First Full Adder
full_adder fa0(
	.a(a[0]),
	.b(b[0]),
	.C_in(C_in),
	.s(s[0]),
	.C_out(carry[0]));
	
//Second Full Adder
full_adder fa1(
	.a(a[1]),
	.b(b[1]),
	.C_in(carry[0]),
	.s(s[1]),
	.C_out(carry[1]));
	
//Third Full Adder
	full_adder fa2(
	.a(a[2]),
	.b(b[2]),
	.C_in(carry[1]),
	.s(s[2]),
	.C_out(carry[2]));
	
//Fourth Full Adder
	full_adder fa3(
	.a(a[3]),
	.b(b[3]),
	.C_in(carry[2]),
	.s(s[3]),
	.C_out(carry[3]));
	
//Fifth Full Adder
full_adder fa4(
	.a(a[4]),
	.b(b[4]),
	.C_in(carry[3]),
	.s(s[4]),
	.C_out(carry[4]));
	
//Sixth Full Adder
full_adder fa5(
	.a(a[5]),
	.b(b[5]),
	.C_in(carry[4]),
	.s(s[5]),
	.C_out(carry[5]));
	
//Seventh Full Adder
	full_adder fa6(
	.a(a[6]),
	.b(b[6]),
	.C_in(carry[5]),
	.s(s[6]),
	.C_out(carry[6]));
	
//Eight Full Adder
	full_adder fa7(
	.a(a[7]),
	.b(b[7]),
	.C_in(carry[6]),
	.s(s[7]),
	.C_out(C_out));
	
endmodule

//Creating 8-bit Full Adder to calculate (Passengers + Crew) + Resources
//Need to connet C_out of full_adder8_1 to this
/*module full_adder8_2(

	input [7:0] a,b, //Inputs a3..a0 and b3..b0
	input C_in,      //Carry in input
	output [7:0] s,  //Sum s3..s0
	output C_out);   //Carry out
	
wire [6:0] carry;    //Carry c2..c0

//First Full Adder
full_adder fa8(
	.a(a[0]),
	.b(b[0]),
	.C_in(C_in),
	.s(s[0]),
	.C_out(carry[0]));
	
//Second Full Adder
full_adder fa9(
	.a(a[1]),
	.b(b[1]),
	.C_in(carry[0]),
	.s(s[1]),
	.C_out(carry[1]));
	
//Third Full Adder
	full_adder fa10(
	.a(a[2]),
	.b(b[2]),
	.C_in(carry[1]),
	.s(s[2]),
	.C_out(carry[2]));
	
//Fourth Full Adder
	full_adder fa11(
	.a(a[3]),
	.b(b[3]),
	.C_in(carry[2]),
	.s(s[3]),
	.C_out(carry[3]));
	
//Fifth Full Adder
full_adder fa12(
	.a(a[4]),
	.b(b[4]),
	.C_in(carry[3]),
	.s(s[4]),
	.C_out(carry[4]));
	
//Sixth Full Adder
full_adder fa13(
	.a(a[5]),
	.b(b[5]),
	.C_in(carry[4]),
	.s(s[5]),
	.C_out(carry[5]));
	
//Seventh Full Adder
	full_adder fa14(
	.a(a[6]),
	.b(b[6]),
	.C_in(carry[5]),
	.s(s[6]),
	.C_out(carry[6]));
	
//Eight Full Adder
	full_adder fa15(
	.a(a[7]),
	.b(b[7]),
	.C_in(carry[6]),
	.s(s[7]),
	.C_out(C_out));
	
endmodule



/*	
module Mult4bit 
(
	input  [3:0] Q,
	input  [3:0] M,
	output [7:0] p
);

wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11;

wire d1, d2, d3, d4, d5, d6, d7;

wire e1, e2, e3;

wire f1, f2, f3, f4, f5, f6, f7;

wire g1, g2, g3, g4;

and(c1, M[3], Q[1]),  //AND 14

(c2, M[2], Q[2]), //AND11

(c3, M[1], Q[3]), //AND8

(c4, M[3], Q[0]), //AND13

(c5, M[2], Q[1]), //AND10

(c6, M[1], Q[2]), //AND7

(c7, M[2], Q[0]), //AND9

(c8, M[1], Q[1]), //AND6

(c9, M[0], Q[2]), //AND3

(c10, M[1], Q[0]), //AND5

(c11, M[0], Q[1]), //AND2

(P[0], M[0], Q[0]); //AND1

//FullAdder fa1(c1(AND14), c2(AND11), c3(AND8), d2, d1);   /*.a(a[0]),
															.b(b[0]),
															.C_in(C_in),
															.s(s[0]),
															.C_out(carry[0]));*/

//FullAdder fa2(c4(And13), c5(AND10), c6(AND7), d4, d3);   /**/

//FullAdder fa3(c7(AND9), c8(AND6), c9(AND3), d6, d5);  /**/

//FullAdder fa4(c10(AND5), c11(AND2), 0, P[1], d7);  /**/

/*
and(e1, M[2], Q[3]), //AND12

(e2, M[3], Q[2]), //AND15

(e3, M[0], Q[3]); //AND4

FullAdder fa5(e1, e2, d1, f2, f1);

FullAdder fa6(d2, d3, f5, f4, f3);

FullAdder fa7(d4, e3, d5, f6, f5);

FullAdder fa8(d6, d7, 0, P[2], f7);

and(g1, M[3], Q[3]); //AND 16

FullAdder fa9(g1, f1, g2, P[6], P[7]);

FullAdder fa10(f2, f3, g3, P[5], g2);

FullAdder fa11(f4, 0, g4, P[4], g3);

FullAdder fa12(f6, f7, 0, P[3], g4);

endmodule*/


