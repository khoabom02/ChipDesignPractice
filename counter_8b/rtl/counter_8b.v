`timescale 1ns/1ns

//-------------------------------------------------------------------------------\\
//This file created by Khoa Le
//Updated date: 11/20/2024
//Module name : Counter_8b
//Additional comments: 
//
//-------------------------------------------------------------------------------\\

//data type and portlist
module counter (                           
	input wire clk 		,
	input wire rst_n 	,
	input wire count_en	,
	input wire count_clr	,
	output wire [7:0] count	,
	output wire overflow

);

	reg [7:0] count_r ;
	wire [7:0] count_r_pre ;

	assign count_r_pre[7:0] = count_clr ? 8'h00 :
	       			  count_en  ? count_r + 8'h01 :
			  	  count_r ;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			count_r <= 8'h00 ;
		else 
			count_r <= count_r_pre ;

	end
	//output logic
	assign count = count_r ;
	assign overflow = (count_r == 8'hFF);

endmodule	

