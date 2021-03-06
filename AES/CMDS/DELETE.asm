DEL_START:

        call tst                        ;Check to see if 'DEL' command
        DB      'DE',('L'or 80H)
        JNC     DEL_2                   ;If not, try next command
        JMP     DEL_CNT
DEL_2:
        call tst                        ;Check to see if 'DELETE' command
        DB      'DELET',('E'or 80H)
        JNC     DEL_END                   ;If not, try next command



DEL_CNT:                                ;Check to see if file in mem
        SETB    CHAR_FLG                ;Reset read Char flag
        MOV     A,#'P'                  ;Set filetype to Program
        CALL    FIND_FILE               ;Find file in memory
        JC      LOAD_BADFN              ;Exit if filename invalid!

        MOV     TMP1,#LOW(EXTRAM)       ;Move to addr Low
        MOV     TMP2,#HIGH(EXTRAM)      ;Move to addr High






        DEC     PNTR_L                  ;Back up pointer to start of FN
        CJNE    PNTR_L,#0FFH,SAVE_CARY
        DEC     PNTR_H
SAVE_CARY:
        SETB    CHAR_FLG                ;Reset read Char flag
        MOV     A,#'P'                  ;Set filetype to Program
        CALL    FIND_FILE               ;Find file in memory
        JNC      LOAD_BADFN             ;Exit if filename invalid!

        MOV     TMP1,#LOW(EXTRAM)       ;Move to addr Low
        MOV     TMP2,#HIGH(EXTRAM)      ;Move to addr High



LOAD_LOOP:
        CLR     A
        MOVC    A,@A+DPTR               ;Get Byte
        INC     DPTR                    ;Bump to next byte
        MOV     TMP3,DPL                ;Save From Addr
        MOV     TMP4,DPH

        MOV     DPL,TMP1                ;Get To Addr
        Mov     DPH,TMP2
        MOVX    @DPTR,A                 ;Store Byte
        INC     DPTR
        MOV     TMP1,DPL                ;Save To Addr
        MOV     TMP2,DPH

        MOV     DPL,TMP3                ;Restore from Addr
        MOV     DPH,TMP4
        CJNE    A,#80H,LOAD_LOOP        ;If not at end, move Next Byte
                                        ;Else we have moved the program
 LOAD_EXIT:
        CLR     ROMMOD                  ;Set Program Mode TO RAM
        JMP     START



LOAD_BADFN:
        CALL    STROUT                   ;Send String Below
        DB      CR,'File not found',CR,80H

        JMP     EXP_ER


SAVE_END: