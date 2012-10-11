;TSTS	(LBL)
;	Test if first character is a quote.
;	If so, print characters from the BASIC source program to the console
;	until a (closing) quote is encountered,
;	pass over any trailing blanks,
;	leave source cursor pointing to first non-blank character,
;	and branch to IL instruction at location (LBL).
;	(Report syntax error if <CR> encountered before quote.)
;	If first character is not a quote, return to next
;	sequential IL instruction with cursor unchanged.
;
TSTS:	CALL	READ_CHAR
	MOV	TMP0,A
	XRL	A,#'"'
	JZ	TSTS_1
	XRL	A,#'''' XOR '"'
	JZ	TSTS_1
	CLR	C
	SETB	CHAR_FLG
	RET
;
TSTS_1:	CALL	READ_CHAR	;Read next string character.
	CJNE	A,TMP0,TSTS_2
	JMP	D_BLNK
;
TSTS_2:	CALL	C_OUT		;Call output routine.
	CJNE	A,#CR,TSTS_1	;<CR> before closing quote is illegal.
	JMP	SYN_ER		;Transmit error message.
;