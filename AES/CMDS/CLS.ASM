CLS_START:

        call tst                        ;Check to see if 'FILE' command
        DB      'CL',('S'or 80H)
        JNC     CLS_END                ;If not, try next command
        CALL    STROUT                 ;Send String Below
        DB      ESC,'[2J',80H          ;Ansi Escape code for Clear Screan
        CALL    DONE                   ;Get ready for next command
        JMP     NXT                    ;Execute next command
CLS_END: