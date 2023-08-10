`include "define.sv"
class wr_transaction extends uvm_sequence_item;
	rand bit [`WIDTH - 1 : 0]	data;
	
	`uvm_object_utils_begin(wr_transaction)
		`uvm_field_int(data,UVM_ALL_ON);
	`uvm_object_utils_end
	
	function new(string name = "wr_transcation");
		super.new(name);
	endfunction
endclass
 
