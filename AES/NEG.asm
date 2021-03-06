IABS:
;	If in decimal mode and TOS < 0
;	then complement SGN_FLG and negate TOS.
;
        PAGE    #0H             ;ZERO PAGE for AES
        MOV     R1,AESP
        MOVX    A,@R1
	MOV	C,ACC.7
	ANL	C,/HEXMOD
	JC	NEG
	RET
;
;=======
;
NEG_IF_NEG:
;	If SGN_FLG is set then negate TOS and complement SGN_FLG,
;	else return with TOS unchanged.
	JB	SGN_FLG,NEG
	RET
;

ICPL:
;	TOS <= /TOS  (ones complement)
	SETB	C
	SJMP	NEG_0
;

NEG:
;	TOS <= -TOS
;
	CLR	C
	CPL	SGN_FLG
NEG_0:
        PAGE    #0H             ;ZERO PAGE for AES
        MOV     R1,AESP         ;Compute variable address.
	DEC	R1		;Index for low-order byte of VAR_1.
        MOVX    A,@R1           ;Get low byte
        MOV     B,A             ;Save in B
        CLR     A               ;Subtract VAR_1 from 0000H.
        SUBB    A,B
        MOVX     @R1,A           ;Save difference.
	INC	R1		;Bump pointer.

        MOVX    A,@R1           ;Get High byte
        MOV     B,A             ;Save in B
        CLR     A               ;Subtract VAR_1 from 0000H.
        SUBB    A,B
        MOVX    @R1,A           ;Save difference.
        JMP     OV_TST
;