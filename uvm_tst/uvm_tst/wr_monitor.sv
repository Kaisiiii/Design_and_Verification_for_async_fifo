`ifndef WR_MONITOR__SV
`define WR_MONITOR__SV
class wr_monitor extends uvm_monitor;
	virtual wr_if wr_if;
	
	uvm_analysis_port #(wr_transaction) ap;
	
	`uvm_component_utils(wr_monitor);
	function new(string name = "wr_monitor",uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual wr_if)::get(this,"","wr_if",wr_if))
			`uvm_fatal("wr_monitor","virtual interface must be configured for wr_monitor!");
		ap = new("ap",this); 
	endfunction
	extern virtual task main_phase(uvm_phase phase);
	extern virtual task collect_one_pkt(wr_transaction tr);
	
	
endclass

task wr_monitor::main_phase(uvm_phase phase);
	wr_transaction tr;
	while(1)begin
		tr = new("tr");
		collect_one_pkt(tr);
		ap.write(tr);
		//tr.my_print();
	end
endtask

task wr_monitor::collect_one_pkt(wr_transaction tr);
	while(1)	begin
		@(posedge wr_if.clk);
		if(wr_if.en)
			break;
	end
	`uvm_info("wr_monitor","start collecting one pkt",UVM_MEDIUM);
	tr.data = wr_if.data;
	`uvm_info("wr_monitor","finish collecting one pkt",UVM_MEDIUM);
	//tr.my_print();
endtask

`endif
