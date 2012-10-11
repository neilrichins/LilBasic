; FIND_NEXT_TAG
;
; SERCH FOR NEXT TAG IN MEMORY
; TAG = 029H,0EEH,0F1H,0F2H
;
; Uses ACC,DPTR,C
; Set:          DPTR --> start location
; Returns:      DPTR --> end of TAG   C --> 1 Found TAG   0 No TAG found

FIND_NEXT_TAG:
        MOV     A,DPH           ; Get highbyte of current pointer address
        JZ      NOT_TAG          ; TAG not allowed in first 256 bytes of mem, so exit with false if we are there.
        CALL    IS_TAG          ; Check to see if DPTR --> TAG
        INC     DPTR            ; Increment DPRT to next byte
        JNC     FIND_NEXT_TAG   ; If tag not found then try again.
TAG_FOUND:
        INC     DPTR            ;Increment DPRT past tag
        INC     DPTR
        INC     DPTR
        RET



; Check if current location DPTR in memory is a TAG.
; C flag = 1 if true 0 if false.
IS_TAG:

        MOV     A,#00H          ; Check first byte
        MOVC    A,@A+DPTR
        CJNE    A,#029H,NOT_TAG ; Exit if fail

        MOV     A,#01H          ; Check second byte
        MOVC    A,@A+DPTR
        CJNE    A,#0EEH,NOT_TAG ; Exit if fail

        MOV     A,#02H          ; Check third byte
        MOVC    A,@A+DPTR
        CJNE    A,#0F1H,NOT_TAG

        MOV     A,#03H          ; Check forth byte
        MOVC    A,@A+DPTR
        CJNE    A,#0F2H,NOT_TAG ; Exit if fail else TAG=valid !!!

YES_TAG:
        SETB    C               ; Set flag for True
        RET

NOT_TAG:
        CLR     C               ; Clear flag for False
        RET

