END_START:
        call   tst                      ;Check to see if next token is 'END'
        db      'EN',('D' OR 80H)
        jnc     END_END                 ;If not try next command
        CALL    LNDONE                  ;Clear pointer to end of line
        JMP     FIN                     ;End Program
END_END:
