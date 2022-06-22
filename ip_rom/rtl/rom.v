module	rom
(
	input	wire		sys_clk,
	input	wire		sys_rst_n,
	input	wire [1:0]	key,
	
	output	wire	stcp,
	output	wire	shcp,
	output	wire	oe,
	output	wire	ds
);
//wire 定义
wire		key1_flag;
wire		key2_flag;
wire [7:0]	addr;
wire [7:0]	rom_data;

rom_control	rom_control_inst
(
	.sys_clk	(sys_clk	),
	.sys_rst_n	(sys_rst_n	),
	.key1_flag	(key1_flag	),
	.key2_flag	(key2_flag	),

	.addr		(addr		)
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
	.data		({12'b0,rom_data}),
	.point		(0		),

	.shcp		(shcp		),
	.stcp		(stcp		),
	.oe			(oe			),
	.ds         (ds)
);

rom_256_8	rom_256_8_inst 
(
	.address ( addr ),
	.clock ( sys_clk ),
	.q ( rom_data )
);

endmodule