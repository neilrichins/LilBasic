TST_XBYTE:
        call   tst                ;Test for Xbyte
        db      'XBYT',('E' OR 80H)
        jnc     TST_XBYTE_END
        LIT_    3                 ; PUSH a 3 ONTO AES STACK
	SJMP	INDEX
TST_XBYTE_END: