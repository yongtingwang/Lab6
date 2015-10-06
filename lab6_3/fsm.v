//************************************************************************
// Filename      : FSM.v
// Author        : hp
// Function      : FSM module for digital watch
// Last Modified : Date: 2009-03-10
// Revision      : Revision: 1
// Copyright (c), Laboratory for Reliable Computing (LaRC), EE, NTHU
// All rights reserved
//************************************************************************
`include "global.v"
module fsm_count(
 // count_enable,  // if counter is enabled 
  in_add, //input control
  in_sub,
  clk, // global clock signal
  rst_n,  // low active reset
  in0,
  in1,
  in2,
  in3,
  key,
  pressed
);

// outputs
//output count_enable;  // if counter is enabled 
output reg [3:0]  in0, in1, in2, in3;
// inputs
input [3:0] key;
input pressed;
input clk; // global clock signal
input rst_n; // low active reset
input in_add,in_sub; //input control

//reg count_enable;  // if counter is enabled 
reg [2:0] state; // state of FSM
reg [2:0] next_state; // next state of FSM
reg [3:0] in0_temp,in1_temp,in2_temp,in3_temp;
reg [4:0] temp,temp_10,temp_100;
// ***************************
// FSM
// ***************************
// FSM state decision

always @(*)

  case (state)
	 3'b000:    if (in_add || in_sub) begin
						  next_state = 3'b010;			end
					else if (pressed) begin
						  next_state = 3'b001;
								in0_temp=0;
								in1_temp=key;
								in2_temp=0;
								in3_temp=0; end
					
					else begin
							 next_state = 3'b000;
								in0_temp=in0;
								in1_temp=in1;
								in2_temp=in2;
								in3_temp=in3;end	
								
	 3'b001:   	if (in_add || in_sub) begin
						  next_state = 3'b010;			end						
					else if (pressed) begin
						  next_state = 3'b001;
								in0_temp=in1;
								in1_temp=key;
								in2_temp=0;
								in3_temp=0; end			
					else begin
							 next_state = 3'b001;
								in0_temp=in0;
								in1_temp=in1;
								in2_temp=in2;
								in3_temp=in3;end				
								
								
    3'b010:      if (in_add || in_sub)  begin
						  next_state = 3'b100;  end
						else if (pressed)  begin
						  next_state =  3'b011;
								in0_temp=in0;
								in1_temp=in1;
								in2_temp=0;
								in3_temp=key;end
						else begin
						 next_state =  3'b010;
								in0_temp=in0;
								in1_temp=in1;
								in2_temp=in2;
								in3_temp=in3;end 	
								
	 3'b011:    		if (in_add)  begin
						  next_state = 3'b100;  
						   
							temp=in1+in3;
							temp_10=in0+in2;
							temp_100=0;
							
							if(temp<5'd10&&temp_10<5'd10) begin
									in0_temp=0;
									in1_temp=0;
									in2_temp=temp_10;
									in3_temp=temp;end
									
							else if(temp>=5'd10&&temp_10<5'd10&&(temp_10+1'b1)<5'd10) begin
									in0_temp=0;
									in1_temp=0;
									in2_temp=temp_10+1'b1;
									in3_temp=temp-5'd10;end
									
							else if(temp>=5'd10&&temp_10<5'd10&&(temp_10+1'b1)>=5'd10) begin
									in0_temp=0;
									in1_temp=4'd1;
									in2_temp=0;
									in3_temp=temp-5'd10;end		
									
							else if(temp>=5'd10&&temp_10>=5'd10) begin
									in0_temp=0;
									in1_temp=4'd1;
									in2_temp=temp_10-5'd9;
									in3_temp=temp-5'd10;end
									
							else if(temp<5'd10&&temp_10>=5'd10) begin
									in0_temp=0;
									in1_temp=4'd1;
									in2_temp=temp_10-5'd10;
									in3_temp=temp;end
									
								else begin
									in0_temp=4'd11;
									in1_temp=4'd11;
									in2_temp=4'd11;
									in3_temp=4'd11;end
						  end
						  
						 else if (in_sub)  begin
						  next_state = 3'b100;  
						   if(in1>in3) begin
									in0_temp=0;
									in1_temp=0;
									in2_temp=in0-in2;
									in3_temp=in1-in3;end
							else  begin
									in0_temp=0;
									in1_temp=0;
									in2_temp=in0-in2-4'd1;
									in3_temp=4'd10-in3+in1;end				
							
						  end
						 
						else if (pressed)  begin
						  next_state =  3'b011;
								in0_temp=in0;
								in1_temp=in1;
								in2_temp=in3;
								in3_temp=key;end
						else begin
						 next_state =  3'b011;
								in0_temp=in0;
								in1_temp=in1;
								in2_temp=in2;
								in3_temp=in3;end 					
															
		
    3'b100:
						if (in_add || in_sub)   begin
						  next_state = 3'b000;  
							   in0_temp=0;
								in1_temp=0;
								in2_temp=0;
								in3_temp=0;end
						else    begin
						  next_state = 3'b100;
								in0_temp=in0;
								in1_temp=in1;
								in2_temp=in2;
								in3_temp=in3;
								  end
 /*   default:
      begin
        next_state = `ADD_DISPLAY;	 

    end */
  endcase

// FSM state transition
always @(posedge clk or negedge rst_n)
  if (~rst_n)begin
    state <= 3'b000;
	 in0<=0;
	 in1<=0;
	 in2<=0;
	 in3<=0;end
  else begin
    state <= next_state;
	 in0<=in0_temp;
	 in1<=in1_temp;
	 in2<=in2_temp;
	 in3<=in3_temp; end
endmodule
