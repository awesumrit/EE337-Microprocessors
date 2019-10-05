; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

ORG 0000H
ljmp start

org 200h
start:
      mov P2,#00h
      mov P1,#00h
	  acall mynameroll
	  ;initial delay for lcd power up

	;here1:setb p1.0
      	  acall delay
	;clr p1.0
	  acall delay
	;sjmp here1


	  acall lcd_init      ;initialise LCD
	
	  acall delay
	  acall delay
	  acall delay
	  mov a,#85h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   r0,#80h   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay

	  mov a,#0C3h		  ;Put cursor on second row,3 column
	  acall lcd_command
	  acall delay
	  mov   r0,#89h
	  acall lcd_sendstring

here: sjmp here				//stay here 

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

mynameroll:
   push 0
   mov r0,#80h
   mov @r0,#'1'
   inc r0
   mov @r0,#'7'
   inc r0
    mov @r0,#'0'
   inc r0
    mov @r0,#'0'
   inc r0 
   mov @r0,#'4'
   inc r0
   mov @r0,#'0'
   inc r0
   mov @r0,#'0'
   inc r0
   mov @r0,#'4'
   inc r0
   mov @r0,#'4'
   inc r0
   
   ;r0 value is now 89H
   mov @r0,#'S'
   inc r0
   mov @r0,#'U'
   inc r0
   mov @r0,#'M'
   inc r0
   mov @r0,#'R'
   inc r0
   mov @r0,#'I'
   inc r0   
   mov @r0,#'T'
   inc r0   
   mov @r0,#' '
   inc r0   
   mov @r0,#'G'
   inc r0  
   mov @r0,#'U'
   inc r0   
   mov @r0,#'P'
   inc r0   
   mov @r0,#'T'
   inc r0   
   mov @r0,#'A'
   inc r0 
   
pop 0
ret

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0
	lcd_sendstring_loop:
			 clr   a                 ;clear Accumulator for any previous data
	         mov  a,@r0         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   r0              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 300h
my_string1:
         DB   "Pt-51", 00H
my_string2:
		 DB   "IIT Bombay", 00H
end
