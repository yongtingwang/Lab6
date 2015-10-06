`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:08:12 09/04/2015 
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
`include "global.v"
module count(
	clk,
	rst_n,
	in0,
	in1,
	in2,
	in3,
	key,
	pressed,
	state
    );
// I/O
input clk,rst_n,pressed;
input [3:0] key;
output reg [3:0] in0,in1,in2,in3;
output [2:0] state;
//
reg [2:0] state,next_state;
reg [3:0] in0_temp,in1_temp,in2_temp,in3_temp;
reg [4:0] temp;
reg [7:0] temp_B;

always@(*)
case(state)
	3'b000:   ///000輸入   
	begin
				if(key==`KEY_A&&pressed==1'b1)begin
					next_state=3'b001;  ///001加法運算
					in0_temp=in0;
					in1_temp=in1;
					in2_temp=in2;
					in3_temp=in3;end
				else if(key==`KEY_D&&pressed==1'b1)begin
					next_state=3'b010;  ///010減法運算
					in0_temp=in0;
					in1_temp=in1;
					in2_temp=in2;
					in3_temp=in3;end
				else if(key==`KEY_B&&pressed==1'b1)begin
					next_state=3'b011;  ///011乘法運算
					in0_temp=in0;
					in1_temp=in1;
					in2_temp=in2;
					in3_temp=in3;end
				else if((key!=`KEY_A)&&(key!=`KEY_D)&&(key!=`KEY_B)&&pressed) begin
					next_state=3'b000;    ///000輸入
					in0_temp=key;
					in1_temp=0;
					in2_temp=0;
					in3_temp=0; end
				else begin
					next_state=3'b000;     ///000輸入
					in0_temp=in0;
					in1_temp=in1;
					in2_temp=in2;
					in3_temp=in3;end
	
	end
	3'b001:  ///001加法運算
		begin  temp=in0+in1;
				if((key==`KEY_E)&&(pressed)&&(temp>=5'd10)) begin
					next_state=3'b100;   ///100顯示
						in0_temp=in0;
						in1_temp=in1;
						in2_temp=4'd1;
						in3_temp=temp-5'd10;end
				else if((key==`KEY_E)&&(pressed==1'b1)&&(temp<5'd10)) begin
					next_state=3'b100;   ///100顯示
						in0_temp=in0; 
						in1_temp=in1;
						in2_temp=0;
						in3_temp=temp;end 
				else if 	((key!=`KEY_A)&&(key!=`KEY_D)&&(key!=`KEY_B)&&(key!=`KEY_E)&&pressed) begin
					next_state=3'b001;    ///001加法運算
					in0_temp=in0;
					in1_temp=key;
					in2_temp=0;
					in3_temp=0;end
				else begin
					next_state=3'b001;   ///001加法運算
					in0_temp=in0;
					in1_temp=in1;
					in2_temp=in2;
					in3_temp=in3;end  end
					
	3'b010:  ///010減法運算
	begin
				if(key==`KEY_E&&pressed==1'b1)begin
					next_state=3'b100;  //100顯示
					
					in0_temp=in0;
					in1_temp=in1;
					in2_temp=0;
					in3_temp=temp;end 
				else if 	((key!=`KEY_A)&&(key!=`KEY_D)&&(key!=`KEY_B)&&(key!=`KEY_E)&&pressed)begin
					next_state=3'b010;   ///010減法運算
					in0_temp=in0;
					in1_temp=key;
					in2_temp=0;
					in3_temp=0;
					temp=in0-in1;end
				else begin
					next_state=3'b010;   ///010減法運算
					in0_temp=in0;
					in1_temp=in1;
					in2_temp=in2;
					in3_temp=in3;
					temp=in0-in1;end
	end
	3'b011:  ///011乘法運算
	begin
				if(key==`KEY_E&&pressed==1'b1)begin
					next_state=3'b100;  //100顯示
					temp_B=in0*in1;
					in0_temp=in0;
					in1_temp=in1;
					in2_temp=temp_B/7'd10;
					in3_temp=temp_B%7'd10;
					end 
				else if 	((key!=`KEY_A)&&(key!=`KEY_D)&&(key!=`KEY_B)&&(key!=`KEY_E)&&pressed) begin
					next_state=3'b011;    ///011乘法運算
					in0_temp=in0;
					in1_temp=key;
					in2_temp=0;
					in3_temp=0;end
				else begin
					next_state=3'b011;   ///011乘法運算
					in0_temp=in0;
					in1_temp=in1;
					in2_temp=in2;
					in3_temp=in3;end
	end
	
	3'b100:  ///顯示
	begin
				if((key!=`KEY_A)&&(key!=`KEY_D)&&(key!=`KEY_B)&&(key!=`KEY_E)&&pressed) begin
					next_state=3'b000;  ///000輸入
					in0_temp=key;
					in1_temp=0;
					in2_temp=0;
					in3_temp=0;end
				else begin
					next_state=3'b100;  ///顯示
					in0_temp=in0;
					in1_temp=in1;
					in2_temp=in2;
					in3_temp=in3; end
		end		
	
	
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
