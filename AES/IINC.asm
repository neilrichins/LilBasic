IINC:
;	TOS <= TOS+1
;
        PAGE    #0H             ;ZERO PAGE for AES
	MOV	R1,AESP		;Compute variable address.
	DEC	R1		;Index for low-order byte of VAR_1.
        MOVX    A,@R1           ;Get low byte
        INC     A               ;Add 1
        MOVX    @R1,A           ;Store
        CJNE    A,#00,IINC_1    ;If not rollover FF -> 00 then Exit
	INC	R1		;Bump pointer.
        MOVX    A,@R1           ;Get high byte
        INC     A               ;Add 1
        MOVX    @R1,A           ;Store
IINC_1:	RET
;