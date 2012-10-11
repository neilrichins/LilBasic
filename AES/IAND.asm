IAND:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS AND VAR
;
        PAGE    #0H             ;ZERO PAGE for AES
        CALL    POP_TOS
        MOVX    A,@R1           ;AND low-order bytes.
	ANL	A,TOS_L
        MOVX    @R1,A           ;Save result.
	INC	R1
        MOVX    A,@R1           ;AND high-order bytes.
	ANL	A,TOS_H
        MOVX    @R1,A           ;Save result.
	RET
;