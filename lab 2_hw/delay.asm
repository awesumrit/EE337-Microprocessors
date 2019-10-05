;---------------------------------------------------------------
;PROBLEM STATEMENT: BLINKING LEDS OF PORT0
;PURPOSE: 1. GOOD CODING STYLES 
;	  2. USING PUSH, POP INSTRUCTIONS IN SUBROUTINES
;---------------------------------------------------------------

	LED EQU P1.7

	ORG 00H
	LJMP MAIN


;----------------------------------------------------------------
	ORG 50H

DELAY:
	USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
	PUSH PSW
	PUSH AR1	; STORE R1 (BANK O) ON THE STACK
	PUSH AR2
	PUSH AR3
	PUSH AR4

	MOV 4FH, #5h;
	MOV R1, #0FFH
	MOV R2, #200
	MOV B, #0AH
	mov A, 4FH
	mul AB
	mov r3, A

	DELAYD:
		MOV R2, #200
		DELAY1:
			MOV R1, #0FFH
			DELAY2:
				DJNZ R1, DELAY2
			DJNZ R2, DELAY1
		DJNZ r3, DELAYD
			

	POP AR4
	POP AR3
	POP AR2 	; POP MUST BE IN REVERSE ORDER OF PUSH
	POP AR1
	POP PSW
	RET

;----------------------------------------------------------------------

MAIN:
		SETB LED
				;MAKE P0 OUTPUT POR       	;01010101B
		
		LCALL DELAY
		CLR LED			;10101010B
		SJMP MAIN		;INFINITE LOOP

;--------------------------------------------------------------------------
END