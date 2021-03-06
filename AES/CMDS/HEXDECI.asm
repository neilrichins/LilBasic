HEXDECIMAL:
         call   tst                     ;Check if 'HEX' command
        db      'HE',('X' OR 80H)
        jnc     DECIMAL                 ;If not, goto DECIMAL
        CALL    DONE                    ;Else ignore rest of line
        SETB    HEXMOD                  ;Set Output mode to HEX
        JMP     NXT                     ;continue with next line

DECIMAL:
        call   tst                      ;Check if 'DEC' command
        db      'DE',('C' OR 80H)
        jnc     HEXDEC_END              ;If not, try next command
        CALL    DONE                    ;Else ignore rest of line
        CLR     HEXMOD                  ;Set Output to Decimal
        JMP     NXT                     ;Continue execution with next command
HEXDEC_END: