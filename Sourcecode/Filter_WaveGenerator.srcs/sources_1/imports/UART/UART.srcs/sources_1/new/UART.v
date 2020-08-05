`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 17:25:51
// Design Name: 
// Module Name: UART
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UART
#(
    parameter CLK_FREQUENCE = 100_000_000,//系统时钟频率
               BAUD_RATE = 115200,//设定的波特率
               PARITY = "NONE",//奇偶校验
               FRAME_WD = 8//每一帧的位数
)
(
    input clk,//系统时钟
    input rst_n,//reset，低电平有效
    input frame_en,//在上一帧发送完毕后，若frame_en为高电平则开始发送下一帧
    input uart_rx,//UART输入RXD
    output uart_tx,//UART输出TXD
    
    input [(FRAME_WD-1):0]tx_frame,//需通过TXD输出的帧
    output [(FRAME_WD-1):0]rx_frame,//通过RXD的帧
    output tx_done,//帧传输完成指示
    output rx_done//帧接收完成指示
);

wire frame_error;

uart_frame_tx
#(
	.CLK_FREQUENCE	( CLK_FREQUENCE )	,
	.BAUD_RATE		( BAUD_RATE )	,
	.PARITY			( PARITY )	,	//"NONE","EVEN","ODD"
	.FRAME_WD		( FRAME_WD )	
)
uart_frame_tx_inst
(
	.clk			( clk		 	 )	,
	.rst_n			( rst_n		 	 )	,
	.frame_en		( frame_en	 	 )	,
	.data_frame		( tx_frame	     )	,
	.tx_done		( tx_done		 )	,
	.uart_tx		( uart_tx		 )	 
);

uart_frame_rx
#(
	.CLK_FREQUENCE	( CLK_FREQUENCE )	,
    .BAUD_RATE        ( BAUD_RATE )    ,
    .PARITY            ( PARITY )    ,    //"NONE","EVEN","ODD"
    .FRAME_WD        ( FRAME_WD )       
)
uart_frame_rx_inst
(
    .clk(clk),
    .rst_n(rst_n),
    .uart_rx(uart_rx),
    .rx_frame(rx_frame),
    .rx_done(rx_done),
    .frame_error(frame_error)
);


endmodule
