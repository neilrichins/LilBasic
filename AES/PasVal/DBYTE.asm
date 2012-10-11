tst_dbyte:
        call   tst                ;Test if 'DBYTE' token.
        db      'DBYT',('E' OR 80H)
        jnc     tst_dbyte_end
        LIT_    1                 ; Push a 1 onto AES STACK
	SJMP	INDEX
tst_dbyte_end: