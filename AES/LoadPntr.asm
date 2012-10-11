LOAD_PNTR:
;	Reload pointer with value saved earlier by SAVE_PNTR.
;
	MOV	PNTR_H,CURS_H
	MOV	PNTR_L,CURS_L
	MOV	CHAR,C_SAVE
	RET
;