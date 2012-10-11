GO_ST:
        CALL    TST                     ;See if 'GO' command
        DB      'G',('O' OR 80H)
        JNC     GO_END                  ;If not Try next command
GOSUB_ST:
        call   tst                      ;Test For 'GO SUB' Command
        db      'SU',('B' OR 80H)
        jnc     GOTO_ST                 ;If Not 'GO SUB' Then try 'GO TO'
        CALL    SAV                     ;Push return addr onto AES stack
        JMP     GO_COMMON
GOTO_ST:
        call   tst                      ;Test for 'GO TO' command
        db      'T',('O' OR 80H)
        jnc     GO_ERR                  ;If Not Must be a syntax Error

GO_COMMON:
        ICALL_  EXPR                    ;Load expression into AES
        CALL    LNDONE                  ;Move Command Pointer to end of line

        JMP     XFER                    ;Pop the value from the top of the arithmetic expression stack (AES).
                                        ;Position cursor at beginning of the BASIC source program line
                                        ;with that label and begin source interpretation.
                                        ;(Report error if corresponding source line not found.)
GO_ERR:
        JMP     SYN_ER



GO_END:


;