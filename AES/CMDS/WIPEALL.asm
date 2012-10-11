WIPEALL_START:

        call tst                        ;Check to see if 'WIPEALL' command
        DB      'WIPEAL',('L'or 80H)
        JNC     WIPEALL_END             ;If not, try next command

        MOV     DPTR,#XRAM              ;Set pointer to start of MFS mem
        CALL    SAVE_XTOP               ;Reset top of mem pointer
        ;MOV     DPTR,#XRAM              ;Set pointer to start of MFS mem

WIPEALL_LOOP:
	MOV     A,#0                    ;Set A to byte to wipe memory with
	MOVX    @DPTR,A                 ;Clear memory

	MOVX	A,@DPTR			;Check to see if memory Wiped
	JNZ	WIPEALL_LOOP		;Try again if we fail

	MOV     A, DPH			;   Get High byte
	call	hexout
	MOV     A, DPL			;   Get low byte
	call	hexout
	MOV     A, #CR			;   Send LF
	call	c_out


					; Handle EEprom Page limitations
	MOV     A, DPL			;   Get low byte
	ANL	A,#01fh                 ;   Compute 32bit page boundry
	JNZ	WIPEALL_CONT            ;   Check

	MOVX     A,@DPTR		; Force end of write cycle on EEPROM
	CALL    WAIT5MS                 ;  Wait to complete
	CALL	WAIT5MS

WIPEALL_CONT:
        INC     DPTR                    ;Bump pointer to next address
	MOV	A,#0
        CJNE    A,DPH,WIPEALL_LOOP      ;Continue until end of memory.

	CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command






WIPEALL_END:
