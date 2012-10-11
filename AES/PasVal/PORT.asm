PORT1:
        call tst                ; Test it 'PORT' token
        db      'POR',('T' OR 80H )
        JNC     PORT1_END
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    90H             ;Push low byte of ADDR onto Stack
        LIT_    00H             ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.
                                ;and continue
PORT1_END:
