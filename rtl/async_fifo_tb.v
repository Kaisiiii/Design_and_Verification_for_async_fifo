module async_fifo_tb;

// async_fifo Parameters
parameter DEPTH  = 8;
parameter WIDTH  = 8;

// async_fifo Inputs
reg   wr_clk = 0 ;
reg   wr_rstn = 1 ;
reg   wr_en  = 0 ;
reg   [WIDTH - 1: 0]  wr_data   = 0 ;
reg   rd_clk = 0 ;
reg   rd_rstn   = 0 ;
reg   rd_en  = 0 ;

// async_fifo Outputs
wire  [WIDTH - 1: 0]  rd_data              ;
wire rd_valid;
wire  full_flag   ;
wire  empty_flag  ;


initial begin
		wr_clk = 0;
		forever begin
			#5 wr_clk = ~wr_clk;
		end
	end

initial begin
	rd_clk = 0;
	forever begin
		#10 rd_clk = ~rd_clk;
	end
end

initial begin
	$vcdpluson;
	wr_en = 0;
	wr_rstn = 0;
        #10;
	wr_rstn = 0;
        #20;
	wr_rstn = 1;


	@(negedge wr_clk)
	wr_data = {$random}%30;
	wr_en = 1;

	repeat(7) begin
		@(negedge wr_clk)
		wr_data = {$random}%30;
	end
	@(negedge wr_clk)
	wr_en = 0;

	#150;

	@(negedge wr_clk)
	wr_en = 1;
	wr_data = {$random}%30;

	repeat(5) begin
		@(negedge wr_clk)
		wr_data = {$random}%30;
	end
	
	@(posedge rd_en);
	repeat(3) begin
		@(posedge wr_clk);
	end
	wr_en = 1;
	repeat (3) begin
		@(negedge wr_clk) 
		wr_data = {$random}%30;
	end
	
	repeat(3) begin
		@(posedge wr_clk);
	end
	wr_en = 0;

	
end


initial begin
	rd_en = 1'b0;
	rd_rstn = 0;

     #10 rd_rstn = 0;

     #20 rd_rstn = 1;
	repeat(4) begin
		@(posedge rd_clk) ;
	end
	rd_en = 1'b1;
		
	repeat(4) begin
		@(negedge rd_clk); 
	end
	rd_en = 1'b0;

	repeat(9) begin
		@(posedge rd_clk);
	end
	
	@(negedge rd_clk)	rd_en = 1'b1;

	repeat(15) begin
		@(negedge rd_clk);
	end
	rd_en = 1'b0;
	#50 $finish;

end

always@(full_flag) begin
	if (full_flag == 1'b1)
		wr_en  = 0;
	else 
		wr_en = wr_en;
end

always@(empty_flag) begin 
	if(empty_flag == 1'b1)
		rd_en = 0;
	else 
		rd_en = rd_en;
end
initial begin 
	//$fsdbDumpon;
	$fsdbDumpfile("fifo.fsdb");
	$fsdbDumpvars(0);
end

async_fifo #(
    .DEPTH ( DEPTH ),
    .WIDTH ( WIDTH ))
 u_async_fifo (
    .wr_clk                  ( wr_clk                     ),        
    .wr_rstn                 ( wr_rstn                    ),        
    .wr_en                   ( wr_en                      ),        
    .wr_data                 ( wr_data     ),        
    .rd_clk                  ( rd_clk                     ),        
    .rd_rstn                 ( rd_rstn                    ),        
    .rd_en                   ( rd_en                      ),        

    .rd_data                 ( rd_data     ),        
    .full_flag               ( full_flag                  ),
	.rd_valid(rd_valid),
    .empty_flag              ( empty_flag                 )

);


endmodule

