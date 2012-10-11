;
;
SEQ_STORE:
;       Same as STORE, below, except that index is retained
;       rather than being popped.
        SETB    SEQ_FLG
        SJMP    STOR_0


STORE:
;	When STORE is called, AES contains
;	(TOS:)	2 byte VALUE to be stored,
;		2 byte INDEX of destination variable,
;		1 byte TYPE code for variable space.
;			(0=BASIC variable,
;			 1=DBYTE,
;			 2=RBIT,
;			 3=XBYTE,
;			 4=CBYTE.)
;	Store (VAR_1) into appropriate variable memory at location of (INDEX).
;
	CLR	SEQ_FLG
STOR_0:	CALL	POP_TOS
	MOV	TMP0,TOS_L
	MOV	TMP1,TOS_H
	CALL	POP_TOS
	CALL	POP_ACC		;Load TYPE code.
	JNB	SEQ_FLG,STOR_1	;Jump forward if simple store.
	INC	AESP
	INC	AESP
	INC	AESP


STOR_1: MOV     DPTR,#STRJTB
	MOVC	A,@A+DPTR
        JMP     @A+DPTR
;
STRJTB:	DB	STRVAR-STRJTB
	DB	STRDBY-STRJTB
	DB	STRRBI-STRJTB
	DB	STRXBY-STRJTB
	DB	STRCBY-STRJTB
;
;=======
;
;	All of the following routines are called with
;	TOS_L holding the low-order address of the destination,
;	TOS_H holding the high-order address (if necessary),
;	and <TMP1><TMP0> holding the 8- or 16-bit data to be stored.
;
STRVAR: MOV     A,TOS_L         ;Get Low byte of Variable number 0 to 25
        CLR     C               ;Clear carry bit.
        RLC     A               ;Multiply by two for 2 byte wide variables.  (0 - 50)
        MOV     R1,A            ;Move A into R1
        MOV     A,TOS_H         ;Get High byte of Variable number.
        RLC     A               ;Multiply by 2 also

        CLR     C               ;Clear carry bit again before adding offset
        XCH     A,R1            ;Swap bytes to get low byte again

        ADDC    A,#LOW(VARRAM)  ;Add offset to variable table in ram
        MOV     DPL,A           ;Save low byte of data pointer

        MOV     A,R1            ;Get Highbyte
        ADDC    A,#HIGH(VARRAM) ;Add offset (with carry bit) to var. table
        MOV     DPH,A           ;Save High byte of data pointer


        MOV     A,TMP0          ;Get lowbyte of value

        MOVX    @DPTR,A         ;Store into variable array
        INC     DPTR            ;Bump pointer to next byte.
	MOV	A,TMP1		;Move high-order byte into variable array.
        MOVX    @DPTR,A
	RET
;
;===
;
STRDBY:	MOV	A,TOS_L		;Load acc. with low-order dest. addr.
	MOV	R1,A
	MOV	A,TMP0
	JMP	STRDIR
;
;===
;
STRRBI:	CALL	SPLIT_DBA
	CALL	FETDIR
	MOV	TOS_L,A
	MOV	A,TMP0
	JB	ACC.0,SETRBI
;
;	Clear RBIT.
;
	MOV	A,B
	CPL	A
	ANL	A,TOS_L
	JMP	STRDIR
;
SETRBI:	MOV	A,B
	ORL	A,TOS_L
	JMP	STRDIR
;
;===
;
STRXBY:
STRCBY: MOV     DPH,TOS_H
        MOV     DPL,TOS_L
        MOV     A,TMP0
        MOVX    @DPTR,A
	RET
;