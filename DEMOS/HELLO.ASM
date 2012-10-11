                             ;HELLO.BAS
                             ;---------
DW      10 
DB     '?"hello  ";' ,0DH
DW      20 
DB     'goto 10' ,0DH
DB 80H
HELLO_LEN EQU  25 
