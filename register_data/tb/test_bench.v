`timescale 1ns/1ns

//-------------------------------------------------------------------------------\\
//This file created by Khoa Le
//Updated date: 11/20/2024
//Module name : Counter_8b
//Additional comments: 
//
//-------------------------------------------------------------------------------\\

module test_bench;
	parameter DW = 32;
	parameter AW = 10;

	parameter ADDR_DATA0    = 10'h0;
	parameter ADDR_DATA0_SR = 10'h4;
	parameter ADDR_DATA_1   = 10'h8;
	parameter ADDR_DATA1_SR = 10'hC;

	reg clk, rst_n;
	reg wr_en, rd_en;
	reg [AW-1:0] addr;
	reg [DW-1:0] wdata;
	wire [DW-1:0] rdata;

	regs #(	
		.DW(DW), 
		.AW(AW)
	      ) 	u_regs(.*); 
	
	// CLK
	initial begin
		clk = 0;
		forever #25 clk = ~clk;
	end

	// RESET
	initial begin
	rst_n = 1'b0;
	#25 rst_n = 1'b1;
	end

	initial begin
		addr = 0;
		wdata = 0;
		wr_en = 0;
		rd_en = 0;
		#50;
			$display("#----------------------------------#");
			$display("Case 0: check reset value ");
			$display("#----------------------------------#");
		chk_ro_32b(ADDR_DATA_1, 32'hffff_ffff, 32'hffff_ffff);   // addr, exp_data, mask
		chk_ro_32b(ADDR_DATA1_SR, 32'hffff_ffff, 32'hffff_ffff); // addr, exp_data, mask
		chk_ro_32b(ADDR_DATA0, 32'h0, 32'hffff_ffff); 		 // addr, exp_data, mask
		chk_ro_32b(ADDR_DATA0_SR, 32'h0, 32'hffff_ffff); 	 // addr, exp_data, mask
	
		#50;
			$display("#----------------------------------#");
			$display("Case 1: check read/write f ");
			$display("#----------------------------------#");
		chk_rw_32b(ADDR_DATA_1, 32'hffff_ffff, 32'hffff_ffff, 32'hffff_ffff); // addr, wdata, exp_data, mask
	
		#50;
			$display("#----------------------------------#");
			$display("Case 2: check read/write 0 ");
			$display("#----------------------------------#");
		chk_rw_32b(ADDR_DATA_1, 32'h0, 32'h0, 32'hffff_ffff); // addr, wdata, exp_data, mask
	
		#50;
			$display("#----------------------------------#");
			$display("Case 3: check read/write a ");
			$display("#----------------------------------#");
		chk_rw_32b(ADDR_DATA_1, 32'haaaa_aaaa, 32'haaaa_aaaa, 32'hffff_ffff); // addr, wdata, exp_data, mask
	
		#50;
			$display("#----------------------------------#");
			$display("Case 4: check read/write mixed ");
			$display("#----------------------------------#");
		chk_rw_32b(ADDR_DATA_1, 32'h1a2b_3c4d, 32'h1a2b_3c4d, 32'hffff_ffff); // addr, wdata, exp_data, mask
	
		#50;
		$finish;
	end


	task chk_rw_32b;
		input [9:0] in_addr;
		input [31:0] in_wdata;
		input [31:0] exp_data;
		input [31:0] mask;

		begin
		$display("RW check task");
		$display("write data = %x at addr: %x", in_wdata, addr);
			@(posedge clk)
			wr_en = 1;
			addr = in_addr;
			wdata = in_wdata;
			@(posedge clk);
			addr = 0;
			wr_en = 0;
			wdata = 32'h0;
			@(posedge clk);
			rd_en = 1;
			addr = in_addr;
			#1;
				if((rdata & mask) == (exp_data & mask)) begin
					$display("#----------------------------------#");
					$display("t = %d, PASS: rdata at %x is correct", $time, addr);
					$display("#----------------------------------#");
			  	end else begin
					$display("#----------------------------------#");
					$display("t=%d, FAIL: rdata at addr %x is not correct", $time, addr);
					$display("Exp: %x Actual: %x", exp_data & mask, rdata & mask);
					$display("#----------------------------------#");
				end
			@(posedge clk);
			rd_en = 0;
			addr  = 0;
		end
	endtask
	
	task chk_ro_32b;
		input [9:0] in_addr;
		input [31:0] exp_data;
		input [31:0] mask;

		begin
			$display("RO check task");
			@(posedge clk);
			rd_en = 1;
			addr  = in_addr;
			#1;
				if((rdata & mask) == (exp_data & mask)) begin
					$display("#----------------------------------#");
					$display("t = %d, PASS: rdata at %x is correct", $time, addr);
					$display("#----------------------------------#");
			  	end else begin
					$display("#----------------------------------#");
					$display("t=%d, FAIL: rdata at addr %x is not correct", $time, addr);
					$display("Exp: %x Actual: %x", exp_data & mask, rdata & mask);
					$display("#----------------------------------#");
				end
			@(posedge clk);
			rd_en = 0;
			addr  = 0;
		end
	endtask


endmodule
