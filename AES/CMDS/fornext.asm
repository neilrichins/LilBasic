;------------;
; FOR COMMAND;
;------------;
FOR_START:
        call   tst                      ;Check if 'FOR' command
        db      'FO',('R' OR 80H)
        jnc     NEXT_START              ;If not Check if 'NEXT' command

        CALL    TSTV                    ;Check for variable
                                        ;If so, Push variable on AES
        JNC     FOR_ER                  ;Else Syntax Error if no var

        call   tst                      ;Check if next char is '='
        db      ('=' OR 80H)
        jnc     for_er                  ;If not then Syntax Error

        CALL    EXPR                    ;Else   Push Expression on AES
        CALL    SEQ_STORE               ;Save Start value in Varable

        call    tst                      ;Check for token 'TO'
        db      'T',('O' OR 80H)
        jnc     for_er                  ;If not present goto Syntax Error
        CALL    EXPR                    ;Push   Expression on AES

        CALL    TST                     ;Check for step
        db      'STE',('P' OR 80H)
        jnc     STEP_1
        call    EXPR                    ;push step value on stack

FOR_END:
        CALL    LNDONE                  ;Move pointers to end of command
        CALL    SAV                     ;Push   Current Line # into AES
                                        ;TOS --->       Basic Ln
                                        ;               End #
                                        ;               Start #
                                        ;               Var
        JMP     NXT                     ;Execute next command

STEP_1:
        LIT_    01H                     ;Push low byte of default step onto Stack
        LIT_    00H                     ;Push high byte of default onto Stack
        jmp      FOR_END



;NEXT command
;------------
NEXT_START:
        call   tst                      ;Check for 'NEXT' command
        db      'NEX',('T' OR 80H)
        jnc     FORNEXT_END             ;If Not 'NEXT' then try next command
        CALL    DONE                    ;Move pointer to end of command
LOOP:
;               LOOP is called with the AES holding:
;       (TOS:)  2 byte LABEL of line initiating FOR loop,
;               2 byte step value
;		2 byte LIMIT specified by FOR statement,
;		2 byte INDEX of variable used by FOR loop,
;		1 byte TYPE of variable code.
;	If indices disagree, then generate syntax error.
;	Otherwise, store incremented value in variable popping both from AES.
;	If the incremented value <= LIMIT then return with carry set.
;	If incr. val. > LIMIT looping is done, so return with carry not set.
;

       call    DUP -9                   ; Duplicate -9 (3 times) to copy var to tos
       call    DUP -9
       call    DUP -9
       call    EXPR                     ;compute value & put back on stack
       CALL    DUP -6                   ;DUP -6 (2 times) to copy setp to tos
       CALL    DUP -6
       CALL    IADD                     ;Add  2(step) to 2(variable)
       CALL    DUPL                     ;Copy 16 bit value (New Value)
       CALL    DUP -11                  ;DUP -11 (3 times) to get var
       CALL    DUP -11
       CALL    DUP -11
       CALL    STORE                    ;save number back into var
       LIT     01H                      ;01H = test whether (VAR_1) >  (VAR_2)
       CALL    DUP -6                   ;DUPlicate -6 (2 times) to get limit
       CALL    DUP -6
       CALL    CMPR                     ;copmair (2 numbers)
       CALL    POP_ACC                  ;POP value  1 = true 0 = false
       JNE     A,0    NEXT_DONE         ;If For/Next stmt complete,
                                        ;       Then clear values off AES
                                        ;       And EXIT

        CALL    DUPL                    ;Else Duplicate TOS
        JMP     RSTR                    ;Jump to LineNumber(TOS)

NEXT_DONE:
        CALL    POP_TOS                 ;Basic Ln return
        CALL    POP_TOS                 ;Setp Value
        CALL    POP_TOS                 ;End # of fornext loop
        CALL    POP_TOS                 ;Start # of fornext loop
        CALL    POP_ACC                 ;POP value int
        JMP     NXT                     ;Execute next command


FOR_ER: JMP     CMD_NG                  ;Jump to Syntax Error
;
FORNEXT_END: