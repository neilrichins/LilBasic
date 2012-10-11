                             ;WALK.BAS
                             ;--------
DW      10 
DB     'cls:?"Cricket By Neil Q. Richins":?"Written in Lil"Basic":?:?' ,0DH
DW      20 
DB     'freq=20:mask=255:b=30:d=0:pwm0=0:r=timer' ,0DH
DW      30 
DB     'a=0' ,0DH
DW      40 
DB     'a=a+1' ,0DH
DW      50 
DB     'if a>2 then goto 30' ,0DH
DW      60 
DB     'Rem check to see what foot to move' ,0DH
DW      70 
DB     'if a=1 then x=50' ,0DH
DW      90 
DB     'if a=2 then x=99' ,0DH
DW      110 
DB     'if a>4 then goto 30' ,0DH
DW      120 
DB     'gosub 1000' ,0DH
DW      130 
DB     'z=0' ,0DH
DW      140 
DB     'z=z+1' ,0DH
DW      150 
DB     'if z<b then goto 140' ,0DH
DW      160 
DB     'd=d+1:pwm0=0' ,0DH
DW      170 
DB     'if d<10 then goto 40' ,0DH
DW      180 
DB     'gosub 2000' ,0DH
DW      190 
DB     'goto 40' ,0DH
DW      1000 
DB     'Rem Take a step' ,0DH
DW      1010 
DB     'pwm6=x' ,0DH
DW      1020 
DB     'pwm4=x' ,0DH
DW      1030 
DB     'return' ,0DH
DW      2000 
DB     'Rem Change Direction' ,0DH
DW      2010 
DB     'd=0' ,0DH
DW      3020 
DB     'rem get random number' ,0DH
DW      3030 
DB     'R=(dbyte(R mod 101)+timer)mod 51' ,0DH
DW      2040 
DB     'pwm0=(R mod 8)+90' ,0DH
DW      2050 
DB     'return' ,0DH
DB 80H
WALK_LEN EQU  514 
