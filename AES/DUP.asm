DUP:
;	Verify that the AES is not full,
;	then duplicate the top element and update AESP.
;
        PAGE    #0H             ;ZERO PAGE for AES
	MOV	R1,AESP
        CJNE    R1,#0FDH,$+3    ;Compare pointer with max. legal level.
	JNC	STK_ER

        POP     DPL
        POP     DPH
        CLR     A
        MOVC    A,@A+DPTR       ;Read next character from in-line code.

        ADD     A,R1            ;Compute offset
        MOV     R1,A            ;save in register
        MOVX    A,@R1           ;copy byte
        MOV     R1,AESP         ;Get current Pos
        INC     R1              ;Bump pointer to next #.
        MOVX    @R1,A           ;Store Byte
        MOV     AESP,R1         ;Save stack pointer.
	RET
;