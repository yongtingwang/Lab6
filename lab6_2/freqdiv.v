`timescale 1ns / 1ps
//************************************************************************
// Filename      : freqdiv.v
// Author        : Hsi-Pin Ma
// Function      : Frequency divider
// Last Modified : Date: 2012-04-02
// Revision      : Revision: 1
// Copyright (c), Laboratory for Reliable Computing (LaRC), EE, NTHU
// All rights reserved
//************************************************************************
`include "global.v"
module freqdiv(
  clk_40M, // clock from the 40MHz oscillator
  rst_n, // low active reset
  clk_1, // divided clock output
  clk_debounce, // clock control for debounce circuit
  clk_ftsd_scan, // divided clock for 14-segment display scan
  clk_100 // generated 100 Hz clock

);

// Declare I/Os
input clk_40M; // clock from the 40MHz oscillator
input rst_n; //low active reset
output clk_1; //divided clock output
output clk_debounce; // clock control for debounce circuit
output [`FTSD_SCAN_CTL_BIT_WIDTH-1:0] clk_ftsd_scan; // divided clock for 14-segment display scan
output clk_100;
// Declare internal nodes
reg clk_100;
reg clk_100_next;
reg clk_1; // divided clock output (in the always block)
reg clk_debounce; // clock control for debounce circuit
reg [`FTSD_SCAN_CTL_BIT_WIDTH-1:0] clk_ftsd_scan; // divided clock for seven-segment display scan (in the always block)
reg [14:0] cnt_l; // temperatory buffer
reg [5:0] cnt_h; // temperatory buffer
reg [`FREQ_DIV_BIT-1:0] cnt_next; // input node to flip flops
reg [`DIV_BY_200K_BIT_WIDTH-1:0] count_200K,count_200K_next;
// Combinational block 
always @*
  cnt_next = {clk_1,cnt_h,clk_debounce,clk_ftsd_scan,cnt_l} + 1'b1;
  
// Sequential block 
always @(posedge clk_40M or negedge rst_n)
  if (~rst_n)
    {clk_1,cnt_h,clk_debounce,clk_ftsd_scan,cnt_l} <= `FREQ_DIV_BIT'b0;
  else
    {clk_1,cnt_h,clk_debounce,clk_ftsd_scan,cnt_l} <= cnt_next;

always@(*)
	if(count_200K==`DIV_BY_200K-1) begin
		count_200K_next=`DIV_BY_200K_BIT_WIDTH'd0;
		clk_100_next=~clk_100; end
	else begin
		count_200K_next=count_200K+1'b1;
		clk_100_next=clk_100; end

always@(posedge clk_40M or negedge rst_n)
	if(~rst_n) begin
		count_200K<=`DIV_BY_200K_BIT_WIDTH'b0;
		clk_100<=1'b0; end
	else begin
		count_200K<=count_200K_next;
		clk_100<=clk_100_next; end


endmodule
