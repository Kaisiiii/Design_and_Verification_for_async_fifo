`ifndef RD_DRIVER__SV
`define RD_DRIVER__SV
class rd_driver extends uvm_driver#(rd_transaction);
	virtual rd_if rd_if;
	logic no_tr = 1'b0; 
	`uvm_component_utils(rd_driver);
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
endclass

task rd_driver::main_phase(uvm_phase phase);
	rd_transaction tr;
	tr=new("tr");
	phase.raise_objection(this);
	`uvm_info("rd_driver","main phase is called",UVM_LOW);
	rd_if.en <= 1'b0;
	while(!rd_if.rstn)
		@(posedge rd_if.clk)
	repeat(6) @(posedge rd_if.clk);
	`uvm_info("rd_driver","starting....",UVM_LOW);
	while(!rd_if.empty)begin
		//if(rd_if.valid)
			read_one_pkt(tr);
	end
	drive_nothing();
	repeat(3) @(posedge rd_if.clk);
	
	phase.drop_objection(this);
	`uvm_info("rd_driver","main phase is finished",UVM_LOW);

endtask
task rd_driver::read_one_pkt(rd_transaction tr);
	`uvm_info("rd_driver","start to read one pkt",UVM_LOW);
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
	`uvm_info("rd_driver","read one pkt",UVM_LOW);
endtask

task rd_driver::drive_nothing();
	@(posedge rd_if.clk) 
	rd_if.en <= 1'b0;
endtask
`endif
