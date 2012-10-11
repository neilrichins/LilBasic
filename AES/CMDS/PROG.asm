FILE_START:

        call tst                        ;Check to see if 'FILE' command
        DB      'PRO',('G'or 80H)
        JNC     FILE_END                ;If not, try next command
;----
ROM_PROGRAM:                            ; ROM
        call tst                        ;Check to see if 'ROM' command
        DB     'DEM',('O'or 80H)
        JNC     TEST_PROGRAM
        CALL    DONE
        SETB    AUTO
        SETB    XAUTO
        JMP     NXT

;----
TEST_PROGRAM:
        call tst                        ;Check to see if 'TEST' command
        DB     'AUT',('O'or 80H)
        JNC     RAM_PROGRAM
        CALL    DONE                    ;clear pointer.
        SETB    AUTO                  ;Set PROGRAM MODE
        CLR     XAUTO
        JMP     NXT                     ;Execute next line of code (if any)

;----
RAM_PROGRAM:
        call tst                        ;Check to see if 'RAM' command
        DB     'RA',('M'or 80H)
        JNC    FILE_ERROR
        CALL    DONE                    ;clear pointers
        CLR     AUTO                    ;Set Program Mode to RAM, no auto run
        JMP     NXT                     ;Execute any further code if present.

;----
FILE_ERROR:
         JMP     EXP_ER
;----
FILE_END: