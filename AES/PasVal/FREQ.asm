
TST_FREQ:
        call tst                ; Test it 'FREQ' token
        db      'FRE',('Q' OR 80H )
        JNC     TST_FREQ_END
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(TH0)        ;Push low byte of ADDR onto Stack
        LIT_    HIGH(TH0)       ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.
                                ;and continue
TST_FREQ_END: