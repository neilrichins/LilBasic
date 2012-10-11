;
;
;           LIL'BASIC INTERPRETER
;       LIL'BASIC INTERPRETER PROGRAM
;	==============================
VERS    EQU     32H

$MOD51                          ;8051 Registers
$NODEBUG                        ;No Emulateion code
$TITLE(LilBasic (c)2002)

;======================================================================================
;                          Macros!
;======================================================================================
;IJMP   (LBL)
;	Jump to the (potentially distant) IL instruction at location LBL.
;Note:	In this implementation IL addresses are equivalent to machine
;	language addresses, so IJMP performs a generic JMP.
;
;
;===============
;
;HOP	(LBL)
;	Perform a branch to the IL instruction at (nearby) location LBL.
;Note:	In this implementation IL addresses are equivalent to machine
;	language addresses, so HOP performs a simple relative SJMP.
;
;
;===============
;
;ICALL	(LBL)
;	Call the IL subroutine starting at instruction LBL.
;	Save the location of the next IL instruction on the control stack.
;Note:	In this implementation, IL addresses are identical with
;	machine language addresses, and are saved on the MCS-51 hardware stack.
;
;
;===============
;
;IRET
;	Return from IL subroutine to location on top of control stack.
;Note:	In this implementation, IL addresses are identical with machine
;	language addresses, which are saved on the hardware stack.
;
;
$INCLUDE(MACROS\MACROS.ASM)


;======================================================================================
;	GLOBAL VARIABLE AND DATA STRUCTURE DECLARATIONS:
;======================================================================================;
;               Intended System Configuration Constants:

AESRAM  EQU     0000H           ;AES STACK 256 Bytes... BIG stack !
STRRAM  EQU     0100H           ;String memory 26vars * 256 bytes = 6656 or 1A00
VARRAM  EQU     1C00H           ;Start of memory for INT Variables
EXTRAM  EQU     2000H           ;Start of program buffer.
RAMLIM  EQU     7FFFH           ;Top of Program ram = 32K.
XTOP    EQU     8000H           ;Address of 2 byte pointer to top of XRAM
XRAM    EQU     8002H           ;Start of MFS ram Area
TABSIZ  EQU     8               ;Formatted column spacing.
AESLEN  EQU     0FFH            ;AES Length = 256 bytes!!!!

;===================================================================================================

;	Working Register Definitions.
;
PNTR_L	EQU	R0		;Program buffer pointer.
DEST_L	EQU	R1		;Destination pointer for line insertion.
PNTR_H	EQU	R2		;High-order pointer byte (temp. cursor)
DEST_H	EQU	R3
CHAR	EQU	R4		;BASIC source string character being parsed.
LP_CNT	EQU	R5
TOS_L   EQU     R6              ;Variable popped from stack for math routines.
TOS_H   EQU     R7

; First 8 bytes reserved for R1 to R8
;                               START OF DATA SEGMENT  128 Bytes !!!


;
	DSEG
        ORG     08H
;
;       Temporary variables used in MUL,DIV and other routines.
;
TMP0:   DS      1
TMP1:   DS      1
TMP2:   DS      1
TMP3:   DS      1
TMP4:   DS      1
TMP5:   DS      1
TMP6:   DS      1               ; Not used in MUL or DIV reserved for use in basic commands.
TMP7:   DS      1               ; Not used in MUL or DIV reserved for use in basic commands.

SEED_L: DS      1               ;Random number key.
SEED_H: DS      1


STRLEN: DS      1               ;Length of text string in L_BUF.

L_CURS: DS      1               ;Cursor for line buffer.

TABCNT: DS      1               ;Column formatting count.

CURS_L: DS      1               ;CURSOR Source line cursor.
CURS_H: DS      1
C_SAVE: DS      1               ;CHAR saved during SAVE_PNTR.

LABL_L: DS      1               ;BASIC program source line counter.
LABL_H: DS      1               ;  "       "       "     high byte.

ERROR:  DS      1               ;Error Code
ELN_L:  DS      1               ;Error Line number Low byte
ELN_H:  DS      1               ;Error Line number Low byte
AESP:   DS      1               ;AES Stack Pointer

TIMER0: DS      1               ;Timer counter passed to basic
TIMER1: DS      1

PWM0:   DS      1               ;ON/OFF  THRESHOLD FOR PWM PIN 1
PWM1:   DS      1               ;ON/OFF  THRESHOLD FOR PWM PIN 1
PWM2:   DS      1               ;ON/OFF  THRESHOLD FOR PWM PIN 2
PWM3:   DS      1               ;ON/OFF  THRESHOLD FOR PWM PIN 3
PWM4:   DS      1               ;ON/OFF  THRESHOLD FOR PWM PIN 4
PWM5:   DS      1               ;ON/OFF  THRESHOLD FOR PWM PIN 5
PWM6:   DS      1               ;ON/OFF  THRESHOLD FOR PWM PIN 6
PWM7:   DS      1               ;ON/OFF  THRESHOLD FOR PWM PIN 7

;===================================================================================================
PRT_MSK:DS      1               ;Port Mask (enabled pins for PWM )  (MUST BE AFTER ADDR 32 dec/ 20 HEX)

