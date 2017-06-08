`timescale 1ns / 1ps

module LVDS_test(
	input clk,
	input rst,
	input ene,
	output channel1_p,
	output channel1_n,
	output channel2_p,
	output channel2_n,
	output channel3_p,
	output channel3_n,
	output clock_p,
	output clock_n
);


wire [7:0] Rimg;
wire [7:0] Gimg;
wire [7:0] Bimg;

reg [30:0]  Cont1=0;
reg [30:0]  ContRx=0;
reg [1:0]  en=0;

parameter ScreenX = 1365;
parameter ScreenY = 767;

parameter BlankingVertical = 12;
parameter BlankingHorizontal = 50;


wire clo,clk6x,clk_lckd, clkdcm;

reg [7:0] Red   = 8'h0;
reg [7:0] Blue  = 8'h0;
reg [7:0] Green = 8'hFF;


reg [10:0] ContadorX = ScreenX+BlankingHorizontal-3; // Contador de colunas
reg [10:0] ContadorY = ScreenY+BlankingVertical; // Contador de lineas


wire HSync =(((ContadorX-1)==ScreenX) & ((ContadorX-1)==(ScreenX+(BlankingHorizontal/2))))?0:1;
wire VSync =(((ContadorY)>ScreenY) & ((ContadorY)<(ScreenY+(BlankingVertical/2))))?0:1;
wire DataEnable = ((ContadorX<ScreenX) & (ContadorY<ScreenY));

always @(posedge clk6x) begin

	ContadorX <= ((ContadorX-1)==(ScreenX+BlankingHorizontal)) ? 0 : ContadorX+1;
	if(ContadorX==(ScreenX+BlankingHorizontal)) ContadorY <= (ContadorY==(ScreenY+BlankingVertical)) ? 0 : ContadorY+1;

end

DCM_SP #(
	.CLKIN_PERIOD	(20),  // from 50MHz Input (valor del periodo en ns)
	.CLKFX_MULTIPLY(7),
	.CLKFX_DIVIDE 	(5)
	)
dcm_main (
	.CLKIN   	(clk),
	.CLKFB   	(clo),
	.RST     	(1'b0),
	.CLK0    	(clkdcm),
	.CLKFX   	(clk6x),
	.LOCKED  	(clk_lckd)
);


BUFG 	clk_bufg	(.I(clkdcm), 	.O(clo) ) ;


video_lvds videoencoder (
    .DotClock(clk6x), 
    .HSync(HSync), 
    .VSync(VSync), 
    .DataEnable(DataEnable), 
    .Red(Red), 
    .Green(Green), 
    .Blue(Blue), 
    .channel1_p(channel1_p), 
    .channel1_n(channel1_n), 
    .channel2_p(channel2_p), 
    .channel2_n(channel2_n), 
    .channel3_p(channel3_p), 
    .channel3_n(channel3_n), 
    .clock_p(clock_p), 
    .clock_n(clock_n)
    );

//Video Generator

ram image(
	.d_outR(Rimg),
	.d_outG(Gimg),
	.d_outB(Bimg),
	.clkq(clk6x),
	.addrX(Cont1),
	.en(en)
);

//Ram

always @(posedge clk6x)begin
	if(ene == 1)begin
		if(en == 1)begin
			Red   <= Rimg;  
			Green <= Gimg;
			Blue  <= Bimg;
		end else begin
			Red   <= 0;  
			Green <= 0;
			Blue  <= 0;
		end
	end
end


always @(posedge clk6x)begin
	
	if(ene == 1)begin
		if((ContadorX < 1364) & (ContadorY < 765)) begin
			en = 1;
			if (ContadorX == 1363) begin
	 			Cont1 <= ((ContadorY+2)/8)*100;
	 			ContRx <= 0;
			end else begin
				if (ContRx == 13) begin
					ContRx <= 0;
					Cont1 <= Cont1 + 1;
				end else begin
					ContRx <= ContRx + 1;
				end
			end
		end else begin
			en = 0;
		end
	end
end

//RAM image

endmodule


//////////////////////////////////////////////////////////////////


