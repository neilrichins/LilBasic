RUNSTART:
        call   tst                      ;Check to see if it is 'RUN'command
        db      'RU',('N' OR 80H)
        jnc     RUNEND                  ;If not, check next command
        JMP     ARUN                   ;Else clear pointer to end of line and run program
RUNEND: