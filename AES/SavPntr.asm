SAVE_PNTR:
;	Save PNTR variables in cursor.
;
	MOV	CURS_L,PNTR_L
	MOV	CURS_H,PNTR_H
	MOV	C_SAVE,CHAR
	RET
;