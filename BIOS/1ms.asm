
WAIT1MS:
;	  ÿÿÿÿWait one MS and exit with out changing anything!!!!
;       Assumes:  Clock fq=11.0592mhz
;		  1.089us per mcycle  (1us if 12mhz xtal)
;                 1ms = 1000us
;                 918.2736 mcycles = 1ms
;                2754.8209 mcycles = 3ms
;                4591.3680 mcycles = 5ms

				;(2) Two cycles required to call this subroutine

	nop			;(1) Total of 10 Overhead cycles
	nop                     ;(1)
WAITMS:
	nop                     ;(1)

	PUSH ACC                ;(2) Save Registers    ( A --> stack)
	XCH A,R2		;(1)                   (R2 --> A)

	MOV R2,#228             ;(1) wait (226 *4)+14 = 918 mcycles


WAIT1MS_LOOP2:                  ;    wait 4 * R2 mcycles
	nop			;    (1)
	nop			;    (1)
	DJNZ R2,wait1ms_loop2   ;    (2)


	XCH A,R2		;(1) Restore Registers (R2 <-- A)
	POP ACC			;(2)                   (A <-- Stack)

	RET			;(2)



WAIT5MS:                       ; 4591 mcycles =  4.9996ms
	CALL waitms ;(2)+916ms
	CALL waitms ;(2)+916ms
WAIT3MS:                       ; 2755 mcycles =  3.0002ms
	nop         ;(1)
	CALL waitms ;(2)+916ms
	CALL waitms ;(2)+916ms
	sjmp waitms ;(2)+916ms
;
