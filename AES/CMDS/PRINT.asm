PRINT_START:
        call   tst                      ;Test for 'PRINT' TOKEN
        db      'PRIN',('T' OR 80H)
        JC      PRINT_LOOP              ;if so, then goto print command

        call   tst                      ;Test for '?' TOKEN (PRINT)
        db      ('?' OR 80H)
        JC      PRINT_LOOP              ;if so, then goto print command
        HOP_    PRINT_EXIT               ;If not, try next Command.

PRINT_LOOP:                              ;Process PRINT Command

        IFDONE_  PRINT_END              ;If empty print statment, EXIT

        call   tst                      ;if PRINT starts with a ';' Skip over it
        db      (';' OR 80H)
        jc     PRINT_CHECK_SEMI

        call   tst
        db      (',' OR 80H)            ;If PRINT starts with a ','
        jc     PRINT_COMMA              ;Space out tab fields

        IFDONE_ PRINT_EXIT              ;If end of PRINT cmd, goto PRINT EXIT
        TSTS_   PRINT_LOOP              ;Output LITERAL string ("") if Exists and continue PRINT_LOOP
                                        ;Else
        ICALL_  EXPR                    ;Push Expression onto AES stack
        CALL    PRN                     ;Print It
        HOP_    PRINT_LOOP              ;Continue Print Loop
;-------------------------
PRINT_COMMA:
CALL    SPC                             ;output sapces, Continue with Print Command
                                        ;Check to see if last command in print Loop (same as ';')
PRINT_CHECK_SEMI:
        IFDONE_  PRINT_SEMI              ;If ';' or ',' is last character in print loop, then exit w/o NewLine
        HOP_    PRINT_LOOP              ;Else Continue Loop
;-------------------------
PRINT_END:
       JMP      NL_NXT                   ;Send NewLine and exit.

PRINT_SEMI:
       JMP      NXT                      ;Exit Without NewLine

PRINT_EXIT:                             ;Continue with checking next Command
;