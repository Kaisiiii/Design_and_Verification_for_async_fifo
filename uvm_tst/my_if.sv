interface wr_if(input clk,input rstn);
	logic [`WIDTH - 1 : 0] data;
	logic en;
	logic full;
endinterface

interface rd_if(input clk,input rstn);
	logic [`WIDTH - 1 : 0] data;
	logic en;
	logic empty;
	logic valid;
endinterface
