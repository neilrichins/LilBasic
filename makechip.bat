@echo off
cls
asm51 lilbasic
HEX2BIN lilbasic.hex lilbasic.bin I 0 ffff 0 >nul
echo .
echo .
copy lilbasic.bin \\nqr2\hex
echo .
echo .
find /N /I "****" lilbasic.lst 
echo .
echo .
