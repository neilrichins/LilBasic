TST_RBIT:
        call   tst                ;Test for RBIT
        db      'RBI',('T' OR 80H)
        jnc     TST_RBIT_END
        LIT_    2                 ; PUSH a 2 onto AES STACK
	SJMP	INDEX
TST_RBIT_END: