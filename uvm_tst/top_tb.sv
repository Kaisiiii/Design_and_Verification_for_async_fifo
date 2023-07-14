`include "uvm_macros.svh"
import uvm_pkg::*;
`include "my_driver.sv"
`include "my_if.sv"


module top_tb;
// async_fifo Parameters
parameter DEPTH  = 8;
parameter WIDTH  = 8;

// async_fifo Inputs
reg   wr_clk = 0 ;
reg   wr_rstn = 1 ;
reg   wr_en  = 0 ;
reg   [WIDTH - 1: 0]  wr_data   = 0 ;
reg   rd_clk = 0 ;
reg   rd_rstn   = 0 ;
reg   rd_en  = 0 ;

// async_fifo Outputs
wire  [WIDTH - 1: 0]  rd_data              ;
wire rd_valid;
wire  full_flag   ;
wire  empty_flag  ;

my_if wr_if(wr_clk,wr_rstn);
my_if rd_if(rd_clk,rd_rstn);

initial begin
	uvm_config_db#(virtual my_if)::set(null,"uvm_test_top","wr_if",wr_if);
	uvm_config_db#(virtual my_if)::set(null,"uvm_test_top","rd_if",rd_if);
end

initial begin 
	$vcdpluson;
	$fsdbDumpfile("fifo.fsdb");
	$fsdbDumpvars(0);
end
initial begin
	wr_clk	= 0;
	forever begin
		#5 wr_clk = ~wr_clk;
	end
end

initial begin
	rd_clk = 0;
	forever begin
		#10 rd_clk = ~rd_clk;
	end
end

initial begin
	wr_rstn = 1'b0;
	wr_rstn = 1'b0;
	#30 wr_rstn = 1'b1;
	#30 rd_rstn = 1'b1;
end
initial begin
	run_test("my_driver");
end

async_fifo #(
    .DEPTH ( DEPTH ),
    .WIDTH ( WIDTH ))
 u_async_fifo (
    .wr_clk                  ( wr_clk                     ),        
    .wr_rstn                 ( wr_rstn                    ),        
    .wr_en                   ( wr_if.en                      ),        
    .wr_data                 ( wr_if.data     ),        
    .rd_clk                  ( rd_clk                     ),        
    .rd_rstn                 ( rd_rstn                    ),        
    .rd_en                   ( rd_if.en                      ),        

    .rd_data                 ( rd_if.data     ),        
    .full_flag               ( wr_if.full                  ),
	.rd_valid(rd_if.valid),
    .empty_flag              ( rd_if.empty                 )

);

endmodule
