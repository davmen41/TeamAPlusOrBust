module full_Adder
(
	//Inputs a, b, and Carry in
	input a, b, C_in,
	//Outputs Sum and Carry out
	output Sum, C_out
);

wire c1, c2, c3; //Connections between gates


xor (c1, a, b); 	 // a xor b = c1
xor (Sum, c1, C_in); // c1 xor C_in = Sum
and (c3, a, b);		 // a and b = c3
and (c2, c1, C_in);  // ci and C_in = c2
or  (C_out, c2, c3); // c2 or c3 = C_out

endmodule

//Creating 4-bit Full Adder to calculate Passengers + Crew
module full_adder4_1( 

	input [3:0] a,b, //Inputs a3..a0 and b3..b0
	input C_in,      //Carry in input
	output [3:0] s,  //Sum s3..s0
	output C_out);   //Carry out
	
wire [2:0] carry;    //Carry c2..c0


//First Full Adder
full_Adder fa0(
	.a(a[0]),
	.b(b[0]),
	.C_in(C_in),
	.Sum(s[0]),
	.C_out(carry[0]));
	
//Second Full Adder
full_Adder  fa1(
	.a(a[1]),
	.b(b[1]),
	.C_in(carry[0]),
	.Sum(s[1]),
	.C_out(carry[1]));
	
//Third Full Adder
full_Adder  fa2(
	.a(a[2]),
	.b(b[2]),
	.C_in(carry[1]),
	.Sum(s[2]),
	.C_out(carry[2]));
	
//Fourth Full Adder
full_Adder  fa3(
	.a(a[3]),
	.b(b[3]),
	.C_in(carry[2]),
	.Sum(s[3]),
	.C_out(C_out));
	
endmodule

module full_adder4_2(

	input [3:0] a,b, //Inputs a3..a0 and b3..b0
	input C_in,      //Carry in input
	output [3:0] s,  //Sum s3..s0
	output C_out);   //Carry out
	
wire [2:0] carry;    //Carry c2..c0



//First Full Adder
full_Adder fa4(
	.a(a[0]),
	.b(b[0]),
	.C_in(C_out),
	.Sum(s[0]),
	.C_out(carry[0]));
	
//Second Full Adder
full_Adder fa5(
	.a(a[1]),
	.b(b[1]),
	.C_in(carry[0]),
	.Sum(s[1]),
	.C_out(carry[1]));
	
//Third Full Adder
full_Adder fa6(
	.a(a[2]),
	.b(b[2]),
	.C_in(carry[1]),
	.Sum(s[2]),
	.C_out(carry[2]));
	
//Fourth Full Adder
full_Adder fa7(
	.a(a[3]),
	.b(b[3]),
	.C_in(carry[2]),
	.Sum(s[3]),
	.C_out(C_out));
	
endmodule

module fulladder(a,b,c,s,ca);

input a,b,c;
output s,ca;

assign s=(a^b^c);
assign ca=((a&b)|(b&c)|(c&a));

endmodule

module mult4bit(a,b,p);
input [3:0] a,b;
output [7:0] p;

wire [39:0] w;

and a1(w[0],a[0],b[0]);
and a2(w[1],a[1],b[0]);
and a3(w[2],a[2],b[0]);
and a4(w[3],a[3],b[0]);

and a5(w[4],a[0],b[1]);
and a6(w[5],a[1],b[1]);
and a7(w[6],a[2],b[1]);
and a8(w[7],a[3],b[1]);

and a9(w[8],a[0],b[2]);
and a10(w[9],a[1],b[2]);
and a11(w[10],a[2],b[2]);
and a12(w[11],a[3],b[2]);

and a13(w[12],a[0],b[3]);
and a14(w[13],a[1],b[3]);
and a15(w[14],a[2],b[3]);
and a16(w[15],a[3],b[3]);

assign p[0] = w[0];

//Full Adders for Multiplier
fulladder a17(1'b0,w[1],w[4],w[16],w[17]);
fulladder a18(1'b0,w[2],w[5],w[18],w[19]);
fulladder a19(1'b0,w[3],w[6],w[20],w[21]);

fulladder a20(w[8],w[17],w[18],w[22],w[23]);
fulladder a21(w[9],w[19],w[20],w[24],w[25]);
fulladder a22(w[10],w[7],w[21],w[26],w[27]);

fulladder a23(w[12],w[23],w[24],w[28],w[29]);
fulladder a24(w[13],w[25],w[26],w[30],w[31]);
fulladder a25(w[14],w[11],w[27],w[32],w[33]);

fulladder a26(1'b0,w[29],w[30],w[34],w[35]);
fulladder a27(w[31],w[32],w[35],w[36],w[37]);
fulladder a28(w[15],w[33],w[37],w[38],w[39]);

//All of the outputs for the Multiplier
assign p[1]=w[16];
assign p[2]=w[22];
assign p[3]=w[28];
assign p[4]=w[34];
assign p[5]=w[36];
assign p[6]=w[38];
assign p[7]=w[39];

endmodule


//Testbench
module testbench();

//Initializing variables
	reg [3:0] a, b;
	reg C_in;
	wire [3:0] s;
	wire C_out;
	wire [2:0] carry;
	
	/*full_Adder dut(
	.a(a[0]),
	.b(b[0]),
	.C_in(C_oin),
	.Sum(s[0]),
	.C_out(carry[0]));*/
	
	//First Full Adder
full_Adder fa0(
	.a(a[0]),
	.b(b[0]),
	.C_in(C_in),
	.Sum(s[0]),
	.C_out(carry[0]));
	
//Second Full Adder
full_Adder  fa1(
	.a(a[1]),
	.b(b[1]),
	.C_in(carry[0]),
	.Sum(s[1]),
	.C_out(carry[1]));
	
//Third Full Adder
full_Adder  fa2(
	.a(a[2]),
	.b(b[2]),
	.C_in(carry[1]),
	.Sum(s[2]),
	.C_out(carry[2]));
	
//Fourth Full Adder
full_Adder  fa3(
	.a(a[3]),
	.b(b[3]),
	.C_in(carry[2]),
	.Sum(s[3]),
	.C_out(C_out));

initial 
		begin
		$dumpvars(1 ,testbench);
		
		#5
		
		a=7;
		b=3;
		C_in=0;
		
			$display("This a test display Passengers = a, Crew = b");
			$display("Full Adder: ", a, b, s, C_in, C_out );
		#5	$finish ;
			
		end
	endmodule

