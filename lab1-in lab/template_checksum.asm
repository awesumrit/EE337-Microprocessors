ORG 00H
;-- code memory location 00h
LJMP MAIN

ORG 050H

INIT:
	;-- store the numbers to be added at appropriate locations
	MOV a, #1;
	MOV r0, #40H
	mov r3, #40
	
	loop2 : 
		   MOV @r0, a
		   INC r0
		   INC a
		   djnz r3, loop2
	
	RET
;-- end of subroutine INIT

ADD_40:
	;-- add the numbers stored from memory location 40h to 67h
	;-- by using subroutine written in homework
	CLR a
	mov r1, #40
	mov r0, #40H


	loop3: 
		  add a,@r0
		  inc r0
		  djnz r1,loop3
	
	mov 68H,a
	
	RET
;-- end of subroutine ADD_40
	
TWOS_COMP:
	;-- perform 2's compliment of the resultant sum
	;-- store the checksum byte at memory location 68h
	XRl a, #255
	inc a
	mov 68H,a
	mov r5,a
	RET
;-- end of subroutine TWOS_COMP

ADD_41:
        ;-- add numbers from memory location 40h to 68h
	mov r1, #41
	mov r0, #40H

	CLR A
	loop4: 
		  add a,@ r0
		  inc r0
		  djnz r1,loop4
	
	mov r6,a

	RET
;-- end of subroutine ADD_41

ORG 0200H
;-- code memory location 200h
MAIN:
	ACALL INIT
	ACALL ADD_40
	ACALL TWOS_COMP
	ACALL ADD_41	;verify the result
	nowHERE:SJMP nowHERE
END



