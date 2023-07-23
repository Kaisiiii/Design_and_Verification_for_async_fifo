`ifndef WR_SEQUENCER__SV
`define WR_SEQUENCER__SV
class wr_sequencer extends uvm_sequencer #(wr_transaction);
	function new(string name = "wr_sequencer", uvm_component parent);
		super.new(name,parent);
	endfunction

	`uvm_component_utils(wr_sequencer);
endclass
`endif
