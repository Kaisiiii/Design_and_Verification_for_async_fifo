`include "define.sv"
`ifndef WR_DRIVER__SV
`define WR_DRIVER__SV
class wr_driver extends uvm_driver#(wr_transaction);
	virtual wr_if wr_if;
	logic no_tr = 1'b0;
	`uvm_component_utils(wr_driver);
	function new(string name = "wr_driver",uvm_component parent);
		super.new(name,parent);
		`uvm_info("wr_driver","new in wr_driver is called",UVM_LOW);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("wr_driver","Build phase is called", UVM_LOW);
		if(!uvm_config_db#(virtual wr_if)::get(this,"","wr_if",wr_if))
			`uvm_fatal("wr_driver","virtual interface for wr_if must be configured!");
	endfunction

	extern virtual task main_phase(uvm_phase phase);
	extern virtual task drive_one_pkt(wr_transaction tr);
	extern virtual task drive_nothing();
endclass


task wr_driver::main_phase(uvm_phase phase);
	
	wr_if.en <= 1'b0;
	wr_if.data <= 'b0;

	while(!wr_if.rstn) 
		@(posedge wr_if.clk);

	fork
		while(1) begin
			seq_item_port.get_next_item(req);
			no_tr = 1'b0;
			drive_one_pkt(req);
			no_tr = 1'b1;
			seq_item_port.item_done();	
		end
		while(1) begin
			drive_nothing();
		end
	join

endtask

task wr_driver::drive_one_pkt(wr_transaction tr);

	@(posedge wr_if.clk)
	while(1) begin
		if(wr_if.full) begin
			wr_if.en <= 1'b0;
			@(posedge wr_if.clk);
		end
		else begin
			wr_if.en <= 1'b1;
			wr_if.data <= tr.data;
			break;
		end
	end
	
endtask

task wr_driver::drive_nothing();
	@(posedge wr_if.clk);
	if (no_tr) wr_if.en <= 1'b0;
endtask
`endif
