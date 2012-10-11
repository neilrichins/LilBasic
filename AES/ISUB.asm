;ISUB
;	Pop VAR from AES (two bytes).
;	TOS <= TOS - VAR
;
;
ISUB:   PAGE    #0H             ;ZERO PAGE for AES
        ACALL   POP_TOS
	CLR	C		;Set up for subtraction with borrow.
        MOVX    A,@R1           ;Subtract low-order bytes.
	SUBB	A,TOS_L
        MOVX    @R1,A           ;Save difference.
	INC	R1		;Bump pointers.
        MOVX    A,@R1           ;Subtract high-order bytes.
	SUBB	A,TOS_H
        MOVX    @R1,A           ;Save difference.
	JMP	OV_TST
;