`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:59:36 09/03/2015 
// Design Name: 
// Module Name:    button_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module button_module(
	clk,
	clk_100,
	rst_n,
	pb_in,
//	count_enable,
	in0,
	in1,
	in2,
	in3,
	key,
	pressed
    );

input clk_100,rst_n,pb_in,clk,pressed;
input [3:0] key;
//output  count_enable;
output  [3:0] in0,in1,in2,in3;
wire pb_debounced;
wire out_pulse;

debounce d1(
	.clk_100(clk_100), //clock control
	.rst_n(rst_n), //reset
	.pb_in(pb_in), //push button input
	.pb_debounced(pb_debounced) //debounced push button output
    );
	 
one_pulse o1(
	.clk_100(clk),  //clock input
	.rst_n(rst_n),  //active low reset
	.in_trig(pb_debounced),  //input trigger
	.out_pulse(out_pulse)  //output one pulse
    );
	 
fsm_count fc1( 
 // .count_enable,  // if counter is enabled 
  .in(out_pulse), //input control
  .clk(clk), // global clock signal
  .rst_n(rst_n),  // low active reset
  .in0(in0),
  .in1(in1),
  .in2(in2),
  .in3(in3),
  .key(key),
  .pressed(pressed)
);

endmodule

