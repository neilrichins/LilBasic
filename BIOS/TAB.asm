
SPC:
;	Transmit one or more space characters to console to move console
;	cursor to start of next field.
;
        MOV     A,#SPACE         ;Load ASCII code for space character.
	CALL	C_OUT
	JNC	SPC		;Repeat until at TAB boundary.
	RET
;