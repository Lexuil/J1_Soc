: 0=    d# 0 = ;
: 1+    d# 1 + ;

: looptest  ( -- FIN )
    r>          ( xt )
    r>          ( xt i )
    1+
    r@ over =   ( xt i FIN )
    dup if
        nip r> drop
    else
        swap >r
    then        ( xt FIN )
    swap
    >r
;

: put-uart	\ hecho por el profe
    begin uart_busy @ 0= until
    uart_data !
;

: get-uart	\ hecho por el profe
    begin uart_avail @ d# 1 = until
    uart_data @
;

: lvds \ lvds
d# 1 lvds_enable !
;

: main 

d# 1

do

lvds

\ get-uart dup put-uart
\ get-uart dup put-uart


\ multiplicar
\ dup
\ put-uart 
\ h# FF
\ dividir
\ put-uart

\ dup
\ put-uart
\ h# FF
\ dividir
\ put-uart

loop
;
