                             ;DEMO.BAS
                             ;--------
DW      10 
DB     'CLS : S = 0' ,0DH
DW      20 
DB     '?"DEMO PROGRAM"' ,0DH
DW      30 
DB     'GOSUB 2000' ,0DH
DW      40 
DB     'L=L+B' ,0DH
DW      50 
DB     'IF L < 1 THEN L = 4' ,0DH
DW      60 
DB     'IF L > 4 THEN L = 1' ,0DH
DW      70 
DB     'GOSUB 1000' ,0DH
DW      80 
DB     'GOTO 30' ,0DH
DW      1000 
DB     'REM LED DECODE' ,0DH
DW      1010 
DB     'IF L=1 THEN PORT1= NOT1' ,0DH
DW      1020 
DB     'IF L=2 THEN PORT1= NOT4' ,0DH
DW      1030 
DB     'IF L=3 THEN PORT1= NOT 16' ,0DH
DW      1040 
DB     'IF L=4 THEN PORT1= NOT 64' ,0DH
DW      1050 
DB     'RETURN' ,0DH
DW      2000 
DB     'REM GET BUTTON STATE' ,0DH
DW      2010 
DB     'B=(PORT1 AND 2) -1' ,0DH
DW      2020 
DB     'IF T = B THEN GOTO 2050' ,0DH
DW      2030 
DB     'S=NOT S' ,0DH
DW      2040 
DB     'IF S THEN PRINT "BUTTON UP"' ,0DH
DW      2045 
DB     'IF NOT S THEN PRINT "BUTTON DOWN"' ,0DH
DW      2050 
DB     'T = B' ,0DH
DW      2060 
DB     'RETURN' ,0DH
DB 80H
DEMO_LEN EQU  418 
