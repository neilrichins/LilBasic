;DONE
;	Delete leading blanks from the BASIC source line.
;	Return with the cursor positioned over the first non-blank
;	character, which must be a colon or <CR> in the source line.
;	If any other characters are encountered report a syntax error.
;
;
;
DONE:	CALL	READ_CHAR
	CJNE	CHAR,#':',DONE_1	;Colon indicates resume interpretation.
	RET			;Return to IL.
;
LNDONE:	CALL	READ_CHAR
DONE_1:	CJNE	CHAR,#CR,DONE_2	;Any non-colon, non-CR characters are illegal.
	RET
;
DONE_2:	SETB	CHAR_FLG
	JMP	SYN_ER		;Process syntax error if so.
;