TST_CBYTE:
        call   tst
        db      'CBYT',('E' OR 80H)
        jnc     TST_CBYTE_END
        LIT_    4
TST_CBYTE_END: