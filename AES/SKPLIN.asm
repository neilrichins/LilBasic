;
;SKPLIN
;	Skip Cursor over entire BASIC source line, leaving
;	cursor pointing to character after terminating <CR>.
;SKPTXT
;	Skip remainder of line in progress, assuming line number
;	has already been passed over.
;	(Note that either byte of binary line number could be
;	mis-interpreted as a CR.)
;
;
SKPLIN:	CALL	READ_CHAR
	CALL	READ_CHAR
SKPTXT:	CALL	READ_CHAR
	CJNE	A,#CR,SKPTXT	;Verify that it is non-<CR>.
	RET			;Return to scanning code.
;