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
module mux(input [2:0] selector,input[3:0] crew, passenger,cargospace, output [1:0] out);
	reg [1:0] out;
	wire [1:0] rst, load, travel, destination;

	//IF YOU NEED TO OUTPUT AS INTEGER, PARSE HERE
	integer crewInt, passIn,cargoIn;	
	always @* begin
		crewInt = crew;
		passIn = passenger;
		cargoIn = cargospace;
	end
	
	//ADD MODULE CALL TO YOUR STATE HERE
	rest S1(rst);
	LoadShip S2(crew, passenger, cargospace, load);
	
	//ADD MODULE OUTPUT TO CASE STATEMENT AND UPDATE THE OUTPUT FOR YOUR STATE
	always @(selector) begin
		case ( selector )
			3'b000: out = rst;
			3'b001: out = load;
			3'b010: out = 2'b10;
			3'b011: out = 2'b10;
			3'b100: out = 2'b10;
			3'b111: out = 2'b10;
			default: out = 2'b00;
		endcase
		//Output from each state!
		case ( selector )
			3'b000:$display(" Rest State           %b      Firing up all systems...",rst);
			3'b001:$display(" Load State           %b      Passengers on board %b(%0d)/15, crew %b(%0d)/4, cargo space %b(%0d)/15(kg)"
				,rst,passenger,passIn,crew,crewInt,cargospace,cargoIn);
			3'b010:$display(" Calculate State      %b     Firing up all systems...",selector);
			3'b011:$display(" Travel State         %b     Firing up all systems...",selector);
			3'b100:$display(" Destination State    %b     Firing up all systems...",selector);
			3'b111:$display(" Doom State           %b     Whoops! Your ship has crashed, retrace your steps to see your mistake",selector);
			default:$display(" Rest State          %b     Firing up all systems...",selector);
		endcase
	end
endmodule

/*
 * TIME MACHINE MODULE: ALL CODE COMES TOGETHER HERE
 */
module TimeMachine(input clk,input[3:0] crew, passenger,cargospace, output [2:0]q, output [1:0] out, output cs0, cs1,cs2);
	
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
	
	mux stateSelector({cs2,cs1,cs0}, crew,passenger,cargospace,out);

	
	assign q[0] = cs0;
	assign q[1] = cs1;
	assign q[2] = cs2;
endmodule

/*
	Steps to Merging your code:
	1)Add any needed inputs into the testbench
	2)make sure you add inputs into methods mux and TimeMachine
	3)add in your inputs to call for mux stateSelector inside TimeMachine
	4)Inside mux, make call to your method and place the output inside
		the case statement, also place your output inside the output case
	5)Test to make sure everything works!
 */

module Testbench();
  reg clk;
  wire [2:0]q;
  wire [1:0] out;
  wire cs2,cs1,cs0;
  
  //PLACE ALL INPUTS HERE AND MAKE SURE TO INCLUDE THEM IN 
  wire [3:0] cargospace = 4'b1001;
  wire [3:0] passenger = 4'b1011;
  wire [3:0] crew = 4'b0100;
  
  //ADD YOUR INPUT HERE TOO
  TimeMachine ex(clk, crew, passenger,cargospace, q, out, cs0, cs1, cs2);
          
  initial begin
   $display("TIME MACHINE");
   $display("|------------------|--------|------------------------------------------------------|");
   $display("|Current State     | Output |State Output                                          |");
   $display("|------------------|--------|------------------------------------------------------|");
	forever
		begin
			#1 clk = 0;
			
			#1 clk = 1;
		end	
	end
  initial begin
	#20
	$finish;
  end 
endmodule