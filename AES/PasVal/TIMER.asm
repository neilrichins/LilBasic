
TST_TIMER:
        call tst                ; Test it 'TIMER' token
        db      'TIME',('R' OR 80H )
        JNC     TST_TIMER_END
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(TIMER1)     ;Push low byte of ADDR onto Stack
        LIT_    HIGH(TIMER1)    ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.
                                ;and continue
TST_TIMER_END: