;XFER
;	Pop the value from the top of the arithmetic expression stack (AES).
;	Position cursor at beginning of the BASIC source program line
;	with that label and begin source interpretation.
;	(Report error if corresponding source line not found.)
;
;
XFER:	CALL	FNDLBL
	JC	XFERNG
	JMP	STMT		;Begin execution of source line.
;
XFERNG:	JMP	EXP_ER
;