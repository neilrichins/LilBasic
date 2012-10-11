FNDLBL:
;	Search program buffer for line with label passed on AES (Pop AES).
;	If found, return with CURSOR pointing to start of line (before label)
;	and carry cleared.
;	If not found return with carry set and pointer at start of first
;	line with a greater label value (possible EOF).
;
	SETB	RUNMOD		;Kludge to make GET_C fetch from prog. buffer.
	CALL	REWIND
	CALL	POP_TOS
FND_1:	CALL	SAVE_PNTR	;Store position of beginning of line.
	CALL	READ_LABEL
	JC	FNDDON
	MOV	A,TOS_L
	SUBB	A,LABL_L
	MOV	LABL_L,A	;Save non-zero bits.
	MOV	A,TOS_H
	SUBB	A,LABL_H
	ORL	A,LABL_L	;Test for non-zero bits.
	JZ	FNDDON
	JC	FNDDON		;Carry=1 if a greater label value found.
	CALL	SKPTXT		;Skip over remaining text portion of line.
	SJMP	FND_1
;
FNDDON:	JMP	LOAD_PNTR
;