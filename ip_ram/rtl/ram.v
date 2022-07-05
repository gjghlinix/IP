module ram
(
	input  wire 		sys_clk,
	input  wire 		sys_rst_n,
	input  wire [1:0] 	key,
	
	output  wire 		stcp,
	output  wire 		shcp,
	output  wire 		ds,
	output  wire 		oe
);

wire		key1_flag;
wire		key2_flag;
wire [7:0]	data;
wire [7:0]	data_rd;
wire [7:0]	addr;
wire		wr_en;
wire 		rd_en;

ram_control ram_control_inst
(
.sys_clk	(sys_clk),
.sys_rst_n	(sys_rst_n),
.key1_flag	(key1_flag),
.key2_flag	(key2_flag),

.wr_en		(wr_en),
.rd_en		(rd_en),
.addr		(addr),
.data	    (data)
);

key_filter	key1_fil_inst
(
	.sys_clock	(sys_clk),
	.sys_rst_n	(sys_rst_n),
	.key_in		(key[0]	),

	.key_flag 	(key1_flag )
);

key_filter	key2_fil_inst
(
	.sys_clock	(sys_clk),
	.sys_rst_n	(sys_rst_n),
	.key_in		(key[1]	),

	.key_flag 	(key2_flag )
);

dynamic_combine	dynamic_combine_inst
(
	.sys_clk	(sys_clk	),
	.sys_rst_n	(sys_rst_n),
	.sign		(0		),
	.seg_en		(1'b1		),
	.data		({12'b0,data_rd}),
	.point		(0		),

	.shcp		(shcp		),
	.stcp		(stcp		),
	.oe			(oe			),
	.ds         (ds)
);

ram_256_8	ram_256_8_inst (
	.aclr ( ~sys_rst_n ),       //异步清零
	.address ( addr ),
	.clock ( sys_clk ),
	.data ( data ),          //要写入arm的数据
	.rden ( rd_en ),
	.wren ( wr_en ),
	.q ( data_rd )        //读出的arm数据
	);
	
endmodule
