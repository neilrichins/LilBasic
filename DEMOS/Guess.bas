10 cls
20 n=timer mod 100
25 c=0:?
30 ?"I'm thinking of a number from 1 to 100"
35 c=c+1:?
40 Input "What number do you think it is";a
50 if a>n then ?"Lower":goto 35
60 if a<n then ?"Higher":goto 35
70 ?"You guessed it !!!!!!!"
75 ?"in only "c" trys."
80 goto 20