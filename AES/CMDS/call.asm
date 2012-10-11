CALL_START:
        call   tst
        db      'CAL',('L' OR 80H)      ;Check if 'CALL' command
        jnc     CALL_END                ;If not try next command
        ICALL_  EXPR                    ;Else push Expresson on AES
        CALL    LNDONE                  ;move pointer to end of stmt
        MLCALL_                         ;Gosub Machine Lang. Subrutine.
        JMP     NXT                     ;Execute next command
CALL_END: