VER_ST:
        call tst                        ;Check to see if 'VER' command
        DB      'VE',('R'or 80H)
        JNC     VER_END                 ;If not, try next command
        CALL    VER_MSG                 ;Send Version
        CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command

VER_MSG:
        CALL    STROUT
        DB      ESC,'[2J',80H    ;CLS
	CALL	STROUT
        DB      '  Lil''Basic ver ',('0'+VERS/10H),'.',('0'+(VERS AND 0FH)),(CR OR 80H)
        CALL    STROUT
        DB      '(c)13/JAN/2002    -NQR',CR,(CR OR 80H)
        CALL    STROUT
        DB      'Type HELP for more information.',CR,(CR OR 80H)
        RET

VER_END:
