
IMOD:	SETB	MOD_FLG		;Indicate modulo entry point.
	SJMP	IDIV_0
;
;=======
;
;
IDIV:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS / VAR
;	If divide-by-zero attempted report error.
;
	CLR	MOD_FLG		;Indicate division entry point.
IDIV_0:	SETB	SGN_FLG		;Initialize sign monitor flag.
	CALL	IABS
	CALL	NEG
	CALL	POP_TOS
	mov	a,tos_l
	ORL	A,TOS_H
	JZ	DIV_NG
	MOV	C,SGN_FLG
	ANL	C,/MOD_FLG	;Clear SGN_FLG if MOD funtion being done.
	MOV	SGN_FLG,C
	CALL	IABS
	MOV	TMP1,A
	DEC	R1
        PAGE    #0H             ;ZERO PAGE for AES
        MOVX     A,@R1
	MOV	TMP0,A
	CLR	A
	MOV	TMP3,A
	MOV	TMP2,A
	MOV	LP_CNT,#17
	CLR	C
	SJMP	DIV_RP
;
DIV_LP:	MOV	A,TMP2
	RLC	A
	MOV	TMP2,A
	XCH	A,TMP3
	RLC	A
	XCH	A,TMP3
	ADD	A,TOS_L
	MOV	TMP4,A
	MOV	A,TMP3
	ADDC	A,TOS_H
	JNC	DIV_RP
	MOV	TMP2,TMP4
	MOV	TMP3,A
DIV_RP: MOV     A,TMP0
	RLC	A
	MOV	TMP0,A
	MOV	A,TMP1
	RLC	A
	MOV	TMP1,A
	DJNZ	LP_CNT,DIV_LP
	JB	MOD_FLG,DIV_1
        MOV     TMP5,A                  ;SAVE A
        MOV     A,TMP0                  ;Mov TMP0 X data
        MOVX     @R1,A
        INC     R1
        MOV     A,TMP1                  ;Mov TMP1 X data
        MOVX     @R1,A
        MOV     A,TMP5                  ;Restore A
	SJMP	DIV_2
;
DIV_1:  MOV     TMP5,A                  ;Save A
        MOV     A,TMP2                  ;Store TMP2 in X data
        MOVX     @R1,A
	INC	R1
        MOV     A,TMP3
        MOVX     @R1,A
        MOV     A,TMP5
DIV_2:	CALL	NEG_IF_NEG
	RET
;
DIV_NG:	AJMP	EXP_OV		;Report expression overflow.
;