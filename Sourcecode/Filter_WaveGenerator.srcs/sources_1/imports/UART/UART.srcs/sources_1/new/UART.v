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
    parameter CLK_FREQUENCE = 100_000_000,//ϵͳʱ��Ƶ��
               BAUD_RATE = 115200,//�趨�Ĳ�����
               PARITY = "NONE",//��żУ��
               FRAME_WD = 8//ÿһ֡��λ��
)
(
    input clk,//ϵͳʱ��
    input rst_n,//reset���͵�ƽ��Ч
    input frame_en,//����һ֡������Ϻ���frame_enΪ�ߵ�ƽ��ʼ������һ֡
    input uart_rx,//UART����RXD
    output uart_tx,//UART���TXD
    
    input [(FRAME_WD-1):0]tx_frame,//��ͨ��TXD�����֡
    output [(FRAME_WD-1):0]rx_frame,//ͨ��RXD��֡
    output tx_done,//֡�������ָʾ
    output rx_done//֡�������ָʾ
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
