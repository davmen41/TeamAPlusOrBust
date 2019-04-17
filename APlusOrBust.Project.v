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
module comparator(input [3:0] A, B, output result);
	wire a1,a2,a3,a4; // AND outputs
	wire [7:0] andOutput;
	wire [3:0] xnorOutput;
	wire aLessThanB; 
	wire result;
	wire equalsOutput;
	
	assign andOutput[0] = ~A[3] & B[3];
	assign andOutput[1] = A[3] & ~B[3];
	assign andOutput[2] = ~A[2] & B[2];
	assign andOutput[3] = A[2] & ~B[2];
	assign andOutput[4] = ~A[1] & B[1];
	assign andOutput[5] = A[1] & ~B[1];
	assign andOutput[6] = ~A[0] & B[0];
	assign andOutput[7] = A[0] & ~B[0];
	
	xnor(xnorOutput[0], andOutput[0],andOutput[1]);
	xnor(xnorOutput[1], andOutput[2],andOutput[3]);
	xnor(xnorOutput[2], andOutput[4],andOutput[5]);
	xnor(xnorOutput[3], andOutput[6],andOutput[7]);
	
	assign a1 = andOutput[2] & xnorOutput[0];
	assign a2 = xnorOutput[0] & xnorOutput[1] & andOutput[4];
	assign a3 = xnorOutput[0] & xnorOutput[1] & xnorOutput[2] & andOutput[6]; 
	assign aLessThanB = a1 | a2 | a3 | andOutput[0];
	assign equalsOutput = xnorOutput[0] & xnorOutput[1] & xnorOutput[2] & xnorOutput[3];
	
	assign result = equalsOutput | aLessThanB;
endmodule

module equals(input [3:0] a, b, output result);
	wire x0,x1,x2,x3, r1, r2;
	
	xnor G1(x0, a[0], b[0]);
	xnor G2(x1, a[1], b[1]);
	xnor G3(x2, a[2], b[2]);
	xnor G4(x3, a[3], b[3]);
	
	and G5(r1,x0,x1);
	and G5(r2,x2,x3);
	and ResultGate(result,r1,r2);
endmodule  
/*
 * State 1: Rest State
 */
 module rest(output nextState);
 
	//do nothing for now
	assign nextState = 3'b001;
 endmodule
 
 /*
  *	State 2: Load ship
  */

module LoadShip (input [3:0] crewSize, passengerSize, cargoSpace, output nextState);
	wire [3:0] fixedPassengerSize; wire [3:0] fixedCrewSize; wire [3:0] fixedCargoSize;
	wire isShipFull; wire isCrewOnBoard; wire isCargoFull;
	reg [2:0] state; wire nextState;
	
	assign fixedPassengerSize = 4'b1111;
	assign fixedCrewSize = 4'b0100;
	assign fixedCargoSize = 4'b1111;
	
	//check passenger size
	comparator  checkPassengerSize(passengerSize,fixedPassengerSize,isShipFull);
	
	//check crew size
	equals checkCrewSize(crewSize,fixedCrewSize,isCrewOnBoard);

	//check cargo space size
	comparator checkCargoSize(cargoSpace,fixedCargoSize,isCargoFull);
	
	wire shipLoaded = isShipFull & isCrewOnBoard & isCargoFull;

	always @* begin
		if(shipLoaded)begin
			state <= 3'b010;
		end else begin
			state <= 3'b111;
		end
	end
	
	assign nextState = state;
endmodule 
