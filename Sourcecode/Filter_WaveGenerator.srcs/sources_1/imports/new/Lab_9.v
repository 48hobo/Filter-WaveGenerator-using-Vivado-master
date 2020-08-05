`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/23 12:05:14
// Design Name: 
// Module Name: Lab_9
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


module Lab_9(
    input clk_100MHz,
    input [1:0]Key,
    input [15:0]Freq,
    input [15:0]Phase,
    output clk_DAC,
    output DAC_Din,
    output DAC_Sync
    );
    //提供DAC时钟
    clk_division clk_div50(
        .i_clk(clk_100MHz),
        .i_rst(1),
        .i_clk_mode(2),
        .o_clk_out(clk_DAC)
    );
    //驱动实例化
    Driver_DAC Driver_DAC0(
        .clk_100MHz(clk_100MHz),
        .clk_DAC(clk_DAC),
        .DAC_En(1),
        .Wave_Mode(Key),
        .Phase(Phase),
        .Freq(Freq),
        .DAC_Din(DAC_Din),
        .DAC_Sync(DAC_Sync)
    );
endmodule
