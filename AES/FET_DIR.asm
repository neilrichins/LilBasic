FETDIR:
;	Fetch on-chip directly addressed byte indicated by R1 into Acc.
;	and return.
;

	MOV	A,R1
	JB	ACC.7,FETSFR
        MOV    A,@R1
	RET
;
FETSFR:	CALL	SFR_ID
	MOV	DPTR,#INDTBL
	JMP	@A+DPTR
;