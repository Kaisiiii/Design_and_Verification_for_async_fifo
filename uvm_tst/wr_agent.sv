`ifndef WR_AGENT__SV
`define WR_AGENT__SV
class wr_agent extends uvm_agent ;
	wr_driver wr_drv;
	wr_monitor wr_mon;

	uvm_analysis_port#(wr_transaction) ap;
	`uvm_component_utils(wr_agent);

	function  new(string name = "wr_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		wr_drv = wr_driver::type_id::create("wr_drv",this);
		wr_mon = wr_monitor::type_id::create("wr_mon",this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		ap = wr_mon.ap;
	endfunction
endclass


`endif
