;XINIT
;	Perform initialization needed before starting sequential execution.
;	Empty stacks, set BASIC line number to 1, etc.
;
;
XINIT:  MOV     AESP,#00H     ;Initialize AE Stack.
	CALL	REWIND
	SETB	RUNMOD
	RET			;Begin execution.
;