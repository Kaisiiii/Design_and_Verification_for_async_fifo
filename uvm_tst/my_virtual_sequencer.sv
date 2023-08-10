`ifndef MY_VIRTUAL_SEQUENCER__SV
`define MY_VIRTUAL_SEQUENCER__SV
class my_virtual_sequencer extends uvm_sequencer;
    wr_sequencer v_wr_sqr;
    rd_sequencer v_rd_sqr;
    function new(string name = "my_virtual_sequencer",uvm_component parent);
            super.new(name, parent);
    endfunction

    `uvm_component_utils(my_virtual_sequencer);
endclass
`endif
