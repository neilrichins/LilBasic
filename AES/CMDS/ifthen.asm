IFST:
s8:     call   tst
        db      'I',('F' OR 80H)        ;Check for 'IF' Command
        jnc     IFEXIT                  ;If not check next command
        ICALL_  EXPR                    ;Push expressionon on AES stack
        call   tst
        db      'THE',('N' OR 80H)      ;Check for 'THEN' command
        jnc     IF_TF                     ; NEEDS changed to jnc ERROR

IF_TF:
        COND_   IF_FALSE
        IJMP_   TOKEN                   ;If True Continue parsing command.

IF_FALSE:
        CALL    SKPTXT                  ;If False Skip rest of line
        IJMP_   STMT

IFEXIT:
