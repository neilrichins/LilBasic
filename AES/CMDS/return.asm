RETURN_START:
        call   tst                      ;If Not 'RETURN' command
        db      'RETUR',('N' OR 80H)
        jnc     RETURN_END              ;Then try next command
        CALL    LNDONE                  ;Else through with this line.
        JMP     RSTR                    ;Pop of of AES new LINE #
RETURN_END: