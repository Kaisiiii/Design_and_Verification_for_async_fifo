`ifndef RD_DRIVER__SV
`define RD_DRIVER__SV
class rd_driver extends uvm_driver;
	virtual my_if rd_if;
	`uvm_component_utils(rd_driver);
	function new(string name = "wr_driver",uvm_component parent = null);
		super.new(name,parent);
		`uvm_info("my_driver","new in my_driver is called",UVM_LOW);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("my_driver","Build phase is called", UVM_LOW);
		if(!uvm_config_db#(virtual my_if)::get(this,"","rd_if",rd_if))
			`uvm_fatal("my driver","virtual interface for rd_if must be configured!");
	endfunction

//	extern virtual task main_phase(uvm_phase phase);

endclass


`endif
