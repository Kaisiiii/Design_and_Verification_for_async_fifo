interface my_if#(WIDTH = 8)(input clk,input rstn);
	
	logic en;
	logic [WIDTH - 1 : 0] data;
	logic full;
	logic empty;
	logic valid;

endinterface
