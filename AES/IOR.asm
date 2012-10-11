IOR:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS OR VAR
;
        PAGE    #0H             ;ZERO PAGE for AES
	CALL	POP_TOS
        MOVX    A,@R1           ;OR low-order bytes.
	ORL	A,TOS_L
        MOVX    @R1,A           ;Save result.
	INC	R1
        MOVX    A,@R1           ;OR high-order bytes.
	ORL	A,TOS_H
        MOVX    @R1,A           ;Save result.
	RET
;