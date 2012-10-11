GET_C:
;	Read character from logical buffer space into A and return.
;
        JB      RUNMOD,GET_BUF   ; If program running,  Get char from Program (Get_Buff)
        PAGE    #0H              ;Set page to 0 For AES
        MOVX    A,@PNTR_L        ;Read char from AES stack. Note: this read is in reverse direction from POP ACC
	RET
;
GET_BUF:
;	Read character from active program buffer space into A and return.
        JB      XAUTO,GETROM             ;Choose to read char from ROM/RAM space

        PUSH    DPL                     ;Save Data Pointer
        PUSH    DPH
        MOV     DPH,PNTR_H              ;Select Address
        MOV     DPL,PNTR_L
        MOVX    A,@DPTR                 ;Read from external address space.
        POP     DPH                     ;Restore Data pointer
        POP     DPL
	RET
;
GETROM:	MOV	A,PNTR_L
	XCH	A,DPL
	XCH	A,PNTR_H
	XCH	A,DPH
	MOV	PNTR_L,A
	CLR	A
	MOVC	A,@A+DPTR
	XCH	A,PNTR_L		;Save char. and load old DPH.
	XCH	A,DPH
	XCH	A,PNTR_H
	XCH	A,DPL
	XCH	A,PNTR_L		;Store DPL and reload byte read.
	RET
;
;=======
;
READ_CHAR:
;	READ_CHAR first tests the state of CHAR_FLG.
;	If it is still cleared, the character most recently read from the line
;	buffer or program buffer has been processed, so read the next
;	character, bump the buffer pointer, and return with the character
;	in both Acc. and CHAR and the CHAR_FLG cleared.
;	If CHAR_FLG has been set by the parsing routines,
;	then CHAR still holds a previously read character which has
;	not yet been processed.  Read this character into Acc. and return
;	with CHAR_FLG again cleared.
;
        JBC     CHAR_FLG,REREAD         ;If CHAR_FLG cleared, reread char and exit!
        CALL    GET_C                   ;Get Char
	MOV	CHAR,A
	INC	PNTR_L
	CJNE	PNTR_L,#00,RDCHDN
	INC	PNTR_H
RDCHDN:	RET
;
REREAD:	MOV	A,CHAR
	RET
;