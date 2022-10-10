module  fifo
(

    //fifo写端
    input  wire         wrclk    ,
    input  wire  [7:0]  pi_data  ,
    
    input  wire         pi_flag  , //输入数据有效信号，也是写请求信号
    
    //fifo读端
    input  wire         rdclk    ,
    input  wire         rdreq    ,
    
    //fifo写端
    output  wire        wrempty  ,
    output  wire        wrfull   ,
    
    output  wire  [7:0] wrusedw  , //写端口存在的数据个数，同步于wrclk时钟
    
    //fifo读端
    output  wire        rdempty  ,
    output  wire        rdfull   ,
    
    output  wire  [15:0] po_data  , //输出数据
    output  wire  [6:0] rdusedw   //读端口存在的数据个数
);


//******************实例化******************//
dcfifo_256x8to128x16	dcfifo_256x8to128x16_inst (
	.data        ( pi_data )   ,
	.rdclk       ( rdclk   ) ,
	.rdreq       ( rdreq ) ,
	.wrclk       ( wrclk ) ,
	.wrreq       ( pi_flag ),
	.q           ( po_data ),
	.rdempty     ( rdempty ),
	.rdfull      ( rdfull ),
	.rdusedw     ( rdusedw ),
	.wrempty     ( wrempty ),
	.wrfull      ( wrfull ),
	.wrusedw     ( wrusedw )
	);

endmodule