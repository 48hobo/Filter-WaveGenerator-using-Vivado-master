`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 16:24:51
// Design Name: 
// Module Name: Filter_WaveGenerator
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


module Filter_WaveGenerator
#(
    //UART参数
    parameter CLK_FREQUENCE = 100_000_000,
               BAUD_RATE = 115200,
               PARITY = "NONE",
               FRAME_WD = 8
)
(
    input clk,
    //UART部分
    input uart_rx,
    output uart_tx,
    //波形发生器及滤波器部分
    input DACOutButton,
    input FIROutButton,
    output reg SettingDone = 0,//指示设置完成
    output DAC_Out//DAC输出
    );
    
    
    wire clk_DAC;//DAC的时钟信号
    reg [1:0]WaveMode = 1;
    reg [15:0]WaveFrequency = 10000;
    reg [15:0]Phase = 0;
    reg [15:0]StartStop = 16'b0111_1110_0111_1110;
    
    wire tx_done;
    wire rx_done;
    reg [(FRAME_WD-1):0]tx_frame;
    wire [(FRAME_WD-1):0]rx_frame;
    reg frame_en = 0;
    
    reg rst_n = 1;
    
    //自动reset，避免串口通信失效
    reg isResetted = 0;
    reg [15:0]timer1 = 0;
    always @ (posedge clk)
        begin
            if(isResetted == 0)
                begin
                    timer1 = timer1 + 1;
                    if(timer1 > 1000 && timer1 < 1100) rst_n = 0;
                    else if(timer1 > 1200)
                        begin
                            rst_n = 1;
                            isResetted = 1;
                        end
                end
        end
    
    wire [7:0]DAC_Data;
    
    wire [23:0] m_axis_data_tdata;
    wire [31:0]FIR_Out;
    reg [7:0]FIR_Out_8;
    always @ (posedge clk)
        FIR_Out_8 = m_axis_data_tdata[16:9];
    //串口发送    
    reg [23:0]SerialOutFreq = 200;
    reg [31:0]timerDACOut = 0;
    reg [31:0]timerFIROut = 0;
    always @ (posedge clk)
        begin
            if(!DACOutButton)//如果按下波形发生器的输出按钮
                begin
                    tx_frame = DAC_Data;
                    timerDACOut = timerDACOut + 1;
                    if(timerDACOut < 10) frame_en = 1;
                    else if(timerDACOut > 20 && timerDACOut < 25) frame_en = 0;
                    else if(timerDACOut > 100_000_000 / SerialOutFreq) 
                        begin
                            timerDACOut = 0;
                        end
                end
            else if(!FIROutButton)//如果按下FIR滤波器的输出按钮
                    begin
                        tx_frame = FIR_Out_8;
                        timerFIROut = timerFIROut + 1;
                        if(timerFIROut < 10) frame_en = 1;
                        else if(timerFIROut > 20 && timerFIROut < 25) frame_en = 0;
                        else if(timerFIROut > 100_000_000 / timerFIROut) 
                            begin
                                timerFIROut = 0;
                            end
                    end
        end
        
    //起始位16bit：0111 1110 0111 1110
    //传输频率选择24bit
    //波形选择8bit：1 2 3分别对应方波 正弦波 三角波
    //频率选择16bit
    //相位选择16bit
    //结束位16bit：0111 1110 0111 1110
    reg [95:0]RecvBuffer = 0;
    
    //已接收完一帧
    always @ (posedge rx_done)
        begin
            RecvBuffer <= {RecvBuffer[87:0],rx_frame};
        end
        
    //判断串口输入并进行设置        
    reg [31:0] timer3 = 0;
    always @ (posedge clk)
        begin
            if(RecvBuffer[95:80] == StartStop && RecvBuffer[15:0] == StartStop)
                begin
                    case(RecvBuffer[55:48])
                        8'b0000_0001: WaveMode = 1;
                        8'b0000_0010: WaveMode = 2;
                        8'b0000_0011: WaveMode = 3;
                        default: WaveMode = 0;
                    endcase
                    SerialOutFreq = RecvBuffer[79:56];
                    WaveFrequency = RecvBuffer[47:32];
                    Phase = RecvBuffer[31:16];
                    SettingDone = 1;
                end
            if(SettingDone == 1)
                begin
                    timer3 = timer3 + 1;
                    if(timer3 > 10_000_000)
                        begin
                            timer3 = 0;
                            SettingDone = 0;
                        end
                end
        end

    wire clk_fir;
    clk_division clk_fir_inst(
        .i_clk(clk),
        .i_rst(1),
        .i_clk_mode(10000),
        .o_clk_out(clk_fir)
    );

    wire m_axis_data_tvalid;
    wire s_axis_data_tready;
    fir_compiler_0 fir_inst (
    .aclk(clk_fir),                              // input wire aclk
    .s_axis_data_tvalid(rst_n),  // input wire s_axis_data_tvalid
    .s_axis_data_tready(s_axis_data_tready),  // output wire s_axis_data_tready
    .s_axis_data_tdata(DAC_Data),    // input wire [7 : 0] s_axis_data_tdata
    .m_axis_data_tvalid(m_axis_data_tvalid),  // output wire m_axis_data_tvalid
    .m_axis_data_tdata(m_axis_data_tdata)    // output wire [23 : 0] m_axis_data_tdata
    );
    
    //fir模块实现
//    fir fir_inst(
//        .clk(clk),
//        .rst(rst_n),
//        .filter_in(DAC_Data),
//        .filter_out(FIR_Out)
//    );
    
    //UART模块实现
    UART
    #(
        .CLK_FREQUENCE(CLK_FREQUENCE),
        .BAUD_RATE (BAUD_RATE),
        .PARITY (PARITY),
        .FRAME_WD (FRAME_WD)
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
    
    //波形发生器模块实现
        //提供DAC时钟
    clk_division clk_div50(
        .i_clk(clk),
        .i_rst(1),
        .i_clk_mode(2),
        .o_clk_out(clk_DAC)
    );
    //驱动实例化
    Driver_DAC Driver_DAC0(
        .clk_100MHz(clk),
        .clk_DAC(clk_DAC),
        .DAC_En(1),
        .Wave_Mode(WaveMode),
        .Phase(Phase),
        .Freq(WaveFrequency),
        .DAC_Din(DAC_Out),
        .DAC_Sync(),
        .DAC_Data(DAC_Data)
    );
endmodule
