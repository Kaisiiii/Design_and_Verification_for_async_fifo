`ifndef RD_SEQUENCE__SV
`define RD_SEQUENCE__SV
class rd_sequence extends uvm_sequence #(rd_transaction);
	function new(string name = "rd_sequence");
		super.new(name);
	endfunction

	extern virtual task body();
	extern virtual task pre_body();
	extern virtual task post_body();

	`uvm_object_utils(rd_sequence);
endclass

task rd_sequence::body();
	rd_transaction rd_tr;
	`uvm_do(rd_tr);
endtask

task rd_sequence::pre_body();
	if(starting_phase != null) begin
		starting_phase.raise_objection(this);
	end
endtask

task rd_sequence::post_body();
	if(starting_phase != null) begin
		starting_phase.drop_objection(this);
	end
endtask
`endif
	
