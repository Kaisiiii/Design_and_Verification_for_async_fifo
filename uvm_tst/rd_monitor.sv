`ifndef RD_MONITOR__SV
`define RD_MONITOR__SV
class rd_monitor extends uvm_monitor;
	virtual rd_if rd_if;
	
	uvm_analysis_port#(wr_transaction) ap;
	
	`uvm_component_utils(rd_monitor);
	function new(string name = "rd_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual rd_if)::get(this,"","rd_if",rd_if))
			`uvm_fatal("rd_monitor","virtual interface must be configured for rd_monitor!");
		ap = new("ap",this); 
	endfunction
	extern virtual task collect_one_pkt(wr_transaction tr);
	extern virtual task main_phase(uvm_phase phase);
	
endclass

task rd_monitor::main_phase(uvm_phase phase);
	wr_transaction tr;
	while(1)begin
		tr = new("tr");
		collect_one_pkt(tr);
		ap.write(tr);
	end
endtask

task rd_monitor::collect_one_pkt(wr_transaction tr);
	while(1)	begin
		@(posedge rd_if.clk);
		if(rd_if.en)
			if(rd_if.valid)
				break;
	end
	tr.data = rd_if.data;	
endtask

`endif
