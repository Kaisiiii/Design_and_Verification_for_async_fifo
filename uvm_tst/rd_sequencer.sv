`ifndef RD_SEQUENCER__SV
`define RD_SEQUENCER__SV
class rd_sequencer extends uvm_sequencer #(rd_transaction);
	function new (string name = "rd_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

	`uvm_component_utils(rd_sequencer);
endclass
`endif
