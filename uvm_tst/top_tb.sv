`include "uvm_macros.svh"
import uvm_pkg::*;
`include  "define.sv"
`include "wr_transaction.sv"
`include "rd_transaction.sv"
`include "my_if.sv"
`include "wr_driver.sv"
`include "rd_driver.sv"
`include "wr_monitor.sv"
`include "rd_monitor.sv"
`include "rd_agent.sv"
`include "wr_agent.sv"
`include "my_model.sv"
`include "my_scoreboard.sv" 
`include "my_env.sv"



module top_tb;
// async_fifo Parameters

// async_fifo Inputs
reg   wr_clk = 0 ;
reg   wr_rstn = 1 ;
reg   wr_en  = 0 ;
reg   [`WIDTH - 1: 0]  wr_data   = 0 ;
reg   rd_clk = 0 ;
reg   rd_rstn   = 0 ;
reg   rd_en  = 0 ;

// async_fifo Outputs
wire  [`WIDTH - 1: 0]  rd_data              ;
wire rd_valid;
wire  full_flag   ;
wire  empty_flag  ;

wr_if wr_if(wr_clk,wr_rstn);
rd_if rd_if(rd_clk,rd_rstn);

initial begin
	uvm_config_db#(virtual wr_if)::set(null,"uvm_test_top.i_agt.wr_drv","wr_if",wr_if);
	uvm_config_db#(virtual wr_if)::set(null,"uvm_test_top.i_agt.wr_mon","wr_if",wr_if);
	uvm_config_db#(virtual rd_if)::set(null,"uvm_test_top.o_agt.rd_drv","rd_if",rd_if);
	uvm_config_db#(virtual rd_if)::set(null,"uvm_test_top.o_agt.rd_mon","rd_if",rd_if);
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
	
	#30 wr_rstn = 1'b1;
	
end
initial begin
	rd_rstn = 1'b0;
	#40 rd_rstn = 1'b1;
end
initial begin
	run_test("my_env");
end

async_fifo #(
    .DEPTH ( `DEPTH ),
    .WIDTH ( `WIDTH ))
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
