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
  in, //input control
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
input in; //input control

//reg count_enable;  // if counter is enabled 
reg state; // state of FSM
reg next_state; // next state of FSM
reg [3:0] in0_temp,in1_temp,in2_temp,in3_temp;
reg [4:0] temp;
// ***************************
// FSM
// ***************************
// FSM state decision

always @(*)

  case (state)
	 `ADDEND:    if (in) begin
						  next_state = `AUGEND;			end
					 else if (~in&&pressed) begin
						  next_state = `ADDEND;
								in0_temp=key;
								in1_temp=0;
								in2_temp=0;
								in3_temp=0; end
					else begin
							 next_state = `ADDEND;
								in0_temp=in0;
								in1_temp=in1;
								in2_temp=in2;
								in3_temp=in3;end	
								
    `AUGEND:      if (in)  begin
						  next_state = `ADD_DISPLAY;  end
						else if (~in&pressed)  begin
						  next_state = `AUGEND;
								in0_temp=in0;
								in1_temp=key;
								temp=in0+in1;
								if(temp<4'd10) begin
									in2_temp=0;
									in3_temp=temp;end
								else begin
									in2_temp=4'd1;
									in3_temp=temp-4'd10;end
								end
						else begin
						 next_state = `AUGEND;
								in0_temp=in0;
								in1_temp=in1;
								in2_temp=in2;
								in3_temp=in3;end 	
		
    `ADD_DISPLAY:
						if (in)   begin
						  next_state = `ADDEND;     end
						else    begin
						  next_state = `ADD_DISPLAY;
						
							temp=in0+in1;
							
							if(temp<4'd9) begin
									in0_temp=in0;
									in1_temp=in1;
									in2_temp=0;
									in3_temp=temp;end
								else begin
									in0_temp=in0;
									in1_temp=in1;
									in2_temp=4'd1;
									in3_temp=temp-4'd9;end	  end
 /*   default:
      begin
        next_state = `ADD_DISPLAY;	 

    end */
  endcase

// FSM state transition
always @(posedge clk or negedge rst_n)
  if (~rst_n)begin
    state <= `ADDEND;
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
