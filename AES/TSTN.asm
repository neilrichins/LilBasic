;TSTN	(LBL)
;	Test if indicated string is an unsigned number.
;	If so, move cursor over string and trailing blanks,
;	compute number's binary value,
;	push onto arithmetic expression stack, and continue with
;	following IL instruction.
;	Otherwise restore cursor and branch to IL instruction at LBL.
;
;
TSTN:	CALL	READ_CHAR
	CALL	CREATE		;Create entry on AES if legit. digit.
	JC	TSTN_1		;Abort if CHAR is not decimal digit.
	SETB	CHAR_FLG
	RET
;
TSTN_1:	CALL	READ_CHAR	;Move over matched character.
	CALL	APPEND		;Append new digit to entry on TOS.
	JC	TSTN_1		;Continue processing while legal characters.
	CALL	PUSH_TOS
	SETB	CHAR_FLG
	JMP	D_BLNK		;Remove leading blank characters.
;