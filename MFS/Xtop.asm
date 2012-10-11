; XTOP
; Maintance for top of Xternal Memory File System
; Value is stored in Xram so it is not lost when
; power is lost!
;
; SAVE_XTOP
; Needs:        DPRT  --> New top of Xram
; Uses          A
;
;
; GET_XTOP
; Returns:      DPRT  --> New top of Xram
; Uses          A




SAVE_XTOP:
        PUSH    DPL                             ;Save Xtop Value
        PUSH    DPH
        MOV     A,DPL                           ;Get Low Byte
        MOV     DPTR,#XTOP                      ;Point to first address
        MOVX    @DPTR,A                         ;Store Low Byte
        INC     DPTR                            ;Bump Pointer to next addr
        POP     ACC                             ;Get High Byte
        MOVX    @DPTR,A                         ;Store High Byte

	MOVX	A,@DPTR				; Flush Eprom
	CALL 	WAIT5MS
	CALL    WAIT5MS

        MOV     DPH,A                           ;Move High Byte to DPTR
        POP     DPL                             ;Move Low Byte to DPTR
        RET




GET_XTOP:
        MOV     DPTR,#XTOP                      ;Point to first address
        MOVX    A,@DPTR                         ;Get Low Byte
        PUSH    ACC                               ;Save Low Byte
        INC     DPTR                            ;Bump Pointer to next addr
        MOVX    A,@DPTR                         ;Get High Byte
        MOV     DPH,A                           ;Move High Byte to DPTR
        POP     DPL                             ;Move Low Byte to DPTR
        RET
