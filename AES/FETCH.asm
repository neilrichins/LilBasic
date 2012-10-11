SEQ_FETCH:
;       Same as FETCH, below, except that index is retained
;       rather than being popped.
        SETB    SEQ_FLG
        SJMP    FET_0
;
;
FETCH:
;	When FETCH is called, AES contains
;	(TOS:)	2 byte INDEX of source variable,
;		1 byte TYPE code for variable space.
;			(0=BASIC variable,
;			 1=DBYTE,
;			 2=RBIT,
;			 3=XBYTE,
;			 4=CBYTE.)
;	Read 8- or 16-bit variable from the appropriate variable
;	memory at location of (INDEX) and return on AES.
;
	CLR	SEQ_FLG
FET_0:	CALL	POP_TOS
	CALL	POP_ACC
	JNB	SEQ_FLG,FET_1	;Jump forward if simple store.
	INC	AESP
	INC	AESP
	INC	AESP
FET_1:	MOV	DPTR,#FETJTB
	MOVC	A,@A+DPTR
	JMP	@A+DPTR
;
FETJTB:	DB	FETVAR-FETJTB
	DB	FETDBY-FETJTB
	DB	FETRBI-FETJTB
	DB	FETXBY-FETJTB
	DB	FETCBY-FETJTB
;
;=======
;
;	All of the following routines are called with
;	TOS_L holding the low-order index of the desired variable,
;	and TOS_H holding the high-order index (if necessary).
;
FETVAR: MOV     A,TOS_L         ;Get Low Byte of var #
        CLR     C               ;Clear carry bit
        RLC     A               ;Multiply by 2 for 16bit vars.
        MOV     R1,A            ;Save in R1.

        MOV     A,TOS_H         ;Get High byte
        RLC     A               ;Multiply High byte.

        CLR     C               ;Clear carry bit again for 16bit add
        XCH     A,R1            ;Swap bytes to get high byte again

        ADDC    A,#LOW(VARRAM)  ;Add offset to low byte
        MOV     DPL,A           ;Save low byte address of pointer

        MOV     A,R1            ;Get high byte
        ADDC    A,#HIGH(VARRAM) ;Add offset
        MOV     DPH,A           ;Save high byte address of pointer

        MOVX    A,@DPTR         ;Load low-order byte of variable.
	MOV	TOS_L,A		;And store on AES.
        INC     DPTR            ;bump data pointer.
        MOVX    A,@DPTR         ;Transfer high-order byte of variable.
	MOV	TOS_H,A
	JMP	PUSH_TOS
;
FETERR:	JMP	ADR_ER
;
;===
;
FETDBY:	MOV	A,TOS_L
	MOV	R1,A
	CALL	FETDIR
	SJMP	FETBDN		;Byte fetch done.
;
;===
;
FETRBI:	CALL	SPLIT_DBA
	CALL	FETDIR
	ANL	A,B
	ADD	A,#0FFH
	CLR	A
	RLC	A
	SJMP	FETBDN
;
;===
;
FETXBY: MOV     DPH,TOS_H
        MOV     DPL,TOS_L
        MOVX    A,@DPTR
	SJMP	FETBDN
;
;===
;
FETCBY:	MOV	DPH,TOS_H
	MOV	DPL,TOS_L
	CLR	A
	MOVC	A,@A+DPTR
FETBDN:	MOV	TOS_H,#00H	;FETCH sequence for Bytes Done.
	MOV	TOS_L,A		;FETCH sequence for words done.
	JMP	PUSH_TOS
;