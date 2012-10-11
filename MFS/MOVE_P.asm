

; Move Program
; Move Basic program in memory FROM TMP1,2 TO TMP3,4
; Uses A,DPTR
; NEEDS         TMP1,TMP2 --> TO   L,H
;               TMP3,TMP4 --> FROM L,H
;               RAMROM    --> Set = ROM to XRAM
;                             Clr = XRAM to XRAM
;
;RETURNS        DPTR      --> End of file +1 address

MOVE_P:
        MOV     DPL,TMP3                ; Get from addr
        MOV     DPH,TMP4

        JB      RAMROM,MOVE_ROM         ; Fetch from RAM/ROM ?  Set = ROM

MOVE_XRAM:                              ; Get byte from XRAM
        MOVX    A,@DPTR
        SJMP    MOVE_CONT

MOVE_ROM:                               ; Get byte from ROM
        CLR     A
        MOVC    A,@A+DPTR               ; Get Byte

MOVE_CONT:
        INC     DPTR                    ; Bump to next byte
        MOV     TMP3,DPL                ; Save From Addr
        MOV     TMP4,DPH

        MOV     DPL,TMP1                ; Get To Addr
        Mov     DPH,TMP2
        MOVX    @DPTR,A                 ; Store Byte
        INC     DPTR

					; Handle EEprom Page limitations
	PUSH ACC                        ; Save reg
	MOV     A, DPL			;   Get low byte
	ANL	A,#01fh                 ;   Compute 32bit page boundry
	JNZ	MOVE_CONT_2             ;   Check

	MOVX    A,@DPTR		; Force end of write cycle on EEPROM
	CALL    WAIT5MS                 ;  Wait to complete
	CALL	WAIT5MS

MOVE_CONT_2:                            ; Restore Registers
	POP ACC

        MOV     TMP1,DPL                ; Save To Addr
        MOV     TMP2,DPH
        ANL     A,#80H                  ; Mask of all but MSB
        CJNE    A,#80H,MOVE_P           ; If MSB not not set, move Next Byte
        RET                             ; Else we have moved the program
