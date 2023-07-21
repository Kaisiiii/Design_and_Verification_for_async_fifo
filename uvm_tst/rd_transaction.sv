`ifndef RD_TRANSACTION__SV
`define RD_TRANSACTION__SV
class rd_transaction extends uvm_sequence_item;
	rand bit en;
	`uvm_object_utils_begin(rd_transaction)
		`uvm_field_int(en,UVM_ALL_ON);
	`uvm_object_utils_end
	function new(string name = "rd_transaction");
		super.new(name);
	endfunction
endclass
`endif
