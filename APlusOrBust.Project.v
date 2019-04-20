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
 
 module Mux3a(a2, a1, a0, s, b) ;
   parameter k = 2 ;
   input [k-1:0] a0, a1, a2 ;  // inputs
   input [1:0]   s ; // one-hot select
   output [k-1:0] b ;
  reg [k-1:0] b ;
    always @(*) begin
    case(s) 
      3'b01: b = a0 ;
      3'b10: b = a1 ;
      3'b00: b = a2 ;
      default: b =  {k{1'bx}} ;
    endcase
  end
endmodule // Mux3a

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

//n bit adder
module nBitAdder(f, cOut, a, b, cIn);
  parameter n = 7; 	
 
  output reg [n:0] f;
  output reg cOut;
  input [n:0] a;
  input [n:0] b;
  input cIn;
 
  always @(a, b, cIn)
    {cOut, f} = a + b + cIn;
endmodule

//subtractor 
module subtractorCal(a,b,s);
	parameter k=12;
	input signed [k-1:0] a,b;
	output signed [k-1:0] s;
	reg [k-1:0] s;
	always @* begin	
		s=a-b;
	end
endmodule

//Toan's comparator
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

//David's comparator
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

/*
 *	State 3: Calculate
 */

module Calculation (input signed [11:0] yearIn,output signed [11:0] difference,output [1:0] nextState);
	wire signed [11:0] defaultYear, zero;
	wire [2:0] travelMode;
	wire l,l2,e,e2,s,s2;
	reg [2:0] state; wire nextState;
	
	assign defaultYear=12'b011111100011;
	assign zero=12'b0;
	
	//compare with zero
	comparatorCal #(12) checkZero(yearIn,zero,l,e,s);
	//find year difference
	subtractorCal #(12) minus2019(yearIn,defaultYear,difference);
	//compare w 2019 to find the mode
	comparatorCal #(12) check2(yearIn,defaultYear,l2,e2,s2);
		
	always @* begin
		state=l2|s2;
	end
	assign nextState={state,s};
endmodule
/*
 *	State 4: Travel
 */	
module Travel(input [7:0] water, food,output [1:0] nextState);
	wire [7:0] enoughFeed;
	wire [7:0] buffer;
	wire nextState;
	wire l,e,s;
	wire zero=0;
	wire cout;
	wire [1:0] temp;
	assign enoughFeed=8'b1100100; 
	
	nBitAdder #(7) addUp(buffer,cout,water,food,zero);
	assign temp={e,s};
	comparatorCal #(8) comp(buffer, enoughFeed, l,e,s);
	Mux3a mux(2'b10, 2'b00, 2'b11, temp, nextState) ;

endmodule
	
	
/*
 *	State 5: Destination
 */
 module Destination(input signed [9:0] altitude, input temp, rad, oxygen, life, output[1:0] nextState);
	wire signed [9:0] fixedAlt;
	wire l,l2,e,e2,s,s2;
	reg [2:0] state; wire nextState;
	wire  pass;
	wire signed [9:0] secondAlt;
	assign fixedAlt=10'b0110000000;
	wire err= ~(temp & ~rad & oxygen &life);
	
	//compare with max altitude
	comparatorCal #(10) checkAlt(altitude,fixedAlt, l,e,s);
	
	//shift bits if larger
	assign secondAlt=altitude<<<l; 
	comparatorCal #(10) check2(altitude,fixedAlt,l2,e2,s2);
	assign pass = e | s | ~l2;
	assign nextState={pass,err};
endmodule
 
 /*
 * State 6: doom
 */
 module doom(output [1:0] nextState);
 	reg [1:0] nextState;
	//do nothing for now
	initial assign nextState = 2'b00;
 endmodule
 
//Ties in all states together, place your code here!!
module mux(
	input [2:0] selector,
	input[3:0] crew, passenger,cargospace,
	input[11:0] year,
	input [9:0] alt,
	input temperature,radiation,o2,lives,
	input [7:0] h2o, bread,
	output [1:0] out);
	
	reg [1:0] out;
	wire [1:0] rst, load, next,safe,enough;
	wire signed [11:0] difference;
	//IF YOU NEED TO OUTPUT AS INTEGER, PARSE HERE
	integer crewInt, passIn,cargoIn;	
	integer yearInt,differenceInt;
	integer altInt;
	integer h2oInt, breadInt;
	always @* begin
		crewInt = crew;
		passIn = passenger;
		cargoIn = cargospace;
		yearInt= year;
		differenceInt=difference;
		altInt=alt;
		h2oInt=h2o;
		breadInt=bread;

	end
	
	//ADD MODULE CALL TO YOUR STATE HERE
	rest S1(rst);
	LoadShip S2(crew, passenger, cargospace, load);
	Calculation S3(year,difference, next);
	Travel S4(h2o,bread,enough);
	Destination S5(alt,temperature,radiation,o2,lives,safe);
	//ADD MODULE OUTPUT TO CASE STATEMENT AND UPDATE THE OUTPUT FOR YOUR STATE
	always @(selector) begin
		case ( selector )
			3'b000: out = rst;
			3'b001: out = load;
			3'b010: out = next;
			3'b011: out = enough;
			3'b100: out = safe;
			3'b111: out = 2'b10;
			default: out = 2'b00;
		endcase
		//Output from each state!
		case ( selector )
			3'b000:$display(" Rest State           %b      Firing up all systems...",rst);
			3'b001:$display(" Load State           %b      Passengers on board %b(%0d)/15, crew %b(%0d)/4, cargo space %b(%0d)/15(kg)"
				,load,passenger,passIn,crew,crewInt,cargospace,cargoIn);
			3'b010:$display(" Calculate State      %b      Current Year:2019, Year travel to:%0d, Difference amount:%0d",next,yearInt,differenceInt);
			3'b011:$display(" Travel State         %b      Food:%0d, Water:%0d. Check if provisions are enough",safe,breadInt,h2oInt);
			3'b100:$display(" Destination State    %b      Safe altitude:384, Landed altitude:%0d,Temperature:%b,Radiation:%b,o2:%b,Lives:%b",
					safe,altInt,temperature,radiation,o2,lives);
			3'b111:$display(" Doom State           %b     Whoops! Your ship has crashed, retrace your steps to see your mistake",selector);
			default:$display(" Rest State          %b     Firing up all systems...",selector);
		endcase
	end
endmodule

/*
 * TIME MACHINE MODULE: ALL CODE COMES TOGETHER HERE
 */
module TimeMachine(input clk,input[3:0] crew, passenger,cargospace, input[11:0] year,input [9:0] alt,
	input temperature,radiation,o2,lives,input [7:0] h2o,bread,output [2:0]q, output [1:0] out, output cs0, cs1,cs2);
	
	wire cs2,cs1,cs0;
	wire ns2, ns1,ns0;
	wire [2:0] q;	//current
	wire [1:0] out;
		
	assign ns0 = out[0] | (~out[1] & cs0) | (out[1] & cs1 & ~cs0) |
		(out[1] & cs2 & cs1) | (~cs2 & ~cs1 & ~cs0 & out[1]);
	
	
	assign ns1 = out[0] | (~out[1] & cs1) |(out[1] & ~cs1 & cs0) |
		(out[1] & cs1 & ~cs0) | (cs2 & cs1 & out[1]);
 	
	
	assign ns2 = cs2 | out[0] | (out[1] & cs1 & cs0);
	
	DFF d0(clk, ns0, cs0);
	DFF d1(clk, ns1, cs1);
	DFF d2(clk, ns2, cs2);
	//change here too
	mux stateSelector({cs2,cs1,cs0}, crew,passenger,cargospace,year,alt,temperature,radiation,o2,lives,h2o,bread,out);

	
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
  wire [11:0] year= 12'b011101100011;
  wire [9:0] alt=10'b0100010000;
  wire temperature=1;
  wire radiation=0;
  wire o2=1;
  wire lives=1;
  wire [7:0] h2o =8'b01101000;
  wire [7:0] bread=8'b00001001;
  
  //ADD YOUR INPUT HERE TOO
  TimeMachine ex(clk, crew, passenger,cargospace, year,alt, temperature,radiation,o2,lives,h2o,bread,q, out, cs0, cs1, cs2);
          
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