;INIT
;	Perform global initialization:
;	Clear program memory, empty all I/O buffers, reset all stack
;	pointers, etc.
;
;
INIT:	CALL	RAM_INIT
RAM_INIT:
        CLR     A               ;Quick & easy version of 00H
        MOV     MODE,A          ;Interactive mode, decimal radix.
	MOV	FLAGS,A		;Interroutine flags.


                                ;Wipe all System memory
        MOV     DPTR,#0000H     ;Set DPTR to 0000H
INIT_LOOP_1:
        MOVX    @DPTR,A         ;Clear a byte
        INC     DPTR            ;Bump to next byte
        MOV     R0,DPH          ;Check if Highbyte at RAMLIMit yet?
        CJNE    R0,#HIGH(RAMLIM),INIT_LOOP_1
        MOV     R0,DPL          ;Check if Lowbyte at RAMLIMit yet?
        CJNE    R0,#LOW(RAMLIM),INIT_LOOP_1

        MOV     DPTR,#EXTRAM    ;Set pointer to beginning of program mem
        MOV     A,#080H
        MOVX    @DPTR,A         ;Store 80H at beginning of program
	RET