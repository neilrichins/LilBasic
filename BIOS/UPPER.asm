
UPPER:                          ;Convert CHAR in ACC to uppercase !
        CJNE    A,#'a',$+3      ;Check for lower-case alphabetics.
        JC      UPPER_EXIT
        CJNE    A,#'z'+1,$+3
        JNC     UPPER_EXIT
        ANL     A,#11011111B    ;Force to upper-case.
UPPER_EXIT:
        RET