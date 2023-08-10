`ifndef MY_ENV__SV
`define MY_ENV__SV
class my_env extends uvm_env;

	wr_agent i_agt;
	rd_agent o_agt;
	my_model mdl;
	my_scoreboard scb;
	my_virtual_sequencer vsqr;

	uvm_tlm_analysis_fifo #(wr_transaction) agt_mdl_fifo;
	uvm_tlm_analysis_fifo #(wr_transaction) agt_scb_fifo;
	uvm_tlm_analysis_fifo #(wr_transaction) mdl_scb_fifo;

	function new(string name = "my_env",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		i_agt = wr_agent::type_id::create("i_agt",this);
		o_agt = rd_agent::type_id::create("o_agt",this);
		mdl = my_model::type_id::create("mdl",this);
		scb = my_scoreboard::type_id::create("scb",this);
		vsqr = my_virtual_sequencer::type_id::create("vsqr",this);
		agt_mdl_fifo = new("agt_mdl_fifo", this);
		agt_scb_fifo = new("agt_scb_fifo", this);
		mdl_scb_fifo = new("mdl_scb_fifo", this);

	endfunction

	`uvm_component_utils(my_env);
	extern virtual function void  connect_phase(uvm_phase phase);

endclass

function void my_env::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	i_agt.ap.connect(agt_mdl_fifo.analysis_export);
	mdl.port.connect(agt_mdl_fifo.blocking_get_export);

	o_agt.ap.connect(agt_scb_fifo.analysis_export);
	scb.act_port.connect(agt_scb_fifo.blocking_get_export);

	mdl.ap.connect(mdl_scb_fifo.analysis_export);
	scb.exp_port.connect(mdl_scb_fifo.blocking_get_export);

	vsqr.v_wr_sqr = i_agt.wr_sqr;
	vsqr.v_rd_sqr = o_agt.rd_sqr;
endfunction

`endif

