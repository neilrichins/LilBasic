D_BLNK:
;	Remove leading blanks from BASIC source line, update cursor,
;	load first non-blank character into CHAR,
;	and leave pointer loaded with its address.
;	(This routine is jumped to by parsing routines when successful,
;	so set C before returning to original routines.)
;
	CALL	READ_CHAR
	XRL	A,#' '		;Verify that it is non-blank.
	JZ	D_BLNK		;Loop until non-blank leading character.
	SETB	CHAR_FLG
	SETB	C
	RET			;Return to scanning code.
;