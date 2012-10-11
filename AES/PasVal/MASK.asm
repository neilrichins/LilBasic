
TST_MASK:
        call tst                ; Test it 'MASK' token
        db      'MAS',('K' OR 80H )
        JNC     TST_MASK_END
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(PRT_MSK)    ;Push low byte of ADDR onto Stack
        LIT_    HIGH(PRT_MSK)   ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.
TST_MASK_END: