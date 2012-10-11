SAV:
;	Push BASIC line number of current source line onto AES.
;
	MOV	TOS_H,LABL_H
	MOV	TOS_L,LABL_L
	JMP	PUSH_TOS
;