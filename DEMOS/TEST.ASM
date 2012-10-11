                             ;TEST.BAS
                             ;--------
DW      10 
DB     'PRINT' ,0DH
DW      20 
DB     'PRINT "LIL"BASIC DEMO PROGRAM"' ,0DH
DW      30 
DB     'INPUT "ENTER 1-TEST INPUT 2-TEST OUTPUT 3-PATTERN TEST",A' ,0DH
DW      40 
DB     'IF A=2 THEN GOTO 200' ,0DH
DW      50 
DB     'IF A=3 THEN GOTO 300' ,0DH
DW      100 
DB     'REM' ,0DH
DW      110 
DB     'REM    TEST PORT INPUT' ,0DH
DW      120 
DB     'REM' ,0DH
DW      130 
DB     'A=PORT1' ,0DH
DW      140 
DB     'PRINT "PORT 1 =" A' ,0DH
DW      150 
DB     'GOTO 100' ,0DH
DW      200 
DB     'REM' ,0DH
DW      210 
DB     'REM    TEST OUTPUT' ,0DH
DW      220 
DB     'REM' ,0DH
DW      230 
DB     'INPUT "PORT1 =",A' ,0DH
DW      240 
DB     'IF A > 255 THEN GOTO 100' ,0DH
DW      250 
DB     'IF A < 0 THEN GOTO 100' ,0DH
DW      260 
DB     'PORT1=A' ,0DH
DW      270 
DB     'GOTO 200' ,0DH
DW      300 
DB     'REM' ,0DH
DW      310 
DB     'REM    TEST PATTERNS' ,0DH
DW      320 
DB     'REM' ,0DH
DW      330 
DB     'FOR A = 0 TO 255' ,0DH
DW      340 
DB     'PORT1=A' ,0DH
DW      350 
DB     'NEXT A' ,0DH
DW      360 
DB     'FOR A = 0 TO 255' ,0DH
DW      370 
DB     'PORT1=255-A' ,0DH
DW      380 
DB     'NEXT A' ,0DH
DW      390 
DB     'GOTO 300' ,0DH
DB 80H
TEST_LEN EQU  479 
