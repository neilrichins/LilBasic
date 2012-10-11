;IFDONE	(LBL)
;	If the first non-blank character is a colon or <CR> in the source line
;	then branch to the IL instruction specified by (LBL).
;	If any other characters are encountered
;	then continue with next IL instruction.
;
;
IFDONE:	CALL	READ_CHAR
	CJNE	CHAR,#':',IFDN_1	;Colon indicates resume interpretation.
	RET			;Return to IL.
;
IFDN_1:	CJNE	CHAR,#CR,IFDN_2	;Any non-colon, non-CR characters are illegal.
	RET
;
IFDN_2:	SETB	CHAR_FLG
	SETB	C
	RET
;