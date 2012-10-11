

STUNLOCK:                               ;Parse explicit UNLCOK command.
        call   tst                      ;Test if 'UNLOCK' Command
        db      '.UNLOC',('K' OR 80H)
        jnc     ENDUNLOCK              ;if not 'UNLOCK' command process next command
	CALL 	UNLOCK
        CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command


ENDUNLOCK:

STLOCK:                               ;Parse explicit LOCK command.
        call   tst                      ;Test if 'LOCK' Command
        db      '.LOC',('K' OR 80H)
        jnc     ENDLOCK              ;if not 'LOCK' command process next command
	CALL   LOCK
        CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command


ENDLOCK:

STCLEAR:                               ;Parse explicit CLEAR command.
        call   tst                      ;Test if 'CLEAR' Command
        db      '.CLEA',('R' OR 80H)
        jnc     ENDCLEAR              ;if not 'CLEAR' command process next command
	CALL	CLEAR
        CALL    DONE                    ;Get ready for next command
        JMP     NXT                     ;Execute next command


ENDCLEAR:

UNLOCK:
	mov A,#0AAh
	mov DPTR,#0D555h                ; Write AA to D555
	MOVX @DPTR,A

	mov A,#55h
	mov DPTR,#0AAAAh                ; Write 55 to AAAA
	MOVX @DPTR,A

	mov A,#80h
	mov DPTR,#0D555h                ; Write 80 to D5555
	MOVX @DPTR,A

	mov A,#0AAh
	mov DPTR,#0D555h                ; Write AA to D555
	MOVX @DPTR,A

	mov A,#55h
	mov DPTR,#0AAAAh                ; Write 55 to AAAA
	MOVX @DPTR,A

	mov A,#20h
	mov DPTR,#0d555h                ; Write 20 to D5555
	MOVX @DPTR,A
	RET
LOCK:
  	mov A,#0AAh
	mov DPTR,#0D555h                ; Write AA to D555
	MOVX @DPTR,A

	mov A,#55h
	mov DPTR,#0AAAAh                ; Write 55 to AAAA
	MOVX @DPTR,A

	mov A,#0A0h
	mov DPTR,#0D555h                ; Write A0 to D5555
	MOVX @DPTR,A

	mov A,#0AAh
	mov DPTR,#0D555h                ; Write AA to D555
	MOVX @DPTR,A
	RET
CLEAR:
	mov A,#0AAh
	mov DPTR,#0D555h                ; Write AA to D555
	MOVX @DPTR,A

	mov A,#55h
	mov DPTR,#0AAAAh                ; Write 55 to AAAA
	MOVX @DPTR,A

	mov A,#080h
	mov DPTR,#0D555h                ; Write 80 to D5555
	MOVX @DPTR,A

	mov A,#0AAh
	mov DPTR,#0D555h                ; Write AA to D555
	MOVX @DPTR,A

	mov A,#55h
	mov DPTR,#0AAAAh                ; Write 55 to AAAA
	MOVX @DPTR,A

	mov A,#010h
	mov DPTR,#0D555h                ; Write 10 to D555
	MOVX @DPTR,A

	CALL WAIT5MS                     ;Wait 30 MS and return
	CALL WAIT5MS
	CALL WAIT5MS
	CALL WAIT5MS
	CALL WAIT5MS
	JMP  WAIT5MS


