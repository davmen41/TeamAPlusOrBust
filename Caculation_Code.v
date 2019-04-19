//Half-Adder Logic
module AddHalf (input a, b, output carry_out, sum);
	xor Gate1(sum, a, b);
	and Gate2(carry_out, a, b);
endmodule

//Full adder made up of Half-Adder
module AddFull (input a, b, carry_in, output carry_out, sum);
	wire w1, w2, w3;
	AddHalf M1 (a, b, w1, w2);
	AddHalf M2 (w2, carry_in, w3, sum);
	or (carry_out, w1, w3);
endmodule

//mux 2:1
module mux2Cal(a1,a0,s,b);	
	parameter k=13;
	input signed [k-1:0] a1,a0;
	input [1:0] s; //one hot select
	output signed [k-1:0] b;
	reg [k-1:0] b;
	always @(a1 or a0 or s) begin
		case(s)
			2'b01: b=a1;
			2'b11: b=a0;
		endcase
	end
endmodule

//comparator with 3 outputs
module comparatorCal(a,b,larger,equal, smaller);
	parameter k=13;
	input  signed [k-1:0] a,b;
	output reg larger,equal, smaller;
	always @* begin
		if (a<b) begin
			larger=0;
			equal=0;
			smaller=1;
		end
		else if (a==b) begin
			larger=0;
			equal=1;
			smaller=0;
		end
		else begin
			larger=1;
			equal=0;
			smaller=0;
		end
	end
endmodule


module substractorCal(a,b,s);
	parameter k=13;
	input signed [k-1:0] a,b;
	output signed [k-1:0] s;
	reg [k-1:0] s;
	always @* begin	
		s=a-b;
	end
endmodule

//decoder we can use
module Dec(a,b) ;
   parameter n=3 ;
   parameter m=8 ;
   
   input  [n-1:0] a ;
   output [m-1:0] b ;
   
   assign b = 1<<a ;
endmodule

//register
module registerCal(reset, clk, d,q);
	parameter k=13;
	input reset, clk;
	input signed [k-1:0] d;
	output signed [k-1:0] q;
	reg [k-1:0] q;
	always @(posedge clk or posedge reset) 
		if (reset)
			q=0;
		else if (clk==1)
			q=d;
	end
endmodule

module Calculation (clk, reset, year_in, year_out, status, fail, ok);	//missing link with decoder
	//set parameter
	parameter k=13;
	input clk, reset;
	input signed [k-1:0] year_in;
	//wait for decoder to combine with status, I just combine reset + 1=status first
	output reg [2:0] status;
	output reg fail,ok;
	output signed [k-1:0] year_out;
	output reg [k-1:0] year_out;
	wire [k-1:0] default_year,zero;
	reg signed [k-1:0]out;
	assign zero=13'b0;
	wire larger,smaller,equal;
	wire larger2,smaller2,equal2;
	assign default_year= 13'b0011111100011;
	wire [1:0]one_hot;
	assign one_hot={1'b1,reset};
	mux2Cal #(k) mux(year_in, default_year, one_hot,out);
	comparatorCal #(k) check0(out,zero,larger,equal,fail);
	comparatorCal #(k) compareW2019(out,default_year,larger2,equal2,smaller2);
	always @* begin
		ok=larger2 | smaller2;
	end
	registerCal #(k) saveYear(reset, clk, year_in,year_out);
endmodule
	


			
		