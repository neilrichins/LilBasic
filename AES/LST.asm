;LST
;	List the contents of the program memory area.
;
;
LST:	SETB	RUNMOD
	CALL	REWIND		;Point to first char of external buffer.
LST_1:	CALL	CNTRL
	JC	LSTRET
	CALL	LSTLIN		;Print out current line if present.
	JNC	LST_1		;Repeat if successful.
LSTRET:	CLR	RUNMOD
	RET
;