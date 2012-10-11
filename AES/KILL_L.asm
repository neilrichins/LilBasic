KILL_L:
;	Kill (delete) line from code buffer indicated by pointer.
;	When called, CURSOR and POINTER hold the address of first LABEL byte of
;	line to be deleted.
;
	MOV	DEST_L,CURS_L
	MOV	DEST_H,CURS_H
	CALL	SKPLIN		;Pass pointer over full text line.
;
;	Pointer now indicates first label byte of following line.
;	Cursor and DEST still indicate first label byte of obsolete line.
;
KILL_2:	CALL	READ_CHAR	;Copy down first label byte.
	CALL	WRITE_CHAR	;Transfer first byte of label number.
	JB	ACC.7,KILL_9	;Quit when End of Code sentinel reached.
	CALL	READ_CHAR	;Copy down second label byte.
	CALL	WRITE_CHAR	;Store second byte of label number.
KILL_3:	CALL	READ_CHAR	;Transfer text character.
	CALL	WRITE_CHAR
	CJNE	A,#CR,KILL_3	;Loop until full line moved.
	SJMP	KILL_2		;Continue until all code moved forward.
;
KILL_9:	RET			;Full line now deleted.
;