
 IMPLST:                               ;Implied LET Basic Command

        call   tst                      ;Test for 'var=' command
        db      ('=' OR 80H)
        jnc     IMPLEXT                  ;If no '=' in CMD line, then Exit

        ICALL_  EXPR                    ;Push Expression into AES

;        call   tst
;        db      (',' OR 80H)           ;Removed implied command A=1,2,3,4
;        jnc     se3a                   ;                        (A=1, B=2, C=3, ...ETC)
;        CALL    SEQ_STORE
;        CALL    IINC
;        HOP_    SE3

        CALL    DONE                    ;Clear pointer to next Command
        CALL    STORE                   ;Store result of AES into Variable
        JMP     NXT                     ;Process next command

CMD_NG: JMP     SYN_ER                  ;Invalid Implied Command; Jump To Syntax Error

IMPLEXT: