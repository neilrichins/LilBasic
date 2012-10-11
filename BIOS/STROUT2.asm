;STROUT2
;       Copy character string to console output device.
;       Start @ DPTR
;       Stop at char  00H
;       255 char limit on length of text!
;
STROUT2:
        CLR     A
        MOVC    A,@A+DPTR       ;Read next byte.
        CALL    C_OUT           ;Output character.
        INC     DPTR            ;Get next char.
        CJNE    a,#00H,STROUT2
        RET                     ;Return To Program