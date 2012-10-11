PUSH_TOS:
;	Verify that the AES is not full,
;	push registers TOS_H and TOS_L onto AES,
;	and update AESP.
;
        PAGE    #0H             ;ZERO PAGE for AES
	MOV	R1,AESP
        CJNE    R1,#0FDH,$+3    ;Compare pointer with max. legal level.
	JNC	STK_ER
	INC	R1
	MOV	A,TOS_L		;Push low-order byte.
        MOVX    @R1,A
	INC	R1
	MOV	A,TOS_H		;Push high-order byte.
        MOVX    @R1,A
	MOV	AESP,R1
	RET
;
STK_ER:	CALL	AES_ER
	DB	0FH
;