/*
 * Time Machine Code - Make sure any code added has comments!
 */
//Half-Adder
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