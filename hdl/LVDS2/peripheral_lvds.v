module peripheral_lvds(
  input clk,
  input rst,
  input [15:0]d_in,
  input cs,
  input [3:0]addr, // 4 LSB from j1_io_addr     /// Variables J1
  input rd,
  input wr,
  output reg [15:0]d_out,
  
	output channel1_p,
	output channel1_n,
	output channel2_p,
	output channel2_n,
	output channel3_p,
	output channel3_n,
	output clock_p,
	output clock_n
);

//------------------------------------ regs and wires-------------------------------

  reg [4:0] s;  //selector mux_4  and demux_4
  reg enable=0;
  wire [23: 0] pixel_rgb;

//------------------------------------ regs and wires-------------------------------




always @(*) begin//----address_decoder------------------
case (addr)
4'h0:begin s = (cs && wr) ? 5'b00001 : 5'b00000 ;end //Enable

/*
4'h2:begin s = (cs && rd) ? 6'b000010 : 6'b000000 ;end //data_out[23:15]
4'h3:begin s = (cs && rd) ? 6'b000100 : 6'b000000 ;end //data_out[14:8]
4'h4:begin s = (cs && rd) ? 6'b001000 : 6'b000000 ;end //data_out[7:0]
4'h6:begin s = (cs && rd) ? 6'b010000 : 6'b000000 ;end //done
*/
default:begin s=3'b000 ; end
endcase
end//-----------------address_decoder--------------------


always @(negedge clk) begin//-------------------- escritura de registros

enable    = (s[0]) ? d_in : enable; //Write Registers
end//------------------------------------------- escritura de registros 


LVDS_test LVDS(
	.clk(clk),
	.rst(rst),
	.ene(enable),
	.channel1_p(channel1_p),
	.channel1_n(channel1_n),
	.channel2_p(channel2_p),
	.channel2_n(channel2_n),
	.channel3_p(channel3_p),
	.channel3_n(channel3_n),
	.clock_p(clock_p),
	.clock_n(clock_n)
);

endmodule
