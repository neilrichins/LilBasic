LISTSTART:
        call   tst
        db      'LIS',('T' OR 80H)              ;Check to see if 'LIST' Commans
        jnc     LISTEND                         ;If not, then check next command
        IFDONE_ FULLLIST                        ;If nothing after 'LIST' command then list whole program
        ICALL_  EXPR                            ;Else get line no.
        CALL    FNDLBL                          ;Find line in code
        CALL    LST_1                           ;Display it
        IJMP_   CONT                            ;exit
;
FULLLIST:
        CALL    LST                             ;Gosub list whole program
        IJMP_   CONT                            ;exit
LISTEND: