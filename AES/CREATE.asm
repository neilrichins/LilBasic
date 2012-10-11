;CREATE
;	Test the contents of Acc.
;	If CHAR holds the ASCII code for a legitimate decimal digit,
;	create a two-byte entry in <TOS_H><TOS_L> holding low-order ACC nibble
;	and return with CY set.
;	Otherwise, return with CY cleared.
;
CREATE:	ADD	A,#-'0'		;Correct for ASCII digit offset.
	CJNE	A,#10,$+3	;Compare to maximum legal digit.
	JNC	CREA_1		;Abort if first char is not decimal digit.
	MOV	TOS_L,A		;Save initial digit read.
	MOV	TOS_H,#0	;Clear high-order bits.
	CLR	H_FLG
CREA_1:	RET
;