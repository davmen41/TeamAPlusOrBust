/*
 * Time Machine Code - Make sure any code added has comments!
 */
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
 /*
  *	State 2: Load ship
  */

module comparator(input [3:0] A, B, output result);
	wire a1,a2,a3,a4; // AND outputs
	wire [7:0] andOutput;
	wire [3:0] xnorOutput;
	wire aLessThanB; wire result;wire equalsOutput;
	
	int j = 0;
	for(i=0; i<7; i=i+2; j=j+1)begin
		and(andOutput[i],~a[j],b[j]);
		and(andOutput[i+1],a[j],~b[j]);
		xnor(xnorOutput[j], andOutput[i], andOutput[i+1]);
	end
	
	and(a1,~andOutput[2], xnorOutput[0]);
	assign a2 = xnorOutput[0] & xnorOutput[1] & andOutput[4];
	assign a3 = xnorOutput[0] & xnorOutput[1] & xnorOutput[2] & andOutput[6]; 
	assign aLessThanB = a1 | a2 | a3 | andOutput[0]
	
	for(i=0; i< 4; i=i+1)begin
		assign equalsOutput &= xnorOutput[i]; 
	end
	
	assign result = equalsOutput | aLessThanB;
endmodule

module equals(input [3:0] A, B, output result);
	wire x0,x1,x2,x3, r1, r2;
	
	xnor G1(x0, a[0], b[0]);
	xnor G2(x1, a[1], b[1]);
	xnor G3(x2, a[2], b[2]);
	xnor G4(x3, a[3], b[3]);
	
	and G5(r1,x0,x1);
	and G5(r2,x2,x3);
	and ResultGate(result,r1,r2);
endmodule  

module LoadShip (input [3:0] crewSize, passengerSize, cargoSpace, output nextState);
	//check passenger size
	comparator(passengerSize,4'b1111,isShipFull);
	
	//check crew size
	equals(crewSize,4'b0100,isCrewOnBoard);

	//check cargo space size
	comparator(cargoSpace,4'b1111,isCargoFull);
	
	if(isShipFull & isCrewOnBoard & isCargoFull)begin
		assign nextState = 3'010
	end else begin
		assign nextState = 3'b111
	end
endmodule 