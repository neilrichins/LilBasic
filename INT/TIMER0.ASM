;===================================================================
;I          TIMER 0 INTERRUPT VECTOR --> PWM   9216.Hz/255
;===================================================================
TIMER_0:
        PUSH    PSW                     ;Save Flags
        PUSH    Acc                     ;Save Acc so we can use it
        DJNZ    TIMER0,TO_CHK           ;Bump counter, if TIMER not 0 then Check to see if time to toggle PWM
        INC     TIMER1                  ;Else increase timer 1
	MOV     TIMER0,#100             ;Reset Timer0 back to 100 (1% to 99% threshold)

; Toggle all pins being used for PWM to 'reset' them
TO_CLR:
        MOV     A,#100  		;Preload A with FF for easy compairson

TCLR0:
        CJNE    A,PWM0,TCLR1            ;Skip if not used
        cpl     P0.0                    ;Else set bit

TCLR1:
        CJNE    A,PWM1,TCLR2           ;Skip if not used
        cpl     P0.1                   ;Toggle pin 1


TCLR2:
        CJNE    A,PWM2,TCLR3           ;Skip if not used
        cpl     P0.2                   ;Toggle pin 2


TCLR3:
        CJNE    A,PWM3,TCLR4           ;Skip if not used
        cpl     P0.3                   ;Toggle pin 3

TCLR4:
        CJNE    A,PWM4,TCLR5            ;Skip if not used
        cpl     P0.4                    ;Toggle pin 4

TCLR5:
        CJNE    A,PWM5,TCLR6            ;Skip if not used
        cpl     P0.5                    ;Toggle pin 6

TCLR6:
        CJNE    A,#100,TCLR7            ;Skip if not used
        cpl     P0.6                    ;Toggle pin 6

TCLR7:
        CJNE    A,#100,T0_EXIT           ;Skip if not used
	cpl     P0.7                    ;Toggle pin 7
        JMP     T0_EXIT                 ;Restore vars & exit

; Check all 8 pins to see if they need toggled.
TO_CHK:
        MOV     A,TIMER0                ;Copy TIMER0 to A for eazy access

TCHK0:
        CJNE    A,PWM0,TCHK1            ;Skip if not at threshold
        cpl     P0.0                    ;Else set bit

TCHK1:
        CJNE    A,PWM1,TCHK2		;Skip if not at threshold
        cpl     P0.1			;Toggle pin 1


TCHK2:
        CJNE    A,PWM2,TCHK3		;Skip if not at threshold
        cpl     P0.2			;Toggle pin 2

TCHK3:
        CJNE    A,PWM3,TCHK4		;Skip if not at threshold
        cpl     P0.3			;Toggle pin 3

TCHK4:
        CJNE    A,PWM4,TCHK5            ;Skip if not at threshold
        cpl     P0.4                    ;Toggle pin 4

TCHK5:
        CJNE    A,PWM5,TCHK6            ;Skip if not at threshold
        cpl     P0.5                    ;Toggle pin 6

TCHK6:
        CJNE    A,PWM6,TCHK7		;Skip if not at threshold
        cpl     P0.6			;Toggle pin 6

TCHK7:
        CJNE    A,PWM7,T0_EXIT		;Skip if not at threshold
	cpl     P0.7                    ;Toggle pin 7

T0_EXIT:
        POP     Acc                     ;Restore Acc
        POP     PSW                     ;Restore Flags
        RETI                            ;Exit
