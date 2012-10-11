SFR_ID:
;	Identify which SFR is indicated by the contents of R1.
;	Return with acc holding (Index of said register)*3.
;	Call error routine if register number not found.
;
	MOV	DPTR,#SFRTBL
	CLR	A
	MOV	LP_CNT,A
SFID_1:	MOV	A,LP_CNT
	MOVC	A,@A+DPTR
	XRL	A,R1
	JNZ	SFID_2
	MOV	A,LP_CNT
	RL	A
	ADD	A,LP_CNT
	RET
;
SFID_2:	INC	LP_CNT
	MOV	A,LP_CNT
	CJNE	A,#NO_SFR,SFID_1
ADR_ER:	JMP	EXP_ER
;