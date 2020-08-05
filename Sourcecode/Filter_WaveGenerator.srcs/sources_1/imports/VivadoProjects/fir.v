`timescale 1ns / 1ps
//All signals are adjusted in order to fit the uart interface.
module fir(
	input clk,
	input rst,
	input wire[15:0] filter_in,
	output reg[32:0] filter_out//output signal, adjusted to 32 bits
    );
	
	parameter word_width = 16;
	parameter order = 16;

	// define delay unit , input width is 16  , filter order is 16
	reg[word_width-1:0] delay_pipeline[order:0];
	
	// define coef_____________changed
	wire [word_width-1:0]  coef[order:0];
	assign coef[0] = 'd1;
	assign coef[1] = 'd3;
	assign coef[2] = 'd4;
	assign coef[3] = 'd2;
	assign coef[4] = 'd11;
	assign coef[5] = 'd36;
	assign coef[6] = 'd69;
	assign coef[7] = 'd96;
	assign coef[8] = 'd107;
	assign coef[9] = 'd96;
	assign coef[10] = 'd69;
	assign coef[11] = 'd36;
	assign coef[12] = 'd11;
	assign coef[13] = 'd2;
	assign coef[14] = 'd4;
	assign coef[15] = 'd3;
	assign coef[16] = 'd1;

	// define multipler
	reg[16:0]  product[16:0];

	// define sum buffer
	reg[32:0]  sum_buf;	

	// define input data buffer
	reg[7:0] data_in_buf;

	// data buffer
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			data_in_buf <= 0;
		end
		else begin
			data_in_buf <= filter_in;
		end
	end

	// delay units pipeline
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			delay_pipeline[0] <= 0 ;
			delay_pipeline[1] <= 0 ;
			delay_pipeline[2] <= 0 ;
			delay_pipeline[3] <= 0 ;
			delay_pipeline[4] <= 0 ;
			delay_pipeline[5] <= 0 ;
			delay_pipeline[6] <= 0 ;
			delay_pipeline[7] <= 0 ;
			delay_pipeline[8] <= 0 ;
			delay_pipeline[9] <= 0 ;
			delay_pipeline[10] <= 0 ;
			delay_pipeline[11] <= 0 ;
			delay_pipeline[12] <= 0 ;
			delay_pipeline[13] <= 0 ;
			delay_pipeline[14] <= 0 ;
			delay_pipeline[15] <= 0 ;
			delay_pipeline[16] <= 0 ;
		end 
		else begin
			delay_pipeline[0] <= data_in_buf ;
			delay_pipeline[1] <= delay_pipeline[0] ;
			delay_pipeline[2] <= delay_pipeline[1] ;
			delay_pipeline[3] <= delay_pipeline[2] ;
			delay_pipeline[4] <= delay_pipeline[3] ;
			delay_pipeline[5] <= delay_pipeline[4] ;
			delay_pipeline[6] <= delay_pipeline[5] ;
			delay_pipeline[7] <= delay_pipeline[6] ;
			delay_pipeline[8] <= delay_pipeline[7] ;
			delay_pipeline[9] <= delay_pipeline[8] ;
			delay_pipeline[10] <= delay_pipeline[9] ;
			delay_pipeline[11] <= delay_pipeline[10] ;
			delay_pipeline[12] <= delay_pipeline[11] ;
			delay_pipeline[13] <= delay_pipeline[12] ;
			delay_pipeline[14] <= delay_pipeline[13] ;
			delay_pipeline[15] <= delay_pipeline[14] ;
			delay_pipeline[16] <= delay_pipeline[15] ;
		end
	end

	// implement product with coef 
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			product[0] <= 0;
			product[1] <= 0;
			product[2] <= 0;
			product[3] <= 0;
			product[4] <= 0;
			product[5] <= 0;
			product[6] <= 0;
			product[7] <= 0;
			product[8] <= 0;
			product[9] <= 0;
			product[10] <= 0;
			product[11] <= 0;
			product[12] <= 0;
			product[13] <= 0;
			product[14] <= 0;
			product[15] <= 0;
			product[16] <= 0;
		end
		else begin
			product[0] <= coef[0] * delay_pipeline[0];
			product[1] <= coef[1] * delay_pipeline[1];
			product[2] <= coef[2] * delay_pipeline[2];
			product[3] <= coef[3] * delay_pipeline[3];
			product[4] <= coef[4] * delay_pipeline[4];
			product[5] <= coef[5] * delay_pipeline[5];
			product[6] <= coef[6] * delay_pipeline[6];
			product[7] <= coef[7] * delay_pipeline[7];
			product[8] <= coef[8] * delay_pipeline[8];
			product[9] <= coef[9] * delay_pipeline[9];
			product[10] <= coef[10] * delay_pipeline[10];
			product[11] <= coef[11] * delay_pipeline[11];
			product[12] <= coef[12] * delay_pipeline[12];
			product[13] <= coef[13] * delay_pipeline[13];
			product[14] <= coef[14] * delay_pipeline[14];
			product[15] <= coef[15] * delay_pipeline[15];
			product[16] <= coef[16] * delay_pipeline[16];
		end
	end

	// accumulation
	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			sum_buf <= 0;
		end
		else begin
			sum_buf <= 'd0+ product[4]+ product[5]+ product[6]+ product[7]+ product[8]+ product[9]+ product[10]
			+ product[11]+ product[12]-product[0] - product[1]- product[2]- product[3]-product[13]- product[14]- product[15]-product[16];
		end
	end

	always @(sum_buf) begin
		if (!rst) begin
			filter_out = 0;
		end
		else begin
			filter_out = sum_buf;
		end
	end

endmodule
