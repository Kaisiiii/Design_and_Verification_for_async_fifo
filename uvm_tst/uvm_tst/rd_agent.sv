`ifndef RD_AGENT__SV
`define RD_AGENT__SV
class rd_agent extends uvm_agent;
	rd_sequencer rd_sqr;
	rd_driver rd_drv;
	rd_monitor	rd_mon;

	uvm_analysis_port#(wr_transaction) ap;
	`uvm_component_utils(rd_agent);
	function new(string name = "rd_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);


endclass
function void rd_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		rd_sqr = rd_sequencer::type_id::create("rd_sqr",this);
		rd_drv = rd_driver::type_id::create("rd_drv",this);
		rd_mon = rd_monitor::type_id::create("rd_mon",this);
endfunction

function void rd_agent::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		rd_drv.seq_item_port.connect(rd_sqr.seq_item_export);
		ap = rd_mon.ap;
endfunction

`endif
