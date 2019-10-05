; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

org 50h
bin2ascii:
			USING 0
			PUSH PSW
			PUSH AR1
			PUSH AR2
			PUSH AR0
			PUSH AR3
			PUSH AR5
			PUSH AR4
			
			MOV R3,A
			ANL A,#0FH
			MOV R4,A
			
			MOV A,R3
			ANL A,#0F0H
			SWAP A
			MOV R5,A
			
			ADD A,#0F6H   ;CONTINUE HERE
			JC CHECK1
			JNC CHECK2
			CHECK1: MOV A,R5
					ADD A,#55
					MOV R5,A
			SJMP OUT1
			CHECK2: MOV A,R5
					ADD A,#48
					MOV R5,A
			OUT1:
			MOV A,R4
			ADD A,#0F6H   ;CONTINUE HERE
			JC CHECK3
			JNC CHECK4
			CHECK3: MOV A,R4
					ADD A,#55
					MOV R4,A
			SJMP OUT2
			CHECK4: MOV A,R4
					ADD A,#48
					MOV R4,A
			OUT2:
			MOV A,R5
			MOV B,R4
			
			POP AR4
			POP AR5
			POP AR3
			POP AR0
			POP AR2
			POP AR1
			POP PSW
			RET



readnibble:
		USING 0
		PUSH PSW
        PUSH AR1	; STORE R1 (BANK O) ON THE STACK
        PUSH AR2
		PUSH AR3
		PUSH AR4
		PUSH AR5
		PUSH AR7
		
		MOV P1,#0FH
		MOV A,#0F0H
		ORL A,P1
		MOV P1,A
		
		LCALL delay2
		
		MOV A,P1
		ANL A,#0FH
		MOV @R0,A
		swap a
		orl a,#0fh
		mov p1,a
		

		lcall delay2						
		
		
		POP AR7
		POP AR5
		POP AR4
        POP AR3
		POP AR2 	; POP MUST BE IN REVERSE ORDER OF PUSH
        POP AR1
        POP PSW
        RET

packnibble:
		USING 0
		PUSH PSW
        PUSH AR1	; STORE R1 (BANK O) ON THE STACK
        PUSH AR2
		PUSH AR3
		PUSH AR4
		PUSH AR5
		PUSH AR7
	
		MOV R3,4fH
		MOV A,4eH
		SWAP A
		ORL A,R3
		MOV 50H,A
	
		POP AR7
		POP AR5
		POP AR4
        POP AR3
		POP AR2 	; POP MUST BE IN REVERSE ORDER OF PUSH
        POP AR1
        POP PSW
		RET		

delay2:
		USING 0			
        PUSH PSW
        PUSH AR1	; STORE R1 (BANK O) ON THE STACK
        PUSH AR2
		PUSH AR3
		PUSH AR4
		PUSH AR5
		
		MOV R4,#10
		BACK3:
		MOV R3,#50
		BACK2: 
			MOV R2,#100
			BACK1:
				MOV R1,#100
				BACK0:
					DJNZ R1,BACK0
				DJNZ R2,BACK1
			DJNZ R3,BACK2
        DJNZ R4, BACK3
		
		POP AR5
		POP AR4
        POP AR3
		POP AR2 	; POP MUST BE IN REVERSE ORDER OF PUSH
        POP AR1
        POP PSW
        RET


start:
      mov P2,#00h
      mov P1,#0fFh
	  
	  ;initial delay for lcd power up

	;here1:setb p1.0
      	  acall delay
	;clr p1.0
	  acall delay
	;sjmp here1


	  acall lcd_init      ;initialise LCD

here:   mov r0,#4eh
	  	  mov 60h,#2ah


		acall readnibble
		inc r0
		acall readnibble
		dec r0
		acall packnibble

	  acall delay
	  acall delay
	  acall delay
	  mov a,#81h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string1   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay
	  acall delay

		mov a,50h
		acall bin2ascii
		acall lcd_senddata
		acall delay
		acall delay
		mov a,b
		acall lcd_senddata
		acall delay
		acall delay

	  mov a,#0C1h		  ;Put cursor on second row,3 column
	  lcall lcd_command
	  mov   dptr,#my_string2
	  acall lcd_sendstring
		acall delay
		acall delay
		
		mov r1,50h

		mov a,@r1
		acall bin2ascii
		acall delay
		acall lcd_senddata
		acall delay
		acall delay
		mov a,b
		acall lcd_senddata

		acall delay2
 ljmp here				//stay here 

;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#3
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
my_string1:
DB   "location:", 00H
my_string2:
DB   "contents:", 00H
end
