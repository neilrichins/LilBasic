STRDIR:
;	Store data byte in ACC into direct on-chip RAM address held in R1.
;
        MOV     TOS_L,A
	MOV	A,R1
	JB	ACC.7,STRSFR	;Direct addresses above 7FH are SFRs.
	MOV	A,TOS_L
        MOV     @R1,A           ;Store low-order byte in RAM.
	RET
;
STRSFR:	CALL	SFR_ID
	MOV	DPTR,#STRTBL
	JMP	@A+DPTR		;Jump into store sequence.