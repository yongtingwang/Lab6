`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:47:32 09/03/2015 
// Design Name: 
// Module Name:    count 
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
module count(
	key,
	in0,
	in1,
	in2,
	in3,
	add,
	clk,
	rst_n
    );
input key,add,clk,rst_n;
output reg [3:0] in0,in1,in2,in3;
reg [3:0] in0_temp,in1_temp,in2_temp,in3_temp,temp;


always@(posedge clk or negedge rst_n)
	if(~rst_n)begin
		in0<=0;
		in1<=0;
		in2<=0;
		in3<=0;
		end
	else begin
		in0<=in0_temp;
		in1<=in1_temp;
		in2<=in2_temp;
		in3<=in3_temp;
		end

always@(*)
if(~add)
	in0_temp=key;
else begin
	in1_temp=key;
	temp=in0+in1;
	if(temp<4'd9) begin
		in2_temp=0;
		in3_temp=temp;
		end
	else begin
		in2_temp=4'd1;
		in3_temp=temp-4'd9;
		end
		
	end


endmodule
