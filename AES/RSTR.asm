RSTR:
;	If AES is empty report a nesting error.
;	Otherwise, pop AES into current BASIC souce program line number.
;
	CALL	FNDLBL
	CALL	SKPLIN		;Pass over statement initiating transfer.
	JMP	STMT
;