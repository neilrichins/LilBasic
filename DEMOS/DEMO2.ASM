                             ;DEMO2.BAS
                             ;---------
DW      10 
DB     'A=0:B=0:K=0:M=0:Z=0' ,0DH
DW      20 
DB     'GOSUB 1000' ,0DH
DW      30 
DB     'GOSUB 2000' ,0DH
DW      40 
DB     'A=A+Z+Z+1' ,0DH
DW      50 
DB     'IF A>6 THEN A =1' ,0DH
DW      60 
DB     'IF A<1 THEN A =6' ,0DH
DW      80 
DB     'GOTO 20' ,0DH
DW      1000 
DB     'REM INPUT ROUTINE' ,0DH
DW      1010 
DB     'B=PORT1 AND 1' ,0DH
DW      1020 
DB     'IF K=B THEN RETURN' ,0DH
DW      1030 
DB     'K=B' ,0DH
DW      1040 
DB     'IF B=1 THEN GOTO 1100' ,0DH
DW      1050 
DB     'M=M+1:Z=NOT Z' ,0DH
DW      1060 
DB     'PRINT "BUTTON PRESSED "M" TIMES"' ,0DH
DW      1070 
DB     'RETURN' ,0DH
DW      1100 
DB     'PRINT "BUTTON RELEASED"' ,0DH
DW      1200 
DB     'RETURN' ,0DH
DW      2000 
DB     'REM DISPLAY ROUTINE' ,0DH
DW      2010 
DB     'IF A=1 THEN PORT1 = NOT 8' ,0DH
DW      2020 
DB     'IF A=2 THEN PORT1 = NOT 4' ,0DH
DW      2030 
DB     'IF A = 3 THEN PORT1 = NOT 32' ,0DH
DW      2040 
DB     'IF A = 4 THEN PORT1 = NOT 16' ,0DH
DW      2050 
DB     'IF A = 5 THEN PORT1 = NOT 128' ,0DH
DW      2060 
DB     'IF A = 6 THEN PORT1 = NOT 64' ,0DH
DW      2070 
DB     'RETURN' ,0DH
DB 80H
DEMO2_LEN EQU  503 
