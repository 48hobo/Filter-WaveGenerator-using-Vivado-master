`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 19:46:41
// Design Name: 
// Module Name: tb_Top
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


module tb_Top();
    reg clk;
    reg rst_n_uart = 1;
    reg uart_rx;
    wire uart_tx;
    
    reg uart_rx_uart;
    wire uart_tx_uart;
    
    reg frame_en_uart;
    reg [7:0]tx_frame_uart;
    wire [7:0]rx_frame_uart;
    wire tx_done_uart;
    wire rx_done_uart;
    
    reg WaveGeneratorRunning = 1;
    wire DAC_Out;
    wire SettingDone;
    
    reg isResetted = 0;
    

    initial
        begin
            clk = 1;
            forever #5 clk = ~clk;
        end
        
    always @ (posedge clk)
        begin
            if(isResetted == 0)
                begin
                    #1000 rst_n_uart = 0;
                    #200 rst_n_uart = 1;
                    isResetted = 1;
                end
        end
        
    reg DACOutButton = 1;    
    reg FIROutButton = 1;
    initial
        begin
//            #1_000_000 DACOutButton = 0;
//            #1_000_000_000 DACOutButton = 1;            
            #1_000_000 FIROutButton = 0;
            #1_000_000_000 FIROutButton = 1;
        end
        
    //调节设置在这！
    initial 
        begin
            frame_en_uart = 1'b1;
            tx_frame_uart = 8'b00000000;
            #2000;
            //起始帧
            @(posedge tx_done_uart)
            tx_frame_uart = 8'h7E;
            @(posedge tx_done_uart)
            tx_frame_uart = 8'h7E;
            //UART串口输出频率Hz
            @(posedge tx_done_uart)
            tx_frame_uart = 8'h00;
            @(posedge tx_done_uart)
            tx_frame_uart = 8'h27;
            @(posedge tx_done_uart)
            tx_frame_uart = 8'h10;
            //波形输出模式，01正弦，02三角波，03方波
            @(posedge tx_done_uart)
            tx_frame_uart = 8'h01;
            //波形输出频率，也就是FIR输入频率，调这个就行，4位16进制无符号数
            @(posedge tx_done_uart)
            tx_frame_uart = 8'h00;
            @(posedge tx_done_uart)
            tx_frame_uart = 8'hc8;
            //相位
            @(posedge tx_done_uart)
            tx_frame_uart = 8'H00;
            @(posedge tx_done_uart)
            tx_frame_uart = 8'hB4;
            //结束位
            @(posedge tx_done_uart)
            tx_frame_uart = 8'h7E;
            @(posedge tx_done_uart)
            tx_frame_uart = 8'h7E;
            #50 frame_en_uart = 0;
        end
        
    always @ (posedge clk)
        begin
            uart_rx = uart_tx_uart;
            uart_rx_uart = uart_tx;
        end
    
    Filter_WaveGenerator
    #(
    .CLK_FREQUENCE(100_000_000),
    .BAUD_RATE (115200),
    .PARITY ("NONE"),
    .FRAME_WD (8)
    )
    FWG_inst
    (
    .clk(clk),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .DACOutButton(DACOutButton),
    .FIROutButton(FIROutButton),
    .SettingDone(SettingDone),
    .DAC_Out(DAC_Out)
    );


UART
#(
    .CLK_FREQUENCE(100_000_000),
    .BAUD_RATE (115200),
    .PARITY ("NONE"),
    .FRAME_WD (8)
)
UART_inst
(
    .clk(clk),
    .rst_n(rst_n_uart),
    .frame_en(frame_en_uart),
    .uart_rx(uart_rx_uart),
    .uart_tx(uart_tx_uart),
    .tx_frame(tx_frame_uart),
    .rx_frame(rx_frame_uart),
    .tx_done(tx_done_uart),
    .rx_done(rx_done_uart)
);
endmodule
