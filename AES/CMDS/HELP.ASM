HELP_START:


HELP_1:
        CALL    TST                        ;Check to see if 'HELP' command
        DB      'HEL',('P'or 80H)
        JNC     JMP2_HELP_END                ;If not help command, try next command

        CALL    TST                     ;Check to see if 'Help CMDS' command
        DB      'CMD',('S'or 80H)
        JNC     HELP_2                  ;If not, try next command
        MOV     DPTR,#HELPTEXTCMD       ;Set pointer to Help text commands
        CALL    STROUT2                 ;Output Help Text
        CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command

JMP2_HELP_END:                          ; Jump to end of help
        JMP HELP_END


HELP_2:
        call tst                        ;Check to see if 'HELP FUNC' command
        DB      'FUN',('C'or 80H)
        JNC     HELP_3                  ;If not, try next command
        MOV     DPTR,#HELPTEXTFUNC      ;Set pointer to Help text functions
        CALL    STROUT2                 ;Output Help Text
        CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command

HELP_3:
        call tst                        ;Check to see if 'HELP OPER' command
        DB      'OPE',('R'or 80H)
        JNC     HELP_4                  ;If not, try next command
        MOV     DPTR,#HELPTEXTOPER      ;Set pointer to Help text operators
        CALL    STROUT2                 ;Output Help Text
        CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command

HELP_4:
        call tst                        ;Check to see if 'VARS' command
        DB      'VA',('R'or 80H)
        JNC     HELP_0                  ;If not, try next command
        MOV     DPTR,#HELPTEXTVARS      ;Set pointer to Help text operators
        CALL    STROUT2                 ;Output Help Text
        CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command

HELP_5:
        call tst                        ;Check to see if 'ALL' command
        DB      'AL',('L'or 80H)
        JNC     HELP_0                  ;If not, try next command

        MOV     DPTR,#HELPTEXT         ;Set pointer to Help text part 1
        CALL    STROUT2                 ;Output Help Text

        MOV     DPTR,#HELPTEXTCMD       ;Set pointer to Help text commands
        CALL    STROUT2                 ;Output Help Text

        MOV     DPTR,#HELPTEXTFUNC      ;Set pointer to Help text functions
        CALL    STROUT2                 ;Output Help Text

        MOV     DPTR,#HELPTEXTOPER      ;Set pointer to Help text operators
        CALL    STROUT2                 ;Output Help Text

        MOV     DPTR,#HELPTEXTVARS      ;Set pointer to Help text operators
        CALL    STROUT2                 ;Output Help Text
        CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command



HELP_0:                                 ; Not 1, 2, or 3. So send help on help
        MOV     DPTR,#HELPTEXT         ;Set pointer to Help text part 1
        CALL    STROUT2                 ;Output Help Text
                CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command



HELP_END:
