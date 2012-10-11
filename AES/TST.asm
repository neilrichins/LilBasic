TST:
;	If "TEMPLATE" matches the BASIC character string read by
;	READ_CHAR then move pointer over string and any trailing blanks
;	and continue with the following IL instruction.
;	Otherwise leave pointer unchanged and branch to IL instruction at LBL.
;
	POP	DPH		;Get in-line parameter base address from stack.
	POP	DPL
        CALL    READ_CHAR       ;Get Next Char to be parsed

        MOV     A,CHAR
        CALL    UPPER           ;Convert to uppercase
        MOV     CHAR,A

        CALL    SAVE_PNTR
TST_1:  CLR     A
	MOVC	A,@A+DPTR	;Read next character from template string.
	MOV	C,ACC.7		;Save terminator bit.
	ANL	A,#7FH		;Mask off terminator.
	XRL	A,CHAR		;Compare with template.
	JNZ	T_BAD		;Abort if first characters miscompare.
	INC	DPTR		;Pass over template character just checked.
	JC	T_GOOD		;Done if template character bit 7 set.
	CALL	READ_CHAR	;Fetch next character for test.

        MOV     A,CHAR
        CALL    UPPER           ;Convert to uppercase
        MOV     CHAR,A

        SJMP    TST_1           ;Continue
;        CJNE    CHAR,#'.',TST_1 ;Done if input string abbreviated at this point
;TST_2:  CLR     A               ;Fetch template characters until end of string
;        MOVC    A,@A+DPTR
;        INC     DPTR
;        JNB     ACC.7,TST_2     ;Loop until last character detected.
T_GOOD:	CALL	D_BLNK
	CLR	A
	JMP	@A+DPTR		;Return to next IL instruction
;
;	Strings do not match.  Leave cursor at start of string.
;
T_BAD:	CLR	A
	MOVC	A,@A+DPTR	;Search for final template character.
	INC	DPTR
	JNB	ACC.7,T_BAD	;Loop until terminator found.
	CALL	LOAD_PNTR
	SETB	CHAR_FLG
	CLR	C		;Mark string not found.
	CLR	A
	JMP	@A+DPTR		;Return to mismatch branch instruction.
;