PWM_E0          BIT     PRT_MSK.0          ;Pin 0
PWM_E1          BIT     PRT_MSK.1          ;Pin 1
PWM_E2          BIT     PRT_MSK.2          ;pin 2
PWM_E3          BIT     PRT_MSK.3          ;Pin 3
PWM_E4          BIT     PRT_MSK.4          ;Pin 4
PWM_E5          BIT     PRT_MSK.5          ;Pin 5
PWM_E6          BIT     PRT_MSK.6          ;Pin 6
PWM_E7          BIT     PRT_MSK.7          ;Pin 7

;===================================================================================================
TMP_MSK:DS      1               ;Temporary mask for bit manulipation

TMP_0          BIT     TMP_MSK.0
TMP_1          BIT     TMP_MSK.1
TMP_2          BIT     TMP_MSK.2
TMP_3          BIT     TMP_MSK.3
TMP_4          BIT     TMP_MSK.4
TMP_5          BIT     TMP_MSK.5
TMP_6          BIT     TMP_MSK.6
TMP_7          BIT     TMP_MSK.7

;===================================================================================================
MODE:   DS      1               ;Operating mode bits.

UNUSED          BIT     MODE.0          ;
AUTO            BIT     MODE.1          ; Set when BASIC programs auto executed.
XAUTO           BIT     MODE.2          ; Set when BASIC programs auto executed from XMEM.
RUNMOD          BIT     MODE.3          ; Set when stored BASIC program is running.
HEXMOD          BIT     MODE.4          ; Set when operations should use HEX radix.


;===================================================================================================
FLAGS:  DS      1               ;Interroutine communication flags.  ;

ZERSUP          BIT     FLAGS.0         ; If set, suppress printing leading zeroes.
CHAR_FLG        BIT     FLAGS.1         ; Set when CHAR has not been processed.
SGN_FLG         BIT     FLAGS.2         ; Keeps track of operand(s) sign during math.
SEQ_FLG         BIT     FLAGS.3         ;
MOD_FLG         BIT     FLAGS.4         ; Set if divide routine should return MOD value.
H_FLG           BIT     FLAGS.5         ; Used to sense allow 'H' suffix in HEX mode.
RAMROM          BIT     FLAGS.6         ; Set when moving program from ROM to RAM Clear = From Ram to Ram

;===================================================================================================
;
;                       Start of Code Segment
;
;	Line Buffer Variables:
;
SP_BASE EQU     $-1             ;Initialization value for hardware SP.   ( STACK = 34 TO 128)
;
CR	EQU	0DH		;ASCII CODE FOR <CARRIAGE RETURN>.
LF	EQU	0AH		;  "    "    "  <LINE FEED>.
BEL	EQU	07H		;  "    "    "  <BELL>.
ESC     EQU     1BH             ;  "    "    "  <ESC>
BS      EQU     08H             ;  "    "    "  <BS>
SPACE   EQU     20H             ;  "    "    "  <SPACE>
CTRL_R  EQU     12H             ;  "    "    "  <CTRL> <R>
DEL     EQU     7FH             ;  "    "    "  <DEL>
;
;$SAVE NOGEN
;===================================================================================================
;
;	Interrupt routine expansion hooks:
;
;===================================================================================================

        CSEG
        ORG     0000H           ;System initialization / reset routine.
        JMP     S_INIT

        ORG     0003H           ;External interrupt 0 service routine.
        RETI

        ORG     000BH           ;Timer 0 service routine.
        JMP    TIMER_0

        ORG     0013H           ;External interrupt 1 service routine.
        RETI

        ORG     001BH           ;Timer 1 service routine.
        RETI

        ORG     0023H           ;Serial port interrupt service routine.
        RETI

$INCLUDE(INT\TIMER0.ASM)  ;Timer 0  Auto reload timer used for PWM
$INCLUDE(INT\RESET.ASM)   ;Power Up and Reset
;===================================================================================================
;                       Basic Input / Output Routines
;===================================================================================================;
;ISALPHANUM
;       Evaluates A
;               C is 0 if in  Alphanumeric range
;               C is 1 if not
;ISALPHA
;       Evaluates A
;               C is 0 if  'A' to 'Z' or 'a' to 'z'
;               C is 1 if not
;ISLOWER
;       Evaluates A
;               C is 0 if Lowercase
;               C is 1 if not
;
; USES: nothing
$INCLUDE(BIOS\ALPHANUM.ASM)

;=======

;UPPER:
;       Convert CHAR in Acc to uppercase !
;
$INCLUDE(BIOS\UPPER.ASM)
;=======
 ;C_IN:
;	Console character input routine.
;	Waits for next input from console device and returns with character
;	code in accumulator.
 $INCLUDE(BIOS\C_IN.ASM)
;=======
;NLINE: Transmit <CR><LF> sequence to console device.
;C_OUT:
;	Console character output routine.
;	Outputs character received in accumulator to console output device.
$INCLUDE(BIOS\C_OUT.ASM)
;=======
;
;
CNTRL:	JNB	RI,CNTRET	;Poll whether character has been typed.
	CALL	C_IN
	CJNE	A,#13H,CNTRET	;Check if char. is <CNTRL-S>.
