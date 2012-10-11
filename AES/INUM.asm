INNUM:
;	Read a numeric character string from the console input device.
;	Convert to binary value and push onto arithmetic expression stack.
;	Report error if illegal characters read.
;
	CLR	SGN_FLG		;Assume number will be positive.
	CALL	STROUT
        DB      ':',(' ' OR 80H);Print input prompt.
INUM_0:	CALL	C_IN
	CALL	C_OUT		;Echo input
	CJNE	A,#' ',INUM_3
	SJMP	INUM_0
;
INUM_3:	CJNE	A,#'+',INUM_4
	SJMP	INUM_0
;
INUM_4:	CJNE	A,#'-',INUM_5
	CPL	SGN_FLG
	SJMP	INUM_0
;
INUM_5:	CALL	CREATE		;Create value on stack if legal decimal digit.
	JNC	INUM_2		;Abort if first character received not legal.
INUM_1:	CALL	C_IN		;Get additional characters.
	CALL	C_OUT		;Echo input.
	CJNE	A,#7FH,INUM_6	;Start over if delete char detected.
INUM_2:	CALL	STROUT
        DB      '#',(CR OR 80H)
	SJMP	INNUM
;
INUM_6:	CALL	APPEND		;Incorporate into stack entry.
	JC	INUM_1		;Loop while legal characters arrive.
	CALL	PUSH_TOS
	JMP	NEG_IF_NEG
;