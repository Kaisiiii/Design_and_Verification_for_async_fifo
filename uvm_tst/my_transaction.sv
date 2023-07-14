class my_transaction #(int WIDTH = 8) extends uvm_sequence_item;
	rand bit					wr_en;
	rand bit [WIDTH - 1 : 0]	wr_data;
	rand bit					rd_en;
	rand bit [WIDTH - 1 : 0]	rd_data;
	
	`uvm_objection_utils(my_transaction);
	function new(string name = "my_transcation");
		super.new(name);
	endfunction


endclass
 
