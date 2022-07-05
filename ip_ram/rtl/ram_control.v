module	ram_control
(
	input	wire		sys_clk,
	input	wire		sys_rst_n,
	input	wire		key1_flag,
	input	wire		key2_flag,
	
	output	reg			wr_en,
	output	reg			rd_en,
	output	reg	[7:0]	addr,
	output	wire	[7:0]	data
	
);
parameter CNT_MAX = 24'd9_999_999;
reg	[23:0]	cnt_200ms;

assign data = (wr_en == 1'b1) ? addr : 8'd0;
//200ms
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_200ms <= 24'd0;
	else if(cnt_200ms == CNT_MAX)
		cnt_200ms <= 24'd0;
	else 
		cnt_200ms <= cnt_200ms + 1'b1;
		

//wr_en
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		wr_en <= 1'b0;
	else if(addr == 8'd255)
	    wr_en <= 1'b0;
	else if(key1_flag == 1'b1)
		wr_en <= 1'b1;
	else
		wr_en <= wr_en;
		
//rd_en
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		rd_en <= 1'b0;
	else if((key2_flag == 1'b1) && (wr_en == 1'b0))
		rd_en <= 1'b1;
	else if(key1_flag == 1'b1)
		rd_en <= 1'b0;
	else
		rd_en <= rd_en;
		
//addr
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		addr <= 8'b0;
	else if((addr == 8'd255 && cnt_200ms == CNT_MAX) || 
			(key1_flag == 1'b1)||
			(key2_flag == 1'b1))
		addr <= 8'd0;
	else if((cnt_200ms == CNT_MAX && rd_en == 1'b1) || (wr_en == 1'b1))
		addr <= addr + 1'b1;
	else
		addr <= addr;
		
endmodule