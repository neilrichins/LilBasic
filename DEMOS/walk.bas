10 cls:?"Cricket By Neil Q. Richins":?"Written in Lil'Basic":?:?
20 freq=20:mask=255:b=30:d=0:pwm0=0:r=timer
30 a=0
40 a=a+1
50 if a>2 then goto 30
60 Rem check to see what foot to move
70 if a=1 then x=50
90 if a=2 then x=99
110 if a>4 then goto 30
120 gosub 1000
130 z=0
140 z=z+1
150 if z<b then goto 140
160 d=d+1:pwm0=0
170 if d<10 then goto 40
180 gosub 2000
190 goto 40
1000 Rem Take a step
1010 pwm6=x
1020 pwm4=x
1030 return
2000 Rem Change Direction
2010 d=0
3020 rem get random number
3030 R=(dbyte(R mod 101)+timer)mod 51
2040 pwm0=(R mod 8)+90
2050 return