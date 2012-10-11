GETLN:
;	Input a line from console input device and put in line buffer
;	in internal RAM.
;
	MOV	A,AESP
	ADD	A,#4
	MOV	TMP0,A
GETL_0:
        MOV     R0,TMP0         ;Point to beginning of line buffer.
	CALL	STROUT
        DB      '--',('>' OR 80H)  ;Display Prompt. -->
GETL_1:
        CALL    C_IN            ;Get next character from console.
        JZ      GETL_1          ;Skip over nul Chars                            Process Nul Char
        CJNE    A,#CTRL_R,GETL_5   ;Re-type line on <CNTRL-R>.                  Process CTYRL-R
	CALL	STROUT
        DB      (CR OR 80H)     ;Newline.
	MOV	CURS_L,R0	;Save old value of cursor.
	MOV	R0,TMP0		;Start at beginning of line buffer.
GETL_6:	MOV	A,R0		;Check if re-write done.
	XRL	A,CURS_L
	JZ	GETL_1		;Continue with line input.
        PAGE    #0H             ;ZERO PAGE for AES
        MOVX     A,@R0           ;Load character to re-write.
	CALL	C_OUT
	INC	R0
	SJMP	GETL_6		;Continue until done.
;
GETL_5: CJNE    A,#DEL,GETL_7   ;Cancel whole line on <DEL>.
	CALL	STROUT
        DB      '#',(CR OR 80H) ;Advance to next line.
	SJMP	GETL_0
;
GETL_7: CJNE    A,#BS,GETL_3                                                    ;Process Back space
	MOV	A,R0
	CJNE	A,TMP0,GETL_4	;Delete previous character (if any).
	CALL	STROUT
        DB      (BEL OR 80H)    ;Echo <BEL>.
	SJMP	GETL_1		;Ignore rubouts at beginning of line
;
GETL_4:	CALL	STROUT
        DB      BS,' ',(BS OR 80H)     ;BKSP,SPC,BKSP
	DEC	R0		;Wipeout last char.
	SJMP	GETL_1
;
GETL_3: CJNE    R0,#0FEH,GETL_2 ;Test if buffer full.
	CALL	STROUT		;Echo <BEL>.
        DB      (BEL OR 80H)
	SJMP	GETL_1		;If so, override character received.
;
GETL_2: PAGE    #0H             ;ZERO PAGE for AES
        MOVX     @R0,A           ;Store into line buffer.
	CALL	C_OUT		;Echo character.
	INC	R0		;Bump pointer.
	CJNE	A,#CR,GETL_1	;Repeat for next character.
	MOV	PNTR_L,TMP0	;Point cursor to beginning of line buffer.
	CLR	CHAR_FLG
	RET
;