                             ;LED.BAS
                             ;-------
DW      10 
DB     'REM Basic LED demo program' ,0DH
DW      20 
DB     'FOR A=1 TO 254' ,0DH
DW      30 
DB     'C=A' ,0DH
DW      40 
DB     'FOR B=1 TO 8' ,0DH
DW      50 
DB     'C=C*2' ,0DH
DW      60 
DB     'C=C+(Z>255)' ,0DH
DW      70 
DB     'C=C MOD 256' ,0DH
DW      80 
DB     'PORT1=C' ,0DH
DW      90 
DB     'FOR D=1 TO 10' ,0DH
DW      100 
DB     'NEXT D' ,0DH
DW      110 
DB     'NEXT B' ,0DH
DW      120 
DB     'NEXT A' ,0DH
DW      130 
DB     'GOTO 20' ,0DH
DB 80H
LED_LEN EQU  167 
