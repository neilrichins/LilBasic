SAVE_START:
        call tst                        ; Check to see if 'SAVE' command
        DB      'SAV',('E'or 80H)
        JNC     SAVE_END                ; If not, try next command
        DEC     PNTR_L                  ; Back up pointer to start of FN
        CJNE    PNTR_L,#0FFH,SAVE_CARY
        DEC     PNTR_H
SAVE_CARY:
        SETB    CHAR_FLG                ; Reset read Char flag
        MOV     A,#'P'                  ; Set filetype to Program
        CALL    FIND_FILE               ; Find file in memory
        JNC     LOAD_BADFN              ; Exit if filename found!


        CALL    GET_XTOP                ; Set Datapointer to Top of Xram


        MOV     A,#'P'                  ; Set filetype to Program
        call SET_TAG                    ; Put header in memory


        MOV     TMP1,DPL                ; SET MOVE_P TO Addr
        MOV     TMP2,DPH

        MOV     TMP3,#LOW(EXTRAM)       ; SET MOVE_P FROM Addr
        MOV     TMP4,#HIGH(EXTRAM)      ;

        CLR     RAMROM                  ; Set flag to move from XRAM to XRAM
        CALL    MOVE_P                  ; Move PROGRAM in Memory

        CALL    SAVE_XTOP               ; Save new Top of Xram



 SAVE_EXIT:

        JMP     START



SAVE_BADFN:
        CALL    STROUT                   ;Send String Below
        DB      CR,'Delete old file first!',CR,80H

        JMP     EXP_ER
SAVE_END:
