`ifndef WR_SEQUENCE__SV
`define WR_SEQUENCE__SV
class wr_sequence extends uvm_sequence #(wr_transaction);
	function new(string name = "wr_sequence");
		super.new(name);
	endfunction

	extern virtual task body();
	extern virtual task pre_body();
	extern virtual task post_body();
	`uvm_object_utils(wr_sequence);
endclass

task wr_sequence::body();
	wr_transaction wr_tr;
	`uvm_do(wr_tr);
endtask

task wr_sequence::pre_body();
    if(starting_phase != null) begin 
       starting_phase.raise_objection(this);
    end
endtask

task wr_sequence::post_body();
    if(starting_phase != null) begin 
        starting_phase.drop_objection(this);
    end
endtask
`endif
