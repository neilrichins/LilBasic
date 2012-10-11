POP_ACC:
;	Pop TOS into accumulator and update AESP.
;
        PAGE    #0H             ;ZERO PAGE for AES
	MOV	R1,AESP
        MOVX    A,@R1
	DEC	AESP
	RET
;