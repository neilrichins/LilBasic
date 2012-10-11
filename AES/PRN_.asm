PRN:
;	Pop top of arithmetic expression stack (AES),
;	convert to decimal number,
;	and print to console output device, suppressing leading zeroes.
;
	CLR	SGN_FLG
	CALL	IABS
	CALL	POP_TOS
PRNTOS:	SETB	ZERSUP		;Set zero suppression flag.
	CLR	A
	MOV	TMP0,A
	MOV	LP_CNT,#16	;Conversion precision.

        JB      HEXMOD,PRNHEX   ;If in hexmode, then jump to ...

        JNB     SGN_FLG,PRN_1   ;Skip ahead if positive number.
	CALL	STROUT		;Output minus sign if negative.
        DB      ('-' OR 80H)

PRN_1:  XCH     A,TOS_L
	RLC	A
	XCH	A,TOS_L
	XCH	A,TOS_H
	RLC	A
	XCH	A,TOS_H
	XCH	A,TMP0
	ADDC	A,ACC
	DA	A
	XCH	A,TMP0
	ADDC	A,ACC
	DA	A
	DJNZ	LP_CNT,PRN_1
	MOV	TOS_H,A
	MOV	A,TOS_L
	RLC	A
	MOV	TOS_L,TMP0

PRNHEX: CALL    NIBOUT
	MOV	A,TOS_H
	SWAP	A
	CALL	NIBOUT		;Print second digit.
	MOV	A,TOS_H
	CALL	NIBOUT		;Print third digit.
	JNB	HEXMOD,PRNH_1
	CLR	ZERSUP		;Print out last two chars. (at least) in hex.

PRNH_1: MOV     A,TOS_L         ;Read into Acc.
	SWAP	A		;Interchange nibbles.
	CALL	NIBOUT		;Print fourth digit.
	CLR	ZERSUP
	MOV	A,TOS_L		;Reload byte.
	CALL	NIBOUT		;Print last digit.
	JNB	HEXMOD,PRNRET
	CALL	STROUT		;Print trailing "H".
        DB      ('H' OR 80H)
PRNRET:	RET
;