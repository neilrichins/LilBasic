POP_TOS:
;	Verify that stack holds at least on (16-bit) entry.
;	(Call AES_ER otherwise.)
;	Pop TOS into registers TOS_H and TOS_L,
;	update AESP,
;	and return with R1 pointing to low-order byte of previous NOS.
;	Do not affect accumulator contents.
;
        PAGE    #0H             ;ZERO PAGE for AES
        MOV     R1,AESP         ;Get current stack pos.
        CJNE    R1,#01H,$+3     ;Compare pointer with min. legal level.
        JC      STK_ER          ;If <1 goto error
        MOV     TOS_L,A         ;Save Tos
        MOVX    A,@R1           ;Get High Byte
	MOV	TOS_H,A
	DEC	R1
        MOVX    A,@R1           ;Get Low Byte
	XCH	A,TOS_L		;Store byte and reload ACC.
	DEC	R1
	MOV	AESP,R1
        DEC     R1              ; ?????? whaddup?
	RET
;