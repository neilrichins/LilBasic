

ERROUT:
;	Error handling routine common entry point.
;	(Could retype bad line, etc.)
;
        MOV     TOS_L,LABL_L
        MOV     TOS_H,LABL_H
        MOV     ELN_L,TOS_L             ;Save Line # of error for later use
        MOV     ELN_H,TOS_H
        CJNE    TOS_L,#0H,ERROR_PR      ;Jump to print routine if Error was from line #
        CJNE    TOS_H,#0H,ERROR_PR

ERROR_NP:
        JMP     ERRENT          ;Return to executive.


ERROR_PR:                       ;Print Basic line number of Error
        CALL    STROUT
        DB      'Error in line number ',(80H)
        MOV     AESP,#00H               ;Initialize AES pointer.
        CALL    PUSH_TOS        ;Push Error Line number on stack
        CALL PRN                ;Print it
        CALL    STROUT          ;Output error message.
        DB      '. ',(CR OR 80H)
        SJMP    ERROR_NP
;
;=======
;
;EXP_ER	Expression evaluation error.
EXP_ER:	CALL	STROUT		;Output error message.
        DB      'Not within my means.  ',07,(CR OR 80H)
        MOV     ERROR,#01
	JMP	ERROUT		;Return to executive.
;
;=======
;
;AES_ER	Arithmetic expression stack error handling routine.
AES_ER:	CALL	STROUT		;Output error message.
        DB      'Stack error. ',07,(CR OR 80H)
        MOV     ERROR,#02
	JMP	ERROUT		;Return to executive.
;
;
;=======
;
;SYN_ER	Syntax error handling routine.
SYN_ER:	CALL	STROUT		;Output error message.
        DB      CR,'Syntax error. ',07,(CR OR 80H)
        MOV     ERROR,#01
	JMP	ERROUT		;Process error.
;
;=======
;
;OV_ER overflow error handling routine.
OV_ER: CALL    STROUT          ;Output error message.
       DB      CR,'Overflow error. ',07,(CR OR 80H)
       MOV     ERROR,#04
       JMP    ERROUT          ;Process error.
;

;=======