CNTR_2:	CALL	C_IN		;If so, hang up...
	CJNE	A,#11H,CNTR_2	;    ...until <CNTRL-Q> received.
CNTRET:	RET
;
;=======
;SPC:
;	Transmit one or more space characters to console to move console
;	cursor to start of next field.
$INCLUDE(BIOS\TAB.ASM)
;===============
;NIBOUT:
;	If low-order nibble in Acc. is non-zero or ZERSUP flag is cleared,
;	output the corresponding ASCII value and clear ZERSUP flag.
;	Otherwise return without affecting output or ZERSUP.
$INCLUDE(BIOS\NIBOUT.ASM)       ;USES C_OUT

;
;HEXOUT:
;       Output Hexdecimal value in ACC
;       USES   TMP0
;       CALLS   NIBOUT
$INCLUDE(BIOS\HEXOUT.ASM)

;=======
;STROUT
;	Copy in-line character string to console output device.
;       Maximum Lenght is 254 Chars + 2 for return addr !!!!
;       (8 bit INC to DPTR)
$INCLUDE(BIOS\STROUT.ASM)       ;USES C_OUT
;=======
;STROUT2
;       Copy character string to console output device.
;       Start @ DPTR
;       Stop at char  00H
;       255 char limit on length of text!
$INCLUDE(BIOS\STROUT2.ASM)      ;USES C_OUT
;=======
;wait1ms
;	Wait one MS and exit with out changing anything!!!!
;       Assumes:  Clock fq=11.0592mhz
;		  1.089us per mcycle  (1us if 12mhz xtal)
;                 1ms = 1000us
;                 918.2736 mcycles = 1ms
$INCLUDE(BIOS\1ms.ASM)      ;USES C_OUT
;=======
;
;       ARITHMETIC SUBROUTINE PACKAGE
;
;=======
;POP_TOS:
;	Verify that stack holds at least on (16-bit) entry.
;	(Call AES_ER otherwise.)
;	Pop TOS into registers TOS_H and TOS_L,
;	update AESP,
;	and return with R1 pointing to low-order byte of previous NOS.
;	Do not affect accumulator contents.
$INCLUDE(AES\POP_TOS.ASM)
;=======
;POP_ACC:
;	Pop TOS into accumulator and update AESP.
$INCLUDE(AES\POP_ACC.ASM)
;=======
;PUSH_TOS:
;	Verify that the AES is not full,
;	push registers TOS_H and TOS_L onto AES,
;	and update AESP.
$INCLUDE(AES\PUSH_TOS.ASM)
;=======
;DUP:   (K)
;	Verify that the AES is not full,
;	then duplicate the top element and update AESP.
$INCLUDE(AES\DUP.ASM)
;=======
;LIT:    (K)
;	Report error if arithmetic expression stack is full.
;	Otherwise push the one-byte constant K onto AES.
;	Return with carry=1, since LIT marks a successful match.
$INCLUDE(AES\LIT.ASM)
;=======

