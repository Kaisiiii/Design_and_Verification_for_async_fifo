interface wr_if#(WIDTH = 8)(input clk,input rstn);
	logic [WIDTH - 1 : 0] data;
	logic en;
	logic full;
endinterface

interface rd_if#(WIDTH = 8)(input clk,input rstn);
	logic [WIDTH - 1 : 0] data;
	logic en;
	logic empty;
	logic valid;
endinterface
