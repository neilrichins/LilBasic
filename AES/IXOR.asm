IXOR:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS XOR VAR
;
        PAGE    #0H             ;ZERO PAGE for AES
	CALL	POP_TOS
        MOVX    A,@R1           ;XOR low-order bytes.
	XRL	A,TOS_L
        MOVX    @R1,A           ;Save result.
	INC	R1
        MOVX    A,@R1           ;XOR high-order bytes.
	XRL	A,TOS_H
        MOVX    @R1,A           ;Save result.
	RET
;