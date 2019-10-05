ORG 0000H
;-- The first opcode is burned into ROM address 0000H,
;-- since this is where the 8051 looks for the first 
;-- instruction when it is booted.
;-- We achieve this by the ORG 00H statement in the source program

LJMP MAIN

;R0 and R1 should contain the address of two no.
;location given by R0:- 	MSB of 1st no.
;location given by R0+1:-	LSB of 1st no.
;location given by R1:- 	MSB of 1st no.
;location given by R1+1:-	LSB of 1st no.
;location given by R0+2:- 	CARRY	
;location given by R0+3:-	MSB OF ANS	
;location given by R0+4:- 	LSB OF ANS

;---------------------------------------------------------;
ORG 50H
;this function adds and stores result in appropriate location
ADDER_16BIT:
	
	;-- perform the addition/subtraction of two 16-bit no.
	;-- use subroutine written for addition of two 8-bit no.
	;-- remember the no. are given in 2's complement form
	;-- take care when you set carry/borrow.
	;-- store the result at appropriate locations.
	MOV R1,#70H;set destination address 70H to R2
	;MOV R3,#71H;set carry address 71H to R3
    MOV A,50H; take the value from source to register A
    MOV R5,A; Move the value from A to R5
    MOV R4,#00H; Clear register R4 to store carry
;INC R0,10;
	MOV A,60H; take the value from source to register A
	ADD A,R5; Add R5 with A and store to register A
	INC R4; Increment R4 to get carry
    MOV B,R4; Get carry to register B
	JNC SAVE
    MOV @R1,B; Store the carry first
	INC R1;
	MOV @R1,A; Store the result 
	
	RET	
;-- end of subroutine ADDER_16BIT	

	

INIT:
	;-- store the numbers to be added/subtracted at appropriate location
	MOV 50H, #0x09
	MOV 60H, #0xF0
	MOV R0,#50H;set source address 50H to R0
    MOV R3,#60H;set address 60H to R1

	RET
;-- end of subroutine INIT



ORG 0200H
MAIN:
	ACALL INIT	    ;-- calling a subroutine INIT
	ACALL ADDER_16BIT   ;-- calling a subroutine ADDER_16BIT
	
HERE:SJMP HERE
END

