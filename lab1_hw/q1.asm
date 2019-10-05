ORG 0000H

LJMP MAIN

ORG 0200H
MAIN:

	MOV 50H, #0xFF
	MOV 60H, #0xFF
	
    MOV A,50H; take the value from source to register A
    MOV B,A; Move the value from A to R5
	MOV A,60H; take the value from source to register A
	ADDC A,B; Add R5 with A and store to register A
	MOV 70H,A;

	MOV R6,#0h;
	JNC here;
	INC R6;
	here: MOV 71H, R6;
halt: sjmp halt
END
