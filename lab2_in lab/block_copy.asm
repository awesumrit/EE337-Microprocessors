ORG 00H
LJMP MAIN

ORG 100H
	memcpy:
	USING 0
		PUSH PSW
		PUSH AR0
		PUSH AR1
		PUSH AR2
		PUSH ACC
		PUSH B
		MOV R2, 50H
		MOV R1, 51H
		MOV R0, 52H
        REPEAT:
            MOV A, @R1
            MOV @R0, A
            INC R1
            INC R0
            DJNZ R2, REPEAT
		POP B
		POP ACC
		POP AR2
		POP AR1
		POP AR0
		POP PSW
		RET

MAIN:
	LCALL memcpy
STOP: SJMP STOP
END
