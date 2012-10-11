

STLET:                                  ;Parse explicit LET command.
        call   tst                      ;Test if 'LET' Command
        db      'LE',('T' OR 80H)
        jnc     ENDLET                  ;if not 'LET' command process next command

        TSTV_   CMD_NG                  ;Test for 'var='
        db      ('=' OR 80H)
        jnc     cmd_ng                  ;If not exizts branch to jump to Syntax Error
        ICALL_  EXPR                    ;Push expressions into AES
        CALL    DONE                    ;Move IL pointer past rest of command
        CALL    STORE                   ;Put Value into Variable
                                        ;       When STORE is called, AES contains
                                        ;       (TOS:)  2 byte VALUE to be stored,
                                        ;               2 byte INDEX of destination variable,
                                        ;               1 byte TYPE code for variable space.
                                        ;                       (0=BASIC variable,
                                        ;                        1=DBYTE,
                                        ;                        2=RBIT,
                                        ;                        3=XBYTE,
                                        ;                        4=CBYTE.)
                                        ;       Store (VAR_1) into appropriate variable memory at location of (INDEX).

        JMP     NXT                     ;Process next Command

ENDLET: