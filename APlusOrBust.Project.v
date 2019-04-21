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

//4-bit multiplier
module multiplier(input [3:0] a, b, output [7:0] result);
	wire [7:0] result;
	//1st adder
	wire [3:0] addr1;
	assign result[0] = a[0] & b[0];
	assign addr1[0] = a[0] & b[1];
	assign addr1[1] = a[0] & b[2];
	assign addr1[2] = a[0] & b[3];
	assign addr1[3] = 1'b0;
	
	wire [3:0] addr2;
	assign addr2[0] = a[1] & b[0];
	assign addr2[1] = a[1] & b[1];
	assign addr2[2] = a[1] & b[2];
	assign addr2[3] = a[1] & b[3];
	
	wire [3:0] out1;
	wire cout1;
	nBitAdder #(3) sum1(out1,cout1,addr1, addr2, 1'b0);
	
	//2nd Adder
	wire [3:0] addr3;
	assign result[1] = out1[0];
	assign addr3[0] = out1[1];
	assign addr3[1] = out1[2];
	assign addr3[2] = out1[3];
	assign addr3[3] = cout1;
	
	wire [3:0] addr4;
	assign addr4[0] = a[2] & b[0];
	assign addr4[1] = a[2] & b[1];
	assign addr4[2] = a[2] & b[2];
	assign addr4[3] = a[2] & b[3];
	
	wire [3:0] out2;
	wire cout2;
	nBitAdder #(3) sum2(out2,cout2,addr3, addr4, 1'b0);
	
	//3rd Adder
	wire [3:0] addr5;
	assign result[2] = out2[0];
	assign addr5[0] = out2[1];
	assign addr5[1] = out2[2];
	assign addr5[2] = out2[3];
	assign addr5[3] = cout2;
	
	wire [3:0] addr6;
	assign addr6[0] = a[3] & b[0];
	assign addr6[1] = a[3] & b[1];
	assign addr6[2] = a[3] & b[2];
	assign addr6[3] = a[3] & b[3];
	
	wire [3:0] out3;
	wire cout3;
	nBitAdder #(3) sum3(out3,cout3,addr5, addr6, 1'b0);
	
	//set result
	assign result[3] = out3[0];
	assign result[4] = out3[1];
	assign result[5] = out3[2];
	assign result[6] = out3[3];
	assign result[7] = cout3;	
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

module LoadShip (input [3:0] crewSize, passengerSize, cargoSpace, output[1:0] nextState, output [3:0] totalWeight, output carryOut);
	wire carryOut, weightChk;
	wire [1:0] nextState;
	reg [1:0] state;
	
	wire[3:0] MAX_WEIGHT = 4'b111;
	wire [3:0] sum1, totalWeight;
	wire cout1, cout2;
	
	nBitAdder #(3) gettotal1(sum1,cout1,passengerSize, crewSize, 1'b0);
	nBitAdder #(3) gettotal2(totalWeight,carryOut,sum1, cargoSpace, cout1);
	wire overflow = carryOut ~| 1'b0;
	
	//check to see if weight requirements are met
	comparator comp(MAX_WEIGHT, totalWeight, weightChk);
	wire shipLoaded = overflow & weightChk;
	
	
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
module Travel(input [3:0] passenger, crew, cargo, totalWeight, output [1:0] nextState, output [7:0] currentForce);
	wire [7:0] currentForce;
	wire [3:0] sum1;
	wire cout1, cout2;
	wire [3:0] FIXED_ACCELERATION = 4'b1000; //acceleration rate is 8yrs/h
	reg [2:0] state;
	wire [1:0] nextState;
	
	//calculate force
	multiplier calcForce(totalWeight, FIXED_ACCELERATION, currentForce);
	
	wire [8:0] isForceSafe = currentForce & 8'b10000000;
	
	always @* begin
		if(isForceSafe == 8'b00000000)begin
			state <= 2'b10;
		end else begin
			state <= 2'b11;
		end
	end
	assign nextState = state;
	
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
	wire [1:0] rst, load, next,safe,enough, fail;
	wire signed [11:0] difference;
	wire [7:0] crntFrce;
	wire [3:0] totalWeight;
	wire cOut;
	wire [4:0] totalWithCarry = {cOut, totalWeight};
	//IF YOU NEED TO OUTPUT AS INTEGER, PARSE HERE
	integer crewInt, passIn,cargoIn;	
	integer yearInt,differenceInt;
	integer altInt;
	integer h2oInt, breadInt;
	integer frceInt, ttlweightInt;
	always @* begin
		crewInt = crew;
		passIn = passenger;
		cargoIn = cargospace;
		yearInt= year;
		differenceInt=difference;
		altInt=alt;
		h2oInt=h2o;
		breadInt=bread;
		frceInt=crntFrce;
		ttlweightInt = totalWithCarry;
	end
	
	//ADD MODULE CALL TO YOUR STATE HERE
	rest S1(rst);
	LoadShip S2(crew, passenger, cargospace, load, totalWeight, cOut);
	Calculation S3(year,difference, next);
	Travel S4(passenger, crew, cargospace, totalWeight, enough, crntFrce);
	Destination S5(alt,temperature,radiation,o2,lives,safe);
	doom S6(fail);
	//ADD MODULE OUTPUT TO CASE STATEMENT AND UPDATE THE OUTPUT FOR YOUR STATE
	always @(selector) begin
		case ( selector )
			3'b000: out = rst;
			3'b001: out = load;
			3'b010: out = next;
			3'b011: out = enough;
			3'b100: out = safe;
			3'b111: out = fail;
			default: out = 2'b00;
		endcase
		//Output from each state!
		case ( selector )
			3'b000:$display(" Rest State           %b      Firing up all systems...",rst);
			3'b001:$display(" Load State           %b      Total ship weight of passengers %b(%0d), crew %b(%0d) and cargo %b(%0d) is %0d(%b). Maximum Weight is 15(kg*10)"
				,load,passenger,passIn,crew,crewInt,cargospace,cargoIn, ttlweightInt,totalWithCarry);
			3'b010:$display(" Calculate State      %b      Current Year:2019, Year travel to:%0d, Difference amount:%0d",next,yearInt,differenceInt);
			3'b011:$display(" Travel State         %b      Traveling through time at a current force of %0d(%b) yrs/s",enough,frceInt,crntFrce);
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
  wire [3:0] cargospace = 4'b0010;
  wire [3:0] passenger = 4'b0011;
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