                             ;GUESS.BAS
                             ;---------
DW      10 
DB     'cls' ,0DH
DW      20 
DB     'n=timer mod 100' ,0DH
DW      25 
DB     'c=0:?' ,0DH
DW      30 
DB     '?"I"m thinking of a number from 1 to 100"' ,0DH
DW      35 
DB     'c=c+1:?' ,0DH
DW      40 
DB     'Input "What number do you think it is";a' ,0DH
DW      50 
DB     'if a>n then ?"Lower":goto 35' ,0DH
DW      60 
DB     'if a<n then ?"Higher":goto 35' ,0DH
DW      70 
DB     '?"You guessed it !!!!!!!"' ,0DH
DW      75 
DB     '?"in only "c" trys."' ,0DH
DW      80 
DB     'goto 20' ,0DH
DB 80H
GUESS_LEN EQU  254 
