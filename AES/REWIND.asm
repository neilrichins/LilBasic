;REWIND
;	Reset Cursor to start of current program buffer space.
;
REWIND:	CLR	CHAR_FLG
        JB      AUTO,REWROM             ;If auto executing from ROM, jump to REWROM
        MOV     PNTR_H,#HIGH(EXTRAM)
        MOV     PNTR_L,#LOW(EXTRAM)
	RET
;
REWROM: JB      XAUTO,RWXROM            ;If Auto executig form Shared eXternal memory jump to RWXROM
        MOV     PNTR_H,#HIGH(DEMOPROG)
        MOV     PNTR_L,#LOW(DEMOPROG)
	RET
;
RWXROM: MOV     DPTR,#XRAM      ;Set pointer to start of Xmem
REWIND_FIND_FILE:
        MOVX    A,@DPTR                 ;Search through mem till first 00H is found
        INC     DPTR
        JNZ     REWIND_FIND_FILE
        MOV     PNTR_H,DPH              ;Return with pointer to first program in Xmem
        MOV     PNTR_L,DPL

        RET                             ;
;
