BREAK_START:
        call   tst                      ;Check if 'BREAK' command
        db      'BREA',('K' OR 80H)
        jnc     BREAK_END               ;If not check next command
        CALL    DONE                    ;Clear pointer
        JMP     0000H                   ;Reset CPU
BREAK_END: