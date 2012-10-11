NEWSTART:
        call   tst                      ;Check to see if 'NEW' command
        db      'NE',('W' OR 80H)
        jnc     NEWEND                  ;If not, try next command
        CALL    DONE                    ;Clear pointer to end of line
        MOV     DPL,#LOW(EXTRAM)        ;Move DPTR to beginning of program
        MOV     DPH,#HIGH(EXTRAM)
        MOV     A,#0FFH                 ;Token for end of basic program
        MOVX    @DPTR,A                 ;Put END token at start of program

        IJMP_   START                   ;Start at beginning
NEWEND: