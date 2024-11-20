`timescale 1ns/1ns 

//-------------------------------------------------------------------------------\\
//This file created by Khoa Le
//Updated date: 11/20/2024
//Module name : Data register
//Additional comments: 
//
//-------------------------------------------------------------------------------\\

//data type and port list
module regs #(	
	parameter DW = 32,
	parameter AW = 10
)(
	input wire clk,
	input wire rst_n,
	input wire wr_en,
	input wire rd_en,
	input wire [AW-1:0] addr,
	input wire [DW-1:0] wdata,
	output wire [DW-1:0] rdata

);

	parameter ADDR_DATA0    = 10'h0; //define parameter
	parameter ADDR_DATA0_SR = 10'h4;
	parameter ADDR_DATA1    = 10'h8;
	parameter ADDR_DATA1_SR = 10'hC;




	reg [DW-1:0]  data_0;
	reg [DW-1:0]  data_1;
	reg [DW-1:0]  data_0_sr;
	reg [DW-1:0]  data_1_sr;

	wire [DW-1:0] data_0_pre;
	wire [DW-1:0] data_1_pre;
	wire          data_0_wr_sel;
	wire 	      data_1_wr_sel;

	reg [DW-1:0]  r_data;

	
	// Write logic
	// Data 0
	assign data_0_wr_sel = wr_en & (addr == ADDR_DATA0);
	assign data_0_pre    = data_0_wr_sel ? wdata : data_0;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			data_0 <= {DW{1'b0}};
		else
			data_0 <= data_0_pre;
	end
	// Data 1 
	assign data_1_wr_sel = wr_en & (addr == ADDR_DATA1);
	assign data_1_pre    = data_1_wr_sel ? wdata : data_1;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			data_1 <= {DW{1'b1}};
		else
			data_1 <= data_1_pre;
	end

	// Read_only logic
	always @(posedge clk or negedge rst_n) begin
		if(rst_n) begin
			data_0_sr <= {DW{1'b0}};
			data_1_sr <= {DW{1'b1}};
		end else begin
			data_0_sr <= data_0;
			data_1_sr <= data_1;
		end
	end

	// Read logic 
	always @(*) begin
		if(rd_en == 1) begin
			case(addr)
				ADDR_DATA0    : r_data = data_0;
				ADDR_DATA0_SR : r_data = data_0_sr;
				ADDR_DATA1    : r_data = data_1;
				ADDR_DATA1_SR : r_data = data_1_sr;
				default:      r_data = {DW{1'b0}};
			endcase 
		end else begin
			r_data = {DW{1'b0}};
		end
	end

	// output logic
	assign rdata = r_data;	

endmodule
