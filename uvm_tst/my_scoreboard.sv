`ifndef MY_SCOREBOARD__SV
`define MY_SCOREBOARD__SV
class my_scoreboard extends uvm_scoreboard;

	wr_transaction expect_queue[$];
	uvm_blocking_get_port#(wr_transaction) exp_port;
	uvm_blocking_get_port#(wr_transaction) act_port;

	function new (string name = "my_scoreboard",uvm_component parent = null);
		super.new(name, parent);
	endfunction
	
	`uvm_component_utils(my_scoreboard);

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual task main_phase(uvm_phase phase);
endclass

function void my_scoreboard::build_phase(uvm_phase phase);
	`uvm_info("my_scoreboard","scoreboard build phase is called!",UVM_LOW);
	super.build_phase(phase);
	exp_port = new("exp_port",this);
	act_port = new("act_port",this);
endfunction

task my_scoreboard::main_phase(uvm_phase phase);
	wr_transaction get_exp, get_act, tmp_tr;
	bit result;
	`uvm_info("my_scoreboard","scoreboard main phase is called!",UVM_LOW);
	super.main_phase(phase);
	fork
		while(1)begin
			exp_port.get(get_exp);
			expect_queue.push_back(get_exp);
		end
		while(1)begin
			act_port.get(get_act);
			if(expect_queue.size() > 0)begin
				tmp_tr = expect_queue.pop_front();
				result = get_act.compare(tmp_tr);
				if(result) begin
					`uvm_info("my_scoreboard","RESULT SATISFY",UVM_LOW);
					$display("The expexct data is ");
					tmp_tr.print();
					$display("The actual data is ");
					get_act.print();
				end
				else begin
					`uvm_info("my_scoreboard","RESULT UNSATISFY",UVM_LOW);
					$display("The expexct data is ");
					tmp_tr.print();
					$display("The actual data is ");
					get_act.print();
				end
			end
			else begin
				`uvm_error("my_scoreboard", "Received from DUT, while Expect Queue is empty");
				$display("the unexpected pkt is");
				get_act.print();
			end
		end
	join
endtask

`endif
