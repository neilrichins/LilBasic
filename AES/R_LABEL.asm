READ_LABEL:
;	Read next two characters from program buffer into <LABL_H><LABL_L>.
;	Return with carry set if bit 15 of LABL is set (indicating EOF).
;
	CALL	READ_CHAR
	MOV	LABL_H,A
	CALL	READ_CHAR
	MOV	LABL_L,A
	MOV	A,LABL_H
	MOV	C,ACC.7
	RET
;