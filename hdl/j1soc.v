module j1soc#(
              //parameter   bootram_file     = "../../firmware/hello_world/j1.mem"    // For synthesis            
              parameter   bootram_file     = "../firmware/Hello_World/j1.mem"       // For simulation         
  )(
   uart_tx, uart_rx,
   sys_clk_i, sys_rst_i,
   channel1_p, channel1_n,  channel2_p, channel2_n, channel3_p, channel3_n, clock_p, clock_n
   );

   input sys_clk_i, sys_rst_i;
   //uart
   output uart_tx;
   input  uart_rx;
   //LVDS
		output channel1_p;
		output channel1_n;
		output channel2_p;
		output channel2_n;
		output channel3_p;
		output channel3_n;
		output clock_p;
		output clock_n;
	 //


//------------------------------------ regs and wires-------------------------------

   wire                 j1_io_rd;//********************** J1
   wire                 j1_io_wr;//********************** J1
   wire                 [15:0] j1_io_addr;//************* J1
   reg                  [15:0] j1_io_din;//************** J1
   wire                 [15:0] j1_io_dout;//************* J1


 
   reg [1:4]cs;  // CHIP-SELECT

   wire			[15:0] mult_dout;  
   wire			[15:0] div_dout;
   wire			[15:0] uart_dout;
   wire 		[15:0] lvds_dout;
   wire			[15:0] dp_ram_dout;
 

//------------------------------------ regs and wires-------------------------------


  j1 #(bootram_file)  cpu0(sys_clk_i, sys_rst_i, j1_io_din, j1_io_rd, j1_io_wr, j1_io_addr, j1_io_dout);

  peripheral_mult  per_m (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[1]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(mult_dout) );

  peripheral_div  per_d (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[2]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(div_dout));

  peripheral_uart  per_u (.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[3]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(uart_dout), .uart_tx(uart_tx), .uart_rxd(uart_rx));
  
  peripheral_lvds per_l(.clk(sys_clk_i), .rst(sys_rst_i), .d_in(j1_io_dout), .cs(cs[4]), .addr(j1_io_addr[3:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(lvds_dout), .channel1_p(channel1_p), .channel1_n(channel1_n), .channel2_p(channel2_p), .channel2_n(channel2_n), .channel3_p(channel3_p), .channel3_n(channel3_n), .clock_p(clock_p), .clock_n(clock_n));

/*
  dpRAM_interface dpRm(.clk(sys_clk_i), .d_in(j1_io_dout), .cs(cs[4]), .addr(j1_io_addr[7:0]), .rd(j1_io_rd), .wr(j1_io_wr), .d_out(dp_ram_dout));
*/

  // ============== Chip_Select (Addres decoder) ========================  // se hace con los 8 bits mas significativos de j1_io_addr
  always @*
  begin
      case (j1_io_addr[15:8])	// direcciones - chip_select
        8'h67: cs= 4'b1000; 		//mult
        8'h68: cs= 4'b0100;		//div
        8'h69: cs= 4'b0010;		//uart
      //8'h70: cs= 4'b0001;		//dp_ram
        8'h71: cs= 4'b0001;		//lvds
        default: cs= 3'b000;
      endcase
  end
  // ============== Chip_Select (Addres decoder) ========================  //




  // ============== MUX ========================  // se encarga de lecturas del J1
  always @*
  begin
      case (cs)
        4'b1000: j1_io_din = mult_dout; 
        4'b0100: j1_io_din = div_dout;
        4'b0010: j1_io_din = uart_dout; 
      //4'b0001: j1_io_din = dp_ram_dout; 
      	4'b0001: j1_io_din = lvds_dout;
        default: j1_io_din = 16'h0666;
      endcase
  end
 // ============== MUX ========================  // 

endmodule // top
