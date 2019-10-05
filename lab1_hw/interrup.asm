org 0h
ljmp main
org 100h
		
main : 
	mov r2, #1
	mov r1, 50H
	mov r0, #50H
	mov a, 50H
	
	jz here
	
	mov a, #0
	loop: add a, r2
		  inc r2
		  inc r0
		  mov @r0, a
		  djnz r1,loop
	
	here : sjmp here	
END
				
