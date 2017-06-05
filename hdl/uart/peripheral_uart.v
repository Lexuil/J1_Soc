module peripheral_uart(clk , rst , d_in , cs , addr , rd , wr, d_out,  uart_tx, uart_rxd);
  
  input clk;
  input rst;
  input [15:0]d_in;
  input cs;
  input [3:0]addr; // 4 LSB from j1_io_addr
  input rd;
  input wr;
  output reg [15:0]d_out;

   output uart_tx;
   input uart_rxd;

//------------------------------------ regs and wires-------------------------------

reg [2:0] s; 	//selector mux_4  and demux_4

reg [7:0] tx_uart; // data in uart

wire uart_busy;  // out_uart
wire uart_avail;  // out_uart
wire  [7:0]rx_data;  // out_uart rxdata
reg rx_ack;
reg tx_wr;

//------------------------------------ regs and wires-------------------------------




always @(*) begin//----address_decoder------------------
case (addr)
4'h0:begin s = (cs) ? 3'b001 : 3'b000 ;end //RX Tx data 
4'h2:begin s = (cs && rd) ? 3'b010 : 3'b000 ;end //busy
4'h4:begin s = (cs && rd) ? 3'b100 : 3'b000 ;end //avail

default:begin s=3'b000 ; end
endcase
end//-----------------address_decoder--------------------





always @(negedge clk) begin

if (rst) begin 
rx_ack <=0;
tx_wr<=0;
end
else begin
	rx_ack <=0;
	tx_wr<=0;

		if ((s[0] == 2'b01) && wr == 1) begin //-------------------- escritura de registros
						tx_wr <= 1;
						tx_uart = d_in[7:0];
		end

		//-------------------- escritura de registros
		if (cs==1 && rd == 1) begin //-------------------- lectura de registros

		case (s)
		3'b001: begin 
						d_out= rx_data;	// revisa si esta ocupado
						rx_ack<=1;
						end
		3'b010: d_out=  {15'h0,uart_busy};	// revisa si esta ocupado
		3'b100: d_out=  {15'h0,uart_avail};	// revisa si esta ocupado

		default: d_out=0;
		endcase
		end 
	end
end
									//(addr != 4'h4): se hace para evitar escrituras fantasma
uart uart(.tx_busy(uart_busy),.uart_txd(uart_tx), .tx_wr(tx_wr), .tx_data(tx_uart), .clk(clk), .reset(rst), .rx_avail(uart_avail), .rx_data(rx_data), .rx_ack(rx_ack), .uart_rxd(uart_rxd));// System clock, 



endmodule
