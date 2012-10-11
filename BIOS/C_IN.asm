C_IN:
;	Console character input routine.
;	Waits for next input from console device and returns with character
;	code in accumulator.
;
;
;
        JNB     RI,$            ;Wait until character received.
        MOV     A,SBUF          ;Read input character.
	CLR	RI		;Clear reception flag.
        ANL     A,#7FH          ;Mask off data bits.
        CJNE    A,#LF,C_IN_END  ;Proceee Linefeeds as Spaces
        MOV     A,#0
C_IN_END:
        RET                     ;Return to calling routine.
;