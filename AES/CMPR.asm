CMPR:
;	When CMPR is called, AES contains:
;	(TOS:)	VAR_2 (two bytes),
;		C_CODE (one byte),
;		VAR_1 (two bytes).
;	Pop all 5 bytes from stack and test relation between VAR_1 and VAR_2.
;	    If C_CODE=010 then test whether (VAR_1) =  (VAR_2)
;	    If C_CODE=100 then test whether (VAR_1) <  (VAR_2)
;	    If C_CODE=110 then test whether (VAR_1) <= (VAR_2)
;	    If C_CODE=101 then test whether (VAR_1) <> (VAR_2)
;	    If C_CODE=001 then test whether (VAR_1) >  (VAR_2)
;	    If C_CODE=011 then test whether (VAR_1) >= (VAR_2)
;	If true then return 0001H on AES;
;	otherwise return 0000H.
;
	CALL	POP_TOS
	CALL	POP_ACC
        PAGE    #0H             ;ZERO PAGE for AES
        MOV     B,A
	MOV	R1,AESP
	DEC	R1
	CLR	C		;...in preparation for string subtract.
        MOVX     A,@R1           ;Compare low-order parameter bytes.
	SUBB	A,TOS_L
	INC	R1		;Bump pointer.

        MOV     TMP5,A          ;Save difference and exchange A with @R1
        MOVX    A,@R1
        XCH     A,TMP5
        MOVX    @R1,A
        XCH     A,TMP5

        JB      HEXMOD,CMPR_4
	XRL	A,#80H		;Offset variable by 80H for unsigned compare.
	XCH	A,TOS_H
	XRL	A,#80H
	XCH	A,TOS_H
CMPR_4:	SUBB	A,TOS_H


        ORL     A,TMP5           ;Add any non-zero high-order bits to acc.
	JNZ	CMPR_1		;Jump ahead VAR_1 <> VAR_2.
;
;	VAR_1 = VAR_2:
;
	MOV	C,B.1		;Load VAR_1 = VAR_2 test flag.
	SJMP	PUSH_C
;
CMPR_1:	JC	CMPR_2		;Jump ahead if VAR_1 < VAR_2.
;
;	VAR_1 > VAR_2:
;
	MOV	C,B.0		;Load VAR_1 > VAR_2 test flag.
	SJMP	PUSH_C
;
;	VAR_1 < VAR_2:
;
CMPR_2:	MOV	C,B.2		;Load VAR_1 < VAR_2 test flag.
PUSH_C:	CLR	A
        PAGE    #0H             ;ZERO PAGE for AES
        MOVX     @R1,A
	RLC	A
	DEC	R1
        MOVX    @R1,A
	RET
;