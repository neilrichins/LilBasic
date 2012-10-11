;STROUT
;	Copy in-line character string to console output device.
;       Maximum Lenght is 254 Chars + 2 for return addr !!!!
;
;
STROUT:	POP	DPH		;Access in-line string.
	POP	DPL
STRO_1:	CLR	A
	MOVC	A,@A+DPTR	;Read next byte.
        INC     DPTR            ;Bump pointer.
        JBC     ACC.7,STRO_2    ;Escape after last character.
	CALL	C_OUT		;Output character.
	SJMP	STRO_1		;Loop until done.
;
STRO_2: CALL    C_OUT           ;Output Last character.
	CLR	A
	JMP	@A+DPTR		;Return to program.
;