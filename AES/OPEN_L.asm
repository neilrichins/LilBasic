OPEN_L:
;	Open space for new line in code buffer starting at Cursor.
;
	CALL	LOAD_PNTR	;Load address of point for insertion.
	CLR	CHAR_FLG
OPEN_3:	CALL	READ_CHAR	;Test first label byte of following line.
	JB	ACC.7,OPEN_4
	CALL	READ_CHAR	;Pass over next LABEL byte.
OPEN_5:	CALL	READ_CHAR
	CJNE	A,#CR,OPEN_5
	SJMP	OPEN_3
;
;	Pointer now indicates end-of-buffer sentinel.
;
OPEN_4:	MOV	A,STRLEN	;Number of bytes needed for BASIC text.
	ADD	A,#3		;Space needed for for label and <CR>.
	ADD	A,R0		;Low-order byte of old pointer.
	MOV	DEST_L,A
	CLR	A
	ADDC	A,PNTR_H
	MOV	DEST_H,A
        CJNE    A,#HIGH(RAMLIM),OPEN_1
	JMP	AES_ER
;
;	Transfer characters from source back to destination
;	until pointer at original CURSOR value.
;
OPEN_1:	CALL	GET_BUF		;Move back next character.
	CALL	PUT_BUF
	MOV	A,PNTR_L
	CJNE	A,CURS_L,OPEN_2
	MOV	A,PNTR_H
	CJNE	A,CURS_H,OPEN_2
;
;	All bytes have been moved back.
;
	RET
;
OPEN_2:
;	Decrement src. and dest. pointers and repeat.
;
	DEC	PNTR_L
	CJNE	PNTR_L,#0FFH,OPEN_6
	DEC	PNTR_H
OPEN_6:	DEC	DEST_L
	CJNE	DEST_L,#0FFH,OPEN_1
	DEC	DEST_H
	SJMP	OPEN_1		;Repeat for next character.
;