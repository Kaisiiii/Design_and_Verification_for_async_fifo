`include "define.sv"
`ifndef MY_CASE0__SV
`define MY_CASE0__SV
class my_case0_sequence extends uvm_sequence;

    `uvm_object_utils(my_case0_sequence)
    `uvm_declare_p_sequencer(my_virtual_sequencer)
    
   function  new(string name= "my_case0_sequence");
      super.new(name);
   endfunction 
   
   extern virtual task body();
   extern virtual task pre_body();
   extern virtual task post_body();

endclass

task my_case0_sequence::body();

  wr_sequence wr_seq;
  rd_sequence  rd_seq;

  repeat (`DEPTH) begin
    `uvm_do_on(wr_seq,p_sequencer.v_wr_sqr)
    `uvm_do_on(rd_seq,p_sequencer.v_rd_sqr)
  end
  

endtask

task my_case0_sequence::pre_body();
	if(starting_phase != null) begin
		starting_phase.raise_objection(this);
	end
endtask

task my_case0_sequence::post_body();
	if(starting_phase != null) begin
		starting_phase.drop_objection(this);
	end
endtask

class my_case0 extends base_test;

	function new(string name = "my_case0",uvm_component parent = null);
		super.new(name, parent);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);

	`uvm_component_utils(my_case0);
endclass

function void my_case0::build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db#(uvm_object_wrapper)::set(this,
										"env.vsqr.main_phase",
										"default_sequence",
										my_case0_sequence::type_id::get());
	
endfunction

task my_case0::main_phase(uvm_phase phase);
	super.main_phase(phase);
	uvm_top.print_topology();
endtask
`endif
