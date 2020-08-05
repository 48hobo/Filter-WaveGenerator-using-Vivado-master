`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/27 21:01:06
// Design Name: 
// Module Name: tb_UART
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


module tb_UART();
    reg clk;
    reg rst_n;
    reg frame_en;
    reg uart_rx;
    wire uart_tx;
    
    reg [7:0]tx_frame;
    wire [7:0]rx_frame;
    wire tx_done;
    wire rx_done;

    initial
        begin
            clk = 1;
            forever #5 clk = ~clk;
        end
        
    initial
        begin
            rst_n = 1;
            #30 rst_n = 0;
            #20 rst_n = 1;
        end
        
    initial 
        begin
            frame_en = 1'b0;
        end
    always 
        begin
            #100 frame_en = 1'b1;
            #20 frame_en = 1'b0;
            @(posedge tx_done);
            #100;
        end
        
//    initial 
//        begin
//            frame_en = 1'b1;
//        end
        
    initial begin
            tx_frame = 8'b00000000;
        end
        
    always@(posedge tx_done)
        begin
            tx_frame = tx_frame + 11;
        end

    always@(posedge clk) uart_rx <= uart_tx;
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
    .rst_n(rst_n),
    .frame_en(frame_en),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),
    .tx_frame(tx_frame),
    .rx_frame(rx_frame),
    .tx_done(tx_done),
    .rx_done(rx_done)
);


endmodule
