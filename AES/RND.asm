RND:
;	Generate a new 16-bit random number from RND_KEY,
;	and push onto the AES.
        MOV     TOS_L,SEED_L            ;Get seed
	MOV	TOS_H,SEED_H
	CALL	PUSH_TOS

        MOV     TOS_L,#LOW(25173)       ;Multiply by 25173
        MOV     TOS_H,#HIGH(25173)
	CALL	MUL_16

        MOV     TOS_L,#LOW(13849)       ;Add 13894
        MOV     TOS_H,#HIGH(13849)
        MOV     R1,AESP
        DEC     R1
	CALL	ADD_16

	CALL	POP_TOS
;
;???
; The code from here to label no_problem to cure a extraneous overflow if seed=8000h.
;???
;
	cjne	tos_l,#0,no_problem
	cjne	tos_h,#80h,no_problem
big_problem:				   ; tos=8000h will generate an overflow
	mov	tos_l,#low(12586)          ; when control gets to iabs.
	mov	tos_h,#high(12586)         ; Load the precalculated seed.
no_problem:
	MOV	SEED_L,TOS_L
	MOV	SEED_H,TOS_H
	CALL	PUSH_TOS
	RET
;
