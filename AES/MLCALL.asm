;MLCALL
;	Call the ML subroutine starting at the address on top of AES.
;
;
MLCALL: PAGE    #0H             ;ZERO PAGE for AES
        MOV     R1,AESP
        XCH     A,B
        MOVX     A,@R1
        XCH     A,B
	DEC	R1
        MOVX     A,@R1
	DEC	R1
	MOV	AESP,R1
	PUSH	ACC
	PUSH	B
	ORL	PSW,#00011000B	;Select RB3.
        PAGE    #0FFH            ;Move to  User Page!
	RET			;Branch to user routine.
;