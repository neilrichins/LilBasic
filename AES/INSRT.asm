INSRT:
;	Pop line number from top of arithmetic expression stack.
;	Search BASIC source program for corresponding line number.
;	If found, delete old line.
;	Otherwise position cursor before next sequential line number.
;	If line buffer is not empty then insert line number, contents of
;	line buffer, and line terminator.
;
	DEC	PNTR_L		;Since previous D_BLNK passed over first char.
        MOV     L_CURS,PNTR_L
        CALL    FNDLBL          ;Check to see if line # in Program
	JC	INSR_1
        CALL    KILL_L          ;Delete line if label found in buffer.
INSR_1:	MOV	R1,L_CURS
	DEC	R1
INSR_2:	INC	R1
        PAGE    #0H             ;ZERO PAGE for AES
        MOVX    A,@R1
	CJNE	A,#CR,INSR_2
	MOV	A,R1
	CLR	C
	SUBB	A,L_CURS
	MOV	STRLEN,A
	JZ	INSR_4
	CALL	OPEN_L
	CALL	INSR_L
INSR_4:	CLR	RUNMOD
	RET
;