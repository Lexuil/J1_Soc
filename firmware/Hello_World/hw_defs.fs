( Hardware port assignments )

h# FF00 constant mult_a  \ no cambiar estos tres
h# FF02 constant mult_b  \ hacen parte de otras
h# FF04 constant mult_p  \ definiciones

\ memory map multiplier:
h# 6700 constant multi_a	
h# 6702 constant multi_b
h# 6704 constant multi_init
h# 6706 constant multi_done
h# 6708 constant multi_pp_high
h# 670A constant multi_pp_low


\ memory map divider:
h# 6800 constant div_a		
h# 6802 constant div_b
h# 6804 constant div_init
h# 6806 constant div_done
h# 6808 constant div_c


\ memory map uart:
h# 6900 constant uart_data    \ escritura y lectura de datos que van a la uart
h# 6902 constant uart_busy    \ para lectura de uart (uart_busy)
h# 6904 constant uart_avail   \ dato valido


\ LVDS
h# 7100 constant lvds_enable  \ Habilita LVDS
h# 7102 constant lvds_w				\ Habilita Lectura
h# 7104 constant lvds_inR 		\ R de entrada ram
h# 7106 constant lvds_inG			\ G de entrada ram
h# 7108 constant lvds_inB			\ B de entrada ram
h# 710A constant lvds_addrW		\ Direccion de entrada ram


