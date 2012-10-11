;
;HEXOUT:
;       Output Hexdecimal value in ACC
;USES   TMP0

HEXOUT:
        MOV TMP0,A              ;Save ACC
        CLR     ZERSUP
        CALL    NIBOUT          ;Send 1st nib
        MOV A,TMP0
        SWAP A                  ;Xchange HI & LOW nibbs in A
        CLR     ZERSUP
        CALL    NIBOUT          ;Send 2nt nib
        MOV A,TMP0              ;Restore A
        RET

