REMARK_START:
        call   tst                      ;Check to see if 'REM' command
        db      'RE',('M' OR 80H)
        jnc     REMARK_END              ;If not try short version
        CALL    SKPTXT                  ;Skip over rest of line.
        IJMP_   STMT                    ;Execute neext stmt
APOSTRO:
        call   tst                      ;Check to see if (') command
        db      (''''OR 80H)            ;(')
        jnc     REMARK_END              ;If not try Next command
        CALL    SKPTXT                  ;Skip over rest of line
        IJMP_   STMT                    ;Execute next stmt

REMARK_END: