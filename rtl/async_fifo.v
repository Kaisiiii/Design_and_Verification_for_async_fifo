module async_fifo #(
    parameter   DEPTH = 8,
    parameter   WIDTH = 8
)(

    input       wr_clk,
    input       wr_rstn,
    input       wr_en,
    input   [WIDTH - 1: 0]  wr_data,

    input       rd_clk,
    input       rd_rstn,
    input       rd_en,

    output  reg [WIDTH - 1: 0]  rd_data,
    output  reg rd_valid,
    output  reg full_flag, 
    output  reg empty_flag


);
reg [$clog2(DEPTH): 0] WR_PTR, RD_PTR;
wire [$clog2(DEPTH) : 0] WR_PTR_n, RD_PTR_n;
reg [WIDTH - 1: 0] FIFO [DEPTH - 1: 0];

//Write Pointer Counter
assign WR_PTR_n = WR_PTR + (wr_en & !full_flag);
always@(posedge wr_clk or negedge wr_rstn) begin
	if(!wr_rstn == 1'b1)
		WR_PTR <= 'b0;
	else
		WR_PTR <= WR_PTR_n;
end
//Read Pointer Counter
assign RD_PTR_n = RD_PTR + (rd_en & !empty_flag);
always@(posedge rd_clk or negedge rd_rstn) begin
	if(!rd_rstn == 1'b1)
		RD_PTR	<= 'b0;
	else
		RD_PTR <= RD_PTR_n;
end

//Write Control
always @(posedge wr_clk or negedge wr_rstn) begin
    if(wr_en == 1'b1 && !full_flag == 1'b1) 
        FIFO[WR_PTR[$clog2(DEPTH)-1 : 0]] <= wr_data;
end

//Read Control
always @(posedge rd_clk or negedge rd_rstn) begin
    if(!rd_rstn == 1'b1) begin
        rd_data <= 'b0;
	    rd_valid <= 1'b0;
    end
    else if(rd_en == 1'b1 && !empty_flag == 1'b1) begin
        rd_data <= FIFO[RD_PTR[$clog2(DEPTH) - 1 : 0]];
        rd_valid <= 1'b1;
    end
	else begin
		rd_data <= rd_data;
		rd_valid <= 1'b0;
	end
end
//Binary -> Grey
wire [$clog2(DEPTH) : 0] wr_ptr_g;
wire [$clog2(DEPTH) : 0] rd_ptr_g;

assign wr_ptr_g = WR_PTR_n ^ (WR_PTR_n >>> 1);
assign rd_ptr_g = RD_PTR_n ^ (RD_PTR_n >>> 1);

//Synchronize READ/WRITE Pointer
reg [$clog2(DEPTH) : 0] wr_ptr_gr, wr_ptr_grr;
reg [$clog2(DEPTH) : 0] rd_ptr_gr, rd_ptr_grr;

always @ (posedge rd_clk or negedge rd_rstn) begin
    if(!rd_rstn) begin
        wr_ptr_gr <= 0;
        wr_ptr_grr <= 0;
    end
    else begin
        wr_ptr_gr <= wr_ptr_g;
        wr_ptr_grr <= wr_ptr_gr;
    end
end

always @ (posedge wr_clk or negedge wr_rstn) begin
    if(!wr_rstn) begin
        rd_ptr_gr <= 0;
        rd_ptr_grr <= 0;
    end
    else begin
        rd_ptr_gr <= rd_ptr_g;
        rd_ptr_grr <= rd_ptr_gr;
    end
end 

//Determine if FULL
always @ (posedge wr_clk or negedge wr_rstn) begin
        if(!wr_rstn)
            full_flag <= 0;
        else if( wr_ptr_g == {~rd_ptr_grr[$clog2(DEPTH) -: 2],rd_ptr_grr[$clog2(DEPTH) - 2 : 0]})
            full_flag <= 1;
        else
            full_flag <= 0;
end

//Determine if EMPTY
always @ (posedge rd_clk or negedge rd_rstn) begin
	if(!rd_rstn)
		empty_flag <= 1;
	else if(wr_ptr_grr[$clog2(DEPTH) : 0] == rd_ptr_g[$clog2(DEPTH) : 0])
		empty_flag <= 1;
	else
		empty_flag <= 0;
end

/*
wire wfull,rempty;
assign wfull = (wr_ptr_g == { ~rd_ptr_grr[$clog2(DEPTH):$clog2(DEPTH) - 1],rd_ptr_grr[$clog2(DEPTH) - 2 : 0]})
assign empty_flag = (wr_ptr_grr[$clog2(DEPTH) : 0] == rd_ptr_g[$clog2(DEPTH) : 0])?  1'b1 : 0;

always@(posedge wr_clk	or negedge wr_rstn) begin
	if(!wr_rstn == 1'b1)
		full_flag <= 1'b0;
	else
		full_flag <= wfull;
end

always@(posedge rd_clk or negedge rd_rstn) begin
	if(!rd_rstn == 1'b1)
		empty_flag <= 1'b1;
	else
		empty_flag <= rempty;
end
*/
endmodule
