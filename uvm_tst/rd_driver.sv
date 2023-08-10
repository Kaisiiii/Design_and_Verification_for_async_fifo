`ifndef RD_DRIVER__SV
`define RD_DRIVER__SV
class rd_driver extends uvm_driver#(rd_transaction);

	virtual rd_if rd_if;
	logic no_tr = 1'b0; 

	function new(string name = "rd_driver",uvm_component parent);
		super.new(name,parent);
		`uvm_info("rd_driver","new in rd_driver is called",UVM_LOW);
	endfunction
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("rd_driver","Build phase is called", UVM_LOW);
		if(!uvm_config_db#(virtual rd_if)::get(this,"","rd_if",rd_if))
			`uvm_fatal("rd_driver","virtual interface for rd_if must be configured!");
	endfunction

	extern virtual task main_phase(uvm_phase phase);
	extern virtual task read_one_pkt(rd_transaction tr);
	extern virtual task drive_nothing();	
	
	`uvm_component_utils(rd_driver);

endclass

task rd_driver::main_phase(uvm_phase phase);

	rd_if.en <= 1'b0;
	while(!rd_if.rstn)
		@(posedge rd_if.clk)
	fork
		while(1) begin
			seq_item_port.get_next_item(req);
			no_tr = 1'b0;
			read_one_pkt(req);
			no_tr = 1'b1;
			seq_item_port.item_done();
		end
		while(1) begin
			drive_nothing();
		end
	join

endtask

task rd_driver::read_one_pkt(rd_transaction tr);
	@(posedge rd_if.clk)
	while(1) begin
		if(rd_if.empty)begin
			rd_if.en <= 1'b0;
 			@(posedge rd_if.clk);
		end
		else begin
			@(negedge rd_if.clk);
			rd_if.en <= 1'b1;
			break;
		end			
	end
endtask

task rd_driver::drive_nothing();
	@(posedge rd_if.clk); 
	if(no_tr)	
		rd_if.en <= 1'b0;
endtask
`endif

