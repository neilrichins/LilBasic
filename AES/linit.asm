L_INIT:
;	Initialize for execution of new BASIC source line.
;	If none present, or if not in sequential execution mode,
;	then return to line collection operation.
;
	JNB	RUNMOD,LINI_1	;Determine operating mode.
	JMP	READ_LABEL
;
LINI_1:	SETB	C
	RET
;