;
;       BASIC VARIABLE ACCESSING OPERATIONS
;	===== ======== ========= ==========
;=======
;Special Function Register Table
$INCLUDE(AES\SFR_TBL.ASM)
;=======
;SFR_ID:
;	Identify which SFR is indicated by the contents of R1.
;	Return with acc holding (Index of said register)*3.
;	Call error routine if register number not found.
$INCLUDE(AES\SFR_ID.ASM)
;=======
;STRDIR:
;       Store data byte in ACC into direct on-chip RAM (and SFR) address held in R1.
$INCLUDE(AES\STR_DIR.ASM)
;=======
;FETDIR:
;       Fetch on-chip directly addressed byte (and SFR)indicated by R1 into Acc.
$INCLUDE(AES\FET_DIR.ASM)
;=======
;SPLIT_DBA:
;	Called with TOS_L containing a direct on-chip bit address.
;	Return the direct &byte& address of encompassing
;	register in R1, and load B with a mask containing a single 1
;	corresponding to the bit's position in a field of zeroes.
$INCLUDE(AES\SPL_DBA.ASM)
;=======
;MSKTBL:
;       Mask Table for 2^x
$INCLUDE(AES\MSK_TBL.ASM)
;=======
;SEQ_STORE:
;       Same as STORE, below, except that index is retained
;       rather than being popped.
;STORE:
;	When STORE is called, AES contains
;	(TOS:)	2 byte VALUE to be stored,
;		2 byte INDEX of destination variable,
;		1 byte TYPE code for variable space.
;			(0=BASIC variable,
;			 1=DBYTE,
;			 2=RBIT,
;			 3=XBYTE,
;			 4=CBYTE.)
;	Store (VAR_1) into appropriate variable memory at location of (INDEX).
$INCLUDE(AES\STORE.ASM)
;===============
;SEQ_FETCH:
;       Same as FETCH, below, except that index is retained
;       rather than being popped.
;FETCH:
;	When FETCH is called, AES contains
;	(TOS:)	2 byte INDEX of source variable,
;		1 byte TYPE code for variable space.
;			(0=BASIC variable,
;			 1=DBYTE,
;			 2=RBIT,
;			 3=XBYTE,
;			 4=CBYTE.)
;	Read 8- or 16-bit variable from the appropriate variable
;	memory at location of (INDEX) and return on AES.
$INCLUDE(AES\FETCH.ASM)
;=======
;CREATE
;	Test the contents of Acc.
;	If CHAR holds the ASCII code for a legitimate decimal digit,
;	create a two-byte entry in <TOS_H><TOS_L> holding low-order ACC nibble
;	and return with CY set.
;	Otherwise, return with CY cleared.
$INCLUDE(AES\CREATE.ASM)
;===============
;APPEND
;	Test ASCII code in Acc.
;	If it is a legal digit in the current radix,
;	modify <TOS_H><TOS_L> to include this digit and return with CY set.
;	Otherwise leave AES and CHAR unchanged and return with CY cleared.
;	Operating mode determined by HEXMOD flag (1=Hex).
$INCLUDE(AES\APPEND.ASM)
;=======
;IADD:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS + VAR
$INCLUDE(AES\IADD.ASM)
;===============
;ISUB
;	Pop VAR from AES (two bytes).
;	TOS <= TOS - VAR
$INCLUDE(AES\ISUB.ASM)
;=======
;IAND:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS AND VAR
$INCLUDE(AES\IAND.ASM)
;=======
;IOR:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS OR VAR
$INCLUDE(AES\IOR.ASM)
;=======
;IXOR:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS XOR VAR
$INCLUDE(AES\IXOR.ASM)
;===============
;ICPL:
;	TOS <= /TOS  (ones complement)
;IABS:
;	If in decimal mode and TOS < 0
;	then complement SGN_FLG and negate TOS.
;NEG_IF_NEG:
;	If SGN_FLG is set then negate TOS and complement SGN_FLG,
;	else return with TOS unchanged.
$INCLUDE(AES\NEG.ASM)
;===============
;IINC:
;	TOS <= TOS+1
$INCLUDE(AES\IINC.ASM)
;=======
;IMUL:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS * VAR
$INCLUDE(AES\IMUL.ASM)
;===============
;IDIV:
;	Pop VAR from AES (two bytes).
;	TOS <= TOS / VAR
;	If divide-by-zero attempted report error.
;IMOD:
;	Pop VAR from AES (two bytes).
;       TOS <= TOS mod VAR        (remainder)
;	If divide-by-zero attempted report error.
$INCLUDE(AES\IDIV.ASM)
;===============
;RND:
;       TOS <= rnd(TOS)
;       Generate a new 16-bit random number from 1 to TOS,
;	and push onto the AES.
$INCLUDE(AES\RND.ASM)
;===============
;CMPR:
;	When CMPR is called, AES contains:
;	(TOS:)	VAR_2 (two bytes),
;		C_CODE (one byte),
;		VAR_1 (two bytes).
;	Pop all 5 bytes from stack and test relation between VAR_1 and VAR_2.
;	    If C_CODE=010 then test whether (VAR_1) =  (VAR_2)
;	    If C_CODE=100 then test whether (VAR_1) <  (VAR_2)
;	    If C_CODE=110 then test whether (VAR_1) <= (VAR_2)
;	    If C_CODE=101 then test whether (VAR_1) <> (VAR_2)
;           If C_CODE=001 then test whether (VAR_1) >  (VAR_2);           If C_CODE=011 then test whether (VAR_1) >= (VAR_2)
;	If true then return 0001H on AES;
;	otherwise return 0000H.
$INCLUDE(AES\CMPR.ASM)
;===============


;	BASIC SOURCE PROGRAM LINE ACCESSING ROUTINES:
;	===== ====== ======= ==== ======= ==========
;
;	The general methodology of the various parsing routines is as follows:
;	The POINTER (PNTR_L, PNTR_H) is used to indicate the next BASIC
;	source character or string to be parsed
;	by routines TST, TSTV, TSTN, TSTL, and TSTS.
;	GET_C reads the indicated character from the appropriate
;	program buffer space into acc. and returns.
;	READ_CHAR reads the character into CHAR as well as acc. and
;	increments the 16-bit pointer.
;	When done, each routine calls D_BLANK to remove any trailing spaces,
;	and leaves READ_CHAR ready to fetch the next non-blank character.
;
;=======
;REWIND
;	Reset Cursor to start of current program buffer space.
$INCLUDE(AES\REWIND.ASM)
;=======
;SAVE_PNTR:
;	Save PNTR variables in cursor.
$INCLUDE(AES\SAVPNTR.ASM)
;=======
;LOAD_PNTR:
;	Reload pointer with value saved earlier by SAVE_PNTR.
$INCLUDE(AES\LOADPNTR.ASM)
;=======
;GET_C:
;	Read character from logical buffer space into A and return.
;GET_BUF:
;	Read character from active program buffer space into A and return.
;REREAD:
;       Re-Read charcter into Acc from CHAR
;
;READ_CHAR:
;	READ_CHAR first tests the state of CHAR_FLG.
;	If it is still cleared, the character most recently read from the line
;	buffer or program buffer has been processed, so read the next
;	character, bump the buffer pointer, and return with the character
;	in both Acc. and CHAR and the CHAR_FLG cleared.
;	If CHAR_FLG has been set by the parsing routines,
;	then CHAR still holds a previously read character which has
;	not yet been processed.  Read this character into Acc. and return
;	with CHAR_FLG again cleared.
$INCLUDE(AES\READCHAR.ASM)
;=======
;PUT_BUF:
;	Put the contents of the acc. into program buffer space
;	currently active at the address held in <DEST_H><DEST_L>.
;WRITE_CHAR:
;	Converse of READ_CHAR.
;	Write contents of acc. into appropriate memory space (@DEST),
;	increment DEST, and return.
$INCLUDE(AES\WRITECHR.ASM)
;=======
;D_BLNK:
;	Remove leading blanks from BASIC source line, update cursor,
;	load first non-blank character into CHAR,
;	and leave pointer loaded with its address.
;	(This routine is jumped to by parsing routines when successful,
;	so set C before returning to original routines.)
$INCLUDE(AES\D_BLNK.ASM)
;=======
;SKPLIN
;	Skip Cursor over entire BASIC source line, leaving
;	cursor pointing to character after terminating <CR>.
;SKPTXT
;	Skip remainder of line in progress, assuming line number
;	has already been passed over.
;	(Note that either byte of binary line number could be
;	mis-interpreted as a CR.)
$INCLUDE(AES\SKPLIN.ASM)
;===================================================================================
;	Token recognition and processing routines.
;===================================================================================
;TST:
;	If "TEMPLATE" matches the BASIC character string read by
;	READ_CHAR then move pointer over string and any trailing blanks
;	and continue with the following IL instruction.
;	Otherwise leave pointer unchanged and branch to IL instruction at LBL.
$INCLUDE(AES\TST.ASM)
;=====
;TSTV	(LBL)
;
;	Test if first non-blank string is a legal variable symbol.
;	If so, move cursor over string and any trailing blanks,
;	compute variable index value,
;	push onto arithmetic expression stack,
;	and continue with following IL instruction.
;	Otherwise branch to IL instruction at LBL with cursor unaffected.
;       Contains PASVAL subrutines.
$INCLUDE(AES\TSTV.ASM)
;===============
;TSTN	(LBL)
;	Test if indicated string is an unsigned number.
;	If so, move cursor over string and trailing blanks,
;	compute number's binary value,
;	push onto arithmetic expression stack, and continue with
;	following IL instruction.
;	Otherwise restore cursor and branch to IL instruction at LBL.
;
;TSTL	(LBL)
;	Test if first non-blank string is a BASIC source line number.
;	If so, move cursor over string and following blanks,
;	compute number's binary value,
;	push onto arithmetic expression stack,
;	and continue with next IL instruction.
;	If invalid source line number report syntax error.
;	If line number not present restore cursor
;	and branch to IL instruction at LBL.
;
$INCLUDE(AES\TSTN.ASM)
;===============
;TSTS	(LBL)
;	Test if first character is a quote.
;	If so, print characters from the BASIC source program to the console
;	until a (closing) quote is encountered,
;	pass over any trailing blanks,
;	leave source cursor pointing to first non-blank character,
;	and branch to IL instruction at location (LBL).
;	(Report syntax error if <CR> encountered before quote.)
;	If first character is not a quote, return to next
;	sequential IL instruction with cursor unchanged.
;
$INCLUDE(AES\TSTS.ASM)
;========
;DONE
;	Delete leading blanks from the BASIC source line.
;	Return with the cursor positioned over the first non-blank
;	character, which must be a colon or <CR> in the source line.
;	If any other characters are encountered report a syntax error.
$INCLUDE(AES\DONE.ASM)
;=======
;IFDONE	(LBL)
;	If the first non-blank character is a colon or <CR> in the source line
;	then branch to the IL instruction specified by (LBL).
;	If any other characters are encountered
;	then continue with next IL instruction.
;
$INCLUDE(AES\IFDONE.ASM)
;=======
;READ_LABEL
;	Read next two characters from program buffer into <LABL_H><LABL_L>.
;	Return with carry set if bit 15 of LABL is set (indicating EOF).
$INCLUDE(AES\R_LABEL.ASM)
;=======
;L_INIT:
;	Initialize for execution of new BASIC source line.
;	If none present, or if not in sequential execution mode,
;	then return to line collection operation.
$INCLUDE(AES\LINIT.ASM)
;=======
;NL_NXT:
;	Output a <CR><LF> and continue with NXT routine.
;
;
;NXT:
;	A colon or carriage return has been previously READ_CHARed.
;	If CHAR holds a colon,
;	continue interpretation of source line in current mode
;	from IL program instruction "TOKEN".
;	Otherwise CHAR is a <CR>, and line has been completed.
;	Resume execution from IL instruction "STMT".
$INCLUDE(AES\NXT.ASM)
;=======
;GETLN:
;	Input a line from console input device and put in line buffer
;	in internal RAM.
$INCLUDE(AES\GETLN.ASM)
;===============
;PRN:
;	Pop top of arithmetic expression stack (AES),
;	convert to decimal number,
;	and print to console output device, suppressing leading zeroes.
;
$INCLUDE(AES\PRN_.ASM)
;===============
;LSTLIN:
;	Check Label of Program line pointed to by Cursor.
;	If legal, print line number, source line, and <CR><LF> to console,
;	adjust Cursor to start of next line,
;	and return with carry set.
;	Else return with carry cleared.
;
$INCLUDE(AES\LSTLIN.ASM)
;===============
;LST
;	List the contents of the program memory area.
;
$INCLUDE(AES\LST.ASM)
;===============
;INNUM:
;	Read a numeric character string from the console input device.
;	Convert to binary value and push onto arithmetic expression stack.
;	Report error if illegal characters read.
$INCLUDE(AES\INUM.ASM)
;===============
;INIT
;	Perform global initialization:
;	Clear program memory, empty all I/O buffers, reset all stack
;	pointers, etc.
$INCLUDE(AES\INIT.ASM)

