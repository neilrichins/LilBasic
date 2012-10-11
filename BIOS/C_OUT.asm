NLINE:
;	Transmit <CR><LF> sequence to console device.
;
	MOV	A,#CR
C_OUT:
;	Console character output routine.
;	Outputs character received in accumulator to console output device.
;
DD006:  JNB     TI,$            ;Wait until transmission completed.
DD007:  CLR     TI              ;Clear interrupt flag.
	MOV	SBUF,A		;Write out character.
	CJNE	A,#CR,COUT_2
DD008:  JNB     TI,$
DD009:  CLR     TI
	MOV	SBUF,#LF	;Output linefeed.
	SJMP	COUT_3
;
COUT_2:	CLR	C
	DJNZ	TABCNT,COUT_1	;Monitor output field position.
COUT_3:	MOV	TABCNT,#TABSIZ	;Reload field counter.
	SETB	C
COUT_1:	RET
