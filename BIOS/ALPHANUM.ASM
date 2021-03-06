;ISALPHANUM
;       Evaluates A
;               C is 1 if in  Alphanumeric range
;               C is 0 if not
;ISALPHA
;       Evaluates A
;               C is 1 if  'A' to 'Z' or 'a' to 'z'
;               C is 0 if not
;ISLOWER
;       Evaluates A
;               C is 1 if Lowercase
;               C is 0 if not
;
; USES: nothing



ISALPHANUM:

        CJNE    A,#'0',$+3                                      ; Is A < '0'
        JC      ISALPHANUM_NO                                   ;

        CJNE    A,#'9'+1,ISALPHANUM_YES                         ; IS A > '9'
        JNC     ISALPHA                                         ; Yes, then check if it is a letter
        SJMP     ISALPHANUM_YES                                  ; No, must be a number '0' to '9'
ISALPHA:
        CJNE    A,#'A',$+3                                      ; Is A < 'A'
        JC      ISALPHANUM_NO                                   ;

        CJNE    A,#'Z'+1,ISALPHANUM_YES                         ; IS A > 'Z'
        JNC     ISLOWER                                         ; Yes, then check if it is lowercase
        SJMP     ISALPHANUM_YES                                  ; No, must be a Letter 'A' to 'Z'

ISLOWER:
        CJNE    A,#'a',$+3                                      ; Is A < 'z'
        JC      ISALPHANUM_NO                                   ;

        CJNE    A,#'z'+1,ISALPHANUM_NO                         ; IS A > 'z'
        JNC     ISALPHANUM_NO                                  ; Yes, then not in range.
        ;SJMP     ISALPHANUM_YES                                 ; No, must be a Letter 'A' to 'Z'

ISALPHANUM_YES:
        SETB    C
        RET

ISALPHANUM_NO:
        CLR     C
        RET