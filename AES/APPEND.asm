;APPEND
;	Test ASCII code in Acc.
;	If it is a legal digit in the current radix,
;	modify <TOS_H><TOS_L> to include this digit and return with CY set.
;	Otherwise leave AES and CHAR unchanged and return with CY cleared.
;	Operating mode determined by HEXMOD flag (1=Hex).
;
APPEND:	JB	H_FLG,APND_2	;Nothing allowed after trailing 'H' received.
	ADD	A,#-'0'		;Correct for ASCII offset.
	CJNE	A,#10,$+3	;Verify whether legal digit.
	JC	APND_1		;Insert decimal digit as is.
	JNB	HEXMOD,APND_2	;If in decimal mode, character isn't legal.
	ADD	A,#'0'-'A'	;Acc now equals 0 if 'A' received.
	CJNE	A,#6,$+3
	JC	APND_4		;Process Hex digit.
;
;	Char was not hexidecimal digit, but if it was the first 'H', that's OK.
;
	CJNE	A,#'H'-'A',APND_2	;Compare original input with 'H'.
	SETB	H_FLG		;Mark that 'H' was detected but don't process.
	SETB	C
	RET
;
APND_4:	ADD	A,#10		;Value of lowest hex digit.
APND_1:	XCH	A,TOS_L		;Save nibble to be appended.
	MOV	B,#10		;(Assuming radix=decimal.)
	JNB	HEXMOD,XRAD_1	;Skip ahead if assumption correct.
	MOV	B,#16		;If mode is actually hex.
XRAD_1:	PUSH	B		;Save for re-use.
	MUL	AB		;Multiply by radix.
	ADD	A,TOS_L		;Append new digit.
	MOV	TOS_L,A		;Save low-order shifted value.
	CLR	A
	ADDC	A,B		;Incremented high-order product if carry.
	XCH	A,TOS_H
	POP	B
	MUL	AB
	ADD	A,TOS_H
	MOV	TOS_H,A
	ORL	C,ACC.7		;Detect if most significant bit set.
	MOV	A,B
	ADDC	A,#0FFH		;Simulate "ORL	C,NZ" instruction.
	ANL	C,/HEXMOD	;Overflow only relevent in decimal mode.
	JC	APN_ER		;Error if bit 7 overflow occurred.
	SETB	C		;CHAR processed as legal character.
	RET
;
APND_2:	CLR	C
	RET
;
;
APN_ER:	CALL	EXP_ER		;Indicate illegal entry.
	DB	2
;

;
OV_TST:
;	If OV is set and operation is BCD mode then call EXP_ER routine.
;
	MOV	C,OV
	ANL	C,/HEXMOD
	JC	EXP_OV
	RET
;
EXP_OV:	CALL	EXP_ER
	DB	6
;