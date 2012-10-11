PUT_BUF:
;	Put the contents of the acc. into program buffer space
;	currently active at the address held in <DEST_H><DEST_L>.
;
        JB      AUTO,PUTROM           ;If Auto Run, read from ROM

        PUSH    DPH
        PUSH    DPL
        MOV     DPH,DEST_H
        MOV     DPL,DEST_L
        MOVX    @DPTR,A
        POP     DPL
        POP     DPH

	RET
;
PUTROM:	JMP	EXP_ER
;
;=======
;
WRITE_CHAR:
;	Converse of READ_CHAR.
;	Write contents of acc. into appropriate memory space (@DEST),
;	increment DEST, and return.
;
	CALL	PUT_BUF
	INC	DEST_L
	CJNE	DEST_L,#00H,WRCH_1
	INC	DEST_H
WRCH_1:	RET
;