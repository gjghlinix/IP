module	rom_control
#(
	parameter	CNT_MAX = 24'd9999999
)
(
	input	wire	sys_clk,
	input	wire	sys_rst_n,
	input	wire	key1_flag,
	input	wire	key2_flag,
	
	output	reg	[7:0]	addr

);

reg	[23:0]	cnt_200ms;
reg			addr1_flag;
reg			addr2_flag;

//计数器
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		cnt_200ms <= 24'd0;
	else if(cnt_200ms == CNT_MAX || addr1_flag == 1'b1 || addr2_flag ==1'b1)
		cnt_200ms <= 24'd0;
	else
		cnt_200ms <= cnt_200ms + 1'b1;

//addr1_flag
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		addr1_flag <= 1'b0;
	else if( key2_flag == 1'b1)
		addr1_flag <= 1'b0;
	else if(key1_flag)
		addr1_flag <= ~addr1_flag;

//addr2_flag
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		addr2_flag <= 1'b0;
	else if(key1_flag == 1'b1)
		addr2_flag <= 1'b0;
	else if(key2_flag)
		addr2_flag <= ~addr2_flag;
		
//*****地址从0-255循环，其中两个按键控制特定位置的转跳
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		addr <= 8'd0;
	else if(addr == 8'd255 && cnt_200ms == CNT_MAX)
		addr <= 8'd0;
	else if(addr1_flag == 1'b1)
		addr <= 8'd99;
	else if(addr2_flag == 1'b1)
		addr <= 8'd155;
	else
		addr  <= addr + 1'b1;
		
endmodule