;=====================================================================================
;                      BASIC PROGRAM LINE SEQUENCE CONTROL MACROS:
;=====================================================================================;

;XINIT
;	Perform initialization needed before starting sequential execution.
;	Empty stacks, set BASIC line number to 1, etc.

$INCLUDE(AES\XINIT.ASM)
;===============
;FNDLBL:
;	Search program buffer for line with label passed on AES (Pop AES).
;	If found, return with CURSOR pointing to start of line (before label)
;	and carry cleared.
;	If not found return with carry set and pointer at start of first
;	line with a greater label value (possible EOF).
$INCLUDE(AES\FNDLBL.ASM)
;=======
;KILL_L:
;	Kill (delete) line from code buffer indicated by pointer.
;	When called, CURSOR and POINTER hold the address of first LABEL byte of
;	line to be deleted.
$INCLUDE(AES\KILL_L.ASM)
;=======
;OPEN_L:
;	Open space for new line in code buffer starting at Cursor.
$INCLUDE(AES\OPEN_L.ASM)
;=======
;INSR_L:
;	Insert program line label (still held in <TOS_H><TOS_L> from earlier
;	call to FNDLBL)
;	and character string in line buffer (pointed at by L_CURS)
;	into program buffer gap created by OPEN_L routine
;	(still pointed at by CURSOR).
$INCLUDE(AES\INSER_L.ASM)
;=======
;INSRT:
;	Pop line number from top of arithmetic expression stack.
;	Search BASIC source program for corresponding line number.
;	If found, delete old line.
;	Otherwise position cursor before next sequential line number.
;	If line buffer is not empty then insert line number, contents of
;	line buffer, and line terminator.
$INCLUDE(AES\INSRT.ASM)
;===============
COND:
        CALL    POP_TOS
	MOV	A,TOS_L
	RRC	A
	RET
;
;=======
;XFER
;	Pop the value from the top of the arithmetic expression stack (AES).
;	Position cursor at beginning of the BASIC source program line
;	with that label and begin source interpretation.
;	(Report error if corresponding source line not found.)
$INCLUDE(AES\XFER.ASM)
;===============
;SAV:
;	Push BASIC line number of current source line onto AES.
$INCLUDE(AES\SAV.ASM)
;===============
;RSTR:
;	If AES is empty report a nesting error.
;	Otherwise, pop AES into current BASIC souce program line number.
$INCLUDE(AES\RSTR.ASM)
;=======
;FIN
;	Return to line collection routine.
;
$INCLUDE(AES\FIN.ASM)
;======================================================================================
;               IL SEQUENCE CONTROL INSTRUCTIONS:
;======================================================================================;
;MLCALL
;	Call the ML subroutine starting at the address on top of AES.
;
;
$INCLUDE(AES\MLCALL.ASM)


;==========================================================================================================
;       LIL'BASIC STATEMENT EXECUTION

START:

ERRENT:
        CLR     RUNMOD
        MOV     SP,#SP_BASE             ;Re-initialize hardware stack.
        MOV     AESP,#00H               ;Initialize AES pointer.
CONT:
        JB      XAUTO, XEC              ;If in Auto or Xauto run mode,
        JBC     AUTO, XEC               ;Do not allow for command line input!
        CALL    STROUT
        DB      CR,'What next boss?   ',(CR OR 80H)
        MOV     LABL_L,#0H              ;
        MOV     LABL_H,#0H
CONT_1:
        CALL    GETLN                   ;Receive interactive command line.
	CALL	D_BLNK
        CALL    TSTN
        JNC     TOKEN
        CALL    INSRT
        JMP    CONT_1
;

;
ARUN:   CALL    LNDONE                  ;Clear pointer to end of line
XEC:    CALL    XINIT                   ;Initialize for sequential execution.
STMT:   LINIT_                          ;Initialize for line execution.
TOKEN:	CALL	CNTRL

        CALL    D_BLNK                  ;Remove leading blanks from BASIC source line, update cursor,
                                        ;load first non-blank character into CHAR, and leave pointer
                                        ;loaded with its address.

        TSTV_   BASCMD                  ;Test if first non-blank string is a legal variable symbol.
                                        ;If not, Jump to process BASic CoMmanDs

                                        ;If so, move cursor over string and any trailing blanks,
                                        ;compute variable index value, push onto arithmetic expression
                                        ;stack, and continue with following IL instruction.
                                        ;Otherwise branch to IL instruction at LBL with cursor unaffected.

