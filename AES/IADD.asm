IADD:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS + VAR
;
	CALL	POP_TOS
	CALL	ADD_16
	JMP	OV_TST

ADD_16: PAGE    #0H             ;ZERO PAGE for AES
        MOVX    A,@R1           ;Add low-order bytes.
	ADD	A,TOS_L
        MOVX    @R1,A           ;Save sum.
	INC	R1
        MOVX    A,@R1           ;Add high-order bytes.
	ADDC	A,TOS_H
        MOVX    @R1,A           ;Save sum.
	RET