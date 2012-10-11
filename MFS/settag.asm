;SET_TAG
; Store  in memory
;029H,0EEH,0F1H,0F2H,'P',NAME,00H
; NEEDS         DPTR    --> Start Address in RAM
;               A       --> FILE TYPE
;               PNTR_L  --> Poiner to filename
;               PNTR_H
;USES           TMP1,2

SET_TAG:

        MOV    TMP1,A           ; Save file type

        MOV     A,#029H         ; Store 029H,0EEH,0F1H,0F2H in Xmem
        MOVX    @DPTR,A
	MOVX    A,@DPTR		; Force end of write cycle on EEPROM
	CALL    WAIT5MS                 ;  Wait to complete
	CALL	WAIT5MS
	INC     DPTR

        MOV     A,#0EEH
        MOVX    @DPTR,A
	MOVX    A,@DPTR	     		; Force end of write cycle on EEPROM
	CALL    WAIT5MS                 ;  Wait to complete
	CALL	WAIT5MS
	INC     DPTR

        MOV     A,#0F1H
        MOVX    @DPTR,A
	MOVX    A,@DPTR	     		; Force end of write cycle on EEPROM
	CALL    WAIT5MS                 ;  Wait to complete
	CALL	WAIT5MS
	INC     DPTR

        MOV     A,#0F2H
        MOVX    @DPTR,A
	MOVX    A,@DPTR	     		; Force end of write cycle on EEPROM
	CALL    WAIT5MS                 ;  Wait to complete
	CALL	WAIT5MS
        INC     DPTR

        MOV     A,TMP1          ; Store File Type in Xmem
        MOVX    @DPTR,A
	MOVX    A,@DPTR	     		; Force end of write cycle on EEPROM
	CALL    WAIT5MS                 ;  Wait to complete
	CALL	WAIT5MS

        DEC     PNTR_L          ; Back up pointer to start of FN
        CJNE    PNTR_L,#0FFH,SET_TAG_JMP
SET_TAG_JMP:
        DEC     PNTR_H


SET_TAG_LOOP:                   ; Move File Name into Xmem
        INC DPTR                ; Bump pointer to next Char
        PUSH    DPL             ; Save DPTR
        PUSH    DPH


        CALL    READ_CHAR       ; Get char from AES
        CALL    UPPER           ; Convert  to uppercase

        POP DPH                 ; Store char from FN in Xmem
        POP DPL
        MOVX    @DPTR,A
        CALL    ISALPHANUM      ; check to see if char is AlphaNumeric
        JC      SET_TAG_LOOP    ; Continue as long as char between A and Z

SET_TAG_EOFN:
        MOV     A,#00H          ; Store 00 in mem to mark end of FN
        MOVX    @DPTR,A
	MOVX    A,@DPTR	     		; Force end of write cycle on EEPROM
	CALL    WAIT5MS                 ;  Wait to complete
	CALL	WAIT5MS
        INC     DPTR


        RET
