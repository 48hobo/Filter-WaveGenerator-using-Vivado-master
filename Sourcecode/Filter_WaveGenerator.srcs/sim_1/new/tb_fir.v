`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/28 17:02:44
// Design Name: 
// Module Name: TestBench
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


module tb_fir();
reg CLK;
reg [7:0] FIR_IN;
reg RST;
reg [7:0] mem[1:4096];                   
wire [15:0] FIR_OUT;
reg [7:0] FIR_OUT_8;
reg [12:0] i;

fir i1 (
      .clk(CLK),
      .rst(RST),
      .filter_in(FIR_IN),
      .filter_out(FIR_OUT)
);

initial                                               
       begin 
           $readmemh("./mem.txt",mem);//½«´ýÂË²¨ÐÅºÅ¶ÁÈëmem
           RST= 0;
           CLK= 0;
           #50;      RST= 1;
           #50000;   $stop;
       end  

initial
       forever
       #10 CLK = ~CLK;
       
 always@(posedge CLK or negedge RST) 
      if(!RST)                                
          FIR_IN <= 8'b0 ;
       else
          FIR_IN <= mem[i];     

always@(posedge CLK or negedge RST) 
       if(!RST)
           i <= 12'd0;
       else
           i <= i + 1'd1;

always @ (posedge CLK) FIR_OUT_8 = FIR_OUT[15:8];
endmodule
