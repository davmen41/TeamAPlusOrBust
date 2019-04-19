/*
 * Time Machine Code - Make sure any code added has comments!
 */
 //D-Flip Flop
module DFF(clk, in, out);
	parameter n = 1;
	input clk;
	input [n-1:0] in;
	output [n-1:0] out;
	reg [n-1:0] out;
	
	initial out <= 0;
	always @(posedge clk)
	out = in;
	
endmodule
 
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
 module rest(output [1:0] nextState);
 	reg [1:0] nextState;
	//do nothing for now
	initial assign nextState = 2'b10;
 endmodule
 
 /*
  *	State 2: Load ship
  */

module LoadShip (input [3:0] crewSize, passengerSize, cargoSpace, output[1:0] nextState);
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
			state <= 2'b10;
		end else begin
			state <= 2'b11;
		end
	end
	
	assign nextState = state;
endmodule 

//Ties in all states together, place your code here!!
module mux(input [2:0] selector, output [1:0] out);
	reg [1:0] out;
	wire [1:0] rst, load, travel, destination;
	
	wire [3:0] crew = 4'b0100;
	wire [3:0] passenger = 4'b1111;
	
	rest S1(rst);
	LoadShip S2(crew, passenger, passenger, load);
	
	always @(selector) begin
	case ( selector )
		3'b000: 
			out = rst;
			//$display("Do I work?");
		3'b001: out = load;
		3'b010: out = 2'b10;
		3'b011: out = 2'b10;
		3'b100: out = 2'b10;
		3'b111: out = 2'b10;
		default: out = 2'b00;
	endcase
	end
	always @* begin
		$display("1MUX(C): %b SELECTOR: %b",out, selector);
	end

endmodule

/*
 * TIME MACHINE MODULE: ALL CODE COMES TOGETHER HERE
 */
module TimeMachine(input clk, output [2:0]q, output [1:0] out, output cs0, cs1,cs2);
	
	wire cs2,cs1,cs0;
	wire ns2, ns1,ns0;
	wire [2:0] q;
	wire [1:0] out;
		
	assign ns0 = out[0] | (~out[1] & cs0) | (out[1] & cs1 & ~cs0) |
		(out[1] & cs2 & cs1) | (~cs2 & ~cs1 & ~cs0 & out[1]);
	
	
	assign ns1 = out[0] | (~out[1] & cs1) |(out[1] & ~cs1 & cs0) |
		(out[1] & cs1 & ~cs0) | (cs2 & cs1 & out[1]);
 	
	
	assign ns2 = cs2 | out[0] | (out[1] & cs1 & cs0);
	
	DFF d0(clk, ns0, cs0);
	DFF d1(clk, ns1, cs1);
	DFF d2(clk, ns2, cs2);
	
	mux stateSelector({cs2,cs1,cs0}, out);

	
	assign q[0] = cs0;
	assign q[1] = cs1;
	assign q[2] = cs2;
endmodule

module Testbench();
  reg clk;
  wire [2:0]q;
  wire [1:0] out;
  wire cs2,cs1,cs0;
  
  //PLACE ALL INPUTS HERE AND MAKE SURE TO INCLUDE THEM IN 
  
  
  TimeMachine ex(clk,q, out, cs0, cs1, cs2);
          
  initial begin
	forever
		begin
			$display("Toggle clk.");
			#1 clk = 0;
			display;
			
			#1 clk = 1;
			display;
		end	
	end
  
  task display;
    #1 $display("%b, Current State: %0h%0h CS2: %b CS1: %b CS0: %b",clk,ex.out[1], ex.out[0], ex.cs2,ex.cs1, ex.cs0);
  endtask
  initial begin
	#20
	$finish;
  end 
endmodule