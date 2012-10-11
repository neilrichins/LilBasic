;TSTV	(LBL)
;
;
TSTV:
;	Test if first non-blank string is a legal variable symbol.
;	If so, move cursor over string and any trailing blanks,
;	compute variable index value,
;	push onto arithmetic expression stack,
;	and continue with following IL instruction.
;	Otherwise branch to IL instruction at LBL with cursor unaffected.
;
        CALL    READ_CHAR       ;Get next parsed char
        CALL    UPPER           ;Convert to upper case
	ADD	A,#-'A'		;Subtract offset for base variable.
	MOV	TOS_L,A		;Save index in case needed later.
	ADD	A,#-26
	JNC	ALPHAB		;First character is alphabetic if C=0.
	SETB	CHAR_FLG
	CLR	C
	RET
;
ALPHAB:	CALL	SAVE_PNTR	;In case variable name not found.
	CALL	READ_CHAR	;Verify that next character is not alphabetic.
        CALL    UPPER
	ADD	A,#-'A'		;Alphabetic characters now <= 25.
	ADD	A,#-26		;Non-alphabetics cause overflow.
	JNC	NOTVAR		;Alphabetic character means illegal var. name.
        JMP    TSTV_1          ;Jump to exit routine

;=====
NOTVAR: CALL    LOAD_PNTR       ;IF not an Inerger Varable.
	SETB	CHAR_FLG
                                ;Check to see if it is a reserved Variable name
$INCLUDE(AES\PASVAL\PORT.ASM)
$INCLUDE(AES\PASVAL\ERROR.ASM)
$INCLUDE(AES\PASVAL\TIMER.ASM)
$INCLUDE(AES\PASVAL\FREQ.ASM)
$INCLUDE(AES\PASVAL\MASK.ASM)
$INCLUDE(AES\PASVAL\PWM.ASM)
$INCLUDE(AES\PASVAL\DBYTE.ASM)
$INCLUDE(AES\PASVAL\RBIT.ASM)
$INCLUDE(AES\PASVAL\XBYTE.ASM)
$INCLUDE(AES\PASVAL\CBYTE.ASM)

NOTSYM: CLR     C               ;Indicate that condition tested wasn't true.
	RET
;==============================================================================
;
INDEX:  CALL    VAR               ;Get value of Next variable
        SETB    C                 ;Set to true
	RET
;==============================================================================
;
;
;	BASIC Variable name is legitimate (A-Z).
;
TSTV_1: LIT_    0               ;Push a 0 onto AES (Varable)
        MOV     TOS_H,#0        ;Clear High byte.
        CALL    PUSH_TOS        ;Push var. (A-Z) onto stack as 16 bit # 1-26
        SETB    CHAR_FLG        ;
	JMP	D_BLNK		;Remove leading blanks from source line.
                                ;and return
;