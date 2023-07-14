`ifndef WR_DRIVER__SV
`define WR_DRIVER__SV
class wr_driver extends uvm_driver;
	virtual my_if wr_if;
	`uvm_component_utils(wr_driver);
	function new(string name = "wr_driver",uvm_component parent = null);
		super.new(name,parent);
		`uvm_info("write_driver","new in my_driver is called",UVM_LOW);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("write_driver","Build phase is called", UVM_LOW);
		if(!uvm_config_db#(virtual my_if)::get(this,"","wr_if",wr_if))
			`uvm_fatal("write driver","virtual interface for wr_if must be configured!");
	endfunction

	extern virtual task main_phase(uvm_phase phase);

endclass


task wr_driver::main_phase(uvm_phase phase);
	phase.raise_objection(this);
	`uvm_info("write_driver","main phase is called",UVM_LOW);
	wr_if.en <= 1'b0;
	wr_if.data <= 8'd0;
	rd_if.en <= 1'b0;
	while(!wr_if.rstn)
		@(posedge wr_if.clk);
	for(int i = 0; i <= 15; i++)begin
		@(negedge wr_if.clk);
		wr_if.en <= 1'b1;
		wr_if.data <= $urandom_range(0,255);
		`uvm_info("write_driver", "data is drived",UVM_LOW);
	end
	@(posedge wr_if.clk);
	wr_if.en <= 1'b0; 
	phase.drop_objection(this);
endtask
`endif
