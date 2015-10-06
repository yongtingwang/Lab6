`timescale 1ns / 1ps
//************************************************************************
// Filename      : top.v
// Author        : Hsi-Pin Ma
// Function      : Top module for keypad scan example
// Last Modified : Date: 2012-04-02
// Revision      : Revision: 1
// Copyright (c), Laboratory for Reliable Computing (LaRC), EE, NTHU
// All rights reserved
//************************************************************************
`include "global.v"
module top(
  clk, // clock from crystal oscillator
  rst_n, // sctive low reset
  col_n, // pressed column index
  row_n, // scanned row index
  display, // 14-segment display
  col_out, // output for debug (column index)
  row_out, // output for debig (row index)
  ftsd_ctl, // 14-segment display scan control
  pressed, // whether keypad pressed (1) or not (0)
  pb_in,    //push button add
  pb_sub,    //push button sub
  add,
  sub
);
// Declare I/Os
input clk,rst_n,pb_in,pb_sub; 
input [`KEYPAD_ROW_WIDTH-1:0] col_n; // pressed column index

output [`KEYPAD_ROW_WIDTH-1:0] row_n;  // scanned row index
output [`FTSD_BIT_WIDTH-1:0] display; // 14-segment display
output [`KEYPAD_COL_WIDTH-1:0] col_out; // output for debug (column index)
output [`KEYPAD_ROW_WIDTH-1:0] row_out; // output for debig (row index)
output [`FTSD_NUM-1:0] ftsd_ctl; // 14-segment display scan control
output pressed,add,sub; // whether keypad pressed (1) or not (0)

// Declare internal nodes
wire clk_d; // divided clock
wire clk_debounce;
wire clk_100;

//wire [3:0] db_col;
wire [3:0] key; // pressed key
wire [1:0] ftsd_ctl_en;
wire [3:0] ftsd_in;
wire [3:0] in0,in1,in2,in3;


assign col_out = ~col_n;
assign row_out = ~row_n;
assign add=~pb_in;
assign sub=~pb_sub;
// Frequency divider
freqdiv U_F(
  .clk_40M(clk), // clock from the 40MHz oscillator
  .rst_n(rst_n), // low active reset
  .clk_1(clk_d), //divided clock output
  .clk_debounce(clk_debounce), // clock control for debounce circuit
  .clk_ftsd_scan(ftsd_ctl_en),
  .clk_100(clk_100)  // divided clock for 14-segment display scan
);

 
fsm_count fc1( 
 // .count_enable,  // if counter is enabled 
  .in_add(~pb_in), //input control
  .in_sub(~ pb_sub),
  .clk(clk_d), // global clock signal
  .rst_n(rst_n),  // low active reset
  .in0(in0),
  .in1(in1),
  .in2(in2),
  .in3(in3),
  .key(key),
  .pressed(pressed)
); 
	 

// Keypad scan
keypad_scan U_k(
  .clk(clk_debounce), // scan clock
  .rst_n(rst_n), // active low reset
  .col_n(col_n), // pressed column index
  .row_n(row_n), // scanned row index
  .key(key), // returned pressed key
  .pressed(pressed) // whether key pressed (1) or not (0)
);

// Scan control
scan_ctl U_SC(
  .in0(in0), // 1st input
  .in1(in1), // 2nd input
  .in2(in2), // 3rd input
  .in3(in3),  // 4th input
  .ftsd_ctl_en(ftsd_ctl_en), // divided clock for scan control
  .ftsd_ctl(ftsd_ctl), // ftsd display control signal
  .ftsd_in(ftsd_in) // output to ftsd display
);

ftsd U_D(
  .in(ftsd_in),  // binary input
  .display(display) // 14-segment display output
);

endmodule
