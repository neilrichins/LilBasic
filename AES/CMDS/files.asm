FILES_START:

        call tst                        ;Check to see if 'FILE' command
        DB      'FILE',('S'or 80H)
        JNC     FILES_END               ;If not, try next command
        CALL    STROUT                 ;Send String Below
        DB      CR,CR,' Files in memory ',CR,'=================',CR,80H
        MOV     DPTR,#START_OF_PROGRAMS ;Initilize DATA pointer

 FILES_LOOK:
        CALL    FIND_NEXT_TAG           ;Look for next TAG
        JNC     FILES_EXIT              ;If end found, then end
        MOV     A,#0H                   ;Clear A
        MOVC    A,@A+DPTR               ;Get File type
        MOV     TMP1,A                  ;Save File type
        INC     DPTR                    ;Step over file type
        MOV     A,#SPACE                 ;Load A with a space
        CALL    C_OUT                   ;Send 2 spaces
        CALL    STROUT2                 ;Output file name
        MOV     A,#SPACE                 ;Load A with a space
        CALL    C_OUT                   ;Send 2 spaces
        CALL    C_OUT
        MOV     A,#'('                  ;
        CALL    C_OUT
        MOV     A,TMP1                  ;Move FILE TYPE into A
        CALL    C_OUT                   ;Send File Type to display
        MOV     A,#')'                  ;
        CALL    C_OUT

        CALL    NLINE                   ;Send Line feed
        SJMP    FILES_LOOK              ;Look for next file in memory




 FILES_EXIT:
        CALL    STROUT                 ;Send String Below
        DB      '=================',CR,CR,80H

        CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command
FILES_END:

