
TST_PWM0:                       ; Test it 'PWM0' token
        call tst
        db      'PWM',('0' OR 80H )
        JNC     TST_PWM1
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(PWM0)    ;Push low byte of ADDR onto Stack
        LIT_    HIGH(PWM0)   ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.

TST_PWM1:                       ; Test it 'PWM0' token
        call tst
        db      'PWM',('1' OR 80H )
        JNC     TST_PWM2
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(PWM2)    ;Push low byte of ADDR onto Stack
        LIT_    HIGH(PWM2)   ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.

;

TST_PWM2:                       ; Test it 'PWM0' token
        call tst
        db      'PWM',('2' OR 80H )
        JNC     TST_PWM3
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(PWM2)    ;Push low byte of ADDR onto Stack
        LIT_    HIGH(PWM2)   ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.

TST_PWM3:                       ; Test it 'PWM0' token
        call tst
        db      'PWM',('3' OR 80H )
        JNC     TST_PWM4
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(PWM3)    ;Push low byte of ADDR onto Stack
        LIT_    HIGH(PWM3)   ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.

TST_PWM4:                       ; Test it 'PWM0' token
        call tst
        db      'PWM',('4' OR 80H )
        JNC     TST_PWM5
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(PWM4)    ;Push low byte of ADDR onto Stack
        LIT_    HIGH(PWM4)   ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.

TST_PWM5:                       ; Test it 'PWM0' token
        call tst
        db      'PWM',('5' OR 80H )
        JNC     TST_PWM6
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(PWM6)    ;Push low byte of ADDR onto Stack
        LIT_    HIGH(PWM6)   ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.

TST_PWM6:                       ; Test it 'PWM0' token
        call tst
        db      'PWM',('6' OR 80H )
        JNC     TST_PWM7
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(PWM6)    ;Push low byte of ADDR onto Stack
        LIT_    HIGH(PWM6)   ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.

TST_PWM7:                       ; Test it 'PWM0' token
        call tst
        db      'PWM',('7' OR 80H )
        JNC     TST_PWM_END
        LIT_    01H             ;Push a 1 for DBYTE addr onto stack
        LIT_    LOW(PWM7)    ;Push low byte of ADDR onto Stack
        LIT_    HIGH(PWM7)   ;Push high byte of ADDR onto Stack
	JMP	D_BLNK		;Remove leading blanks from source line.
TST_PWM_END: