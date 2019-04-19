module substractorCal(a,b,s);
	parameter k=12;
	input signed [k-1:0] a,b;
	output signed [k-1:0] s;
	reg [k-1:0] s;
	always @* begin	
		s=a-b;
	end
endmodule

module comparatorCal(a,b,larger,equal, smaller);
	parameter k=12;
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
/*
module Calculation(year_in,year_out,state_next,travel);
	parameter k=13;
	input signed [k-1:0] year_in;
	output signed [k-1:0] year_out;
	output reg [1:0] state_next;
	output reg [2:0] travel;
	wire signed [k-1:0] zero, default_year;
	wire l,e,sm, l2,e2,sm2;
	reg [k-1:0] year_out;
	reg go;
comparatorCal #(13) first_com(year_in,zero,l,e,sm);
substractorCal #(13) difference(year_in,default_year,year_out);
comparatorCal	#(13) second_com(year_in,default_year,l2,e2,sm2);
	assign default_year=13'b0011111100011;
	assign zero=13'b0;
	assign travel= {l2,e2,sm2};
	assign go= l2 | sm2;
	assign state_next={go,sm};
endmodule
*/

module Calculation(year_in,year_out,state_next,travel);
	parameter k=12;
	input signed [k-1:0] year_in;
	output signed [k-1:0] year_out;
	output [1:0] state_next;
	output [2:0] travel;
	wire signed [k-1:0] zero, default_year;
	wire l,e,sm, l2,e2,sm2;
	reg go;
	wire [8*8:1] travel_name;
	comparatorCal #(12) first_com(year_in,zero,l,e,sm);
	substractorCal #(12) difference(year_in,default_year,year_out);
	comparatorCal	#(12) second_com(year_in,default_year,l2,e2,sm2);
	assign default_year=12'b011111100011;
	assign zero=12'b0;
	assign travel= {l2,e2,sm2};
	always @* begin
		go=l2 | sm2;
	end
	assign state_next={go,sm};
	always @* begin
		#1	
		$display("Current Year:           %b (%d)",default_year,default_year);
		#1
		$display("Year Travel To:         %b (%d)", year_in,year_in);
		#1
		$display("Difference:             %b (%d)", year_out,year_out);
	end
endmodule
module circuit();
	wire signed [11:0] a,b;
	wire [1:0] n;
	wire [2:0] t;
	Calculation ca(a,b,n,t);
	assign a=12'b011101100011;
endmodule

module testbench();
	circuit ci();
initial begin
$display("Hello, Class. It is Dr. Horrible's Verilog!");
#1
$display("%b %d %b %d %b %b",ci.a,ci.a,ci.b,ci.b,ci.n,ci.t);
//$display("%b %d", ci.c,ci.c);
end
endmodule