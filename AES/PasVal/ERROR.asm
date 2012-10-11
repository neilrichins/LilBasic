
TST_ERROR:
        call tst                ; Test it 'ERROR' token
        db      'ERRO',('R' OR 80H )
        JNC     TST_ERROR_END
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(ERROR)      ;Push low byte of ADDR onto Stack
        LIT_    HIGH(ERROR)     ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.
                                ;and continue
TST_ERROR_END:
