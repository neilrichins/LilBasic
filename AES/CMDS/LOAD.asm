LOAD_START:

        call tst                        ; Check to see if 'FILE' command
        DB      'LOA',('D'or 80H)
        JNC     LOAD_END                ; If not, try next command
        DEC     PNTR_L                  ; Back up pointer to start of FN
        CJNE    PNTR_L,#0FFH,LOAD_CARY
        DEC     PNTR_H
LOAD_CARY:
        SETB    CHAR_FLG                ; Reset read Char flag
        MOV     A,#'P'                  ; Set filetype to Program
        CALL    FIND_FILE               ; Find file in memory
        JC      LOAD_BADFN              ; Exit if filename invalid!

        MOV     TMP1,#LOW(EXTRAM)       ; Setup To ADDR
        MOV     TMP2,#HIGH(EXTRAM)      ;
        MOV     TMP3,DPL                ; Setup From Addr
        MOV     TMP4,DPH

        SETB    RAMROM                  ; Move from ROM to XRAM
        Call    MOVE_P                  ; Move program in memory

 LOAD_EXIT:
        CLR     AUTO                  ; Set Program Mode TO RAM, no autorun
        JMP     START



LOAD_BADFN:
        CALL    STROUT                   ; Send String Below
        DB      CR,'File not found',CR,80H

        JMP     EXP_ER


LOAD_END: