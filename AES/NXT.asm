NL_NXT:
;	Output a <CR><LF> and continue with NXT routine.
;
	CALL	NLINE
;
NXT:
;	A colon or carriage return has been previously READ_CHARed.
;	If CHAR holds a colon,
;	continue interpretation of source line in current mode
;	from IL program instruction "TOKEN".
;	Otherwise CHAR is a <CR>, and line has been completed.
;	Resume execution from IL instruction "STMT".
;
	CJNE	CHAR,#':',NXT_1	;Skip ahead unless colon detected.
	CALL	D_BLNK
	JMP	TOKEN		;Continue with interpretation.
;
NXT_1:	JMP	STMT
;