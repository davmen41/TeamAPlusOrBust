 /*
  *	State : Destination
  */
  
  module Destination (input [9:0] altitude, temp, rad, oxygen, life, output[1:0] nextState);
  
	//max altitude
	wire [9:0] fixedAlt;
	
	wire nextState;
  
	//set max altitude
	assign fixedAlt = 10'b1100000000;
  
	//err 
	wire err = temp & ~rad & oxygen & life; 
  
	//compare altitude to max altutude
	comparatorCal first_com(altitude, fixedAlt, large, equal, small);
  
	//shift bits if atltitude is larger
	always @* begin
		if(large  > 0)
			$display (" altitude: %b", (altitude >> 1));
			comparatorCal second_com(altitude, fixedAlt, large2, equal2, small2);
			
	    //else pass < and = thru OR
		else 
			wire pass = equal || small;
	end
	
	//Altitude check bit
	wire altCheck = pass || small2;
	
	//set next state
	always @* begin
		if(altCheck  > err)
			assign nextState = 000;
		else
			assign nextState = 111;
	end
	
	initial begin
	$display (" Next State : %b", nextState);
	end
	
endmodule


module Destination_testbench;
	wire nextState;
	wire [9:0] t_altitude = 10'b1101100001;
	
	wire t_temp = 1;
	wire t_rad = 0;
	wire t_oxygen = 1;
	wire t_life = 1;
	
	initial begin
		
	end
	
	endmodule
	
	
	
	