;
;NIBOUT
;	If low-order nibble in Acc. is non-zero or ZERSUP flag is cleared,
;	output the corresponding ASCII value and clear ZERSUP flag.
;	Otherwise return without affecting output or ZERSUP.
;
NIBOUT:	ANL	A,#0FH		;Mask out low-order bits.
	JNZ	NIBO_2		;Output ASCII code for Acc contents.
	JB	ZERSUP,NIBO_3
NIBO_2:	CLR	ZERSUP		;Mark that non-zero character encountered.
	ADD	A,#(ASCTBL-(NIBO_1+1))	;Offset to start of table.
NIBO_1:	MOVC	A,@A+PC		;Look up corresponding code.
	CALL	C_OUT		;Output character.
NIBO_3:	RET
;
ASCTBL:	DB	'0123456789ABCDEF'
;