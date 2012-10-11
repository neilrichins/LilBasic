;
SPLIT_DBA:
;	Called with TOS_L containing a direct on-chip bit address.
;	Return the direct &byte& address of encompassing
;	register in R1, and load B with a mask containing a single 1
;	corresponding to the bit's position in a field of zeroes.
;
	MOV	A,TOS_L
	ANL	A,#11111000B
	JB	ACC.7,SPLSFR
	RL	A
	SWAP	A
	ADD	A,#20H		;Address of bit-address space.
SPLSFR:	MOV	R1,A
	MOV	A,TOS_L
	ANL	A,#07H		;Mask off bit-displacement field.
	ADD	A,#MSKTBL-MSK_PC
	MOVC	A,@A+PC		;Read mask byte.
MSK_PC:
	MOV	B,A
	RET