$INCLUDE(AES\CMDS\IMPLIED.ASM)              ;Execute Implied commands
;-----
BASCMD:                                 ;Process Basic Token Commands.
$INCLUDE(AES\CMDS\LET.ASM)
$INCLUDE(AES\CMDS\GO.ASM)
$INCLUDE(AES\CMDS\PRINT.ASM)
$INCLUDE(AES\CMDS\IFTHEN.ASM)
$INCLUDE(AES\CMDS\INPUT.ASM)
$INCLUDE(AES\CMDS\RETURN.ASM)
$INCLUDE(AES\CMDS\CALL.ASM)  ; call machine subroutine
$INCLUDE(AES\CMDS\END.ASM)   ; end program
$INCLUDE(AES\CMDS\LIST.ASM)   ; list program
$INCLUDE(AES\CMDS\RUN.ASM)   ; run program
$INCLUDE(AES\CMDS\NEW.ASM)   ; clear out program
$INCLUDE(AES\CMDS\BREAK.ASM)  ; simulate reset
$INCLUDE(AES\CMDS\PROG.ASM)
$INCLUDE(AES\CMDS\HEXDECI.ASM) ; set oytput mode decimal or Hex
$INCLUDE(AES\CMDS\REMARK.ASM); remark stmt
$INCLUDE(AES\CMDS\CLS.ASM)   ; send clear screen command
$INCLUDE(AES\CMDS\HELP.ASM)  ; display help file
$INCLUDE(AES\CMDS\VER.ASM)   ; display version
$INCLUDE(AES\CMDS\FILES.ASM) ; display program saved
$INCLUDE(AES\CMDS\LOAD.ASM)  ; load program
$INCLUDE(AES\CMDS\SAVE.ASM)  ; save program
$INCLUDE(AES\CMDS\WIPEALL.ASM) ; Wipe all programs
$INCLUDE(AES\CMDS\LOCK.ASM)    ; lock & Unlock memory
;$INCLUDE(AES\CMDS\FORNEXT.ASM)

JMP   SYN_ER           ;If not a command, then Syntax Error

$INCLUDE(AES\ERROR.ASM)
;EXP_ER
;       Expression evaluation error.
;AES_ER
;       Arithmetic expression stack error handling routine.
;SYN_ER
;       Syntax error handling routine.
;OV_ER
;       Overflow error handling routine.
;==========================================================================================================
;
;
;	INTERPRETIVE LANGUAGE SUBROUTINES:
;	============ ======== ===========
;
EXPR:   CALL    AR_EXP
E0:     CALL    RELOP
	JNC	E5
        CALL    AR_EXP
        CALL    CMPR
        JMP    E0

AR_EXP: CALL  TERM


;*E1:     %TST    (E2,+)
e1:     call   tst
        db      ('+' OR 80H)
        jnc     e2
        CALL   TERM
	CALL	IADD
        JMP    E1
;
;*E2:     %TST    (E3,-)
e2:     call   tst
        db      ('-' OR 80H)
        jnc     e3
        CALL  TERM
	CALL	ISUB
        JMP    E1
;
;*E3:     %TST    (E4,OR)
e3:     call   tst
        db      'O',('R' OR 80H)
        jnc     e4
        CALL  TERM
	CALL	IOR
        JMP    E1
;
;*E4:     %TST    (E5,XOR)
e4:     call   tst
        db      'XO',('R' OR 80H)
        jnc     e5
        CALL  TERM
	CALL	IXOR
        JMP    E1

E5:     RET
;
;
;=======
;
TERM:   CALL  FACT
;*TERM_0: %TST    (TERM_1,*)
term_0: call   tst
        db      ('*' OR 80H)
        jnc     term_1
        CALL  FACT
	CALL	IMUL
        JMP    TERM_0
;
;*TERM_1: %TST    (TERM_2,/)
term_1: call   tst
        db      ('/' OR 80H)
        jnc     term_2
        CALL  FACT
	CALL	IDIV
        JMP    TERM_0
;
;*TERM_2: %TST    (TERM_3,AND)
term_2: call   tst
        db      'AN',('D' OR 80H)
        jnc     term_3
        CALL  FACT
	CALL	IAND
        JMP    TERM_0
;
;*TERM_3: %TST    (TERM_4,MOD)
term_3: call   tst
        db      'MO',('D' OR 80H)
        jnc     term_4
        CALL  FACT
	CALL	IMOD
        JMP    TERM_0
;
TERM_4: RET
;
;=======
;
;*FACT:   %TST    (FACT_1,-)
fact:   call   tst
        db      ('-' OR 80H)
        jnc     fact_1
        CALL  VAR
	CALL	NEG
        RET
;
;*FACT_1: %TST    (VAR,NOT)
fact_1: call   tst
        db      'NO',('T' OR 80H)
        jnc     var
        CALL  VAR
	CALL	ICPL
        RET
;
;
;=======
;
VAR:    TSTV_   VAR_0
	CALL	FETCH
        RET
;
VAR_0:  TSTN_   VAR_1
        RET
