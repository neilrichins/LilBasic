MUL_16:
;	Multiply unsigned 16-bit quantity in <TOS_H><TOS_L> by entry
;	on top of stack, and return with product on stack.
;	If product exceeds 16-bits, set OV flag.
;

        MOV     TMP0,TOS_H      ;Save first Part of equasion
        MOV     TMP1,TOS_L
        CALL    POP_TOS         ;Get other Part of equasion

                                ;High-order byte of atleast one paramater must be 0.
        MOV     A,TMP0          ;Get High byte of first param
        JZ      IMUL_SWAP       ;If 0 then reverse params before multipling

        MOV     A,TOS_H         ;Get High byte of second param
        JZ      IMUL_MUL        ;if 0 then pocede with multiply
                                ;Error! Both values too large!

IMUL_ERR:                       ;Jump to overflow erroe handeler
        JMP     OV_ER

IMUL_SWAP:                      ;Swap paramaters so that TOS_H is ALLWAYS zero!
        MOV     A,TMP0          ;Swap high bytes
        MOV     TMP0,TOS_H
        MOV     TOS_H,A

        MOV     A,TMP1          ;Swap low bytes
        MOV     TMP1,TOS_L
        MOV     TOS_L,A

IMUL_MUL:                       ;16 bit multiply

        MOV     A,TMP1
        MOV     B,TOS_L
        MUL     AB              ;multiply low order bytes
        MOV     TMP2,B          ;Save High Byte
        MOV     TMP3,A          ;Save Low Byte

        MOV     A,TOS_L
        MOV     B,TMP0
        MUL     AB              ;Multiply high bytes.

        JBC    OV,IMUL_ERR      ;Overflow Error! Somthing in B!; answer will be 3 bytes wide !

        CLR     C               ;Clear carry flag
        ADDC    A,TMP2          ;Add high bytes
        JC      IMUL_ERR        ;Error! answer is 3 bytes wide !

        MOV     TOS_H,A         ;Get High byte of answer
        MOV     TOS_L,TMP3      ;Get Low byte of answer

        CAll    PUSH_TOS        ;Push answer into stack



	RET
;
;=======
;
;
IMUL:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS * VAR
;
	CLR	SGN_FLG		;Initialize sign monitor flag.
	CALL	IABS		;Take absolute value of TOS.
	CALL	POP_TOS		;Pop top entry.
	CALL	IABS		;Take absolute value of NOS.
	CALL	MUL_16
	CALL	OV_TST		;Check if OV relevent.
	CALL	NEG_IF_NEG
	RET
;