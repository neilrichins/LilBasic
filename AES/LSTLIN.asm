LSTLIN:
;	Check Label of Program line pointed to by Cursor.
;	If legal, print line number, source line, and <CR><LF> to console,
;	adjust Cursor to start of next line,
;	and return with carry set.
;	Else return with carry cleared.
;
	CALL	READ_LABEL
	JC	LSTL_1
	MOV	TOS_H,LABL_H
	MOV	TOS_L,LABL_L
	CLR	SGN_FLG
	CALL	PRNTOS
	CALL	STROUT		;Insert space before user's source line.
        DB      (' ' OR 80H)
LSTL_2:	CALL	READ_CHAR
	CALL	C_OUT
	CJNE	A,#CR,LSTL_2
LSTL_1:	RET
;