;
;*VAR_1:  %TST    (VAR_1A,RND)
var_1:  call   tst
        db      'RN',('D' OR 80H)
        jnc     var_1a
        CALL    RND
        CALL  VAR_2
	CALL	IMOD
	CALL	IABS
	CALL	IINC
        RET
;
;*VAR_1A: %TST    (VAR_2,ABS)
var_1a: call   tst
        db      'AB',('S' OR 80H)
        jnc     var_2
        CALL  VAR_2
	CALL	IABS
        RET
;
;*VAR_2:  %TST    (SYN_NG,%1()
var_2:  call   tst
        db      ('(' OR 80H)            ;to match lil'basic.LST
        jnc     syn_ng
        CALL  EXPR
;*        %TST    (SYN_NG,%1))
        call   tst
        db      (')' OR 80H)            ;to match lil'basic.LST
        jnc     syn_ng
        RET
;
;=======
;
SYN_NG: JMP   CMD_NG
;

;
RELOP:
;	Search for relational operator in text string.
;	If found, push appropriate operator code on AES and return with
;	carry set.
;	Otherwise restore cursor and return with carry=0.
;
;*        %TST    (REL_1,=)
        call   tst
        db      ('=' OR 80H)
        jnc     rel_1
        CALL    LIT
        DB      010B            ;Test for _=_
        RET
;
;*REL_1:  %TST    (REL_2,<=)
rel_1:  call   tst
        db      '<',('=' OR 80H)
        jnc     rel_2
        CALL    LIT
        DB      110B            ;Test for <=_
        RET
;
;*REL_2:  %TST    (REL_3,<>)
rel_2:  call   tst
        db      '<',('>' OR 80H)
        jnc     rel_3
        CALL    LIT
        DB      101B            ;Test for <_>
        RET
;
;*REL_3:  %TST    (REL_4,<)
rel_3:  call   tst
        db      ('<' OR 80H)
        jnc     rel_4
	CALL	LIT
        DB      100B            ;Test for <__
        RET
;
;*REL_4:  %TST    (REL_5,>=)
rel_4:  call   tst
        db      '>',('=' OR 80H)
        jnc     rel_5
	CALL	LIT
        DB      011B            ;Test for _=>
        RET
;
;*REL_5:  %TST    (REL_6,>)
rel_5:  call   tst
        db      ('>' OR 80H)
        jnc     rel_6
	CALL	LIT
        DB      001B            ;Test for __>
        RET
;
REL_6:	CLR	C
        RET
;
;======================================================================================
;       Memory File System
;======================================================================================

; FIND_NEXT_TAG
;
; SERCH FOR NEXT TAG IN MEMORY
; TAG = 029H,0EEH,0F1H,0F2H
; Uses ACC,DPTR,C
; Set:          DPTR --> start location
; Returns:      DPTR --> end of TAG   C --> 1 Found TAG   0 No TAG found
$INCLUDE(MFS\TAG.asm)



;=======
;FIND_FILE
;Find file pointed ontop of AES stack
; then point to program in memory!
; Uses A,DPTR,TMP1,TMP5,TMP6,TMP7
; Needs:        AESP --> Filename
;               A    --> Filetype
;
; Returns :     DPTR --> Start of program
;               C    --> Set if File not found.
$INCLUDE(MFS\FIND.asm)


;=======
; Move Program
; Move Basic program in memory FROM,TO
; Uses A,DPTR
; NEEDS         TMP1,TMP2 --> TO   L,H
;               TMP3,TMP4 --> FROM L,H
;               RAMROM    --> Set = ROM to XRAM
;                             Clr = XRAM to XRAM
; RETURNS       DPTR      --> END of moved file +1
$INCLUDE(MFS\MOVE_P.asm)

;=======

;SET_TAG
; Store  in memory
;029H,0EEH,0F1H,0F2H,'P',NAME,00H
; NEEDS         DPTR    --> Start Address in RAM

;               A       --> FILE TYPE
;               PNTR_L  --> Poiner to filename
;               PNTR_H
; USES          TMP1, TMP2
$INCLUDE(MFS\SETTAG.asm)


;=======


; XTOP
; Maintance for top of Xternal Memory File System
; Value is stored in Xram so it is not lost when
; power is lost!
;
; SAVE_XTOP
; Needs:        DPRT  --> New top of Xram
; Uses          A
;
;
; GET_XTOP
; Returns:      DPRT  --> New top of Xram
; Uses          A
$INCLUDE(MFS\XTOP.asm)



;End Of Basic code
;======================================================================================
;       Basic Help Files
;======================================================================================



$INCLUDE(AES\CMDS\HELPTEXT.ASM)         ;Text Help FILE


;======================================================================================
;       Basic Programs stored in ROM
;======================================================================================


START_OF_PROGRAMS:
                                    ;PFILE = PROGRAM FILE
                                    ;DFILE = DATA FILE


;'PFILE 'DEMO'
;$INCLUDE(DEMOS\DEMO.ASM)
;PFILE 'WALK'
;$INCLUDE(DEMOS\walk.ASM)
;PFILE 'LED'
;$INCLUDE(DEMOS\LED.ASM)
PFILE 'HELLO'
DEMOPROG:                           ;Start of DEMO program buffer.
$INCLUDE(DEMOS\HELLO.ASM)

END                                 ;END of code
