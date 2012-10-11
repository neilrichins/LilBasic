INSR_L:
;	Insert program line label (still held in <TOS_H><TOS_L> from earlier
;	call to FNDLBL)
;	and character string in line buffer (pointed at by L_CURS)
;	into program buffer gap created by OPEN_L routine
;	(still pointed at by CURSOR).
;
	MOV	DEST_L,CURS_L
	MOV	DEST_H,CURS_H
	MOV	A,TOS_H
	CALL	WRITE_CHAR
	MOV	A,TOS_L
	CALL	WRITE_CHAR
	MOV	PNTR_L,L_CURS
        PAGE    #0H             ;ZERO PAGE for AES
INSL_1: MOVX     A,@PNTR_L
	CALL	WRITE_CHAR
	INC	PNTR_L
	CJNE	A,#CR,INSL_1
	RET
;