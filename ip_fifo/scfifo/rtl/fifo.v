module fifo
(
    input   wire            sys_clk     ,   //系统时钟50Mhz
    input   wire    [7:0]   pi_data     ,   //输入顶层模块的数据
                                            //要写入到FIFO中的数据
    input   wire            pi_flag     ,   //输入数据有效标志信号
                                            //也作为FIFO的写请求信号
    input   wire            rdreq       ,   //FIFO读请求信号

    output  wire    [7:0]   po_data     ,   //FIFO读出的数据
    output  wire            empty       ,   //FIFO空标志信号，高有效
    output  wire            full        ,   //FIFO满标志信号，高有效
    output  wire    [7:0]   usedw           //FIFO中存在的数据个数
);

//********************************************************************//
//*************************** Instantiation **************************//
//********************************************************************//

//---------------scfifo_256x8_inst-------------------
scfifo_256x8    scfifo_256x8_inst(
    .clock  (sys_clk    ),  //input            clock
    .data   (pi_data    ),  //input    [7:0]   data
    .rdreq  (rdreq      ),  //input            rdreq
    .wrreq  (pi_flag    ),  //input            wrreq

    .empty  (empty      ),  //output           empty
    .full   (full       ),  //output           full
    .q      (po_data    ),  //output   [7:0]   q
    .usedw  (usedw      )   //output   [7:0]   usedw
);

endmodule