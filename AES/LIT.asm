;LIT:    (K)
;	Report error if arithmetic expression stack is full.
;	Otherwise push the one-byte constant K onto AES.
;	Return with carry=1, since LIT marks a successful match.
;
LIT:    PAGE    #0H             ;ZERO PAGE for AES

        POP     DPH             ;Get parameter address.
	POP	DPL

        CLR     A
	MOVC	A,@A+DPTR	;Read literal value.
	INC	AESP		;Reserve storage on top of AES.
	MOV	R1,AESP		;Point to free entry on stack.
        CJNE    R1,#0FFH,LIT_1
	JMP	AES_ER
;
LIT_1:  MOVX    @R1,A           ;Store literal.
	MOV	A,#1		;Branch over constant on return.
	SETB	C
	JMP	@A+DPTR		;Return to IL program.
;