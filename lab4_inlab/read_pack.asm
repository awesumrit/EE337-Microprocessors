org 00h

ljmp main
org 50h

DELAY:
	USING 0		;ASSEMBLER DIRECTIVE TO INDICATE REGISTER BANK0
	PUSH PSW
	PUSH AR1	; STORE R1 (BANK O) ON THE STACK
	PUSH AR2
	PUSH AR3
	PUSH AR4

	MOV R1, #0FFH
	MOV R2, #200	

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
	
readNibble:
	setb p1.3
	setb p1.2
	setb p1.1
	setb p1.0
	
	setb p1.7
	setb p1.6
	setb p1.5
	setb p1.4
	
	mov r3, #100 ; for 5 sec delay
	lcall delay
	
	clr p1.7
	clr p1.6
	clr p1.5
	clr p1.4
	
	mov r3, #20 ; for 1 sec delay
	lcall delay
	
	mov a, p1
	anl a, #0Fh
	rl a
	rl a
	rl a
	rl a
	
	mov p1, a;
	mov r3, #40 ; for 2 sec delay
	lcall delay
	
	
	RET

packNibbles:
	clr a
	dec r0
	mov a, @r0
	rl a
	rl a
	rl a
	rl a
	
	inc r0
	mov b, @r0
	anl b, #0Fh
	add a, b
	
	RET

store:
	clr a
	mov a, p1
	mov b, a
	anl a, #0Fh
	cjne a, #0Fh, here ; for verification
	SETB P1.7
	SETB P1.6
	SETB P1.5
	SETB P1.4
	RET
	
	here:
		loop: 	
			lcall readNibble;
			rr a
			rr a
			rr a
			rr a
			mov @r0, a;
			inc r0
			
	
	RET

store2:
	clr a
	
	lcall store
	lcall store
	
	lcall packNibbles;
	mov @r0, a
	inc r0 ; r0 -> 50h
	
	RET
	
disp_checksum:
	mov r0, #51h;
	lcall store2; 51h, 52h, 53h
	
	mov r0, #54h;
	lcall store2; 54h, 55h, 56h 
	
	mov a, 53h;
	mov b, 56h;
	add a, b ;
	cpl a
	add a, #1;  ;;Checksum
	mov 57h, a	;;Checksum
	
	RET
	
	
main:
	mov r0, #4Eh;
	lcall store2; 4Eh, 4Fh, 50h
	
	lcall disp_checksum;
	
	;anl p1, #0ffh
	mov r3, #40 ; for 2 sec delay
	lcall delay 
	mov p1, 57h
	mov r3, #40 ; for 2 sec delay
	lcall delay 
	
	mov a, 57h
	rl a
	rl a
	rl a
	rl a
	mov p1, a
	mov r3, #40 ;
	lcall delay 
	; anl p1, #0xf0h
	;sjmp main
	there:
		sjmp there
	
END